const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');
const { verifyToken, checkPermission } = require('../middleware/auth');

/**
 * @swagger
 * /api/projects:
 *   post:
 *     tags:
 *       - 项目管理
 *     summary: 创建新项目
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - start_date
 *               - end_date
 *             properties:
 *               name:
 *                 type: string
 *                 description: 项目名称
 *               description:
 *                 type: string
 *                 description: 项目描述
 *               start_date:
 *                 type: string
 *                 format: date
 *                 description: 项目开始日期
 *               end_date:
 *                 type: string
 *                 format: date
 *                 description: 项目结束日期
 *               leader_id:
 *                 type: integer
 *                 description: 项目负责人ID
 *               doc_file_url:
 *                 type: string
 *                 description: 需求文档URL
 *     responses:
 *       201:
 *         description: 项目创建成功
 *       403:
 *         description: 权限不足
 */
router.post('/', verifyToken, checkPermission('project:create'), projectController.createProject);

/**
 * @swagger
 * /api/projects:
 *   get:
 *     tags:
 *       - 项目管理
 *     summary: 获取项目列表
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
 *         name: name
 *         schema:
 *           type: string
 *         description: 项目名称（模糊搜索）
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *         description: 项目状态
 *     responses:
 *       200:
 *         description: 成功获取项目列表
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
 *                           name:
 *                             type: string
 *                           description:
 *                             type: string
 *                           start_date:
 *                             type: string
 *                             format: date
 *                           end_date:
 *                             type: string
 *                             format: date
 *                           leader_id:
 *                             type: integer
 *                           leader_nickname:
 *                             type: string
 *                           status:
 *                             type: string
 *                           doc_file_url:
 *                             type: string
 *                           doc_file_name:
 *                             type: string
 *                           duration_days:
 *                             type: integer
 *                           created_at:
 *                             type: string
 *                             format: date-time
 *                     pagination:
 *                       type: object
 *                       properties:
 *                         total:
 *                           type: integer
 *                           description: 总记录数
 *                         page:
 *                           type: integer
 *                           description: 当前页码
 *                         pageSize:
 *                           type: integer
 *                           description: 每页数量
 */
router.get('/', verifyToken, checkPermission('project:view'), projectController.getProjects);

/**
 * @swagger
 * /api/projects/my-projects:
 *   get:
 *     tags:
 *       - 项目管理
 *     summary: 获取我参与的项目
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: 成功获取我参与的项目列表
 */
router.get('/my-projects', verifyToken, projectController.getMyProjects);

/**
 * @swagger
 * /api/projects/{id}:
 *   get:
 *     tags:
 *       - 项目管理
 *     summary: 获取项目详情
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 项目ID
 *     responses:
 *       200:
 *         description: 成功获取项目详情
 *       404:
 *         description: 项目不存在
 */
router.get('/:id', verifyToken, checkPermission('project:view'), projectController.getProjectById);

/**
 * @swagger
 * /api/projects/{id}:
 *   put:
 *     tags:
 *       - 项目管理
 *     summary: 更新项目信息
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 项目ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               start_date:
 *                 type: string
 *                 format: date
 *               end_date:
 *                 type: string
 *                 format: date
 *               leader_id:
 *                 type: integer
 *               status:
 *                 type: integer
 *               doc_file_url:
 *                 type: string
 *     responses:
 *       200:
 *         description: 项目更新成功
 *       403:
 *         description: 权限不足
 *       404:
 *         description: 项目不存在
 */
router.put('/:id', verifyToken, checkPermission('project:edit'), projectController.updateProject);

/**
 * @swagger
 * /api/projects/{id}:
 *   delete:
 *     tags:
 *       - 项目管理
 *     summary: 删除项目
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 项目ID
 *     responses:
 *       200:
 *         description: 项目删除成功
 *       403:
 *         description: 权限不足
 *       404:
 *         description: 项目不存在
 */
router.delete('/:id', verifyToken, checkPermission('project:delete'), projectController.deleteProject);

/**
 * @swagger
 * /api/projects/{id}/members:
 *   post:
 *     tags:
 *       - 项目管理
 *     summary: 添加项目成员
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 项目ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - user_id
 *             properties:
 *               user_id:
 *                 type: integer
 *                 description: 用户ID
 *               role_label:
 *                 type: string
 *                 description: 成员角色标签
 *     responses:
 *       201:
 *         description: 成员添加成功
 *       403:
 *         description: 权限不足
 */
router.post('/:id/members', verifyToken, checkPermission('project:manage_members'), projectController.addProjectMember);

/**
 * @swagger
 * /api/projects/{id}/members/{userId}:
 *   delete:
 *     tags:
 *       - 项目管理
 *     summary: 移除项目成员
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 项目ID
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: integer
 *         description: 用户ID
 *     responses:
 *       200:
 *         description: 成员移除成功
 *       403:
 *         description: 权限不足
 *       404:
 *         description: 成员不存在
 */
router.delete('/:id/members/:userId', verifyToken, checkPermission('project:manage_members'), projectController.removeProjectMember);

/**
 * @swagger
 * /api/projects/{id}/members:
 *   get:
 *     tags:
 *       - 项目管理
 *     summary: 获取项目成员列表
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: 项目ID
 *     responses:
 *       200:
 *         description: 成功获取成员列表
 */
router.get('/:id/members', verifyToken, checkPermission('project:view'), projectController.getProjectMembers);

module.exports = router; 