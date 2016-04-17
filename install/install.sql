-- phpMyAdmin SQL Dump
-- version 3.4.10.1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2016 年 04 月 17 日 11:34
-- 服务器版本: 5.5.20
-- PHP 版本: 5.3.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `gui`
--

-- --------------------------------------------------------

--
-- 表的结构 `gui_admin`
--

CREATE TABLE IF NOT EXISTS `gui_admin` (
  `adminid` smallint(6) NOT NULL AUTO_INCREMENT,
  `adminname` varchar(50) COLLATE gbk_bin NOT NULL,
  `password` varchar(100) COLLATE gbk_bin NOT NULL,
  PRIMARY KEY (`adminid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk COLLATE=gbk_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_cab`
--

CREATE TABLE IF NOT EXISTS `gui_cab` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) DEFAULT NULL,
  `alias` varchar(50) DEFAULT NULL,
  `level_cnt` smallint(3) DEFAULT '6',
  `group_cnt` smallint(3) DEFAULT '6',
  `disk_cnt` smallint(3) DEFAULT '4',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sn` (`sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_chg_log`
--

CREATE TABLE IF NOT EXISTS `gui_chg_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `obj_id` int(5) NOT NULL,
  `value` varchar(300) NOT NULL COMMENT 'md5 or sn',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `handled` int(1) NOT NULL,
  `comment` varchar(3000) DEFAULT NULL,
  `type` int(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='异常记录' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_cmd_log`
--

CREATE TABLE IF NOT EXISTS `gui_cmd_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dst_id` int(10) DEFAULT '0' COMMENT '目标命令id',
  `user_id` int(11) DEFAULT NULL,
  `cmd` varchar(20) NOT NULL,
  `sub_cmd` varchar(10) NOT NULL,
  `start_time` varchar(500) DEFAULT NULL COMMENT '开始时间',
  `status` int(2) DEFAULT NULL,
  `sub_status` int(2) DEFAULT '0' COMMENT '子状态',
  `stage` int(5) DEFAULT '0' COMMENT '桥接子状态',
  `progress` float DEFAULT NULL,
  `msg` varchar(1000) DEFAULT NULL COMMENT 'json原命令',
  `return_msg` varchar(1000) DEFAULT NULL COMMENT '桥接返回消息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=94 ;

--
-- 转存表中的数据 `gui_cmd_log`
--

INSERT INTO `gui_cmd_log` (`id`, `dst_id`, `user_id`, `cmd`, `sub_cmd`, `start_time`, `status`, `sub_status`, `stage`, `progress`, `msg`, `return_msg`) VALUES
(1, 0, NULL, 'DEVICESTATUS', '', '2016-04-09 08:09:28', 0, 0, 0, NULL, NULL, NULL),
(2, 0, NULL, 'DEVICESTATUS', '', '2016-04-09 08:25:23', 0, 0, 0, NULL, NULL, NULL),
(3, 0, NULL, 'DEVICESTATUS', '', '2016-04-09 08:30:01', -1, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"3"}', NULL),
(4, 0, NULL, 'DEVICESTATUS', '', '1460551404', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"4"}', NULL),
(5, 0, NULL, 'BRIDGE', 'START', '1460551476', -3, 0, 0, NULL, '{"cmd":"BRIDGE","subcmd":"START","level":"1","group":"3","disks":[{"id":"2","SN":""}],"CMD_ID":"5"}', NULL),
(6, 0, NULL, 'BRIDGE', 'START', '1460551506', -3, 0, 0, NULL, '{"cmd":"BRIDGE","subcmd":"START","level":"1","group":"3","disks":[{"id":"1","SN":""}],"CMD_ID":"6"}', NULL),
(7, 0, NULL, 'DEVICESTATUS', '', '1460551519', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"7"}', NULL),
(8, 0, NULL, 'BRIDGE', 'STOP', '1460551594', -1, 0, 0, NULL, NULL, NULL),
(9, 0, NULL, '', '', '1460551594', -1, 0, 0, NULL, NULL, NULL),
(10, 0, NULL, 'DEVICESTATUS', '', '1460554177', -1, 0, 0, NULL, NULL, NULL),
(11, 0, NULL, 'MD5', 'START', '1460554218', -1, 0, 0, NULL, NULL, NULL),
(12, 0, NULL, 'DEVICESTATUS', '', '1460554271', -1, 0, 0, NULL, NULL, NULL),
(13, 0, NULL, 'MD5', 'START', '1460554276', -1, 0, 0, NULL, NULL, NULL),
(14, 0, NULL, 'MD5', 'START', '1460554295', -1, 0, 0, NULL, NULL, NULL),
(15, 0, NULL, 'DEVICESTATUS', '', '1460554425', -1, 0, 0, NULL, NULL, NULL),
(16, 0, NULL, 'DEVICESTATUS', '', '1460555073', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"16"}', NULL),
(17, 0, NULL, 'MD5', 'START', '1460555104', -1, 0, 0, NULL, '{"cmd":"MD5","subcmd":"START","level":"1","group":"2","disk":"2","CMD_ID":"17"}', NULL),
(18, 0, NULL, 'DEVICESTATUS', '', '1460555336', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"18"}', NULL),
(19, 0, NULL, 'MD5', 'START', '1460555342', -1, 0, 0, NULL, '{"cmd":"MD5","subcmd":"START","level":"1","group":"1","disk":"1","CMD_ID":"19"}', NULL),
(20, 0, NULL, 'DEVICESTATUS', '', '1460557209', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"20"}', NULL),
(21, 0, NULL, 'MD5', 'START', '1460557242', -1, 0, 0, NULL, '{"cmd":"MD5","subcmd":"START","level":"1","group":"4","disk":"3","CMD_ID":"21"}', NULL),
(22, 0, NULL, 'DEVICESTATUS', '', '1460557313', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"22"}', NULL),
(23, 0, NULL, 'MD5', 'START', '1460557372', -1, 0, 0, NULL, '{"cmd":"MD5","subcmd":"START","level":"1","group":"6","disk":"3","CMD_ID":"23"}', NULL),
(24, 0, NULL, 'DEVICESTATUS', '', '1460557942', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"24"}', NULL),
(25, 0, NULL, 'DEVICESTATUS', '', '1460557995', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"25"}', NULL),
(26, 0, NULL, 'DEVICESTATUS', '', '1460558505', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"26"}', NULL),
(27, 0, NULL, 'MD5', 'START', '1460558541', -1, 0, 0, NULL, NULL, NULL),
(28, 0, NULL, '', '', '1460558552', -1, 0, 0, NULL, NULL, NULL),
(29, 0, NULL, 'DEVICESTATUS', '', '1460560332', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"29"}', NULL),
(30, 0, NULL, 'MD5', 'START', '1460560364', -1, 0, 0, NULL, '{"cmd":"MD5","subcmd":"START","level":"1","group":"1","disk":"1","CMD_ID":"30"}', NULL),
(31, 0, NULL, 'BRIDGE', 'START', '1460560409', -3, 0, 0, NULL, '{"cmd":"BRIDGE","subcmd":"START","level":"1","group":"6","disks":[{"id":"2","SN":""}],"CMD_ID":"31"}', NULL),
(32, 0, NULL, 'DEVICESTATUS', '', '1460561221', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"32"}', NULL),
(33, 0, NULL, 'MD5', 'START', '1460561274', -1, 0, 0, NULL, '{"cmd":"MD5","subcmd":"START","level":"1","group":"6","disk":"2","CMD_ID":"33"}', NULL),
(34, 0, NULL, 'DEVICESTATUS', '', '1460727266', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"34"}', NULL),
(35, 0, NULL, 'DEVICESTATUS', '', '1460767821', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"35"}', NULL),
(36, 0, NULL, 'DEVICESTATUS', '', '1460767887', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"36"}', NULL),
(37, 0, NULL, 'DEVICESTATUS', '', '1460767970', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"37"}', NULL),
(38, 0, NULL, 'DEVICESTATUS', '', '1460768039', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"38"}', NULL),
(39, 0, NULL, 'DEVICESTATUS', '', '1460769660', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"39"}', NULL),
(40, 0, NULL, 'DEVICESTATUS', '', '1460771378', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"40"}', NULL),
(41, 0, NULL, 'DEVICESTATUS', '', '1460771759', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"41"}', NULL),
(42, 0, NULL, 'DEVICESTATUS', '', '1460790313', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"42"}', NULL),
(43, 0, NULL, '', '', '1460790327', -3, 0, 0, NULL, '{"cmd":"","CMD_ID":"43"}', NULL),
(44, 0, NULL, 'DEVICESTATUS', '', '1460790806', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"44"}', NULL),
(45, 0, NULL, 'DEVICESTATUS', '', '1460791065', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"45"}', NULL),
(46, 0, NULL, 'DEVICESTATUS', '', '1460791308', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"46"}', NULL),
(47, 0, NULL, 'DEVICESTATUS', '', '1460791325', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"47"}', NULL),
(48, 0, NULL, 'DEVICESTATUS', '', '1460791374', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"48"}', NULL),
(49, 0, NULL, 'DEVICESTATUS', '', '1460791449', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"49"}', NULL),
(50, 0, NULL, 'DEVICESTATUS', '', '1460792012', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"50"}', NULL),
(51, 0, NULL, '', '', '1460792029', -3, 0, 0, NULL, '{"cmd":"","CMD_ID":"51"}', NULL),
(52, 0, NULL, 'BRIDGE', 'START', '1460792055', -3, 0, 0, NULL, '{"cmd":"BRIDGE","subcmd":"START","level":"1","group":"1","disks":[{"id":"1","SN":""}],"CMD_ID":"52"}', NULL),
(53, 0, NULL, 'DEVICESTATUS', '', '1460792158', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"53"}', NULL),
(54, 0, NULL, 'DEVICESTATUS', '', '1460792738', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"54"}', NULL),
(55, 0, NULL, 'DEVICESTATUS', '', '1460792785', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"55"}', NULL),
(56, 0, NULL, 'DEVICESTATUS', '', '1460793025', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"56"}', NULL),
(57, 0, NULL, 'DEVICESTATUS', '', '1460793036', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"57"}', NULL),
(58, 0, NULL, 'DEVICESTATUS', '', '1460793055', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"58"}', NULL),
(59, 0, NULL, 'DEVICESTATUS', '', '1460793064', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"59"}', NULL),
(60, 0, NULL, 'DEVICESTATUS', '', '1460793125', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"60"}', NULL),
(61, 0, NULL, 'DEVICESTATUS', '', '1460793137', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"61"}', NULL),
(62, 0, NULL, 'DEVICESTATUS', '', '1460793458', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"62"}', NULL),
(63, 0, NULL, 'DEVICESTATUS', '', '1460793464', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"63"}', NULL),
(64, 0, NULL, 'DEVICESTATUS', '', '1460793783', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"64"}', NULL),
(65, 0, NULL, 'DEVICESTATUS', '', '1460793825', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"65"}', NULL),
(66, 0, NULL, 'DEVICESTATUS', '', '1460793848', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"66"}', NULL),
(67, 0, NULL, 'DEVICESTATUS', '', '1460793922', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"67"}', NULL),
(68, 0, NULL, 'DEVICESTATUS', '', '1460793955', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"68"}', NULL),
(69, 0, NULL, 'DEVICESTATUS', '', '1460793974', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"69"}', NULL),
(70, 0, NULL, 'DEVICESTATUS', '', '1460794056', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"70"}', NULL),
(71, 0, NULL, 'DEVICESTATUS', '', '1460794073', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"71"}', NULL),
(72, 0, NULL, 'DEVICESTATUS', '', '1460794180', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"72"}', NULL),
(73, 0, NULL, 'DEVICESTATUS', '', '1460794237', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"73"}', NULL),
(74, 0, NULL, 'DEVICESTATUS', '', '1460794263', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"74"}', NULL),
(75, 0, NULL, 'DEVICESTATUS', '', '1460798801', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"75"}', NULL),
(76, 0, NULL, 'DEVICESTATUS', '', '1460798873', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"76"}', NULL),
(77, 0, NULL, 'DEVICESTATUS', '', '1460798984', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"77"}', NULL),
(78, 0, NULL, 'DEVICESTATUS', '', '1460799451', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"78"}', NULL),
(79, 0, NULL, 'DEVICESTATUS', '', '1460799597', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"79"}', NULL),
(80, 0, NULL, 'DEVICESTATUS', '', '1460799646', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"80"}', NULL),
(81, 0, NULL, 'DEVICESTATUS', '', '1460799646', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"81"}', NULL),
(82, 0, NULL, 'DEVICESTATUS', '', '1460799795', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"82"}', NULL),
(83, 0, NULL, 'DEVICESTATUS', '', '1460799795', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"83"}', NULL),
(84, 0, NULL, 'DEVICESTATUS', '', '1460799954', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"84"}', NULL),
(85, 0, NULL, 'DEVICESTATUS', '', '1460799954', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"85"}', NULL),
(86, 0, NULL, 'DEVICESTATUS', '', '1460800098', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"86"}', NULL),
(87, 0, NULL, 'DEVICESTATUS', '', '1460800254', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"87"}', NULL),
(88, 0, NULL, 'DEVICESTATUS', '', '1460800384', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"88"}', NULL),
(89, 0, NULL, 'DEVICESTATUS', '', '1460800433', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"89"}', NULL),
(90, 0, NULL, 'DEVICESTATUS', '', '1460800633', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"90"}', NULL),
(91, 0, NULL, 'DEVICESTATUS', '', '1460808197', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"91"}', NULL),
(92, 0, NULL, 'DEVICESTATUS', '', '1460810708', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"92"}', NULL),
(93, 0, NULL, 'DEVICESTATUS', '', '1460892019', -3, 0, 0, NULL, '{"cmd":"DEVICESTATUS","CMD_ID":"93"}', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `gui_device`
--

CREATE TABLE IF NOT EXISTS `gui_device` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `cab_id` int(5) DEFAULT '1' COMMENT '柜子id',
  `level` smallint(2) NOT NULL,
  `zu` smallint(2) NOT NULL,
  `disk` smallint(2) NOT NULL,
  `disk_id` int(10) DEFAULT NULL,
  `loaded` tinyint(1) DEFAULT '1',
  `bridged` tinyint(1) DEFAULT '0',
  `status` tinyint(1) DEFAULT '0',
  `modify_time` varchar(300) DEFAULT NULL,
  `time` varchar(30) DEFAULT NULL COMMENT 'string time',
  `path` varchar(500) DEFAULT NULL COMMENT '桥接之后的路径，bridge为1时有效',
  `is_slave` tinyint(1) DEFAULT '0' COMMENT '是否为备份盘',
  `master_id` int(10) DEFAULT '0' COMMENT '备份盘的主盘id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='the storage closet' AUTO_INCREMENT=145 ;

--
-- 转存表中的数据 `gui_device`
--

INSERT INTO `gui_device` (`id`, `cab_id`, `level`, `zu`, `disk`, `disk_id`, `loaded`, `bridged`, `status`, `modify_time`, `time`, `path`, `is_slave`, `master_id`) VALUES
(1, 1, 1, 1, 1, NULL, 1, 0, 0, '2016-04-09 08:09:15', NULL, NULL, 0, 0),
(2, 1, 1, 1, 2, NULL, 1, 0, 0, '2016-04-09 08:09:15', NULL, NULL, 0, 0),
(3, 1, 1, 1, 3, NULL, 1, 0, 0, '2016-04-09 08:09:15', NULL, NULL, 0, 0),
(4, 1, 1, 1, 4, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(5, 1, 1, 2, 1, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(6, 1, 1, 2, 2, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(7, 1, 1, 2, 3, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(8, 1, 1, 2, 4, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(9, 1, 1, 3, 1, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(10, 1, 1, 3, 2, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(11, 1, 1, 3, 3, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(12, 1, 1, 3, 4, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(13, 1, 1, 4, 1, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(14, 1, 1, 4, 2, NULL, 1, 0, 0, '2016-04-09 08:09:16', NULL, NULL, 0, 0),
(15, 1, 1, 4, 3, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(16, 1, 1, 4, 4, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(17, 1, 1, 5, 1, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(18, 1, 1, 5, 2, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(19, 1, 1, 5, 3, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(20, 1, 1, 5, 4, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(21, 1, 1, 6, 1, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(22, 1, 1, 6, 2, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(23, 1, 1, 6, 3, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(24, 1, 1, 6, 4, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(25, 1, 2, 1, 1, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(26, 1, 2, 1, 2, NULL, 1, 0, 0, '2016-04-09 08:09:17', NULL, NULL, 0, 0),
(27, 1, 2, 1, 3, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(28, 1, 2, 1, 4, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(29, 1, 2, 2, 1, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(30, 1, 2, 2, 2, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(31, 1, 2, 2, 3, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(32, 1, 2, 2, 4, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(33, 1, 2, 3, 1, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(34, 1, 2, 3, 2, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(35, 1, 2, 3, 3, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(36, 1, 2, 3, 4, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(37, 1, 2, 4, 1, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(38, 1, 2, 4, 2, NULL, 1, 0, 0, '2016-04-09 08:09:18', NULL, NULL, 0, 0),
(39, 1, 2, 4, 3, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(40, 1, 2, 4, 4, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(41, 1, 2, 5, 1, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(42, 1, 2, 5, 2, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(43, 1, 2, 5, 3, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(44, 1, 2, 5, 4, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(45, 1, 2, 6, 1, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(46, 1, 2, 6, 2, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(47, 1, 2, 6, 3, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(48, 1, 2, 6, 4, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(49, 1, 3, 1, 1, NULL, 1, 0, 0, '2016-04-09 08:09:19', NULL, NULL, 0, 0),
(50, 1, 3, 1, 2, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(51, 1, 3, 1, 3, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(52, 1, 3, 1, 4, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(53, 1, 3, 2, 1, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(54, 1, 3, 2, 2, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(55, 1, 3, 2, 3, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(56, 1, 3, 2, 4, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(57, 1, 3, 3, 1, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(58, 1, 3, 3, 2, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(59, 1, 3, 3, 3, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(60, 1, 3, 3, 4, NULL, 1, 0, 0, '2016-04-09 08:09:20', NULL, NULL, 0, 0),
(61, 1, 3, 4, 1, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(62, 1, 3, 4, 2, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(63, 1, 3, 4, 3, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(64, 1, 3, 4, 4, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(65, 1, 3, 5, 1, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(66, 1, 3, 5, 2, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(67, 1, 3, 5, 3, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(68, 1, 3, 5, 4, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(69, 1, 3, 6, 1, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(70, 1, 3, 6, 2, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(71, 1, 3, 6, 3, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(72, 1, 3, 6, 4, NULL, 1, 0, 0, '2016-04-09 08:09:21', NULL, NULL, 0, 0),
(73, 1, 4, 1, 1, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(74, 1, 4, 1, 2, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(75, 1, 4, 1, 3, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(76, 1, 4, 1, 4, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(77, 1, 4, 2, 1, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(78, 1, 4, 2, 2, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(79, 1, 4, 2, 3, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(80, 1, 4, 2, 4, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(81, 1, 4, 3, 1, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(82, 1, 4, 3, 2, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(83, 1, 4, 3, 3, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(84, 1, 4, 3, 4, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(85, 1, 4, 4, 1, NULL, 1, 0, 0, '2016-04-09 08:09:22', NULL, NULL, 0, 0),
(86, 1, 4, 4, 2, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(87, 1, 4, 4, 3, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(88, 1, 4, 4, 4, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(89, 1, 4, 5, 1, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(90, 1, 4, 5, 2, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(91, 1, 4, 5, 3, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(92, 1, 4, 5, 4, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(93, 1, 4, 6, 1, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(94, 1, 4, 6, 2, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(95, 1, 4, 6, 3, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(96, 1, 4, 6, 4, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(97, 1, 5, 1, 1, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(98, 1, 5, 1, 2, NULL, 1, 0, 0, '2016-04-09 08:09:23', NULL, NULL, 0, 0),
(99, 1, 5, 1, 3, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(100, 1, 5, 1, 4, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(101, 1, 5, 2, 1, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(102, 1, 5, 2, 2, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(103, 1, 5, 2, 3, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(104, 1, 5, 2, 4, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(105, 1, 5, 3, 1, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(106, 1, 5, 3, 2, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(107, 1, 5, 3, 3, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(108, 1, 5, 3, 4, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(109, 1, 5, 4, 1, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(110, 1, 5, 4, 2, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(111, 1, 5, 4, 3, NULL, 1, 0, 0, '2016-04-09 08:09:24', NULL, NULL, 0, 0),
(112, 1, 5, 4, 4, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(113, 1, 5, 5, 1, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(114, 1, 5, 5, 2, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(115, 1, 5, 5, 3, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(116, 1, 5, 5, 4, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(117, 1, 5, 6, 1, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(118, 1, 5, 6, 2, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(119, 1, 5, 6, 3, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(120, 1, 5, 6, 4, NULL, 1, 0, 0, '2016-04-09 08:09:25', NULL, NULL, 0, 0),
(121, 1, 6, 1, 1, NULL, 1, 0, 0, '2016-04-09 08:09:26', NULL, NULL, 0, 0),
(122, 1, 6, 1, 2, NULL, 1, 0, 0, '2016-04-09 08:09:26', NULL, NULL, 0, 0),
(123, 1, 6, 1, 3, NULL, 1, 0, 0, '2016-04-09 08:09:26', NULL, NULL, 0, 0),
(124, 1, 6, 1, 4, NULL, 1, 0, 0, '2016-04-09 08:09:26', NULL, NULL, 0, 0),
(125, 1, 6, 2, 1, NULL, 1, 0, 0, '2016-04-09 08:09:26', NULL, NULL, 0, 0),
(126, 1, 6, 2, 2, NULL, 1, 0, 0, '2016-04-09 08:09:26', NULL, NULL, 0, 0),
(127, 1, 6, 2, 3, NULL, 1, 0, 0, '2016-04-09 08:09:26', NULL, NULL, 0, 0),
(128, 1, 6, 2, 4, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(129, 1, 6, 3, 1, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(130, 1, 6, 3, 2, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(131, 1, 6, 3, 3, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(132, 1, 6, 3, 4, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(133, 1, 6, 4, 1, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(134, 1, 6, 4, 2, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(135, 1, 6, 4, 3, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(136, 1, 6, 4, 4, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(137, 1, 6, 5, 1, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(138, 1, 6, 5, 2, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(139, 1, 6, 5, 3, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(140, 1, 6, 5, 4, NULL, 1, 0, 0, '2016-04-09 08:09:27', NULL, NULL, 0, 0),
(141, 1, 6, 6, 1, NULL, 1, 0, 0, '2016-04-09 08:09:28', NULL, NULL, 0, 0),
(142, 1, 6, 6, 2, NULL, 1, 0, 0, '2016-04-09 08:09:28', NULL, NULL, 0, 0),
(143, 1, 6, 6, 3, NULL, 1, 0, 0, '2016-04-09 08:09:28', NULL, NULL, 0, 0),
(144, 1, 6, 6, 4, NULL, 1, 0, 0, '2016-04-09 08:09:28', NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `gui_disk`
--

CREATE TABLE IF NOT EXISTS `gui_disk` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `sn` int(20) DEFAULT NULL,
  `md5` varchar(500) DEFAULT NULL,
  `c5` int(10) DEFAULT NULL,
  `file_list` varchar(1000) DEFAULT NULL COMMENT '文件列表存储路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_disk_chg_log`
--

CREATE TABLE IF NOT EXISTS `gui_disk_chg_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `disk_id` smallint(5) NOT NULL,
  `md5` varchar(300) DEFAULT NULL,
  `c5` int(5) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `file_content` varchar(200) DEFAULT NULL COMMENT '内容变化',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_disk_smart`
--

CREATE TABLE IF NOT EXISTS `gui_disk_smart` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `disk_id` int(10) DEFAULT NULL,
  `attrname` varchar(5) DEFAULT NULL,
  `explanation` varchar(20) DEFAULT NULL,
  `value` varchar(20) DEFAULT NULL,
  `normal` varchar(20) DEFAULT NULL COMMENT '安全值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='smart value' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_level`
--

CREATE TABLE IF NOT EXISTS `gui_level` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `level` int(5) NOT NULL,
  `protected` int(1) DEFAULT '1' COMMENT '写保护',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='层级表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_super`
--

CREATE TABLE IF NOT EXISTS `gui_super` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pwd` varchar(500) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=38 ;

--
-- 转存表中的数据 `gui_super`
--

INSERT INTO `gui_super` (`id`, `pwd`, `name`) VALUES
(37, '0192023a7bbd73250516f069df18b500', 'admin');

-- --------------------------------------------------------

--
-- 表的结构 `gui_test`
--

CREATE TABLE IF NOT EXISTS `gui_test` (
  `response` varchar(1000) NOT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=380 ;

--
-- 转存表中的数据 `gui_test`
--

INSERT INTO `gui_test` (`response`, `time`, `id`) VALUES
('1-1-1-added', '2016-03-18 06:17:49', 127),
('1-1-2-added', '2016-03-18 06:17:49', 128),
('1-1-3-added', '2016-03-18 06:17:49', 129),
('1-1-4-added', '2016-03-18 06:17:49', 130),
('2-1-1-added', '2016-03-18 06:17:50', 131),
('2-1-3-added', '2016-03-18 06:17:50', 132),
('3-1-1-added', '2016-03-18 06:17:50', 133),
('3-1-3-added', '2016-03-18 06:17:50', 134),
('3-1-4-added', '2016-03-18 06:17:50', 135),
('1-1-1-added', '2016-03-18 06:45:17', 136),
('1-1-2-added', '2016-03-18 06:45:17', 137),
('1-1-3-added', '2016-03-18 06:45:17', 138),
('1-1-4-added', '2016-03-18 06:45:17', 139),
('2-1-1-added', '2016-03-18 06:45:17', 140),
('2-1-3-added', '2016-03-18 06:45:18', 141),
('3-1-1-added', '2016-03-18 06:45:18', 142),
('3-1-3-added', '2016-03-18 06:45:18', 143),
('3-1-4-added', '2016-03-18 06:45:18', 144),
('1-1-1-added', '2016-03-18 07:11:43', 145),
('1-1-2-added', '2016-03-18 07:11:43', 146),
('1-1-3-added', '2016-03-18 07:11:43', 147),
('1-1-4-added', '2016-03-18 07:11:43', 148),
('2-1-1-added', '2016-03-18 07:11:43', 149),
('2-1-3-added', '2016-03-18 07:11:43', 150),
('3-1-1-added', '2016-03-18 07:11:43', 151),
('3-1-3-added', '2016-03-18 07:11:44', 152),
('3-1-4-added', '2016-03-18 07:11:44', 153),
('1-1-1-added', '2016-03-18 07:15:20', 154),
('1-1-2-added', '2016-03-18 07:15:20', 155),
('1-1-3-added', '2016-03-18 07:15:20', 156),
('1-1-4-added', '2016-03-18 07:15:20', 157),
('2-1-1-added', '2016-03-18 07:15:20', 158),
('2-1-3-added', '2016-03-18 07:15:20', 159),
('3-1-1-added', '2016-03-18 07:15:20', 160),
('3-1-3-added', '2016-03-18 07:15:21', 161),
('3-1-4-added', '2016-03-18 07:15:21', 162),
('1-1-1-added', '2016-03-18 07:39:48', 163),
('1-1-2-added', '2016-03-18 07:39:49', 164),
('1-1-3-added', '2016-03-18 07:39:49', 165),
('1-1-4-added', '2016-03-18 07:39:49', 166),
('2-1-1-added', '2016-03-18 07:39:49', 167),
('2-1-3-added', '2016-03-18 07:39:49', 168),
('3-1-1-added', '2016-03-18 07:39:49', 169),
('3-1-3-added', '2016-03-18 07:39:50', 170),
('3-1-4-added', '2016-03-18 07:39:50', 171),
('1-1-1-added', '2016-03-18 07:41:07', 172),
('1-1-2-added', '2016-03-18 07:41:07', 173),
('1-1-3-added', '2016-03-18 07:41:07', 174),
('1-1-4-added', '2016-03-18 07:41:07', 175),
('2-1-1-added', '2016-03-18 07:41:07', 176),
('2-1-3-added', '2016-03-18 07:41:07', 177),
('3-1-1-added', '2016-03-18 07:41:07', 178),
('3-1-3-added', '2016-03-18 07:41:08', 179),
('3-1-4-added', '2016-03-18 07:41:08', 180),
('1-1-1-added', '2016-03-18 07:54:03', 181),
('1-1-2-added', '2016-03-18 07:54:03', 182),
('1-1-3-added', '2016-03-18 07:54:03', 183),
('1-1-4-added', '2016-03-18 07:54:03', 184),
('2-1-1-added', '2016-03-18 07:54:03', 185),
('2-1-3-added', '2016-03-18 07:54:03', 186),
('3-1-1-added', '2016-03-18 07:54:04', 187),
('3-1-3-added', '2016-03-18 07:54:04', 188),
('3-1-4-added', '2016-03-18 07:54:04', 189),
('1-1-1-added', '2016-03-18 11:09:56', 190),
('1-1-2-added', '2016-03-18 11:09:56', 191),
('1-1-3-added', '2016-03-18 11:09:56', 192),
('1-1-4-added', '2016-03-18 11:09:56', 193),
('2-1-1-added', '2016-03-18 11:09:57', 194),
('2-1-3-added', '2016-03-18 11:09:57', 195),
('3-1-1-added', '2016-03-18 11:09:57', 196),
('3-1-3-added', '2016-03-18 11:09:57', 197),
('3-1-4-added', '2016-03-18 11:09:57', 198),
('1-1-1-added', '2016-03-18 11:15:32', 199),
('1-1-2-added', '2016-03-18 11:15:32', 200),
('1-1-3-added', '2016-03-18 11:15:32', 201),
('1-1-4-added', '2016-03-18 11:15:32', 202),
('2-1-1-added', '2016-03-18 11:15:32', 203),
('2-1-3-added', '2016-03-18 11:15:32', 204),
('3-1-1-added', '2016-03-18 11:15:32', 205),
('3-1-3-added', '2016-03-18 11:15:33', 206),
('3-1-4-added', '2016-03-18 11:15:33', 207),
('1-1-1-added', '2016-03-18 11:16:15', 208),
('1-1-2-added', '2016-03-18 11:16:15', 209),
('1-1-3-added', '2016-03-18 11:16:15', 210),
('1-1-4-added', '2016-03-18 11:16:15', 211),
('2-1-1-added', '2016-03-18 11:16:15', 212),
('2-1-3-added', '2016-03-18 11:16:15', 213),
('3-1-1-added', '2016-03-18 11:16:15', 214),
('3-1-3-added', '2016-03-18 11:16:16', 215),
('3-1-4-added', '2016-03-18 11:16:16', 216),
('1-1-1-added', '2016-03-18 11:45:57', 217),
('1-1-2-added', '2016-03-18 11:45:57', 218),
('1-1-3-added', '2016-03-18 11:45:57', 219),
('1-1-4-added', '2016-03-18 11:45:57', 220),
('2-1-1-added', '2016-03-18 11:45:57', 221),
('2-1-3-added', '2016-03-18 11:45:57', 222),
('3-1-1-added', '2016-03-18 11:45:57', 223),
('3-1-3-added', '2016-03-18 11:45:58', 224),
('3-1-4-added', '2016-03-18 11:45:58', 225),
('1-1-1-added', '2016-03-18 11:48:00', 226),
('1-1-2-added', '2016-03-18 11:48:00', 227),
('1-1-3-added', '2016-03-18 11:48:00', 228),
('1-1-4-added', '2016-03-18 11:48:00', 229),
('2-1-1-added', '2016-03-18 11:48:00', 230),
('2-1-3-added', '2016-03-18 11:48:00', 231),
('3-1-1-added', '2016-03-18 11:48:01', 232),
('3-1-3-added', '2016-03-18 11:48:01', 233),
('3-1-4-added', '2016-03-18 11:48:01', 234),
('1-1-1-added', '2016-03-18 11:49:24', 235),
('1-1-2-added', '2016-03-18 11:49:24', 236),
('1-1-3-added', '2016-03-18 11:49:24', 237),
('1-1-4-added', '2016-03-18 11:49:24', 238),
('2-1-1-added', '2016-03-18 11:49:24', 239),
('2-1-3-added', '2016-03-18 11:49:24', 240),
('3-1-1-added', '2016-03-18 11:49:24', 241),
('3-1-3-added', '2016-03-18 11:49:24', 242),
('3-1-4-added', '2016-03-18 11:49:25', 243),
('1-1-1-added', '2016-03-18 12:51:49', 244),
('1-1-2-added', '2016-03-18 12:51:49', 245),
('1-1-3-added', '2016-03-18 12:51:49', 246),
('1-1-4-added', '2016-03-18 12:51:49', 247),
('2-1-1-added', '2016-03-18 12:51:49', 248),
('2-1-3-added', '2016-03-18 12:51:50', 249),
('3-1-1-added', '2016-03-18 12:51:50', 250),
('3-1-3-added', '2016-03-18 12:51:50', 251),
('3-1-4-added', '2016-03-18 12:51:50', 252),
('1-1-1-added', '2016-03-18 12:52:27', 253),
('1-1-2-added', '2016-03-18 12:52:27', 254),
('1-1-3-added', '2016-03-18 12:52:27', 255),
('1-1-4-added', '2016-03-18 12:52:27', 256),
('2-1-1-added', '2016-03-18 12:52:27', 257),
('2-1-3-added', '2016-03-18 12:52:27', 258),
('3-1-1-added', '2016-03-18 12:52:28', 259),
('3-1-3-added', '2016-03-18 12:52:28', 260),
('3-1-4-added', '2016-03-18 12:52:28', 261),
('1-1-1-added', '2016-03-18 13:08:19', 262),
('1-1-2-added', '2016-03-18 13:08:19', 263),
('1-1-3-added', '2016-03-18 13:08:19', 264),
('1-1-4-added', '2016-03-18 13:08:19', 265),
('2-1-1-added', '2016-03-18 13:08:19', 266),
('2-1-3-added', '2016-03-18 13:08:19', 267),
('3-1-1-added', '2016-03-18 13:08:19', 268),
('3-1-3-added', '2016-03-18 13:08:20', 269),
('3-1-4-added', '2016-03-18 13:08:20', 270),
('1-1-1-added', '2016-03-18 13:25:37', 271),
('1-1-2-added', '2016-03-18 13:25:37', 272),
('1-1-3-added', '2016-03-18 13:25:37', 273),
('1-1-4-added', '2016-03-18 13:25:37', 274),
('2-1-1-added', '2016-03-18 13:25:37', 275),
('2-1-3-added', '2016-03-18 13:25:37', 276),
('3-1-1-added', '2016-03-18 13:25:37', 277),
('3-1-3-added', '2016-03-18 13:25:37', 278),
('3-1-4-added', '2016-03-18 13:25:38', 279),
('1-1-1-added', '2016-03-18 13:27:10', 280),
('1-1-2-added', '2016-03-18 13:27:10', 281),
('1-1-3-added', '2016-03-18 13:27:10', 282),
('1-1-4-added', '2016-03-18 13:27:10', 283),
('2-1-1-added', '2016-03-18 13:27:10', 284),
('2-1-3-added', '2016-03-18 13:27:10', 285),
('3-1-1-added', '2016-03-18 13:27:11', 286),
('3-1-3-added', '2016-03-18 13:27:11', 287),
('3-1-4-added', '2016-03-18 13:27:11', 288),
('1-1-1-added', '2016-03-18 13:27:47', 289),
('1-1-2-added', '2016-03-18 13:27:48', 290),
('1-1-3-added', '2016-03-18 13:27:48', 291),
('1-1-4-added', '2016-03-18 13:27:48', 292),
('2-1-1-added', '2016-03-18 13:27:48', 293),
('2-1-3-added', '2016-03-18 13:27:48', 294),
('3-1-1-added', '2016-03-18 13:27:48', 295),
('3-1-3-added', '2016-03-18 13:27:49', 296),
('3-1-4-added', '2016-03-18 13:27:49', 297),
('1-1-1-added', '2016-03-18 13:35:38', 298),
('1-1-2-added', '2016-03-18 13:35:38', 299),
('1-1-3-added', '2016-03-18 13:35:38', 300),
('1-1-4-added', '2016-03-18 13:35:38', 301),
('2-1-1-added', '2016-03-18 13:35:38', 302),
('2-1-3-added', '2016-03-18 13:35:38', 303),
('3-1-1-added', '2016-03-18 13:35:38', 304),
('3-1-3-added', '2016-03-18 13:35:39', 305),
('3-1-4-added', '2016-03-18 13:35:39', 306),
('1-1-1-added', '2016-03-18 13:36:42', 307),
('1-1-2-added', '2016-03-18 13:36:42', 308),
('1-1-3-added', '2016-03-18 13:36:42', 309),
('1-1-4-added', '2016-03-18 13:36:42', 310),
('2-1-1-added', '2016-03-18 13:36:42', 311),
('2-1-3-added', '2016-03-18 13:36:42', 312),
('3-1-1-added', '2016-03-18 13:36:42', 313),
('3-1-3-added', '2016-03-18 13:36:43', 314),
('3-1-4-added', '2016-03-18 13:36:43', 315),
('1-1-1-added', '2016-03-18 13:45:27', 316),
('1-1-2-added', '2016-03-18 13:45:27', 317),
('1-1-3-added', '2016-03-18 13:45:27', 318),
('1-1-4-added', '2016-03-18 13:45:27', 319),
('2-1-1-added', '2016-03-18 13:45:27', 320),
('2-1-3-added', '2016-03-18 13:45:27', 321),
('3-1-1-added', '2016-03-18 13:45:27', 322),
('3-1-3-added', '2016-03-18 13:45:28', 323),
('3-1-4-added', '2016-03-18 13:45:28', 324),
('1-1-1-added', '2016-03-18 14:25:02', 325),
('1-1-2-added', '2016-03-18 14:25:02', 326),
('1-1-3-added', '2016-03-18 14:25:02', 327),
('1-1-4-added', '2016-03-18 14:25:02', 328),
('2-1-1-added', '2016-03-18 14:25:02', 329),
('2-1-3-added', '2016-03-18 14:25:02', 330),
('3-1-1-added', '2016-03-18 14:25:02', 331),
('3-1-3-added', '2016-03-18 14:25:03', 332),
('3-1-4-added', '2016-03-18 14:25:03', 333),
('1-1-1-added', '2016-03-18 14:26:08', 334),
('1-1-2-added', '2016-03-18 14:26:08', 335),
('1-1-3-added', '2016-03-18 14:26:08', 336),
('1-1-4-added', '2016-03-18 14:26:08', 337),
('2-1-1-added', '2016-03-18 14:26:08', 338),
('2-1-3-added', '2016-03-18 14:26:08', 339),
('3-1-1-added', '2016-03-18 14:26:09', 340),
('3-1-3-added', '2016-03-18 14:26:09', 341),
('3-1-4-added', '2016-03-18 14:26:09', 342),
('1-1-1-added', '2016-03-19 06:19:46', 343),
('1-1-2-added', '2016-03-19 06:19:47', 344),
('1-1-3-added', '2016-03-19 06:19:47', 345),
('1-1-4-added', '2016-03-19 06:19:47', 346),
('2-1-1-added', '2016-03-19 06:19:47', 347),
('2-1-3-added', '2016-03-19 06:19:47', 348),
('3-1-1-added', '2016-03-19 06:19:47', 349),
('3-1-3-added', '2016-03-19 06:19:48', 350),
('3-1-4-added', '2016-03-19 06:19:48', 351),
('1-1-1-added', '2016-03-19 06:29:33', 352),
('1-1-2-added', '2016-03-19 06:29:33', 353),
('1-1-3-added', '2016-03-19 06:29:33', 354),
('1-1-4-added', '2016-03-19 06:29:33', 355),
('2-1-1-added', '2016-03-19 06:29:33', 356),
('2-1-3-added', '2016-03-19 06:29:34', 357),
('3-1-1-added', '2016-03-19 06:29:34', 358),
('3-1-3-added', '2016-03-19 06:29:34', 359),
('3-1-4-added', '2016-03-19 06:29:34', 360),
('1-1-1-added', '2016-03-19 06:42:40', 361),
('1-1-2-added', '2016-03-19 06:42:40', 362),
('1-1-3-added', '2016-03-19 06:42:40', 363),
('1-1-4-added', '2016-03-19 06:42:40', 364),
('2-1-1-added', '2016-03-19 06:42:40', 365),
('2-1-3-added', '2016-03-19 06:42:40', 366),
('3-1-1-added', '2016-03-19 06:42:40', 367),
('3-1-3-added', '2016-03-19 06:42:40', 368),
('3-1-4-added', '2016-03-19 06:42:41', 369),
('S4Z0AJ8T-010f00726300000490cf88060303006160000000000000000432005e5e0000000019a51405330064640000000000000a070f0064fd00000001ed921e09320064640000000000d3000a13006464000000000000610c32006161000000000cf214b73200646400000000000000b83200646400000000000063bb3200646400000000000000bc3200646400000000000600bd3a00595900000000000b00be22004323001d212000212dbf3200646400000000000000c03200646400000000006500c1320061610000000019d100c22200214100080000002100c51200646400000000000000c61000646400000000000000c73e00c8c800000000000700f0000064fd7466000000cc00f1000064fd0003276f9ef000f2000064fd0028c9da13890000000000000000000000', '2016-03-19 06:55:08', 370),
('1-1-1-added', '2016-03-19 07:02:02', 371),
('1-1-2-added', '2016-03-19 07:02:02', 372),
('1-1-3-added', '2016-03-19 07:02:02', 373),
('1-1-4-added', '2016-03-19 07:02:02', 374),
('2-1-1-added', '2016-03-19 07:02:02', 375),
('2-1-3-added', '2016-03-19 07:02:02', 376),
('3-1-1-added', '2016-03-19 07:02:03', 377),
('3-1-3-added', '2016-03-19 07:02:03', 378),
('3-1-4-added', '2016-03-19 07:02:03', 379);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
