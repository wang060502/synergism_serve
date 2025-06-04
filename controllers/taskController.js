const db = require('../db/db');

const taskController = {
    // 创建任务
    async createTask(req, res) {
        const { project_id, title, description, estimated_start_date, estimated_end_date } = req.body;
        const user_id = req.user.userId;
        try {
            // 验证用户是否为项目成员
            const members = await db.query(
                'SELECT * FROM project_members WHERE project_id = ? AND user_id = ?',
                [project_id, user_id]
            );
            if (members.length === 0) {
                return res.status(403).json({
                    code: 403,
                    message: '您不是该项目的成员，无法创建任务'
                });
            }
            const result = await db.query(
                `INSERT INTO project_tasks 
                (project_id, user_id, title, description, estimated_start_date, estimated_end_date) 
                VALUES (?, ?, ?, ?, ?, ?)`,
                [project_id, user_id, title, description, estimated_start_date, estimated_end_date]
            );
            res.status(201).json({
                code: 201,
                message: '任务创建成功',
                data: { taskId: result.insertId }
            });
        } catch (error) {
            console.error('创建任务失败:', error);
            res.status(500).json({ code: 500, message: '创建任务失败', error: error.message });
        }
    },

    // 获取我的任务列表
    async getMyTasks(req, res) {
        const user_id = req.user.userId;
        try {
            const tasks = await db.query(
                `SELECT t.*, p.name as project_name 
                FROM project_tasks t
                LEFT JOIN projects p ON t.project_id = p.id
                WHERE t.user_id = ?
                ORDER BY t.created_at DESC`,
                [user_id]
            );
            res.json({ code: 200, data: tasks });
        } catch (error) {
            console.error('获取我的任务列表失败:', error);
            res.status(500).json({ code: 500, message: '获取我的任务列表失败', error: error.message });
        }
    },

    // 获取项目下的所有任务
    async getProjectTasks(req, res) {
        const { projectId } = req.params;
        const user_id = req.user.userId;
        try {
            // 验证用户是否为项目成员
            const members = await db.query(
                'SELECT * FROM project_members WHERE project_id = ? AND user_id = ?',
                [projectId, user_id]
            );
            if (members.length === 0) {
                return res.status(403).json({
                    code: 403,
                    message: '您不是该项目的成员，无法查看任务'
                });
            }
            const tasks = await db.query(
                `SELECT t.*, u.username, u.nickname 
                FROM project_tasks t
                LEFT JOIN sys_user u ON t.user_id = u.user_id
                WHERE t.project_id = ?
                ORDER BY t.created_at DESC`,
                [projectId]
            );
            res.json({ code: 200, data: tasks });
        } catch (error) {
            console.error('获取项目任务失败:', error);
            res.status(500).json({ code: 500, message: '获取项目任务失败', error: error.message });
        }
    },

    // 获取任务详情
    async getTaskById(req, res) {
        const { id } = req.params;
        const user_id = req.user.userId;
        try {
            const tasks = await db.query(
                `SELECT t.*, p.name as project_name, u.username, u.nickname
                FROM project_tasks t
                LEFT JOIN projects p ON t.project_id = p.id
                LEFT JOIN sys_user u ON t.user_id = u.user_id
                WHERE t.id = ?`,
                [id]
            );
            if (tasks.length === 0) {
                return res.status(404).json({
                    code: 404,
                    message: '任务不存在'
                });
            }
            // 验证用户是否为项目成员
            const members = await db.query(
                'SELECT * FROM project_members WHERE project_id = ? AND user_id = ?',
                [tasks[0].project_id, user_id]
            );
            if (members.length === 0) {
                return res.status(403).json({
                    code: 403,
                    message: '您不是该项目的成员，无法查看任务'
                });
            }
            res.json({ code: 200, data: tasks[0] });
        } catch (error) {
            console.error('获取任务详情失败:', error);
            res.status(500).json({ code: 500, message: '获取任务详情失败', error: error.message });
        }
    },

    // 更新任务信息
    async updateTask(req, res) {
        const { id } = req.params;
        const { title, description, estimated_start_date, estimated_end_date } = req.body;
        const user_id = req.user.userId;
        try {
            // 验证任务是否存在且属于当前用户
            const tasks = await db.query(
                'SELECT * FROM project_tasks WHERE id = ? AND user_id = ?',
                [id, user_id]
            );
            if (tasks.length === 0) {
                return res.status(404).json({
                    code: 404,
                    message: '任务不存在或您没有权限修改'
                });
            }
            await db.query(
                `UPDATE project_tasks 
                SET title = ?, description = ?, estimated_start_date = ?, estimated_end_date = ?
                WHERE id = ? AND user_id = ?`,
                [title, description, estimated_start_date, estimated_end_date, id, user_id]
            );
            res.json({ code: 200, message: '任务更新成功' });
        } catch (error) {
            console.error('更新任务信息失败:', error);
            res.status(500).json({ code: 500, message: '更新任务信息失败', error: error.message });
        }
    },

    // 更新任务状态
    async updateTaskStatus(req, res) {
        const { id } = req.params;
        const { status } = req.body;
        const user_id = req.user.userId;
        try {
            // 验证任务是否存在且属于当前用户
            const tasks = await db.query(
                'SELECT * FROM project_tasks WHERE id = ? AND user_id = ?',
                [id, user_id]
            );
            if (tasks.length === 0) {
                return res.status(404).json({
                    code: 404,
                    message: '任务不存在或您没有权限修改'
                });
            }
            const actual_end_date = status === 2 ? new Date() : null;
            await db.query(
                `UPDATE project_tasks 
                SET status = ?, actual_end_date = ?
                WHERE id = ? AND user_id = ?`,
                [status, actual_end_date, id, user_id]
            );
            res.json({ code: 200, message: '任务状态更新成功' });
        } catch (error) {
            console.error('更新任务状态失败:', error);
            res.status(500).json({ code: 500, message: '更新任务状态失败', error: error.message });
        }
    },

    // 更新任务进度
    async updateTaskProgress(req, res) {
        const { id } = req.params;
        const { progress_remark } = req.body;
        const user_id = req.user.userId;
        try {
            // 验证任务是否存在且属于当前用户
            const tasks = await db.query(
                'SELECT * FROM project_tasks WHERE id = ? AND user_id = ?',
                [id, user_id]
            );
            if (tasks.length === 0) {
                return res.status(404).json({
                    code: 404,
                    message: '任务不存在或您没有权限修改'
                });
            }
            await db.query(
                `UPDATE project_tasks 
                SET progress_remark = ?
                WHERE id = ? AND user_id = ?`,
                [progress_remark, id, user_id]
            );
            res.json({ code: 200, message: '任务进度更新成功' });
        } catch (error) {
            console.error('更新任务进度失败:', error);
            res.status(500).json({ code: 500, message: '更新任务进度失败', error: error.message });
        }
    },

    // 删除任务
    async deleteTask(req, res) {
        const { id } = req.params;
        const user_id = req.user.userId;
        try {
            // 验证任务是否存在且属于当前用户
            const tasks = await db.query(
                'SELECT * FROM project_tasks WHERE id = ? AND user_id = ?',
                [id, user_id]
            );
            if (tasks.length === 0) {
                return res.status(404).json({
                    code: 404,
                    message: '任务不存在或您没有权限删除'
                });
            }
            await db.query(
                'DELETE FROM project_tasks WHERE id = ? AND user_id = ?',
                [id, user_id]
            );
            res.json({ code: 200, message: '任务删除成功' });
        } catch (error) {
            console.error('删除任务失败:', error);
            res.status(500).json({ code: 500, message: '删除任务失败', error: error.message });
        }
    }
};

module.exports = taskController; 