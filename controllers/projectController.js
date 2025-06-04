const db = require('../db/db');

const projectController = {
    // 创建项目
    async createProject(req, res) {
        try {
            const { name, description, start_date, end_date, leader_id, doc_file_url } = req.body;
            // 创建项目
            const result = await db.query(
                'INSERT INTO projects (name, description, start_date, end_date, leader_id, doc_file_url) VALUES (?, ?, ?, ?, ?, ?)',
                [name, description, start_date, end_date, leader_id, doc_file_url]
            );
            const projectId = result.insertId;
            // 如果指定了负责人，将负责人添加为项目成员
            if (leader_id) {
                await db.query(
                    'INSERT INTO project_members (project_id, user_id, role_label) VALUES (?, ?, ?)',
                    [projectId, leader_id, '项目负责人']
                );
            }
            res.status(200).json({
                code: 200,
                message: '项目创建成功',
                data: { projectId }
            });
        } catch (error) {
            console.error('创建项目失败:', error);
            res.status(500).json({ code: 500, message: '创建项目失败', error: error.message });
        }
    },

    // 获取项目列表
    async getProjects(req, res) {
        try {
            const { 
                page = 1, 
                pageSize = 10, 
                name = '', 
                status = '' 
            } = req.query;

            // 构建查询条件
            let conditions = [];
            let params = [];
            
            if (name) {
                conditions.push('p.name LIKE ?');
                params.push(`%${name}%`);
            }
            
            if (status) {
                conditions.push('p.status = ?');
                params.push(status);
            }

            const whereClause = conditions.length > 0 
                ? 'WHERE ' + conditions.join(' AND ') 
                : '';

            // 计算总记录数
            const [totalResult] = await db.query(
                `SELECT COUNT(*) as total 
                FROM projects p 
                ${whereClause}`,
                params
            );
            const total = totalResult.total;

            // 查询项目列表
            const pageNum = parseInt(page);
            const pageSizeNum = parseInt(pageSize);
            const offset = (pageNum - 1) * pageSizeNum;
            
            const projects = await db.query(`
                SELECT p.*, u.real_name as leader_nickname,
                    DATEDIFF(p.end_date, p.start_date) as duration_days
                FROM projects p
                LEFT JOIN sys_user u ON p.leader_id = u.user_id
                ${whereClause}
                ORDER BY p.created_at DESC
                LIMIT ${pageSizeNum} OFFSET ${offset}
            `, params);

            // 增加文件名称字段
            const projectsWithFileName = projects.map(item => ({
                ...item,
                doc_file_name: item.doc_file_url ? decodeURIComponent(item.doc_file_url.split('/').pop()) : null
            }));

            res.json({ 
                code: 200, 
                data: {
                    list: projectsWithFileName,
                    pagination: {
                        total,
                        page: pageNum,
                        pageSize: pageSizeNum
                    }
                }
            });
        } catch (error) {
            console.error('获取项目列表失败:', error);
            res.status(500).json({ code: 500, message: '获取项目列表失败', error: error.message });
        }
    },

    // 获取我参与的项目
    async getMyProjects(req, res) {
        const userId = req.user.userId;
        try {
            const projects = await db.query(
                `SELECT p.* FROM projects p 
                LEFT JOIN project_members pm ON p.id = pm.project_id 
                WHERE p.leader_id = ? OR pm.user_id = ?
                GROUP BY p.id
                ORDER BY p.created_at DESC`,
                [userId, userId]
            );
            res.json({ code: 200, data: projects });
        } catch (error) {
            console.error('获取我参与的项目失败:', error);
            res.status(500).json({ code: 500, message: '获取我参与的项目失败', error: error.message });
        }
    },

    // 获取项目详情
    async getProjectById(req, res) {
        const { id } = req.params;
        try {
            const projects = await db.query(`
                SELECT p.*, u.real_name as leader_nickname,
                    DATEDIFF(p.end_date, p.start_date) as duration_days
                FROM projects p
                LEFT JOIN sys_user u ON p.leader_id = u.user_id
                WHERE p.id = ?
            `, [id]);
            if (projects.length === 0) {
                return res.status(404).json({ code: 404, message: '项目不存在' });
            }
            // 增加文件名称字段
            const projectWithFileName = {
                ...projects[0],
                doc_file_name: projects[0].doc_file_url ? decodeURIComponent(projects[0].doc_file_url.split('/').pop()) : null
            };
            // 查询项目成员列表
            const members = await db.query(
                `SELECT pm.*, u.username, u.real_name 
                FROM project_members pm
                LEFT JOIN sys_user u ON pm.user_id = u.user_id
                WHERE pm.project_id = ?`,
                [id]
            );
            // 返回项目详情和成员列表
            res.json({ code: 200, data: { ...projectWithFileName, members } });
        } catch (error) {
            console.error('获取项目详情失败:', error);
            res.status(500).json({ code: 500, message: '获取项目详情失败', error: error.message });
        }
    },

    // 更新项目信息
    async updateProject(req, res) {
        const { id } = req.params;
        const { name, description, start_date, end_date, leader_id, status, doc_file_url } = req.body;
        try {
            // 首先获取现有项目数据
            const [existingProject] = await db.query('SELECT * FROM projects WHERE id = ?', [id]);
            if (!existingProject) {
                return res.status(404).json({ code: 404, message: '项目不存在' });
            }

            // 格式化日期函数
            const formatDate = (dateString) => {
                if (!dateString) return null;
                const date = new Date(dateString);
                return date.toISOString().split('T')[0]; // 转换为 YYYY-MM-DD 格式
            };

            // 使用现有数据作为默认值，只更新提供的字段
            const updateData = {
                name: name ?? existingProject.name,
                description: description ?? existingProject.description,
                start_date: formatDate(start_date) ?? existingProject.start_date,
                end_date: formatDate(end_date) ?? existingProject.end_date,
                leader_id: leader_id ?? existingProject.leader_id,
                status: status ?? existingProject.status,
                doc_file_url: doc_file_url ?? existingProject.doc_file_url
            };

            const result = await db.query(
                `UPDATE projects 
                SET name = ?, description = ?, start_date = ?, end_date = ?, 
                    leader_id = ?, status = ?, doc_file_url = ?
                WHERE id = ?`,
                [
                    updateData.name,
                    updateData.description,
                    updateData.start_date,
                    updateData.end_date,
                    updateData.leader_id,
                    updateData.status,
                    updateData.doc_file_url,
                    id
                ]
            );

            res.json({ code: 200, message: '项目更新成功' });
        } catch (error) {
            console.error('更新项目信息失败:', error);
            res.status(500).json({ code: 500, message: '更新项目信息失败', error: error.message });
        }
    },

    // 删除项目
    async deleteProject(req, res) {
        const { id } = req.params;
        try {
            const result = await db.query('DELETE FROM projects WHERE id = ?', [id]);
            if (result.affectedRows === 0) {
                return res.status(404).json({ code: 404, message: '项目不存在' });
            }
            res.json({ code: 200, message: '项目删除成功' });
        } catch (error) {
            console.error('删除项目失败:', error);
            res.status(500).json({ code: 500, message: '删除项目失败', error: error.message });
        }
    },

    // 添加项目成员
    async addProjectMember(req, res) {
        const { id } = req.params;
        const { user_id, role_label } = req.body;
        try {
            await db.query(
                'INSERT INTO project_members (project_id, user_id, role_label) VALUES (?, ?, ?)',
                [id, user_id, role_label]
            );
            res.status(200).json({ code: 200, message: '项目成员添加成功' });
        } catch (error) {
            console.error('添加项目成员失败:', error);
            res.status(500).json({ code: 500, message: '添加项目成员失败', error: error.message });
        }
    },

    // 移除项目成员
    async removeProjectMember(req, res) {
        const { id, userId } = req.params;
        try {
            const result = await db.query(
                'DELETE FROM project_members WHERE project_id = ? AND user_id = ?',
                [id, userId]
            );
            if (result.affectedRows === 0) {
                return res.status(404).json({ code: 404, message: '项目成员不存在' });
            }
            res.json({ code: 200, message: '项目成员移除成功' });
        } catch (error) {
            console.error('移除项目成员失败:', error);
            res.status(500).json({ code: 500, message: '移除项目成员失败', error: error.message });
        }
    },

    // 获取项目成员列表
    async getProjectMembers(req, res) {
        const { id } = req.params;
        try {
            const members = await db.query(
                `SELECT pm.*, u.username, u.real_name 
                FROM project_members pm
                LEFT JOIN sys_user u ON pm.user_id = u.user_id
                WHERE pm.project_id = ?`,
                [id]
            );
            res.json({ code: 200, data: members });
        } catch (error) {
            console.error('获取项目成员列表失败:', error);
            res.status(500).json({ code: 500, message: '获取项目成员列表失败', error: error.message });
        }
    }
};

module.exports = projectController;