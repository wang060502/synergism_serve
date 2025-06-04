const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');

// 配置文件存储
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

// 文件过滤器
const fileFilter = (req, file, cb) => {
  // 允许的文件类型
  const allowedTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/pdf',
    'application/msword', // .doc
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document', // .docx
    'application/vnd.ms-excel', // .xls
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // .xlsx
    'application/vnd.ms-powerpoint', // .ppt
    'application/vnd.openxmlformats-officedocument.presentationml.presentation', // .pptx
    'application/octet-stream' // 兼容部分上传
  ];
  if (allowedTypes.includes(file.mimetype)) {
    // 对于 application/octet-stream，进一步判断扩展名
    if (
      file.mimetype === 'application/octet-stream' &&
      !['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx'].includes(path.extname(file.originalname).toLowerCase())
    ) {
      return cb(new Error('不支持的文件类型！'), false);
    }
    cb(null, true);
  } else {
    cb(new Error('不支持的文件类型！'), false);
  }
};

const upload = multer({ 
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024 // 限制5MB
  }
});

/**
 * @swagger
 * tags:
 *   - name: 文件管理
 *     description: 文件上传相关接口
 */

/**
 * @swagger
 * /api/files/upload:
 *   post:
 *     summary: 上传文件
 *     description: 上传单个文件并返回文件URL
 *     tags: [文件管理]
 *     consumes:
 *       - multipart/form-data
 *     parameters:
 *       - in: formData
 *         name: file
 *         type: file
 *         required: true
 *         description: 要上传的文件（支持 jpg, png, gif, pdf，最大 5MB）
 *     responses:
 *       200:
 *         description: 文件上传成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: 文件上传成功
 *                 file:
 *                   type: object
 *                   properties:
 *                     filename:
 *                       type: string
 *                       description: 服务器上的文件名
 *                     originalname:
 *                       type: string
 *                       description: 原始文件名
 *                     size:
 *                       type: number
 *                       description: 文件大小（字节）
 *                     url:
 *                       type: string
 *                       description: 文件访问URL
 *       400:
 *         description: 请求错误
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: 没有文件被上传
 *       500:
 *         description: 服务器错误
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: 文件上传失败
 */
// 上传文件
router.post('/upload', upload.single('file'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: '没有文件被上传' });
    }
    
    // 构建文件URL
    const fileUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
    
    res.json({
      code: 200,
      message: '文件上传成功',
      file: {
        filename: req.file.filename,
        originalname: req.file.originalname,
        size: req.file.size,
        url: fileUrl
      }
    });
  } catch (error) {
    res.status(500).json({ error: '文件上传失败' });
  }
});

module.exports = router; 