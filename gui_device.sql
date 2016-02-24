-- phpMyAdmin SQL Dump
-- version 3.4.10.1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2016 年 02 月 21 日 15:15
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
(1, 1, 1, 1, 1, 0, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
