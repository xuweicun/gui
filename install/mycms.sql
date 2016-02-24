/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50128
Source Host           : localhost:3306
Source Database       : mycms

Target Server Type    : MYSQL
Target Server Version : 50128
File Encoding         : 65001

Date: 2013-11-26 14:35:31
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `pre_article`
-- ----------------------------
DROP TABLE IF EXISTS `pre_article`;
CREATE TABLE `pre_article` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章表自增主键',
  `nid` char(20) NOT NULL COMMENT '文章自定义编号',
  `title` char(90) NOT NULL COMMENT '标题',
  `content` varchar(9000) NOT NULL COMMENT '文章内容',
  `keyword` char(180) NOT NULL COMMENT '10个关键词',
  `tag` char(150) NOT NULL COMMENT '10个文章标签',
  `addtime` datetime NOT NULL COMMENT '文章发表时间',
  `edittime` datetime NOT NULL COMMENT '文章编辑时间',
  `edithistory` char(255) NOT NULL COMMENT '文章编辑时间',
  `ip` char(60) NOT NULL COMMENT '作者ip地址',
  `sid` char(30) NOT NULL COMMENT '文章所属分类id',
  `sort` char(60) NOT NULL COMMENT '文章分类名称',
  `imgtype` int(2) unsigned NOT NULL COMMENT '文章附件类型',
  `imgaddr` varchar(600) NOT NULL COMMENT '文章附件地址 length 30 * 20 img',
  `mode` int(5) NOT NULL DEFAULT '1' COMMENT '文章模型',
  `status` char(8) NOT NULL DEFAULT '1' COMMENT '文章的状态:2的n次方.01 2 4 8 16 32 ...1024',
  `uid` char(90) NOT NULL COMMENT '作者id',
  `username` char(90) NOT NULL COMMENT '作者名字',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_article
-- ----------------------------
INSERT INTO `pre_article` VALUES ('1', '', 'hhhhhhuuuu777777', 'hhhhhhuuuuuuuuuuuuuuuuu', '', '', '2013-03-04 14:25:16', '2013-03-04 14:25:16', '', '127.0.0.1', '001', '1', '0', '', '1', '1', '', '');
INSERT INTO `pre_article` VALUES ('2', '', 'bnnnnnnnnnnnnnnnnnbbbbbbbbbbb', '899999999900jjjjjjjjjjjnnnnnnnnnnnnmmmmmmmmmmm', '', '', '2013-03-04 14:26:06', '2013-03-04 14:26:06', '', '127.0.0.1', '001', '1', '0', '', '1', '1', '', '');
INSERT INTO `pre_article` VALUES ('3', '', 'just reply & download this game...', 'kkkkkkkkkkkkkk\r\n\r\n<br /><b>Notice</b>:  Only variable references should be returned by reference in <b>F:\\APMServ5.2.6\\www\\htdocs\\mycms\\plugin\\pscws3\\pscws3.class.php</b> on line <b>452</b><br />', 'kkkkkkkkkkkkkk', '', '2013-05-25 20:54:46', '2013-05-25 20:54:46', '', '127.0.0.1', '0', '*自动分类', '0', '', '1', '1', '', '');
INSERT INTO `pre_article` VALUES ('4', '', 'just reply & download this game...', 'kkkkkkkkkkkkkk\r\n\r\n<br /><b>Notice</b>:  Only variable references should be returned by reference in <b>F:\\APMServ5.2.6\\www\\htdocs\\mycms\\plugin\\pscws3\\pscws3.class.php</b> on line <b>452</b><br />\r\n\r\n\r\n<img src=\"./attachment/1369486527_419683.jpg\" />', '', '', '2013-05-25 20:55:40', '2013-05-25 20:55:40', '', '127.0.0.1', '0', '*自动分类', '0', '1369486527_419683.jpg', '1', '1', '', '');
INSERT INTO `pre_article` VALUES ('5', '', '云对雨，雪对风，晚照对晴空。长虹对落', '请选择主题相关的分类\r\n云对雨，雪对风，晚照对晴空。长虹对落雁，宿鸟对鸣虫。\r\n\r\n<img src=\"./attachment/1369502677_190536.jpg\" />\r\n\r\n<img src=\"./attachment/1369502711_106539.gif\" />', '云 雨 雪 风 晚照 晴空 长虹 落雁 宿鸟 鸣 虫', '', '2013-05-26 01:26:31', '2013-05-26 01:26:31', '', '127.0.0.1', 'auto', '*自动分类', '0', '', '1', '1', '', '');
INSERT INTO `pre_article` VALUES ('6', '', '丹亭悟真篇', '丹亭悟真篇 丹亭悟真篇 丹亭悟真篇\r\n<img src=\"./attachment/1374029559_012347.png\" />\r\n\r\n<img src=\"./attachment/1374029559_014723.gif\" />', '丹 亭 悟 真 篇', '', '2013-07-17 11:04:43', '2013-07-17 11:04:43', '', '127.0.0.1', '0', '*自动分类', '0', '1374029559_012347.png;1374029559_014723.gif', '1', '1', '', '');
INSERT INTO `pre_article` VALUES ('7', '', 'ffffffffff', 'ddddd \r\nffff\r\n<img src=\"./attachment/1376373116_371763.jpg\" />', '', '', '2013-08-13 13:52:08', '2013-08-13 13:52:08', '', '127.0.0.1', '0', '*自动分类', '0', '1376373116_371763.jpg', '1', '1', '', '');
INSERT INTO `pre_article` VALUES ('8', '', '丹亭悟真篇', 'ali_069.gif\r\nAll images received.', 'ali_ 069. All images received.', '', '2013-09-05 23:39:53', '2013-09-05 23:39:53', '', '127.0.0.1', '002000', '&nbsp;&nbsp;--栏目改呗。。湖广会馆好', '0', '1378395570_137938.jpg;1378395570_337891.gif;1378395571_719833.gif', '1', '1', '', '');

