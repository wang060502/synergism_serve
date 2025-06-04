const db = require('../db/db');

// 创建通知/公告
exports.createNotification = async (req, res) => {
    try {
        const { title, content, type, receiver_scope, targets } = req.body;
        const creator_id = req.user.userId;
        console.log('前端传入 req.body:', req.body);
        if (!creator_id) {
            return res.status(401).json({
                code: 401,
                message: '未获取到用户信息'
            });
        }

        // 1. 创建通知记录
        const notificationResult = await db.query(
            'INSERT INTO notifications (title, content, type, creator_id, receiver_scope) VALUES (?, ?, ?, ?, ?)',
            [title, content, type, creator_id, receiver_scope]
        );
        const notificationId = notificationResult.insertId;

        // 2. 根据接收范围创建目标记录
        if (receiver_scope === 0) { // 全员
            // 获取所有用户ID
            const users = await db.query('SELECT user_id FROM sys_user');
            console.log('db.query("SELECT user_id FROM sys_user") 返回:', users);
            for (const user of users) {
                await db.query(
                    'INSERT INTO notification_targets (notification_id, target_type, target_id) VALUES (?, ?, ?)',
                    [notificationId, 0, user.user_id]
                );
            }
        } else if (receiver_scope === 1) { // 部门
            // 只添加指定的部门
            if (targets && targets.length > 0) {
                for (const target of targets) {
                    await db.query(
                        'INSERT INTO notification_targets (notification_id, target_type, target_id) VALUES (?, ?, ?)',
                        [notificationId, target.type, target.id]
                    );
                }
            }
        } else if (receiver_scope === 2 && targets) { // 指定用户
            for (const target of targets) {
                await db.query(
                    'INSERT INTO notification_targets (notification_id, target_type, target_id) VALUES (?, ?, ?)',
                    [notificationId, 0, target.id]
                );
            }
        }

        res.status(200).json({
            code: 200,
            message: '通知创建成功',
            data: { id: notificationId }
        });
    } catch (error) {
        console.error('创建通知失败:', error);
        res.status(500).json({
            code: 500,
            message: '创建通知失败',
            error: error.message
        });
    }
};

// 获取通知列表
exports.getNotifications = async (req, res) => {
    try {
        const userId = req.user.userId;
        if (!userId) {
            return res.status(401).json({
                code: 401,
                message: '未获取到用户信息'
            });
        }

        // 获取用户部门ID
        const rows = await db.query('SELECT dept_id FROM sys_user WHERE user_id = ?', [userId]);
        const userRow = rows[0];
        const deptId = userRow ? userRow.dept_id : null;

        const { page = 1, pageSize = 10, type } = req.query;
        const offset = (page - 1) * pageSize;

        // 确保 pageSize 和 offset 是数字
        const pageSizeNum = Number(pageSize);
        const offsetNum = Number(offset);

        let query = `
            SELECT DISTINCT n.*, 
                   CASE WHEN nr.is_read IS NULL THEN 0 ELSE nr.is_read END as is_read,
                   nr.read_at
            FROM notifications n
            LEFT JOIN notification_reads nr ON n.id = nr.notification_id AND nr.user_id = ?
            WHERE EXISTS (
                SELECT 1 FROM notification_targets nt
                WHERE nt.notification_id = n.id
                AND (
                    (nt.target_type = 0 AND nt.target_id = ?)
                    OR (nt.target_type = 1 AND nt.target_id = ?)
                    OR (nt.target_type = 2 AND nt.target_id = ?)
                )
            )`;

        // 修改参数数组
        const params = [
            userId, 
            userId, 
            deptId, 
            userId
        ];

        if (type !== undefined) {
            query += ' AND n.type = ?';
            params.push(type);
        }

        query += `
            ORDER BY n.created_at DESC
            LIMIT ${pageSizeNum} OFFSET ${offsetNum}
        `;

        console.log('SQL:', query);
        console.log('params:', params);

        const notifications = await db.query(query, params);

        // 获取总数
        let countQuery = `
            SELECT COUNT(DISTINCT n.id) as total 
            FROM notifications n 
            WHERE EXISTS (
                SELECT 1 FROM notification_targets nt 
                WHERE nt.notification_id = n.id 
                AND (
                    (nt.target_type = 0 AND nt.target_id = ?)
                    OR (nt.target_type = 1 AND nt.target_id = ?)
                    OR (nt.target_type = 2 AND nt.target_id = ?)
                )
            )`;

        const countParams = [userId, deptId, userId];

        if (type !== undefined) {
            countQuery += ' AND n.type = ?';
            countParams.push(type);
        }

        const totalResult = await db.query(countQuery, countParams);

        res.json({
            code: 200,
            data: {
                list: notifications,
                total: totalResult[0].total,
                page: parseInt(page),
                pageSize: parseInt(pageSize)
            }
        });
    } catch (error) {
        console.error('获取通知列表失败:', error);
        res.status(500).json({
            code: 500,
            message: '获取通知列表失败',
            error: error.message
        });
    }
};

