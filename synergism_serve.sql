/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : synergism_serve

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 04/06/2025 23:17:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account_password_permissions
-- ----------------------------
DROP TABLE IF EXISTS `account_password_permissions`;
CREATE TABLE `account_password_permissions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL,
  `created_by` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `can_view` tinyint(1) NULL DEFAULT 0,
  `can_edit` tinyint(1) NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `account_password_permissions_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `account_password_permissions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of account_password_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for account_passwords
-- ----------------------------
DROP TABLE IF EXISTS `account_passwords`;
CREATE TABLE `account_passwords`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL,
  `created_by` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_by`(`created_by` ASC) USING BTREE,
  CONSTRAINT `account_passwords_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of account_passwords
-- ----------------------------
INSERT INTO `account_passwords` VALUES (1, '3467520359@qq.com', 'da5acd4855e37f1ea14b171843f42a8d:fcedaf9c93a38ae058884566e1aa7a6c', 'https://www.qiniu.com/', '七牛云账号密码', 1, '2025-06-03 21:20:34', '2025-06-03 21:45:04');
INSERT INTO `account_passwords` VALUES (2, '714021488@qq.com', '232daf2f728f8c1ee0a11f5f6ed5e99f:8f7bc3f3c5eae1fb111c16a1c8464d48', 'https://www.airsecurecard.com/', '全球收款（需要二步验证）', 1, '2025-06-03 21:27:50', NULL);
INSERT INTO `account_passwords` VALUES (4, 'admin', '29249ad47b96e332c7987b1d69d443ee:2f32cddfef32471276de5792e9e9cb4a', 'http://47.82.96.217:3000/dashboard', 'umami网站统计', 1, '2025-06-04 15:25:44', NULL);
INSERT INTO `account_passwords` VALUES (5, 'd0e2e322', '58ba05de33963f5a51804c2b3041a07c:fbc395c9b94df36e5bba915d5190fc4c', 'https://47.82.96.217:8888/80b03ec8', '短剧宝塔', 1, '2025-06-04 18:14:12', NULL);

-- ----------------------------
-- Table structure for notification_reads
-- ----------------------------
DROP TABLE IF EXISTS `notification_reads`;
CREATE TABLE `notification_reads`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `notification_id` int NOT NULL,
  `user_id` int NOT NULL,
  `is_read` tinyint NULL DEFAULT 0 COMMENT '0=未读, 1=已读',
  `read_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `notification_id`(`notification_id` ASC) USING BTREE,
  CONSTRAINT `notification_reads_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notification_reads
-- ----------------------------
INSERT INTO `notification_reads` VALUES (1, 10, 1, 1, '2025-06-04 14:30:24');
INSERT INTO `notification_reads` VALUES (2, 15, 1, 1, '2025-06-04 14:34:54');

-- ----------------------------
-- Table structure for notification_targets
-- ----------------------------
DROP TABLE IF EXISTS `notification_targets`;
CREATE TABLE `notification_targets`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `notification_id` int NOT NULL,
  `target_type` tinyint NOT NULL COMMENT '0=用户, 1=部门',
  `target_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `notification_id`(`notification_id` ASC) USING BTREE,
  CONSTRAINT `notification_targets_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notification_targets
-- ----------------------------
INSERT INTO `notification_targets` VALUES (13, 10, 1, 5);
INSERT INTO `notification_targets` VALUES (19, 15, 0, 1);
INSERT INTO `notification_targets` VALUES (20, 15, 0, 2);
INSERT INTO `notification_targets` VALUES (21, 16, 0, 2);
INSERT INTO `notification_targets` VALUES (22, 17, 0, 1);
INSERT INTO `notification_targets` VALUES (23, 17, 0, 2);
INSERT INTO `notification_targets` VALUES (24, 18, 0, 1);

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `type` tinyint NOT NULL COMMENT '0=通知, 1=公告',
  `creator_id` int NOT NULL,
  `receiver_scope` tinyint NOT NULL COMMENT '0=全员, 1=部门, 2=指定用户',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notifications
-- ----------------------------
INSERT INTO `notifications` VALUES (10, '逆向海淘', '周五需要上线', 0, 1, 1, '2025-06-04 13:05:37');
INSERT INTO `notifications` VALUES (15, '放假通知', '21321饿', 0, 1, 0, '2025-06-04 14:11:02');
INSERT INTO `notifications` VALUES (16, '测试', '查韦斯', 0, 1, 2, '2025-06-04 14:29:01');
INSERT INTO `notifications` VALUES (17, '测试未读', '阿萨的劳动力', 0, 1, 0, '2025-06-04 14:42:55');
INSERT INTO `notifications` VALUES (18, '1234', '123421', 1, 1, 2, '2025-06-04 16:35:02');

-- ----------------------------
-- Table structure for project_members
-- ----------------------------
DROP TABLE IF EXISTS `project_members`;
CREATE TABLE `project_members`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `project_id` int NOT NULL COMMENT '所属项目ID',
  `user_id` bigint NOT NULL COMMENT '成员用户ID',
  `role_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '成员职责（前端/后端/测试等）',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_id`(`project_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `project_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目成员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project_members
-- ----------------------------
INSERT INTO `project_members` VALUES (9, 5, 1, '项目负责人', '2025-06-04 22:49:24');
INSERT INTO `project_members` VALUES (10, 5, 2, '前端', '2025-06-04 22:49:32');

-- ----------------------------
-- Table structure for project_tasks
-- ----------------------------
DROP TABLE IF EXISTS `project_tasks`;
CREATE TABLE `project_tasks`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `project_id` int NOT NULL COMMENT '所属项目ID',
  `user_id` bigint NOT NULL COMMENT '执行人用户ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '任务详情',
  `estimated_start_date` date NULL DEFAULT NULL COMMENT '预估开始时间',
  `estimated_end_date` date NULL DEFAULT NULL COMMENT '预估结束时间',
  `actual_end_date` date NULL DEFAULT NULL COMMENT '实际完成日期',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0未开始，1进行中，2已完成，3延期',
  `progress_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '进度备注（每周更新）',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_id`(`project_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `project_tasks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `project_tasks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project_tasks
-- ----------------------------