-- ----------------------------
-- Table structure for `pre_article_cmm`
-- ----------------------------
DROP TABLE IF EXISTS `pre_article_cmm`;
CREATE TABLE `pre_article_cmm` (
  `id` int(9) unsigned NOT NULL AUTO_INCREMENT COMMENT '评论的号序',
  `aid` int(9) unsigned NOT NULL COMMENT '文章的序号',
  `statu` tinyint(1) unsigned NOT NULL COMMENT '状态',
  `content` varchar(1050) NOT NULL COMMENT '评论的内容',
  `addtime` datetime NOT NULL COMMENT '评论时间',
  `ip` varchar(40) NOT NULL COMMENT 'ip地址',
  `uid` int(9) unsigned NOT NULL COMMENT '评论人uid',
  `uname` char(15) NOT NULL COMMENT '评论人账号',
  PRIMARY KEY (`id`,`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_article_cmm
-- ----------------------------
INSERT INTO `pre_article_cmm` VALUES ('1', '2', '0', '没有评论数据.', '2013-03-05 09:45:53', '127.0.0.1', '0', '');
INSERT INTO `pre_article_cmm` VALUES ('2', '2', '0', 'ddddddddddddddddddddd', '2013-05-25 20:51:48', '127.0.0.1', '0', '');
INSERT INTO `pre_article_cmm` VALUES ('3', '5', '0', '评论1评论1评论1', '2013-05-26 01:27:16', '127.0.0.1', '0', '');
INSERT INTO `pre_article_cmm` VALUES ('4', '5', '0', '评论2评论2评论2评论2222', '2013-05-26 01:27:34', '127.0.0.1', '0', '');
INSERT INTO `pre_article_cmm` VALUES ('5', '7', '0', 'ddddddddddddddddd', '2013-08-13 13:52:38', '127.0.0.1', '0', '');
INSERT INTO `pre_article_cmm` VALUES ('6', '5', '0', '看起来不错呀', '2013-09-11 16:44:59', '127.0.0.1', '0', '');
INSERT INTO `pre_article_cmm` VALUES ('7', '5', '0', '琳琳你喜欢吗', '2013-09-11 16:45:24', '127.0.0.1', '0', '');

-- ----------------------------
-- Table structure for `pre_member`
-- ----------------------------
DROP TABLE IF EXISTS `pre_member`;
CREATE TABLE `pre_member` (
  `uid` int(9) unsigned NOT NULL AUTO_INCREMENT COMMENT '系统主键',
  `mid` char(12) NOT NULL COMMENT '会员数字序号',
  `introduced` char(30) DEFAULT NULL COMMENT '推荐者的用户名',
  `uname` char(30) NOT NULL,
  `upass` char(100) NOT NULL COMMENT 'password',
  `email` char(30) DEFAULT NULL,
  `email_status` tinyint(1) unsigned DEFAULT NULL COMMENT '邮箱验证状态',
  `phone` char(30) DEFAULT NULL,
  `qq` char(15) DEFAULT NULL,
  `other` char(40) DEFAULT NULL,
  `regtime` datetime NOT NULL COMMENT '注册时间',
  `regip` char(16) NOT NULL COMMENT '注册ip',
  `mlevel` smallint(3) unsigned NOT NULL COMMENT '级别',
  `mgroup` int(7) unsigned NOT NULL COMMENT '所属用户组(位运算权限)',
  `money_total` char(10) NOT NULL COMMENT '充值总额, 累计充值的总金额',
  `money_frozen` char(10) NOT NULL COMMENT '不可用余额,被冻结的金额.储存通过担保交易充值的金额，只有用户确认收货，我们收到钱后才会转为可用余额',
  `money` char(10) NOT NULL COMMENT '当前余额',
  `score` char(10) NOT NULL COMMENT '积分',
  `system_ban` smallint(3) DEFAULT '0' COMMENT '系统操作',
  `lasttime` datetime NOT NULL,
  `lastip` char(16) NOT NULL COMMENT '最后登录ip',
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_member
-- ----------------------------
INSERT INTO `pre_member` VALUES ('33', '', '0', 'test001', '383435393236356130643930393639623664323465666234356162633038346437646261393263338095', 'admin@admin.com', null, '', '', '', '2012-07-13 22:10:58', '127.0.0.1', '0', '1', '', '', '0', '0', '0', '2012-07-13 22:10:58', '');
INSERT INTO `pre_member` VALUES ('32', '', null, 'dfdfd', '613639343632303766396166393930346663633439313032383635323039663830373531626665628095', 'ssss@1111.com', null, '', '', '', '2012-03-30 19:37:33', '127.0.0.1', '0', '1', '', '', '0', '0', '0', '2012-03-30 19:37:33', '');
INSERT INTO `pre_member` VALUES ('31', '', null, 'user1', '313631626330333230366137653165383639653637323932333035306536656563373766393263668095', '1111@admin.com', null, '', '', '', '2012-03-02 06:38:09', '127.0.0.1', '1', '1', '', '', '0', '0', '0', '2012-03-02 06:38:09', '');
INSERT INTO `pre_member` VALUES ('34', '0', 'test001@dsdsd.com', 'test002', '613136663931356536356162303366343761323161366432626635646437386430383838363530348095', 'test002@dsdsd.com', null, '11111111', '', '', '2012-07-15 12:00:14', '127.0.0.1', '0', '1', '', '', '0', '0', '0', '2012-07-15 12:00:14', '127.0.0.1');

-- ----------------------------
-- Table structure for `pre_member_product`
-- ----------------------------
DROP TABLE IF EXISTS `pre_member_product`;
CREATE TABLE `pre_member_product` (
  `id` int(8) unsigned NOT NULL COMMENT '表主键',
  `pid` char(12) NOT NULL COMMENT '产品数字序号',
  `pname` char(100) NOT NULL COMMENT '产品名称',
  `price` char(12) NOT NULL COMMENT '价格',
  `buynum` int(5) unsigned NOT NULL COMMENT '购买数量',
  `buyuid` int(9) unsigned NOT NULL COMMENT '购买者uid',
  `buyuname` char(30) NOT NULL COMMENT '购买者账号',
  `buytime` datetime NOT NULL,
  `buyip` char(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_member_product
-- ----------------------------

-- ----------------------------
-- Table structure for `pre_product`
-- ----------------------------
DROP TABLE IF EXISTS `pre_product`;
CREATE TABLE `pre_product` (
  `id` int(8) unsigned NOT NULL COMMENT '表主键',
  `pid` char(12) NOT NULL COMMENT '产品数字序号',
  `pname` char(100) NOT NULL COMMENT '产品名称',
  `p_desc` varchar(3000) NOT NULL COMMENT '产品描述',
  `p_attr` char(255) NOT NULL COMMENT '产品属性',
  `p_info` varchar(500) NOT NULL COMMENT '产品信息(图片、其他字段组成的字符数组)',
  `price` char(12) NOT NULL COMMENT '价格',
  `presstime` datetime NOT NULL COMMENT '发布时间',
  `endtime` datetime NOT NULL COMMENT '结束时间',
  `adduid` int(9) unsigned NOT NULL COMMENT '发布者uid',
  `addser` char(16) NOT NULL COMMENT '发布者用户名',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_product
-- ----------------------------

-- ----------------------------
-- Table structure for `pre_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `pre_recharge`;
CREATE TABLE `pre_recharge` (
  `rid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uid` int(9) unsigned NOT NULL COMMENT '用户id',
  `uname` char(12) NOT NULL COMMENT '用户名',
  `order_id` char(30) NOT NULL COMMENT '订单号',
  `money` int(6) unsigned NOT NULL COMMENT '金额',
  `summary` char(255) DEFAULT NULL COMMENT '摘要说明',
  `state` tinyint(2) unsigned NOT NULL COMMENT '状态',
  `addtime` datetime NOT NULL COMMENT '订单时间',
  `addip` char(50) NOT NULL COMMENT '订单人ip',
  `others` char(255) DEFAULT NULL COMMENT '保留字段',
  PRIMARY KEY (`rid`),
  KEY `userid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_recharge
-- ----------------------------

-- ----------------------------
-- Table structure for `pre_text`
-- ----------------------------
DROP TABLE IF EXISTS `pre_text`;
CREATE TABLE `pre_text` (
  `aid` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `title` char(150) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`aid`),
  FULLTEXT KEY `content` (`content`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_text
-- ----------------------------
INSERT INTO `pre_text` VALUES ('1', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('2', '靖江近海', '近海，是长三角一座年轻美丽、充满生机活力的滨江城市。位于苏中平原最南端。');
INSERT INTO `pre_text` VALUES ('3', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('4', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('5', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('6', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('7', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('8', '靖江近海', '近海，是长三角一座年轻美丽、充满生机活力的滨江城市。位于苏中平原最南端。');
INSERT INTO `pre_text` VALUES ('9', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('10', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('11', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text` VALUES ('12', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');

-- ----------------------------
-- Table structure for `pre_text_2`
-- ----------------------------
DROP TABLE IF EXISTS `pre_text_2`;
CREATE TABLE `pre_text_2` (
  `aid` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `title` char(150) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`aid`),
  FULLTEXT KEY `content` (`content`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of pre_text_2
-- ----------------------------
INSERT INTO `pre_text_2` VALUES ('9', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('8', '靖江近海', '近海，是长三角一座年轻美丽、充满生机活力的滨江城市。位于苏中平原最南端。');
INSERT INTO `pre_text_2` VALUES ('7', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('10', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('11', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('12', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('13', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('14', '靖江近海', '你好近海，是长三角一座年轻美丽、充满生机活力的滨江城市。位于苏中平原最南端。');
INSERT INTO `pre_text_2` VALUES ('15', '淘宝要求', '你好类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('16', '淘宝要求', '类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('17', '淘宝要求', '你好类似淘宝 卖家发货 10天后 买家默认收货');
INSERT INTO `pre_text_2` VALUES ('18', '淘宝要求', '你好类似淘宝 卖家发货 10天后 买家默认收货');

-- ----------------------------
-- Table structure for `pre_userbook`
-- ----------------------------
DROP TABLE IF EXISTS `pre_userbook`;
CREATE TABLE `pre_userbook` (
  `bid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '本表自增id',
  `uid` int(9) unsigned NOT NULL COMMENT '用户id',
  `uname` char(12) NOT NULL COMMENT '用户名',
  `note_id` int(9) unsigned NOT NULL COMMENT '留言编号',
  `pid` int(9) unsigned NOT NULL COMMENT '上级编号(父id)',
  `type` tinyint(2) unsigned NOT NULL COMMENT '留言类型',
  `title` char(100) NOT NULL COMMENT '留言标题',
  `content` varchar(3000) NOT NULL COMMENT '留言内容',
  `state` tinyint(2) unsigned NOT NULL COMMENT '状态',
  `addtime` datetime NOT NULL COMMENT '订单时间',
  `addip` char(50) NOT NULL COMMENT '订单人ip',
  `others` char(255) DEFAULT NULL COMMENT '保留字段',
  PRIMARY KEY (`bid`),
  KEY `userid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_userbook
-- ----------------------------
INSERT INTO `pre_userbook` VALUES ('1', '34', 'test002', '0', '0', '1', 'fffffffffff', 'dddddddd', '0', '2012-07-27 03:04:06', '127.0.0.1', '');
INSERT INTO `pre_userbook` VALUES ('2', '34', 'test002', '0', '0', '1', 'kkkkkkk', '..............', '0', '2012-07-27 03:12:54', '127.0.0.1', '');
INSERT INTO `pre_userbook` VALUES ('3', '33', 'test001', '0', '0', '1', 'saaaaaaaaaaa', 'ssssssssssss', '0', '2012-07-27 15:19:24', '127.0.0.1', '');
INSERT INTO `pre_userbook` VALUES ('4', '34', 'test002', '1', '1', '0', '', 'ddddddddddddddd', '0', '2012-07-27 16:48:28', '127.0.0.1', '');
INSERT INTO `pre_userbook` VALUES ('5', '34', 'test002', '1', '1', '0', '', 'ddddddddddddd', '0', '2012-07-27 16:49:29', '127.0.0.1', '');
INSERT INTO `pre_userbook` VALUES ('6', '34', 'test002', '1', '1', '0', '', 'aaaaaaaaa', '0', '2012-07-27 16:49:41', '127.0.0.1', '');
