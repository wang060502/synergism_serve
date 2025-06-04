const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');
const { verifyToken, checkPermission } = require('../middleware/auth');

/**
 * @swagger
 * /api/tasks:
 *   post:
 *     tags:
 *       - 任务管理
 *     summary: 创建任务
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - project_id
 *               - title
 *             properties:
 *               project_id:
 *                 type: integer
 *                 description: 所属项目ID
 *               title:
 *                 type: string
 *                 description: 任务标题
 *               description:
 *                 type: string
 *                 description: 任务描述
 *               estimated_start_date:
 *                 type: string
 *                 format: date
 *                 description: 预估开始时间
 *               estimated_end_date:
 *                 type: string
 *                 format: date
 *                 description: 预估结束时间
 *     responses:
 *       201:
 *         description: 任务创建成功
 *       403:
 *         description: 权限不足
 */
router.post('/', verifyToken, checkPermission('task:create'), taskController.createTask);

/**
 * @swagger
 * /api/tasks/my-tasks:
 *   get:
 *     tags:
 *       - 任务管理
 *     summary: 获取我的任务列表
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: 成功获取任务列表
 */
router.get('/my-tasks', verifyToken, taskController.getMyTasks);

/**
 * @swagger
 * /api/tasks/project/{projectId}:
 *   get:
 *     tags:
 *       - 任务管理
 *     summary: 获取项目下的所有任务
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: projectId
 *         required: true
 *         schema:
 *           type: integer
 *         description: 项目ID
 *     responses:
 *       200:
 *         description: 成功获取项目任务列表
 *       403:
 *         description: 权限不足
 */
router.get('/project/:projectId', verifyToken, checkPermission('task:view'), taskController.getProjectTasks);

/**
 * @swagger
 * /api/tasks/{id}:
 *   get:
 *     tags:
 *       - 任务管理
 *     summary: 获取任务详情
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 任务ID
 *     responses:
 *       200:
 *         description: 成功获取任务详情
 *       404:
 *         description: 任务不存在
 */
router.get('/:id', verifyToken, checkPermission('task:view'), taskController.getTaskById);

/**
 * @swagger
 * /api/tasks/{id}:
 *   put:
 *     tags:
 *       - 任务管理
 *     summary: 更新任务信息
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 任务ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               description:
 *                 type: string
 *               estimated_start_date:
 *                 type: string
 *                 format: date
 *               estimated_end_date:
 *                 type: string
 *                 format: date
 *     responses:
 *       200:
 *         description: 任务更新成功
 *       403:
 *         description: 权限不足
 *       404:
 *         description: 任务不存在
 */
router.put('/:id', verifyToken, checkPermission('task:edit'), taskController.updateTask);

/**
 * @swagger
 * /api/tasks/{id}/status:
 *   patch:
 *     tags:
 *       - 任务管理
 *     summary: 更新任务状态
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 任务ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - status
 *             properties:
 *               status:
 *                 type: integer
 *                 enum: [0, 1, 2, 3]
 *                 description: 任务状态（0未开始，1进行中，2已完成，3延期）
 *     responses:
 *       200:
 *         description: 任务状态更新成功
 *       403:
 *         description: 权限不足
 *       404:
 *         description: 任务不存在
 */
router.patch('/:id/status', verifyToken, checkPermission('task:edit'), taskController.updateTaskStatus);

/**
 * @swagger
 * /api/tasks/{id}/progress:
 *   patch:
 *     tags:
 *       - 任务管理
 *     summary: 更新任务进度
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 任务ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - progress_remark
 *             properties:
 *               progress_remark:
 *                 type: string
 *                 description: 进度备注
 *     responses:
 *       200:
 *         description: 任务进度更新成功
 *       403:
 *         description: 权限不足
 *       404:
 *         description: 任务不存在
 */
router.patch('/:id/progress', verifyToken, checkPermission('task:edit'), taskController.updateTaskProgress);

/**
 * @swagger
 * /api/tasks/{id}:
 *   delete:
 *     tags:
 *       - 任务管理
 *     summary: 删除任务
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 任务ID
 *     responses:
 *       200:
 *         description: 任务删除成功
 *       403:
 *         description: 权限不足
 *       404:
 *         description: 任务不存在
 */
router.delete('/:id', verifyToken, checkPermission('task:delete'), taskController.deleteTask);

module.exports = router; 
 