-- ----------------------------
-- Table structure for projects
-- ----------------------------
DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目描述',
  `start_date` date NOT NULL COMMENT '项目开始日期',
  `end_date` date NOT NULL COMMENT '项目结束日期',
  `leader_id` bigint NULL DEFAULT NULL COMMENT '项目负责人用户ID',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0进行中，1已完成，2已延期，3已取消',
  `doc_file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '需求文档上传路径',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `leader_id`(`leader_id` ASC) USING BTREE,
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`leader_id`) REFERENCES `sys_user` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of projects
-- ----------------------------
INSERT INTO `projects` VALUES (5, 'AI翻译平台', 'AI翻译商业化', '2025-05-30', '2025-06-07', 1, 0, 'http://localhost:3000/uploads/1749047959366-154131547.docx', '2025-06-04 22:17:21', '2025-06-04 22:39:21');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NULL DEFAULT 0,
  `dept_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `order_num` int NULL DEFAULT 0,
  `status` tinyint NULL DEFAULT 1,
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (1, 0, '一起发展贸易有限公司', 0, 1);
INSERT INTO `sys_dept` VALUES (3, 1, '人事部', 0, 1);
INSERT INTO `sys_dept` VALUES (5, 1, '技术部', 1, 1);
INSERT INTO `sys_dept` VALUES (6, 0, '一起发展服饰有限公司', 1, 1);
INSERT INTO `sys_dept` VALUES (7, 6, '财务部', 0, 1);
INSERT INTO `sys_dept` VALUES (8, 1, '运营部', 2, 1);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '菜单名称',
  `menu_type` tinyint NULL DEFAULT NULL COMMENT '类型(1-目录 2-菜单 3-按钮)',
  `path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '路由路径',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '组件路径',
  `perms` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '权限标识(如:user:add)',
  `icon` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图标',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `visible` tinyint NULL DEFAULT 1 COMMENT '是否可见(0-隐藏 1-显示)',
  `create_time` datetime NOT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 78 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 0, '系统管理', 1, '/system', NULL, NULL, 'Setting', 50, 1, '2025-05-22 23:13:45', '2025-05-24 15:57:08');
INSERT INTO `sys_menu` VALUES (2, 1, '部门管理', 2, '/system/department', NULL, NULL, 'OfficeBuilding', 20, 1, '2025-05-22 23:13:45', NULL);
INSERT INTO `sys_menu` VALUES (3, 2, '部门列表', 3, NULL, NULL, 'dept:list', NULL, 1, 0, '2025-05-22 23:13:45', NULL);
INSERT INTO `sys_menu` VALUES (4, 2, '新增部门', 3, NULL, NULL, 'dept:add', NULL, 2, 0, '2025-05-22 23:13:45', NULL);
INSERT INTO `sys_menu` VALUES (5, 2, '编辑部门', 3, NULL, NULL, 'dept:edit', NULL, 3, 0, '2025-05-22 23:13:45', NULL);
INSERT INTO `sys_menu` VALUES (6, 2, '删除部门', 3, NULL, NULL, 'dept:delete', NULL, 4, 0, '2025-05-22 23:13:45', NULL);
INSERT INTO `sys_menu` VALUES (7, 1, '用户管理', 2, '/system/user', NULL, NULL, 'User', 30, 1, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (8, 7, '用户列表', 3, NULL, NULL, 'user:list', NULL, 1, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (9, 7, '新增用户', 3, NULL, NULL, 'user:add', NULL, 2, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (10, 7, '编辑用户', 3, NULL, NULL, 'user:edit', NULL, 3, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (11, 7, '删除用户', 3, NULL, NULL, 'user:delete', NULL, 4, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (12, 7, '分配角色', 3, NULL, NULL, 'user:assign', NULL, 5, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (13, 1, '角色管理', 2, '/system/role', NULL, NULL, 'UserFilled', 40, 1, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (14, 13, '角色列表', 3, NULL, NULL, 'role:list', NULL, 1, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (15, 13, '新增角色', 3, NULL, NULL, 'role:add', NULL, 2, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (16, 13, '编辑角色', 3, NULL, NULL, 'role:edit', NULL, 3, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (17, 13, '删除角色', 3, NULL, NULL, 'role:delete', NULL, 4, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (18, 13, '分配权限', 3, NULL, NULL, 'role:assign', NULL, 5, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (19, 1, '菜单管理', 2, '/system/menu', NULL, NULL, 'Menu', 50, 1, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (20, 19, '菜单列表', 3, NULL, NULL, 'menu:list', NULL, 1, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (21, 19, '新增菜单', 3, NULL, NULL, 'menu:add', NULL, 2, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (22, 19, '编辑菜单', 3, NULL, NULL, 'menu:edit', NULL, 3, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (23, 19, '删除菜单', 3, NULL, NULL, 'menu:delete', NULL, 4, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (24, 1, '操作日志', 2, '/system/log', NULL, NULL, 'Document', 60, 1, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (25, 24, '日志列表', 3, NULL, NULL, 'operationLog:list', NULL, 1, 0, '2025-05-23 11:49:14', NULL);
INSERT INTO `sys_menu` VALUES (26, 0, '首页', 1, '/dashboard', NULL, '', 'HomeFilled', 0, 1, '2025-05-23 14:07:08', '2025-05-24 12:07:36');
INSERT INTO `sys_menu` VALUES (54, 0, '账密管理', 1, '/account', '', '', 'Key', 1, 1, '2025-06-03 21:07:00', '2025-06-03 21:07:23');
INSERT INTO `sys_menu` VALUES (55, 54, '账密列表', 2, '/account/list', '', 'account_password:list', '', 0, 1, '2025-06-03 21:08:39', '2025-06-03 21:46:48');
INSERT INTO `sys_menu` VALUES (56, 55, '创建账密', 3, '', '', 'account_password:create', '', 0, 0, '2025-06-03 21:09:22', NULL);
INSERT INTO `sys_menu` VALUES (57, 55, '修改账密', 3, '', '', 'account_password:edit', '', 1, 0, '2025-06-03 21:10:02', NULL);
INSERT INTO `sys_menu` VALUES (58, 55, '删除账密', 3, '', '', 'account_password:delete', '', 3, 0, '2025-06-03 21:10:41', NULL);
INSERT INTO `sys_menu` VALUES (59, 55, '查看账密', 3, '', '', 'account_password:view', '', 4, 0, '2025-06-03 21:11:09', '2025-06-03 21:51:27');
INSERT INTO `sys_menu` VALUES (60, 55, '查看账密列表', 3, '', '', 'account_password:list', '', 5, 0, '2025-06-03 21:51:24', NULL);
INSERT INTO `sys_menu` VALUES (61, 0, '通知管理', 1, '/notice', '', '', 'Bell', 2, 1, '2025-06-04 11:07:01', '2025-06-04 21:46:27');
INSERT INTO `sys_menu` VALUES (62, 61, '通知列表', 2, '/notice/list', '', '', '', 0, 1, '2025-06-04 11:07:44', '2025-06-04 11:08:07');
INSERT INTO `sys_menu` VALUES (63, 62, '创建通知/公告', 3, '', '', 'notification:create', '', 0, 0, '2025-06-04 11:08:24', NULL);
INSERT INTO `sys_menu` VALUES (64, 62, '获取所有通知列表（管理员）', 3, '', '', 'notification:admin', '', 1, 0, '2025-06-04 11:09:08', NULL);
INSERT INTO `sys_menu` VALUES (65, 62, '删除通知', 3, '', '', 'notification:delete', '', 2, 0, '2025-06-04 11:09:39', '2025-06-04 11:09:43');
INSERT INTO `sys_menu` VALUES (67, 62, '获取通知列表', 3, '', '', 'notification:list', '', 5, 0, '2025-06-04 11:11:04', NULL);
INSERT INTO `sys_menu` VALUES (68, 61, '我的通知', 2, '/notice/my', '', '', '', 1, 1, '2025-06-04 13:58:20', '2025-06-04 13:58:28');
INSERT INTO `sys_menu` VALUES (69, 68, '标记通知为已读', 3, '', '', 'notification:read', '', 0, 0, '2025-06-04 13:59:32', NULL);
INSERT INTO `sys_menu` VALUES (70, 68, '获取当前用户的通知列表', 3, '', '', 'notification:userlist', '', 1, 0, '2025-06-04 14:00:11', NULL);
INSERT INTO `sys_menu` VALUES (71, 68, '获取未读通知数量', 3, '', '', 'notification:unread', '', 2, 0, '2025-06-04 14:01:12', NULL);
INSERT INTO `sys_menu` VALUES (72, 0, '项目管理', 1, '/projects', '', '', 'Folder', 3, 1, '2025-06-04 21:47:01', NULL);
INSERT INTO `sys_menu` VALUES (73, 72, '项目列表', 2, '/projects/list', '', 'project:view', '', 0, 1, '2025-06-04 21:47:46', NULL);
INSERT INTO `sys_menu` VALUES (74, 73, '创建新项目', 3, '', '', 'project:create', '', 0, 0, '2025-06-04 21:48:28', NULL);
INSERT INTO `sys_menu` VALUES (75, 73, '更新项目信息', 3, '', '', 'project:edit', '', 1, 0, '2025-06-04 21:49:06', NULL);
INSERT INTO `sys_menu` VALUES (76, 73, '删除项目', 3, '', '', 'project:delete', '', 3, 0, '2025-06-04 21:49:23', NULL);
INSERT INTO `sys_menu` VALUES (77, 73, '项目成员功能', 3, '', '', 'project:manage_members', '', 4, 0, '2025-06-04 21:49:43', '2025-06-04 21:50:17');

-- ----------------------------
-- Table structure for sys_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL COMMENT '操作人',
  `operation` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '操作类型',
  `method` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '请求方法',
  `params` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL COMMENT '请求参数',
  `ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT 'IP地址',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 147 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_operation_log
