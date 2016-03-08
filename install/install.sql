-- phpMyAdmin SQL Dump
-- version 3.4.10.1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2016 年 03 月 08 日 14:23
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
  `user_id` int(11) NOT NULL,
  `cmd` varchar(20) NOT NULL,
  `sub_cmd` varchar(10) NOT NULL,
  `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `return_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(2) NOT NULL,
  `progress` int(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gui_device`
--

CREATE TABLE IF NOT EXISTS `gui_device` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `level` smallint(2) NOT NULL,
  `group` smallint(2) NOT NULL,
  `index` smallint(2) NOT NULL,
  `disk_id` int(10) NOT NULL,
  `loaded` tinyint(1) NOT NULL,
  `bridged` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='the storage closet' AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `gui_device`
--

INSERT INTO `gui_device` (`id`, `level`, `group`, `index`, `disk_id`, `loaded`, `bridged`, `status`) VALUES
(1, 1, 1, 1, 1, 1, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `gui_disk`
--

CREATE TABLE IF NOT EXISTS `gui_disk` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `sn` int(20) NOT NULL,
  `md5` varchar(500) NOT NULL,
  `c5` int(10) NOT NULL,
  `file_list` varchar(1000) NOT NULL COMMENT '文件列表存储路径',
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
