const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const { verifyToken, checkPermission } = require('../middleware/auth');

/**
 * @swagger
 * /api/notifications:
 *   post:
 *     tags:
 *       - 通知管理
 *     summary: 创建通知/公告
 *     description: 创建新的通知或公告，支持全员、部门、指定人员的消息下发
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - title
 *               - content
 *               - type
 *               - receiver_scope
 *             properties:
 *               title:
 *                 type: string
 *                 description: 通知标题
 *               content:
 *                 type: string
 *                 description: 通知内容
 *               type:
 *                 type: integer
 *                 enum: [0, 1]
 *                 description: 通知类型(0=通知, 1=公告)
 *               receiver_scope:
 *                 type: integer
 *                 enum: [0, 1, 2]
 *                 description: 接收范围(0=全员, 1=部门, 2=指定用户)
 *               targets:
 *                 type: array
 *                 description: 指定用户时的目标列表
 *                 items:
 *                   type: object
 *                   properties:
 *                     type:
 *                       type: integer
 *                       enum: [0, 1]
 *                       description: 目标类型(0=用户, 1=部门)
 *                     id:
 *                       type: integer
 *                       description: 目标ID
 *     responses:
 *       201:
 *         description: 创建成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 201
 *                 message:
 *                   type: string
 *                   example: 通知创建成功
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: 创建的通知ID
 *       500:
 *         description: 服务器错误
 */
router.post('/', verifyToken, checkPermission('notification:create'), notificationController.createNotification);

/**
 * @swagger
 * /api/notifications:
 *   get:
 *     tags:
 *       - 通知管理
 *     summary: 获取通知列表
 *     description: 获取当前用户的通知列表，支持分页和类型筛选
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: 页码
 *       - in: query
 *         name: pageSize
 *         schema:
 *           type: integer
 *           default: 10
 *         description: 每页数量
 *       - in: query
 *         name: type
 *         schema:
 *           type: integer
 *           enum: [0, 1]
 *         description: 通知类型(0=通知, 1=公告)
 *     responses:
 *       200:
 *         description: 成功获取通知列表
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 data:
 *                   type: object
 *                   properties:
 *                     list:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           id:
 *                             type: integer
 *                           title:
 *                             type: string
 *                           content:
 *                             type: string
 *                           type:
 *                             type: integer
 *                           is_read:
 *                             type: integer
 *                           created_at:
 *                             type: string
 *                             format: date-time
 *                     total:
 *                       type: integer
 *                     page:
 *                       type: integer
 *                     pageSize:
 *                       type: integer
 */
router.get('/', verifyToken, checkPermission('notification:userlist'), notificationController.getNotifications);

/**
 * @swagger
 * /api/notifications/{id}:
 *   get:
 *     tags:
 *       - 通知管理
 *     summary: 获取通知详情
 *     description: 获取指定通知的详细信息
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 通知ID
 *     responses:
 *       200:
 *         description: 成功获取通知详情
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                     title:
 *                       type: string
 *                     content:
 *                       type: string
 *                     type:
 *                       type: integer
 *                     is_read:
 *                       type: integer
 *                     created_at:
 *                       type: string
 *                       format: date-time
 *       404:
 *         description: 通知不存在或无权访问
 */
router.get('/:id', verifyToken, notificationController.getNotificationById);

/**
 * @swagger
 * /api/notifications/{id}/read:
 *   put:
 *     tags:
 *       - 通知管理
 *     summary: 标记通知为已读
 *     description: 将指定通知标记为已读状态
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 通知ID
 *     responses:
 *       200:
 *         description: 标记成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 message:
 *                   type: string
 *                   example: 标记已读成功
 *       404:
 *         description: 通知不存在或无权访问
 */
router.put('/:id/read', verifyToken, checkPermission('notification:read'), notificationController.markAsRead);

/**
 * @swagger
 * /api/notifications/unread/count:
 *   get:
 *     tags:
 *       - 通知管理
 *     summary: 获取未读通知数量
 *     description: 获取当前用户的未读通知数量
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: 成功获取未读数量
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 data:
 *                   type: object
 *                   properties:
 *                     unread_count:
 *                       type: integer
 *                       description: 未读通知数量
 */
router.get('/unread/count', verifyToken, checkPermission('notification:unread'), notificationController.getUnreadCount);

/**
 * @swagger
 * /api/notifications/{id}/read-status:
 *   get:
 *     tags:
 *       - 通知管理
 *     summary: 获取通知阅读状态
 *     description: 获取指定通知的阅读状态
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 通知ID
 *     responses:
 *       200:
 *         description: 成功获取阅读状态
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 data:
 *                   type: object
 *                   properties:
 *                     is_read:
 *                       type: integer
 *                       enum: [0, 1]
 *                       description: 是否已读(0=未读, 1=已读)
 *                     read_at:
 *                       type: string
 *                       format: date-time
 *                       description: 阅读时间
 */
router.get('/:id/read-status', verifyToken, checkPermission('notification:read'), notificationController.getReadStatus);

/**
 * @swagger
 * /api/notifications/admin/list:
 *   get:
 *     tags:
 *       - 通知管理
 *     summary: 获取所有通知列表（管理员）
 *     description: 管理员获取所有通知列表，支持分页、类型筛选和搜索
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: 页码
 *       - in: query
 *         name: pageSize
 *         schema:
 *           type: integer
 *           default: 10
 *         description: 每页数量
 *       - in: query
 *         name: type
 *         schema:
 *           type: integer
 *           enum: [0, 1]
 *         description: 通知类型(0=通知, 1=公告)
 *       - in: query
 *         name: receiver_scope
 *         schema:
 *           type: integer
 *           enum: [0, 1, 2]
 *         description: 接收范围(0=全员, 1=部门, 2=指定用户)
 *       - in: query
 *         name: keyword
 *         schema:
 *           type: string
 *         description: 搜索关键词（标题或内容）
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: 开始日期
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: 结束日期
 *     responses:
 *       200:
 *         description: 成功获取通知列表
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 data:
 *                   type: object
 *                   properties:
 *                     list:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           id:
 *                             type: integer
 *                           title:
 *                             type: string
 *                           content:
 *                             type: string
 *                           type:
 *                             type: integer
 *                           receiver_scope:
 *                             type: integer
 *                           creator_id:
 *                             type: integer
 *                           created_at:
 *                             type: string
 *                             format: date-time
 *                           creator_name:
 *                             type: string
 *                           read_count:
 *                             type: integer
 *                           total_receivers:
 *                             type: integer
 *                     total:
 *                       type: integer
 *                     page:
 *                       type: integer
 *                     pageSize:
 *                       type: integer
 */
router.get('/admin/list', verifyToken, checkPermission('notification:admin'), notificationController.getAllNotifications);

/**
 * @swagger
 * /api/notifications/{id}:
 *   delete:
 *     tags:
 *       - 通知管理
 *     summary: 删除通知
 *     description: 删除指定的通知（需要管理员权限）
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 通知ID
 *     responses:
 *       200:
 *         description: 删除成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 message:
 *                   type: string
 *                   example: 通知删除成功
 *       404:
 *         description: 通知不存在
 *       500:
 *         description: 服务器错误
 */
router.delete('/:id', verifyToken, checkPermission('notification:delete'), notificationController.deleteNotification);

module.exports = router; 