-- ----------------------------
INSERT INTO `sys_operation_log` VALUES (1, 1, 'updateUser', 'PUT', '{\"userId\":\"1\",\"realName\":\"汪义强\",\"avatar\":null,\"email\":\"3467520359@qq.com\",\"mobile\":\"19360256621\",\"deptId\":5,\"status\":1,\"remark\":\"1\",\"roleId\":1}', '::1', '2025-05-24 10:24:39');
INSERT INTO `sys_operation_log` VALUES (2, 1, 'updateUser', 'PUT', '{\"userId\":\"1\",\"realName\":\"汪义强\",\"avatar\":null,\"email\":\"3467520359@qq.com\",\"mobile\":\"19360256621\",\"deptId\":5,\"status\":1,\"remark\":\"1\",\"roleId\":1}', '::1', '2025-05-24 10:35:25');
INSERT INTO `sys_operation_log` VALUES (3, 1, 'updateUser', 'PUT', '{\"userId\":\"1\",\"realName\":\"汪义强\",\"avatar\":null,\"email\":\"3467520359@qq.com\",\"mobile\":\"19360256621\",\"deptId\":5,\"status\":1,\"remark\":\"\",\"roleId\":1}', '::1', '2025-05-24 10:41:36');
INSERT INTO `sys_operation_log` VALUES (4, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"parentId\":26,\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/system/customer\",\"component\":\"system/customer/index\",\"perms\":null,\"icon\":\"UserGroup\",\"sort\":70,\"visible\":1}', '::1', '2025-05-24 11:42:16');
INSERT INTO `sys_operation_log` VALUES (5, 1, 'updateMenu', 'PUT', '{\"menuId\":\"29\",\"parentId\":27,\"menuName\":\"新增客户\",\"menuType\":3,\"path\":null,\"component\":null,\"perms\":\"customer:add\",\"icon\":null,\"sort\":2,\"visible\":0}', '::1', '2025-05-24 11:43:06');
INSERT INTO `sys_operation_log` VALUES (6, 1, 'updateMenu', 'PUT', '{\"menuId\":\"31\",\"parentId\":27,\"menuName\":\"删除客户\",\"menuType\":3,\"path\":null,\"component\":null,\"perms\":\"customer:delete\",\"icon\":null,\"sort\":4,\"visible\":0}', '::1', '2025-05-24 11:43:28');
INSERT INTO `sys_operation_log` VALUES (7, 1, 'updateMenu', 'PUT', '{\"menuId\":\"30\",\"parentId\":27,\"menuName\":\"编辑客户\",\"menuType\":3,\"path\":null,\"component\":null,\"perms\":\"customer:edit\",\"icon\":null,\"sort\":3,\"visible\":0}', '::1', '2025-05-24 11:43:35');
INSERT INTO `sys_operation_log` VALUES (8, 1, 'updateMenu', 'PUT', '{\"menuId\":\"29\",\"parentId\":28,\"menuName\":\"新增客户\",\"menuType\":3,\"path\":null,\"component\":null,\"perms\":\"customer:add\",\"icon\":null,\"sort\":2,\"visible\":0}', '::1', '2025-05-24 11:44:24');
INSERT INTO `sys_operation_log` VALUES (9, 1, 'updateMenu', 'PUT', '{\"menuId\":\"30\",\"parentId\":28,\"menuName\":\"编辑客户\",\"menuType\":3,\"path\":null,\"component\":null,\"perms\":\"customer:edit\",\"icon\":null,\"sort\":3,\"visible\":0}', '::1', '2025-05-24 11:44:37');
INSERT INTO `sys_operation_log` VALUES (10, 1, 'updateMenu', 'PUT', '{\"menuId\":\"31\",\"parentId\":28,\"menuName\":\"删除客户\",\"menuType\":3,\"path\":null,\"component\":null,\"perms\":\"customer:delete\",\"icon\":null,\"sort\":4,\"visible\":0}', '::1', '2025-05-24 11:44:45');
INSERT INTO `sys_operation_log` VALUES (11, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/system/customer\",\"component\":\"system/customer/index\",\"perms\":null,\"icon\":\"UserGroup\",\"sort\":70,\"visible\":1}', '::1', '2025-05-24 11:53:40');
INSERT INTO `sys_operation_log` VALUES (12, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"parentId\":26,\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/system/customer\",\"component\":\"system/customer/index\",\"perms\":null,\"icon\":\"UserGroup\",\"sort\":70,\"visible\":1}', '::1', '2025-05-24 11:57:43');
INSERT INTO `sys_operation_log` VALUES (13, 1, 'createMenu', 'POST', '{\"menuName\":\"1\",\"menuType\":1,\"path\":\"312\",\"component\":\"\",\"perms\":\"21wq\",\"icon\":\"AddLocation\",\"sort\":0,\"visible\":1}', '::1', '2025-05-24 11:58:43');
INSERT INTO `sys_operation_log` VALUES (14, 1, 'deleteMenu', 'DELETE', '{\"menuId\":32}', '::1', '2025-05-24 12:05:43');
INSERT INTO `sys_operation_log` VALUES (15, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/system/customer\",\"component\":\"system/customer/index\",\"perms\":null,\"icon\":\"UserGroup\",\"sort\":70,\"visible\":1}', '::1', '2025-05-24 12:05:51');
INSERT INTO `sys_operation_log` VALUES (16, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"parentId\":0,\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/system/customer\",\"component\":\"system/customer/index\",\"perms\":null,\"icon\":\"UserGroup\",\"sort\":70,\"visible\":1}', '::1', '2025-05-24 12:07:00');
INSERT INTO `sys_operation_log` VALUES (17, 1, 'updateMenu', 'PUT', '{\"menuId\":\"26\",\"parentId\":27,\"menuName\":\"首页\",\"menuType\":1,\"path\":\"/dashboard\",\"component\":\"\",\"perms\":\"\",\"icon\":\"HomeFilled\",\"sort\":0,\"visible\":1}', '::1', '2025-05-24 12:07:30');
INSERT INTO `sys_operation_log` VALUES (18, 1, 'updateMenu', 'PUT', '{\"menuId\":\"26\",\"parentId\":0,\"menuName\":\"首页\",\"menuType\":1,\"path\":\"/dashboard\",\"component\":\"\",\"perms\":\"\",\"icon\":\"HomeFilled\",\"sort\":0,\"visible\":1}', '::1', '2025-05-24 12:07:36');
INSERT INTO `sys_operation_log` VALUES (19, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"parentId\":0,\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/customer\",\"component\":\"system/customer/index\",\"perms\":null,\"icon\":\"UserGroup\",\"sort\":70,\"visible\":1}', '::1', '2025-05-24 12:45:49');
INSERT INTO `sys_operation_log` VALUES (20, 1, 'updateMenu', 'PUT', '{\"menuId\":\"28\",\"parentId\":27,\"menuName\":\"客户列表\",\"menuType\":3,\"path\":\"/customer/list\",\"component\":null,\"perms\":\"customer:list\",\"icon\":null,\"sort\":1,\"visible\":0}', '::1', '2025-05-24 12:46:43');
INSERT INTO `sys_operation_log` VALUES (21, 1, 'updateMenu', 'PUT', '{\"menuId\":\"28\",\"parentId\":27,\"menuName\":\"客户列表\",\"menuType\":2,\"path\":\"/customer/list\",\"perms\":\"customer:list\",\"icon\":null,\"sort\":1,\"visible\":0}', '::1', '2025-05-24 12:50:54');
INSERT INTO `sys_operation_log` VALUES (22, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"parentId\":0,\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/customer\",\"component\":null,\"perms\":null,\"icon\":\"UserGroup\",\"sort\":5,\"visible\":1}', '::1', '2025-05-24 12:51:18');
INSERT INTO `sys_operation_log` VALUES (23, 1, 'updateMenu', 'PUT', '{\"menuId\":\"28\",\"parentId\":27,\"menuName\":\"客户列表\",\"menuType\":2,\"path\":\"/customer/list\",\"component\":null,\"perms\":\"customer:list\",\"icon\":null,\"sort\":1,\"visible\":1}', '::1', '2025-05-24 12:52:26');
INSERT INTO `sys_operation_log` VALUES (24, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,27,28,29,30,31,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-05-24 13:00:18');
INSERT INTO `sys_operation_log` VALUES (25, 1, 'createMenu', 'POST', '{\"menuName\":\"商品管理\",\"menuType\":1,\"path\":\"/product\",\"component\":\"\",\"perms\":\"\",\"icon\":\"Goods\",\"sort\":6,\"visible\":1}', '::1', '2025-05-24 15:56:53');
INSERT INTO `sys_operation_log` VALUES (26, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"parentId\":0,\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/customer\",\"component\":null,\"perms\":null,\"icon\":\"UserGroup\",\"sort\":15,\"visible\":1}', '::1', '2025-05-24 15:57:00');
INSERT INTO `sys_operation_log` VALUES (27, 1, 'updateMenu', 'PUT', '{\"menuId\":\"1\",\"parentId\":0,\"menuName\":\"系统管理\",\"menuType\":1,\"path\":\"/system\",\"component\":null,\"perms\":null,\"icon\":\"Setting\",\"sort\":50,\"visible\":1}', '::1', '2025-05-24 15:57:08');
INSERT INTO `sys_operation_log` VALUES (28, 1, 'updateMenu', 'PUT', '{\"menuId\":\"33\",\"parentId\":0,\"menuName\":\"商品管理\",\"menuType\":1,\"path\":\"/product\",\"component\":\"\",\"perms\":\"\",\"icon\":\"Goods\",\"sort\":5,\"visible\":1}', '::1', '2025-05-24 15:57:15');
INSERT INTO `sys_operation_log` VALUES (29, 1, 'updateMenu', 'PUT', '{\"menuId\":\"27\",\"parentId\":0,\"menuName\":\"客户管理\",\"menuType\":1,\"path\":\"/customer\",\"component\":null,\"perms\":null,\"icon\":\"User\",\"sort\":15,\"visible\":1}', '::1', '2025-05-24 15:58:42');
INSERT INTO `sys_operation_log` VALUES (30, 1, 'createMenu', 'POST', '{\"parentId\":33,\"menuName\":\"商品分类\",\"menuType\":2,\"path\":\"/product/category\",\"component\":\"\",\"perms\":\"\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-05-24 15:59:15');
INSERT INTO `sys_operation_log` VALUES (31, 1, 'updateMenu', 'PUT', '{\"menuId\":\"34\",\"parentId\":33,\"menuName\":\"商品分类\",\"menuType\":2,\"path\":\"/product/category\",\"component\":\"\",\"perms\":\"productCategory:list\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-05-24 15:59:47');
INSERT INTO `sys_operation_log` VALUES (32, 1, 'createMenu', 'POST', '{\"parentId\":34,\"menuName\":\"新增商品分类\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:add\",\"icon\":\"\",\"sort\":1,\"visible\":1}', '::1', '2025-05-24 16:00:16');
INSERT INTO `sys_operation_log` VALUES (33, 1, 'updateMenu', 'PUT', '{\"menuId\":\"34\",\"parentId\":33,\"menuName\":\"商品分类\",\"menuType\":2,\"path\":\"/product/category\",\"component\":\"\",\"perms\":\"productCategory:list\",\"icon\":\"\",\"sort\":1,\"visible\":1}', '::1', '2025-05-24 16:00:24');
INSERT INTO `sys_operation_log` VALUES (34, 1, 'createMenu', 'POST', '{\"parentId\":34,\"menuName\":\"修改商品分类\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:edit\",\"icon\":\"\",\"sort\":2,\"visible\":1}', '::1', '2025-05-24 16:00:57');
INSERT INTO `sys_operation_log` VALUES (35, 1, 'updateMenu', 'PUT', '{\"menuId\":\"35\",\"parentId\":34,\"menuName\":\"新增商品分类\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:add\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-05-24 16:01:01');
INSERT INTO `sys_operation_log` VALUES (36, 1, 'updateMenu', 'PUT', '{\"menuId\":\"36\",\"parentId\":34,\"menuName\":\"修改商品分类\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:edit\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-05-24 16:01:04');
INSERT INTO `sys_operation_log` VALUES (37, 1, 'createMenu', 'POST', '{\"parentId\":34,\"menuName\":\"删除商品分类\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:delete\",\"icon\":\"\",\"sort\":3,\"visible\":1}', '::1', '2025-05-24 16:01:25');
INSERT INTO `sys_operation_log` VALUES (38, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,33,34,35,36,37,27,28,29,30,31,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-05-24 16:02:30');
INSERT INTO `sys_operation_log` VALUES (39, 1, 'createMenu', 'POST', '{\"parentId\":33,\"menuName\":\"商品列表\",\"menuType\":2,\"path\":\"/product/list\",\"component\":\"\",\"perms\":\"productCategory:list\",\"icon\":\"\",\"sort\":1,\"visible\":1}', '::1', '2025-05-24 16:37:54');
INSERT INTO `sys_operation_log` VALUES (40, 1, 'updateMenu', 'PUT', '{\"menuId\":\"34\",\"parentId\":33,\"menuName\":\"商品分类\",\"menuType\":2,\"path\":\"/product/category\",\"component\":\"\",\"perms\":\"productCategory:list\",\"icon\":\"\",\"sort\":2,\"visible\":1}', '::1', '2025-05-24 16:38:00');
INSERT INTO `sys_operation_log` VALUES (41, 1, 'createMenu', 'POST', '{\"parentId\":38,\"menuName\":\"新增商品\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:add\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-05-24 16:38:27');
INSERT INTO `sys_operation_log` VALUES (42, 1, 'createMenu', 'POST', '{\"parentId\":38,\"menuName\":\"修改商品\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:edit\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-05-24 16:38:51');
INSERT INTO `sys_operation_log` VALUES (43, 1, 'createMenu', 'POST', '{\"parentId\":38,\"menuName\":\"删除商品\",\"menuType\":1,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:delete\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-05-24 16:39:11');
INSERT INTO `sys_operation_log` VALUES (44, 1, 'updateMenu', 'PUT', '{\"menuId\":\"37\",\"parentId\":34,\"menuName\":\"删除商品分类\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"productCategory:delete\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-05-24 16:39:30');
INSERT INTO `sys_operation_log` VALUES (45, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,33,38,39,40,41,34,35,36,37,27,28,29,30,31,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-05-24 16:40:11');
INSERT INTO `sys_operation_log` VALUES (46, 1, 'createMenu', 'POST', '{\"menuName\":\"仓库管理\",\"menuType\":1,\"path\":\"/warehouse\",\"component\":\"\",\"perms\":\"\",\"icon\":\"House\",\"sort\":20,\"visible\":1}', '::1', '2025-05-25 16:24:16');
INSERT INTO `sys_operation_log` VALUES (47, 1, 'createMenu', 'POST', '{\"parentId\":42,\"menuName\":\"仓库列表\",\"menuType\":2,\"path\":\"/warehouse/list\",\"component\":\"\",\"perms\":\"warehouse:list\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-05-25 16:25:45');
INSERT INTO `sys_operation_log` VALUES (48, 1, 'updateMenu', 'PUT', '{\"menuId\":\"43\",\"parentId\":42,\"menuName\":\"仓库列表\",\"menuType\":2,\"path\":\"/warehouse/list\",\"component\":\"\",\"perms\":\"warehouse:list\",\"icon\":\"\",\"sort\":1,\"visible\":1}', '::1', '2025-05-25 16:25:58');
INSERT INTO `sys_operation_log` VALUES (49, 1, 'createMenu', 'POST', '{\"parentId\":43,\"menuName\":\"新增仓库\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"warehouse:add\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-05-25 16:26:25');
INSERT INTO `sys_operation_log` VALUES (50, 1, 'createMenu', 'POST', '{\"parentId\":43,\"menuName\":\"更新仓库\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"warehouse:edit\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-05-25 16:26:55');
INSERT INTO `sys_operation_log` VALUES (51, 1, 'updateMenu', 'PUT', '{\"menuId\":\"45\",\"parentId\":43,\"menuName\":\"更新仓库\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"warehouse:edit\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-05-25 16:27:01');
INSERT INTO `sys_operation_log` VALUES (52, 1, 'createMenu', 'POST', '{\"parentId\":43,\"menuName\":\"删除仓库\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"warehouse:delete\",\"icon\":\"\",\"sort\":4,\"visible\":0}', '::1', '2025-05-25 16:27:21');
INSERT INTO `sys_operation_log` VALUES (53, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,33,38,39,40,41,34,35,36,37,27,28,29,30,31,42,43,44,45,46,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-05-25 16:28:35');
INSERT INTO `sys_operation_log` VALUES (54, 1, 'createMenu', 'POST', '{\"parentId\":42,\"menuName\":\"库存管理\",\"menuType\":2,\"path\":\"/warehouse/inventory\",\"component\":\"\",\"perms\":\"\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-05-25 18:38:41');
INSERT INTO `sys_operation_log` VALUES (55, 1, 'updateMenu', 'PUT', '{\"menuId\":\"47\",\"parentId\":42,\"menuName\":\"库存管理\",\"menuType\":2,\"path\":\"/warehouse/inventory\",\"component\":\"\",\"perms\":\"\",\"icon\":\"\",\"sort\":2,\"visible\":1}', '::1', '2025-05-25 18:38:51');
INSERT INTO `sys_operation_log` VALUES (56, 1, 'createMenu', 'POST', '{\"parentId\":47,\"menuName\":\"库存列表\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"inventory:list\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-05-25 18:39:33');
INSERT INTO `sys_operation_log` VALUES (57, 1, 'createMenu', 'POST', '{\"parentId\":47,\"menuName\":\"新增库存\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"inventory:add\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-05-25 18:40:19');
INSERT INTO `sys_operation_log` VALUES (58, 1, 'createMenu', 'POST', '{\"parentId\":47,\"menuName\":\"更新库存\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"inventory:update\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-05-25 18:40:43');
INSERT INTO `sys_operation_log` VALUES (59, 1, 'createMenu', 'POST', '{\"parentId\":47,\"menuName\":\"删除库存\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"inventory:delete\",\"icon\":\"\",\"sort\":4,\"visible\":0}', '::1', '2025-05-25 18:41:02');
INSERT INTO `sys_operation_log` VALUES (60, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,33,38,39,40,41,34,35,36,37,27,28,29,30,31,42,43,44,45,46,47,48,49,50,51,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-05-25 18:41:21');
INSERT INTO `sys_operation_log` VALUES (61, 1, 'updateMenu', 'PUT', '{\"menuId\":\"39\",\"parentId\":38,\"menuName\":\"新增商品\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"product:add\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-05-26 10:50:04');
INSERT INTO `sys_operation_log` VALUES (62, 1, 'updateMenu', 'PUT', '{\"menuId\":\"40\",\"parentId\":38,\"menuName\":\"修改商品\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"product:update\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-05-26 10:50:19');
INSERT INTO `sys_operation_log` VALUES (63, 1, 'updateMenu', 'PUT', '{\"menuId\":\"40\",\"parentId\":38,\"menuName\":\"修改商品\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"product:edit\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-05-26 10:50:38');
INSERT INTO `sys_operation_log` VALUES (64, 1, 'updateMenu', 'PUT', '{\"menuId\":\"41\",\"parentId\":38,\"menuName\":\"删除商品\",\"menuType\":1,\"path\":\"\",\"component\":\"\",\"perms\":\"product:delete\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-05-26 10:50:52');
INSERT INTO `sys_operation_log` VALUES (65, 1, 'createMenu', 'POST', '{\"parentId\":38,\"menuName\":\"商品统计\",\"menuType\":2,\"path\":\"\",\"component\":\"\",\"perms\":\"product:view\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-05-26 10:51:36');
INSERT INTO `sys_operation_log` VALUES (66, 1, 'updateMenu', 'PUT', '{\"menuId\":\"52\",\"parentId\":33,\"menuName\":\"商品统计\",\"menuType\":2,\"path\":\"\",\"component\":\"\",\"perms\":\"product:view\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-05-26 10:51:55');
INSERT INTO `sys_operation_log` VALUES (67, 1, 'updateMenu', 'PUT', '{\"menuId\":\"52\",\"parentId\":33,\"menuName\":\"商品统计\",\"menuType\":2,\"path\":\"\",\"component\":\"\",\"perms\":\"product:view\",\"icon\":\"\",\"sort\":3,\"visible\":1}', '::1', '2025-05-26 10:52:10');
INSERT INTO `sys_operation_log` VALUES (68, 1, 'updateMenu', 'PUT', '{\"menuId\":\"41\",\"parentId\":38,\"menuName\":\"删除商品\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"product:delete\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-05-26 10:52:21');
INSERT INTO `sys_operation_log` VALUES (69, 1, 'updateMenu', 'PUT', '{\"menuId\":\"52\",\"parentId\":33,\"menuName\":\"商品统计\",\"menuType\":2,\"path\":\"/product/statistics\",\"component\":\"\",\"perms\":\"product:view\",\"icon\":\"\",\"sort\":3,\"visible\":1}', '::1', '2025-05-26 11:00:36');
INSERT INTO `sys_operation_log` VALUES (70, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,33,38,39,40,41,34,35,36,37,52,27,28,29,30,31,42,43,44,45,46,47,48,49,50,51,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-05-26 11:00:52');
INSERT INTO `sys_operation_log` VALUES (71, 1, 'createMenu', 'POST', '{\"parentId\":27,\"menuName\":\"客户分析\",\"menuType\":2,\"path\":\"/customer/analysis\",\"component\":\"\",\"perms\":\"customer:list\",\"icon\":\"\",\"sort\":2,\"visible\":1}', '::1', '2025-05-26 15:29:44');
INSERT INTO `sys_operation_log` VALUES (72, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-03 12:59:30');
INSERT INTO `sys_operation_log` VALUES (73, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-03 12:59:45');
INSERT INTO `sys_operation_log` VALUES (74, 1, 'deleteMenu', 'DELETE', '{\"menuId\":44}', '::1', '2025-06-03 13:00:06');
INSERT INTO `sys_operation_log` VALUES (75, 1, 'deleteMenu', 'DELETE', '{\"menuId\":46}', '::1', '2025-06-03 13:00:10');
INSERT INTO `sys_operation_log` VALUES (76, 1, 'deleteMenu', 'DELETE', '{\"menuId\":45}', '::1', '2025-06-03 13:00:12');
INSERT INTO `sys_operation_log` VALUES (77, 1, 'deleteMenu', 'DELETE', '{\"menuId\":43}', '::1', '2025-06-03 13:00:13');
INSERT INTO `sys_operation_log` VALUES (78, 1, 'deleteMenu', 'DELETE', '{\"menuId\":51}', '::1', '2025-06-03 13:00:19');
INSERT INTO `sys_operation_log` VALUES (79, 1, 'deleteMenu', 'DELETE', '{\"menuId\":50}', '::1', '2025-06-03 13:00:21');
INSERT INTO `sys_operation_log` VALUES (80, 1, 'deleteMenu', 'DELETE', '{\"menuId\":49}', '::1', '2025-06-03 13:00:23');
INSERT INTO `sys_operation_log` VALUES (81, 1, 'deleteMenu', 'DELETE', '{\"menuId\":48}', '::1', '2025-06-03 13:00:25');
INSERT INTO `sys_operation_log` VALUES (82, 1, 'deleteMenu', 'DELETE', '{\"menuId\":47}', '::1', '2025-06-03 13:00:26');
INSERT INTO `sys_operation_log` VALUES (83, 1, 'deleteMenu', 'DELETE', '{\"menuId\":42}', '::1', '2025-06-03 13:00:29');
INSERT INTO `sys_operation_log` VALUES (84, 1, 'deleteMenu', 'DELETE', '{\"menuId\":53}', '::1', '2025-06-03 13:00:33');
INSERT INTO `sys_operation_log` VALUES (85, 1, 'deleteMenu', 'DELETE', '{\"menuId\":31}', '::1', '2025-06-03 13:00:37');
INSERT INTO `sys_operation_log` VALUES (86, 1, 'deleteMenu', 'DELETE', '{\"menuId\":30}', '::1', '2025-06-03 13:00:39');
INSERT INTO `sys_operation_log` VALUES (87, 1, 'deleteMenu', 'DELETE', '{\"menuId\":29}', '::1', '2025-06-03 13:00:40');
INSERT INTO `sys_operation_log` VALUES (88, 1, 'deleteMenu', 'DELETE', '{\"menuId\":28}', '::1', '2025-06-03 13:00:42');
INSERT INTO `sys_operation_log` VALUES (89, 1, 'deleteMenu', 'DELETE', '{\"menuId\":27}', '::1', '2025-06-03 13:00:44');
INSERT INTO `sys_operation_log` VALUES (90, 1, 'deleteMenu', 'DELETE', '{\"menuId\":52}', '::1', '2025-06-03 13:00:48');
INSERT INTO `sys_operation_log` VALUES (91, 1, 'deleteMenu', 'DELETE', '{\"menuId\":37}', '::1', '2025-06-03 13:00:51');
INSERT INTO `sys_operation_log` VALUES (92, 1, 'deleteMenu', 'DELETE', '{\"menuId\":36}', '::1', '2025-06-03 13:00:52');
INSERT INTO `sys_operation_log` VALUES (93, 1, 'deleteMenu', 'DELETE', '{\"menuId\":35}', '::1', '2025-06-03 13:00:54');
INSERT INTO `sys_operation_log` VALUES (94, 1, 'deleteMenu', 'DELETE', '{\"menuId\":34}', '::1', '2025-06-03 13:00:55');
INSERT INTO `sys_operation_log` VALUES (95, 1, 'deleteMenu', 'DELETE', '{\"menuId\":41}', '::1', '2025-06-03 13:01:00');
INSERT INTO `sys_operation_log` VALUES (96, 1, 'deleteMenu', 'DELETE', '{\"menuId\":40}', '::1', '2025-06-03 13:01:01');
INSERT INTO `sys_operation_log` VALUES (97, 1, 'deleteMenu', 'DELETE', '{\"menuId\":39}', '::1', '2025-06-03 13:01:03');
INSERT INTO `sys_operation_log` VALUES (98, 1, 'deleteMenu', 'DELETE', '{\"menuId\":38}', '::1', '2025-06-03 13:01:05');
INSERT INTO `sys_operation_log` VALUES (99, 1, 'deleteMenu', 'DELETE', '{\"menuId\":33}', '::1', '2025-06-03 13:01:07');
INSERT INTO `sys_operation_log` VALUES (100, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-03 13:01:13');
INSERT INTO `sys_operation_log` VALUES (101, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"2\",\"menuIds\":[26,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,1]}', '::1', '2025-06-03 13:01:18');
INSERT INTO `sys_operation_log` VALUES (102, 1, 'updateRole', 'PUT', '{\"roleId\":\"2\",\"roleName\":\"运营\",\"remark\":\"负责用户增长、活跃度，社群管理与用户互动，市场推广与品牌建设\",\"dataScope\":1}', '::1', '2025-06-03 13:01:23');
INSERT INTO `sys_operation_log` VALUES (103, 1, 'updateRole', 'PUT', '{\"roleId\":\"2\",\"roleName\":\"运营\",\"remark\":\"负责用户增长、活跃度，社群管理与用户互动，市场推广与品牌建设\",\"dataScope\":2}', '::1', '2025-06-03 13:01:32');
INSERT INTO `sys_operation_log` VALUES (104, 1, 'createMenu', 'POST', '{\"menuName\":\"账密管理\",\"menuType\":1,\"path\":\"/account/list\",\"component\":\"\",\"perms\":\"\",\"icon\":\"Key\",\"sort\":1,\"visible\":1}', '::1', '2025-06-03 21:07:00');
INSERT INTO `sys_operation_log` VALUES (105, 1, 'updateMenu', 'PUT', '{\"menuId\":\"54\",\"parentId\":0,\"menuName\":\"账密管理\",\"menuType\":1,\"path\":\"/account\",\"component\":\"\",\"perms\":\"\",\"icon\":\"Key\",\"sort\":1,\"visible\":1}', '::1', '2025-06-03 21:07:23');
INSERT INTO `sys_operation_log` VALUES (106, 1, 'createMenu', 'POST', '{\"parentId\":54,\"menuName\":\"账密列表\",\"menuType\":2,\"path\":\"/account/list\",\"component\":\"\",\"perms\":\"account_password:view\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-06-03 21:08:39');
INSERT INTO `sys_operation_log` VALUES (107, 1, 'createMenu', 'POST', '{\"parentId\":55,\"menuName\":\"创建账密\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"account_password:create\",\"icon\":\"\",\"sort\":0,\"visible\":0}', '::1', '2025-06-03 21:09:22');
INSERT INTO `sys_operation_log` VALUES (108, 1, 'createMenu', 'POST', '{\"parentId\":55,\"menuName\":\"修改账密\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"account_password:edit\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-06-03 21:10:02');
INSERT INTO `sys_operation_log` VALUES (109, 1, 'createMenu', 'POST', '{\"parentId\":55,\"menuName\":\"删除账密\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"account_password:delete\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-06-03 21:10:41');
INSERT INTO `sys_operation_log` VALUES (110, 1, 'createMenu', 'POST', '{\"parentId\":55,\"menuName\":\"查看账密\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"account_password:view\",\"icon\":\"\",\"sort\":4,\"visible\":1}', '::1', '2025-06-03 21:11:09');
INSERT INTO `sys_operation_log` VALUES (111, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-03 21:12:49');
INSERT INTO `sys_operation_log` VALUES (112, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-03 21:16:51');
INSERT INTO `sys_operation_log` VALUES (113, 1, 'updateMenu', 'PUT', '{\"menuId\":\"55\",\"parentId\":54,\"menuName\":\"账密列表\",\"menuType\":2,\"path\":\"/account/list\",\"component\":\"\",\"perms\":\"account_password:list\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-06-03 21:46:48');
INSERT INTO `sys_operation_log` VALUES (114, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-03 21:46:55');
INSERT INTO `sys_operation_log` VALUES (115, 2, 'createMenu', 'POST', '{\"parentId\":55,\"menuName\":\"查看账密列表\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"account_password:list\",\"icon\":\"\",\"sort\":5,\"visible\":0}', '::1', '2025-06-03 21:51:24');
INSERT INTO `sys_operation_log` VALUES (116, 2, 'updateMenu', 'PUT', '{\"menuId\":\"59\",\"parentId\":55,\"menuName\":\"查看账密\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"account_password:view\",\"icon\":\"\",\"sort\":4,\"visible\":0}', '::1', '2025-06-03 21:51:27');
INSERT INTO `sys_operation_log` VALUES (117, 2, 'assignRoleMenus', 'POST', '{\"roleId\":\"2\",\"menuIds\":[26,60,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,54,55]}', '::1', '2025-06-03 21:51:35');
INSERT INTO `sys_operation_log` VALUES (118, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,60,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-03 22:02:12');
INSERT INTO `sys_operation_log` VALUES (119, 1, 'createMenu', 'POST', '{\"menuName\":\"通知管理\",\"menuType\":1,\"path\":\"/notice\",\"component\":\"\",\"perms\":\"\",\"icon\":\"Bell\",\"sort\":1,\"visible\":1}', '::1', '2025-06-04 11:07:01');
INSERT INTO `sys_operation_log` VALUES (120, 1, 'createMenu', 'POST', '{\"parentId\":61,\"menuName\":\"菜单列表\",\"menuType\":2,\"path\":\"/notice/list\",\"component\":\"\",\"perms\":\"\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-06-04 11:07:44');
INSERT INTO `sys_operation_log` VALUES (121, 1, 'updateMenu', 'PUT', '{\"menuId\":\"62\",\"parentId\":61,\"menuName\":\"通知列表\",\"menuType\":2,\"path\":\"/notice/list\",\"component\":\"\",\"perms\":\"\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-06-04 11:08:07');
INSERT INTO `sys_operation_log` VALUES (122, 1, 'createMenu', 'POST', '{\"parentId\":62,\"menuName\":\"创建通知/公告\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:create\",\"icon\":\"\",\"sort\":0,\"visible\":0}', '::1', '2025-06-04 11:08:24');
INSERT INTO `sys_operation_log` VALUES (123, 1, 'createMenu', 'POST', '{\"parentId\":62,\"menuName\":\"获取所有通知列表（管理员）\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:admin\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-06-04 11:09:08');
INSERT INTO `sys_operation_log` VALUES (124, 1, 'createMenu', 'POST', '{\"parentId\":62,\"menuName\":\"删除通知\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:delete\",\"icon\":\"\",\"sort\":2,\"visible\":1}', '::1', '2025-06-04 11:09:39');
INSERT INTO `sys_operation_log` VALUES (125, 1, 'updateMenu', 'PUT', '{\"menuId\":\"65\",\"parentId\":62,\"menuName\":\"删除通知\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:delete\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-06-04 11:09:43');
INSERT INTO `sys_operation_log` VALUES (126, 1, 'createMenu', 'POST', '{\"parentId\":62,\"menuName\":\"获取通知阅读状态\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:read\",\"icon\":\"\",\"sort\":4,\"visible\":0}', '::1', '2025-06-04 11:10:13');
INSERT INTO `sys_operation_log` VALUES (127, 1, 'createMenu', 'POST', '{\"parentId\":62,\"menuName\":\"获取通知列表\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:list\",\"icon\":\"\",\"sort\":5,\"visible\":0}', '::1', '2025-06-04 11:11:04');
INSERT INTO `sys_operation_log` VALUES (128, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,60,61,62,63,64,65,66,67,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-04 11:11:55');
INSERT INTO `sys_operation_log` VALUES (129, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,60,63,64,65,67,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,61,62]}', '::1', '2025-06-04 13:54:17');
INSERT INTO `sys_operation_log` VALUES (130, 1, 'deleteMenu', 'DELETE', '{\"menuId\":66}', '::1', '2025-06-04 13:54:37');
INSERT INTO `sys_operation_log` VALUES (131, 1, 'createMenu', 'POST', '{\"parentId\":61,\"menuName\":\"我的通知\",\"menuType\":2,\"path\":\"/notice/my\",\"component\":\"\",\"perms\":\"\",\"icon\":\"\",\"sort\":2,\"visible\":1}', '::1', '2025-06-04 13:58:20');
INSERT INTO `sys_operation_log` VALUES (132, 1, 'updateMenu', 'PUT', '{\"menuId\":\"68\",\"parentId\":61,\"menuName\":\"我的通知\",\"menuType\":2,\"path\":\"/notice/my\",\"component\":\"\",\"perms\":\"\",\"icon\":\"\",\"sort\":1,\"visible\":1}', '::1', '2025-06-04 13:58:28');
INSERT INTO `sys_operation_log` VALUES (133, 1, 'createMenu', 'POST', '{\"parentId\":68,\"menuName\":\"标记通知为已读\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:read\",\"icon\":\"\",\"sort\":0,\"visible\":0}', '::1', '2025-06-04 13:59:32');
INSERT INTO `sys_operation_log` VALUES (134, 1, 'createMenu', 'POST', '{\"parentId\":68,\"menuName\":\"获取当前用户的通知列表\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:userlist\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-06-04 14:00:11');
INSERT INTO `sys_operation_log` VALUES (135, 1, 'createMenu', 'POST', '{\"parentId\":68,\"menuName\":\"获取未读通知数量\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"notification:unread\",\"icon\":\"\",\"sort\":2,\"visible\":0}', '::1', '2025-06-04 14:01:12');
INSERT INTO `sys_operation_log` VALUES (136, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,60,61,62,63,64,65,67,68,69,70,71,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-04 14:04:37');
INSERT INTO `sys_operation_log` VALUES (137, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"2\",\"menuIds\":[26,60,68,69,70,71,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,54,55,61]}', '::1', '2025-06-04 14:49:56');
INSERT INTO `sys_operation_log` VALUES (138, 1, 'updateMenu', 'PUT', '{\"menuId\":\"61\",\"parentId\":0,\"menuName\":\"通知管理\",\"menuType\":1,\"path\":\"/notice\",\"component\":\"\",\"perms\":\"\",\"icon\":\"Bell\",\"sort\":2,\"visible\":1}', '::1', '2025-06-04 21:46:27');
INSERT INTO `sys_operation_log` VALUES (139, 1, 'createMenu', 'POST', '{\"menuName\":\"项目管理\",\"menuType\":1,\"path\":\"/projects\",\"component\":\"\",\"perms\":\"\",\"icon\":\"Folder\",\"sort\":3,\"visible\":1}', '::1', '2025-06-04 21:47:01');
INSERT INTO `sys_operation_log` VALUES (140, 1, 'createMenu', 'POST', '{\"parentId\":72,\"menuName\":\"项目列表\",\"menuType\":2,\"path\":\"/projects/list\",\"component\":\"\",\"perms\":\"project:view\",\"icon\":\"\",\"sort\":0,\"visible\":1}', '::1', '2025-06-04 21:47:46');
INSERT INTO `sys_operation_log` VALUES (141, 1, 'createMenu', 'POST', '{\"parentId\":73,\"menuName\":\"创建新项目\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"project:create\",\"icon\":\"\",\"sort\":0,\"visible\":0}', '::1', '2025-06-04 21:48:28');
INSERT INTO `sys_operation_log` VALUES (142, 1, 'createMenu', 'POST', '{\"parentId\":73,\"menuName\":\"更新项目信息\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"project:edit\",\"icon\":\"\",\"sort\":1,\"visible\":0}', '::1', '2025-06-04 21:49:06');
INSERT INTO `sys_operation_log` VALUES (143, 1, 'createMenu', 'POST', '{\"parentId\":73,\"menuName\":\"删除项目\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"project:delete\",\"icon\":\"\",\"sort\":3,\"visible\":0}', '::1', '2025-06-04 21:49:23');
INSERT INTO `sys_operation_log` VALUES (144, 1, 'createMenu', 'POST', '{\"parentId\":73,\"menuName\":\"添加项目成员\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"project:manage_members\",\"icon\":\"\",\"sort\":4,\"visible\":0}', '::1', '2025-06-04 21:49:43');
INSERT INTO `sys_operation_log` VALUES (145, 1, 'updateMenu', 'PUT', '{\"menuId\":\"77\",\"parentId\":73,\"menuName\":\"项目成员功能\",\"menuType\":3,\"path\":\"\",\"component\":\"\",\"perms\":\"project:manage_members\",\"icon\":\"\",\"sort\":4,\"visible\":0}', '::1', '2025-06-04 21:50:17');
INSERT INTO `sys_operation_log` VALUES (146, 1, 'assignRoleMenus', 'POST', '{\"roleId\":\"1\",\"menuIds\":[26,54,55,56,57,58,59,60,61,62,63,64,65,67,68,69,70,71,72,73,74,75,76,77,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}', '::1', '2025-06-04 21:50:32');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '角色编码',
  `role_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '角色名称',
  `data_scope` tinyint NULL DEFAULT 3 COMMENT '数据权限(1-本人 2-部门 3-全部)',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`role_id`) USING BTREE,
  UNIQUE INDEX `role_code`(`role_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, 'ADMIN', '管理员', 3, '系统管理员角色', '2025-05-22 23:03:02', '2025-05-23 15:59:05');
INSERT INTO `sys_role` VALUES (2, 'OPSUO101', '运营', 2, '负责用户增长、活跃度，社群管理与用户互动，市场推广与品牌建设', '2025-05-23 18:42:57', '2025-06-03 13:01:32');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 781 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '角色菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (756, 1, 1);
INSERT INTO `sys_role_menu` VALUES (757, 1, 2);
INSERT INTO `sys_role_menu` VALUES (758, 1, 3);
INSERT INTO `sys_role_menu` VALUES (759, 1, 4);
INSERT INTO `sys_role_menu` VALUES (760, 1, 5);
INSERT INTO `sys_role_menu` VALUES (761, 1, 6);
INSERT INTO `sys_role_menu` VALUES (762, 1, 7);
INSERT INTO `sys_role_menu` VALUES (763, 1, 8);
INSERT INTO `sys_role_menu` VALUES (764, 1, 9);
INSERT INTO `sys_role_menu` VALUES (765, 1, 10);
INSERT INTO `sys_role_menu` VALUES (766, 1, 11);
INSERT INTO `sys_role_menu` VALUES (767, 1, 12);
INSERT INTO `sys_role_menu` VALUES (768, 1, 13);
INSERT INTO `sys_role_menu` VALUES (769, 1, 14);
INSERT INTO `sys_role_menu` VALUES (770, 1, 15);
INSERT INTO `sys_role_menu` VALUES (771, 1, 16);
INSERT INTO `sys_role_menu` VALUES (772, 1, 17);
INSERT INTO `sys_role_menu` VALUES (773, 1, 18);
INSERT INTO `sys_role_menu` VALUES (774, 1, 19);
INSERT INTO `sys_role_menu` VALUES (775, 1, 20);
INSERT INTO `sys_role_menu` VALUES (776, 1, 21);
INSERT INTO `sys_role_menu` VALUES (777, 1, 22);
INSERT INTO `sys_role_menu` VALUES (778, 1, 23);
INSERT INTO `sys_role_menu` VALUES (779, 1, 24);
INSERT INTO `sys_role_menu` VALUES (780, 1, 25);
INSERT INTO `sys_role_menu` VALUES (732, 1, 26);
INSERT INTO `sys_role_menu` VALUES (733, 1, 54);
INSERT INTO `sys_role_menu` VALUES (734, 1, 55);
INSERT INTO `sys_role_menu` VALUES (735, 1, 56);
INSERT INTO `sys_role_menu` VALUES (736, 1, 57);
INSERT INTO `sys_role_menu` VALUES (737, 1, 58);
INSERT INTO `sys_role_menu` VALUES (738, 1, 59);
INSERT INTO `sys_role_menu` VALUES (739, 1, 60);
INSERT INTO `sys_role_menu` VALUES (740, 1, 61);
INSERT INTO `sys_role_menu` VALUES (741, 1, 62);
INSERT INTO `sys_role_menu` VALUES (742, 1, 63);
INSERT INTO `sys_role_menu` VALUES (743, 1, 64);
INSERT INTO `sys_role_menu` VALUES (744, 1, 65);
INSERT INTO `sys_role_menu` VALUES (745, 1, 67);
INSERT INTO `sys_role_menu` VALUES (746, 1, 68);
INSERT INTO `sys_role_menu` VALUES (747, 1, 69);
INSERT INTO `sys_role_menu` VALUES (748, 1, 70);
INSERT INTO `sys_role_menu` VALUES (749, 1, 71);
INSERT INTO `sys_role_menu` VALUES (750, 1, 72);
INSERT INTO `sys_role_menu` VALUES (751, 1, 73);
INSERT INTO `sys_role_menu` VALUES (752, 1, 74);
INSERT INTO `sys_role_menu` VALUES (753, 1, 75);
INSERT INTO `sys_role_menu` VALUES (754, 1, 76);
INSERT INTO `sys_role_menu` VALUES (755, 1, 77);
INSERT INTO `sys_role_menu` VALUES (704, 2, 1);
INSERT INTO `sys_role_menu` VALUES (705, 2, 2);
INSERT INTO `sys_role_menu` VALUES (706, 2, 3);
INSERT INTO `sys_role_menu` VALUES (707, 2, 4);
INSERT INTO `sys_role_menu` VALUES (708, 2, 5);
INSERT INTO `sys_role_menu` VALUES (709, 2, 6);
INSERT INTO `sys_role_menu` VALUES (710, 2, 7);
INSERT INTO `sys_role_menu` VALUES (711, 2, 8);
INSERT INTO `sys_role_menu` VALUES (712, 2, 9);
INSERT INTO `sys_role_menu` VALUES (713, 2, 10);
INSERT INTO `sys_role_menu` VALUES (714, 2, 11);
INSERT INTO `sys_role_menu` VALUES (715, 2, 12);
INSERT INTO `sys_role_menu` VALUES (716, 2, 13);
INSERT INTO `sys_role_menu` VALUES (717, 2, 14);
INSERT INTO `sys_role_menu` VALUES (718, 2, 15);
INSERT INTO `sys_role_menu` VALUES (719, 2, 16);
INSERT INTO `sys_role_menu` VALUES (720, 2, 17);
INSERT INTO `sys_role_menu` VALUES (721, 2, 18);
INSERT INTO `sys_role_menu` VALUES (722, 2, 19);
INSERT INTO `sys_role_menu` VALUES (723, 2, 20);
INSERT INTO `sys_role_menu` VALUES (724, 2, 21);
INSERT INTO `sys_role_menu` VALUES (725, 2, 22);
INSERT INTO `sys_role_menu` VALUES (726, 2, 23);
INSERT INTO `sys_role_menu` VALUES (727, 2, 24);
INSERT INTO `sys_role_menu` VALUES (728, 2, 25);
INSERT INTO `sys_role_menu` VALUES (698, 2, 26);
INSERT INTO `sys_role_menu` VALUES (729, 2, 54);
INSERT INTO `sys_role_menu` VALUES (730, 2, 55);
INSERT INTO `sys_role_menu` VALUES (699, 2, 60);
INSERT INTO `sys_role_menu` VALUES (731, 2, 61);
INSERT INTO `sys_role_menu` VALUES (700, 2, 68);
INSERT INTO `sys_role_menu` VALUES (701, 2, 69);
INSERT INTO `sys_role_menu` VALUES (702, 2, 70);
INSERT INTO `sys_role_menu` VALUES (703, 2, 71);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '登录账号',
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '加密密码',
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '真实姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '手机号',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '所属部门',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(0-禁用 1-启用)',
  `remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '系统用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2b$10$gGD6U4DSjGV76WSmReFURekr6RcfIPPq2Es64/b5c7jRmhrN93PfS', '汪义强', NULL, '3467520359@qq.com', '19360256621', 5, 1, '', '2025-06-04 22:04:18', '2025-05-22 14:52:33', '2025-05-24 10:41:36');
INSERT INTO `sys_user` VALUES (2, 'zhang', '$2b$10$Dcq3Sz61PwUauTTsSKPJSeA0Ck4FNdK7TN3vw4IdHRhSaW1nWqlM2', '张昕', NULL, 'wangyiqiang59@gmail.com', '18555444800', 1, 1, NULL, '2025-06-04 14:50:08', '2025-05-23 17:43:44', '2025-05-23 18:44:12');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (6, 1, 1);
INSERT INTO `sys_user_role` VALUES (3, 2, 2);

SET FOREIGN_KEY_CHECKS = 1;