// 获取单个通知详情
exports.getNotificationById = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.userId;
        if (!userId) {
            return res.status(401).json({
                code: 401,
                message: '未获取到用户信息'
            });
        }

        const notifications = await db.query(
            `SELECT n.*, 
                    CASE WHEN nr.is_read IS NULL THEN 0 ELSE nr.is_read END as is_read,
                    nr.read_at,
                    u.username as creator_name,
                    CASE 
                        WHEN n.receiver_scope = 0 THEN CONCAT('用户：', GROUP_CONCAT(u2.real_name))
                        WHEN n.receiver_scope = 1 THEN CONCAT('部门：', GROUP_CONCAT(d.dept_name))
                        WHEN n.receiver_scope = 2 THEN CONCAT('用户：', GROUP_CONCAT(u2.real_name))
                        ELSE GROUP_CONCAT(
                            CASE 
                                WHEN nt.target_type = 0 THEN u2.real_name
                                WHEN nt.target_type = 1 THEN d.dept_name
                            END
                        )
                    END as target_details
             FROM notifications n
             LEFT JOIN notification_reads nr ON n.id = nr.notification_id AND nr.user_id = ?
             LEFT JOIN sys_user u ON n.creator_id = u.user_id
             LEFT JOIN notification_targets nt ON n.id = nt.notification_id
             LEFT JOIN sys_user u2 ON (nt.target_type IN (0, 2) AND nt.target_id = u2.user_id)
             LEFT JOIN sys_dept d ON nt.target_type = 1 AND nt.target_id = d.dept_id
             WHERE n.id = ?
             GROUP BY n.id, n.title, n.content, n.type, n.creator_id, n.receiver_scope, n.created_at, 
                      nr.is_read, nr.read_at, u.username`,
            [userId, id]
        );

        if (notifications.length === 0) {
            return res.status(404).json({
                code: 404,
                message: '通知不存在'
            });
        }

        res.json({
            code: 200,
            data: notifications[0]
        });
    } catch (error) {
        console.error('获取通知详情失败:', error);
        res.status(500).json({
            code: 500,
            message: '获取通知详情失败',
            error: error.message
        });
    }
};

