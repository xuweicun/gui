/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50520
Source Host           : localhost:3306
Source Database       : gui

Target Server Type    : MYSQL
Target Server Version : 50520
File Encoding         : 65001

Date: 2016-04-09 19:11:09
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `gui_admin`
-- ----------------------------
DROP TABLE IF EXISTS `gui_admin`;
CREATE TABLE `gui_admin` (
  `adminid` smallint(6) NOT NULL AUTO_INCREMENT,
  `adminname` varchar(50) COLLATE gbk_bin NOT NULL,
  `password` varchar(100) COLLATE gbk_bin NOT NULL,
  PRIMARY KEY (`adminid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk COLLATE=gbk_bin;

-- ----------------------------
-- Records of gui_admin
-- ----------------------------

-- ----------------------------
-- Table structure for `gui_chg_log`
-- ----------------------------
DROP TABLE IF EXISTS `gui_chg_log`;
CREATE TABLE `gui_chg_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `obj_id` int(5) NOT NULL,
  `value` varchar(300) NOT NULL COMMENT 'md5 or sn',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `handled` int(1) NOT NULL,
  `comment` varchar(3000) DEFAULT NULL,
  `type` int(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='异常记录';

-- ----------------------------
-- Records of gui_chg_log
-- ----------------------------

-- ----------------------------
-- Table structure for `gui_cmd_log`
-- ----------------------------
DROP TABLE IF EXISTS `gui_cmd_log`;
CREATE TABLE `gui_cmd_log` (
  `msg` varchar(500) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `cmd` varchar(20) NOT NULL,
  `sub_cmd` varchar(10) DEFAULT NULL,
  `start_time` varchar(100) DEFAULT NULL,
  `return_time` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(2) NOT NULL,
  `progress` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gui_cmd_log
-- ----------------------------
INSERT INTO `gui_cmd_log` VALUES (null, '1', null, 'DEVICESTATUS', null, '2016-03-11 15:23:19', '0000-00-00 00:00:00', '-1', null);
INSERT INTO `gui_cmd_log` VALUES (null, '2', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '3', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '4', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '5', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '6', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '7', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '8', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '9', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '10', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '11', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '12', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '13', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '14', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '15', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '16', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '17', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '18', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '19', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '20', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '21', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '22', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '23', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '24', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '25', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '26', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '27', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '28', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '29', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '30', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '31', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '32', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '33', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '34', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '35', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '36', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '37', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '38', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '39', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '40', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '41', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '42', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '43', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '44', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '45', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '46', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '47', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '48', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '49', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '50', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '51', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '52', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '53', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '54', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '55', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '56', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '57', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '58', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '59', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '60', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '61', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '62', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '63', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '64', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '65', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '66', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '67', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '68', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '69', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '70', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '71', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '72', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '73', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '74', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '75', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '76', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '77', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '78', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '79', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '80', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '81', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '82', null, '', null, '2016-03-15 15:14:43', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '83', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '84', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '85', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '86', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '87', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '88', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '89', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '90', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '91', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '92', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '93', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '94', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '95', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '96', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '97', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '98', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '99', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '100', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES (null, '101', null, '', null, '2016-03-15 15:14:44', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES ('{\"cmd\":\"DEVICESTATUS\",\"CMD_ID\":\"102\"}', '102', null, 'DEVICESTATUS', null, '2016-04-09 16:39:55', '0000-00-00 00:00:00', '0', null);
INSERT INTO `gui_cmd_log` VALUES ('{\"cmd\":\"DEVICESTATUS\",\"CMD_ID\":\"103\"}', '103', null, 'DEVICESTATUS', null, '1460199078', '0000-00-00 00:00:00', '-1', null);

-- ----------------------------
-- Table structure for `gui_device`
-- ----------------------------
DROP TABLE IF EXISTS `gui_device`;
CREATE TABLE `gui_device` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `level` smallint(2) NOT NULL,
  `group` smallint(2) NOT NULL,
  `index` smallint(2) NOT NULL,
  `disk_id` int(10) DEFAULT NULL,
  `loaded` tinyint(1) NOT NULL,
  `bridged` tinyint(1) NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8 COMMENT='the storage closet';

-- ----------------------------
-- Records of gui_device
-- ----------------------------
INSERT INTO `gui_device` VALUES ('1', '1', '1', '1', null, '0', '0', '0');
INSERT INTO `gui_device` VALUES ('2', '1', '1', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('3', '1', '1', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('4', '1', '1', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('5', '1', '2', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('6', '1', '2', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('7', '1', '2', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('8', '1', '2', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('9', '1', '3', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('10', '1', '3', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('11', '1', '3', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('12', '1', '3', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('13', '1', '4', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('14', '1', '4', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('15', '1', '4', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('16', '1', '4', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('17', '1', '5', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('18', '1', '5', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('19', '1', '5', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('20', '1', '5', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('21', '1', '6', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('22', '1', '6', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('23', '1', '6', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('24', '1', '6', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('25', '2', '1', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('26', '2', '1', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('27', '2', '1', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('28', '2', '1', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('29', '2', '2', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('30', '2', '2', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('31', '2', '2', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('32', '2', '2', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('33', '2', '3', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('34', '2', '3', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('35', '2', '3', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('36', '2', '3', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('37', '2', '4', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('38', '2', '4', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('39', '2', '4', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('40', '2', '4', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('41', '2', '5', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('42', '2', '5', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('43', '2', '5', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('44', '2', '5', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('45', '2', '6', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('46', '2', '6', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('47', '2', '6', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('48', '2', '6', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('49', '3', '1', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('50', '3', '1', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('51', '3', '1', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('52', '3', '1', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('53', '3', '2', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('54', '3', '2', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('55', '3', '2', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('56', '3', '2', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('57', '3', '3', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('58', '3', '3', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('59', '3', '3', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('60', '3', '3', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('61', '3', '4', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('62', '3', '4', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('63', '3', '4', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('64', '3', '4', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('65', '3', '5', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('66', '3', '5', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('67', '3', '5', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('68', '3', '5', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('69', '3', '6', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('70', '3', '6', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('71', '3', '6', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('72', '3', '6', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('73', '4', '1', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('74', '4', '1', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('75', '4', '1', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('76', '4', '1', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('77', '4', '2', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('78', '4', '2', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('79', '4', '2', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('80', '4', '2', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('81', '4', '3', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('82', '4', '3', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('83', '4', '3', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('84', '4', '3', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('85', '4', '4', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('86', '4', '4', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('87', '4', '4', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('88', '4', '4', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('89', '4', '5', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('90', '4', '5', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('91', '4', '5', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('92', '4', '5', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('93', '4', '6', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('94', '4', '6', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('95', '4', '6', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('96', '4', '6', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('97', '5', '1', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('98', '5', '1', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('99', '5', '1', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('100', '5', '1', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('101', '5', '2', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('102', '5', '2', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('103', '5', '2', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('104', '5', '2', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('105', '5', '3', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('106', '5', '3', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('107', '5', '3', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('108', '5', '3', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('109', '5', '4', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('110', '5', '4', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('111', '5', '4', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('112', '5', '4', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('113', '5', '5', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('114', '5', '5', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('115', '5', '5', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('116', '5', '5', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('117', '5', '6', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('118', '5', '6', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('119', '5', '6', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('120', '5', '6', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('121', '6', '1', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('122', '6', '1', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('123', '6', '1', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('124', '6', '1', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('125', '6', '2', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('126', '6', '2', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('127', '6', '2', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('128', '6', '2', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('129', '6', '3', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('130', '6', '3', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('131', '6', '3', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('132', '6', '3', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('133', '6', '4', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('134', '6', '4', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('135', '6', '4', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('136', '6', '4', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('137', '6', '5', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('138', '6', '5', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('139', '6', '5', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('140', '6', '5', '4', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('141', '6', '6', '1', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('142', '6', '6', '2', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('143', '6', '6', '3', null, '1', '0', '0');
INSERT INTO `gui_device` VALUES ('144', '6', '6', '4', null, '1', '0', '0');

-- ----------------------------
-- Table structure for `gui_disk`
-- ----------------------------
DROP TABLE IF EXISTS `gui_disk`;
CREATE TABLE `gui_disk` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `sn` int(20) NOT NULL,
  `md5` varchar(500) NOT NULL,
  `c5` int(10) NOT NULL,
  `file_list` varchar(1000) NOT NULL COMMENT '文件列表存储路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gui_disk
-- ----------------------------

-- ----------------------------
-- Table structure for `gui_disk_chg_log`
-- ----------------------------
DROP TABLE IF EXISTS `gui_disk_chg_log`;
CREATE TABLE `gui_disk_chg_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `disk_id` smallint(5) NOT NULL,
  `md5` varchar(300) DEFAULT NULL,
  `c5` int(5) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `file_content` varchar(200) DEFAULT NULL COMMENT '内容变化',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gui_disk_chg_log
-- ----------------------------

-- ----------------------------
-- Table structure for `gui_level`
-- ----------------------------
DROP TABLE IF EXISTS `gui_level`;
CREATE TABLE `gui_level` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `level` int(5) NOT NULL,
  `protected` int(1) DEFAULT '1' COMMENT '写保护',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='层级表';

-- ----------------------------
-- Records of gui_level
-- ----------------------------

-- ----------------------------
-- Table structure for `gui_super`
-- ----------------------------
DROP TABLE IF EXISTS `gui_super`;
CREATE TABLE `gui_super` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pwd` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gui_super
-- ----------------------------