// 标记通知为已读
exports.markAsRead = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.userId;
        if (!userId) {
            return res.status(401).json({
                code: 401,
                message: '未获取到用户信息'
            });
        }

        // 先获取用户的部门ID
        const userRows = await db.query('SELECT dept_id FROM sys_user WHERE user_id = ?', [userId]);
        const deptId = userRows[0] ? userRows[0].dept_id : null;

        // 检查通知是否存在且用户是否有权限访问
        const notifications = await db.query(
            `SELECT 1 FROM notifications n
             WHERE n.id = ? AND EXISTS (
                 SELECT 1 FROM notification_targets nt
                 WHERE nt.notification_id = n.id
                 AND (
                     (nt.target_type = 0 AND nt.target_id = ?)
                     OR (nt.target_type = 1 AND nt.target_id = ?)
                     OR (nt.target_type = 2 AND nt.target_id = ?)
                 )
             )`,
            [id, userId, deptId, userId]
        );

        if (notifications.length === 0) {
            return res.status(404).json({
                code: 404,
                message: '通知不存在或无权访问'
            });
        }

        // 更新或插入阅读状态
        await db.query(
            `INSERT INTO notification_reads (notification_id, user_id, is_read, read_at)
             VALUES (?, ?, 1, NOW())
             ON DUPLICATE KEY UPDATE is_read = 1, read_at = NOW()`,
            [id, userId]
        );

        res.json({
            code: 200,
            message: '标记已读成功'
        });
    } catch (error) {
        console.error('标记已读失败:', error);
        res.status(500).json({
            code: 500,
            message: '标记已读失败',
            error: error.message
        });
    }
};

// 获取未读通知数量
exports.getUnreadCount = async (req, res) => {
    try {
        const userId = req.user.userId;
        if (!userId) {
            return res.status(401).json({
                code: 401,
                message: '未获取到用户信息'
            });
        }

        // 获取用户部门ID
        const userRows = await db.query('SELECT dept_id FROM sys_user WHERE user_id = ?', [userId]);
        const deptId = userRows[0] ? userRows[0].dept_id : null;

        const result = await db.query(
            `SELECT COUNT(DISTINCT n.id) as unread_count
             FROM notifications n
             WHERE EXISTS (
                 SELECT 1 FROM notification_targets nt
                 WHERE nt.notification_id = n.id
                 AND (
                     (nt.target_type = 0 AND nt.target_id = ?)
                     OR (nt.target_type = 1 AND nt.target_id = ?)
                     OR (nt.target_type = 2 AND nt.target_id = ?)
                 )
             )
             AND NOT EXISTS (
                 SELECT 1 FROM notification_reads nr
                 WHERE nr.notification_id = n.id
                 AND nr.user_id = ?
                 AND nr.is_read = 1
             )`,
            [userId, deptId, userId, userId]
        );

        res.json({
            code: 200,
            data: {
                unread_count: result[0].unread_count
            }
        });
    } catch (error) {
        console.error('获取未读数量失败:', error);
        res.status(500).json({
            code: 500,
            message: '获取未读数量失败',
            error: error.message
        });
    }
};

// 获取通知阅读状态
exports.getReadStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.userId; // 修改这里，使用userId
        if (!userId) {
            return res.status(401).json({
                code: 401,
                message: '未获取到用户信息'
            });
        }

        const result = await db.query(
            `SELECT nr.is_read, nr.read_at
             FROM notification_reads nr
             WHERE nr.notification_id = ? AND nr.user_id = ?`,
            [id, userId]
        );

        res.json({
            code: 200,
            data: {
                is_read: result.length > 0 ? result[0].is_read : 0,
                read_at: result.length > 0 ? result[0].read_at : null
            }
        });
    } catch (error) {
        console.error('获取阅读状态失败:', error);
        res.status(500).json({
            code: 500,
            message: '获取阅读状态失败',
            error: error.message
        });
    }
};

// 获取所有通知列表（管理员）
exports.getAllNotifications = async (req, res) => {
    try {
        const { 
            page = 1, 
            pageSize = 10, 
            type, 
            receiver_scope,
            keyword,
            startDate,
            endDate
        } = req.query;
        
        const offset = (page - 1) * pageSize;
        const pageSizeNum = Number(pageSize);
        const offsetNum = Number(offset);
        const whereParams = [];
        let whereClause = '';

        if (type !== undefined && type !== '') {
            whereClause += ' AND n.type = ?';
            whereParams.push(Number(type));
        }
        if (receiver_scope !== undefined && receiver_scope !== '') {
            whereClause += ' AND n.receiver_scope = ?';
            whereParams.push(Number(receiver_scope));
        }
        if (keyword) {
            whereClause += ' AND (n.title LIKE ? OR n.content LIKE ?)';
            whereParams.push(`%${keyword}%`, `%${keyword}%`);
        }
        if (startDate) {
            whereClause += ' AND DATE(n.created_at) >= ?';
            whereParams.push(startDate);
        }
        if (endDate) {
            whereClause += ' AND DATE(n.created_at) <= ?';
            whereParams.push(endDate);
        }

        const query = `
            SELECT 
                n.*,
                u.username as creator_name,
                (SELECT COUNT(*) FROM notification_reads nr WHERE nr.notification_id = n.id AND nr.is_read = 1) as read_count,
                (SELECT COUNT(*) FROM notification_targets nt WHERE nt.notification_id = n.id) as total_receivers,
                CASE 
                    WHEN n.receiver_scope = 0 THEN CONCAT('用户：', GROUP_CONCAT(DISTINCT u2.real_name))
                    WHEN n.receiver_scope = 1 THEN CONCAT('部门：', GROUP_CONCAT(DISTINCT d.dept_name))
                    WHEN n.receiver_scope = 2 THEN CONCAT('用户：', GROUP_CONCAT(DISTINCT u2.real_name))
                    ELSE GROUP_CONCAT(DISTINCT
                        CASE 
                            WHEN nt.target_type = 0 THEN u2.real_name
                            WHEN nt.target_type = 1 THEN d.dept_name
                        END
                    )
                END as target_details
            FROM notifications n
            LEFT JOIN sys_user u ON n.creator_id = u.user_id
            LEFT JOIN notification_targets nt ON n.id = nt.notification_id
            LEFT JOIN sys_user u2 ON (nt.target_type IN (0, 2) AND nt.target_id = u2.user_id)
            LEFT JOIN sys_dept d ON nt.target_type = 1 AND nt.target_id = d.dept_id
            WHERE 1=1 ${whereClause}
            GROUP BY n.id, n.title, n.content, n.type, n.creator_id, n.receiver_scope, n.created_at, u.username
            ORDER BY n.created_at DESC
            LIMIT ${pageSizeNum} OFFSET ${offsetNum}
        `;

        const notifications = await db.query(query, whereParams);

        const countQuery = `
            SELECT COUNT(*) as total
            FROM notifications n
            WHERE 1=1 ${whereClause}
        `;
        const totalResult = await db.query(countQuery, whereParams);
        const total = totalResult[0] ? totalResult[0].total : 0;

        res.json({
            code: 200,
            data: {
                list: Array.isArray(notifications) ? notifications : [],
                total: total,
                page: Number(page),
                pageSize: Number(pageSize)
            }
        });
    } catch (error) {
        console.error('获取所有通知列表失败:', error);
        res.status(500).json({
            code: 500,
            message: '获取所有通知列表失败',
            error: error.message
        });
    }
};

// 删除通知
exports.deleteNotification = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.userId;
        if (!userId) {
            return res.status(401).json({
                code: 401,
                message: '未获取到用户信息'
            });
        }

        // 1. 检查通知是否存在
        const notifications = await db.query(
            'SELECT id, creator_id FROM notifications WHERE id = ?',
            [id]
        );

        if (notifications.length === 0) {
            return res.status(404).json({
                code: 404,
                message: '通知不存在'
            });
        }

        // 2. 删除相关的阅读记录
        await db.query(
            'DELETE FROM notification_reads WHERE notification_id = ?',
            [id]
        );

        // 3. 删除相关的目标记录
        await db.query(
            'DELETE FROM notification_targets WHERE notification_id = ?',
            [id]
        );

        // 4. 删除通知本身
        await db.query(
            'DELETE FROM notifications WHERE id = ?',
            [id]
        );

        res.json({
            code: 200,
            message: '通知删除成功'
        });
    } catch (error) {
        console.error('删除通知失败:', error);
        res.status(500).json({
            code: 500,
            message: '删除通知失败',
            error: error.message
        });
    }
}; 