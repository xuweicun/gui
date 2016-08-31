-- MySQL dump 10.13  Distrib 5.5.42, for Linux (x86_64)
--
-- Host: localhost    Database: gui
-- ------------------------------------------------------
-- Server version	5.5.42-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gui_admin`
--

DROP TABLE IF EXISTS `gui_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_admin` (
  `adminid` smallint(6) NOT NULL AUTO_INCREMENT,
  `adminname` varchar(50) COLLATE gbk_bin NOT NULL,
  `password` varchar(100) COLLATE gbk_bin NOT NULL,
  PRIMARY KEY (`adminid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk COLLATE=gbk_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_cab`
--

DROP TABLE IF EXISTS `gui_cab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_cab` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `sn` varchar(64) DEFAULT NULL COMMENT 'proxy id',
  `alias` varchar(50) DEFAULT NULL,
  `level_cnt` smallint(3) DEFAULT '6',
  `group_cnt` smallint(3) DEFAULT '6',
  `disk_cnt` smallint(3) DEFAULT '4',
  `loaded` tinyint(1) DEFAULT '1',
  `inited` tinyint(1) DEFAULT '0',
  `voltage` varchar(10) DEFAULT NULL,
  `electricity` varchar(10) DEFAULT NULL,
  `charge` varchar(10) DEFAULT NULL,
  `status` varchar(4096) DEFAULT NULL,
  `name` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_cab_caution_log`
--

DROP TABLE IF EXISTS `gui_cab_caution_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_cab_caution_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `cab_id` smallint(6) NOT NULL,
  `status` varchar(2056) NOT NULL,
  `dismissed` tinyint(1) DEFAULT '0',
  `pushed` tinyint(1) DEFAULT NULL,
  `user_id` smallint(6) DEFAULT NULL,
  `time` varchar(1024) DEFAULT NULL,
  `modify_time` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_check_conf`
--

DROP TABLE IF EXISTS `gui_check_conf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_check_conf` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `time` varchar(100) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `hour` smallint(6) DEFAULT NULL,
  `start_date` varchar(100) DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `cnt` smallint(6) DEFAULT NULL,
  `user_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_check_plan`
--

DROP TABLE IF EXISTS `gui_check_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_check_plan` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) DEFAULT NULL,
  `status` smallint(6) DEFAULT NULL,
  `start_time` varchar(100) DEFAULT NULL,
  `finish_time` varchar(100) DEFAULT NULL,
  `modify_time` varchar(100) DEFAULT NULL,
  `user_id` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_check_start_time`
--

DROP TABLE IF EXISTS `gui_check_start_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_check_start_time` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `is_current` tinyint(1) DEFAULT '1',
  `type` varchar(10) DEFAULT NULL,
  `start_date` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_chg_log`
--

DROP TABLE IF EXISTS `gui_chg_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_chg_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `obj_id` int(5) NOT NULL,
  `value` varchar(300) NOT NULL COMMENT 'md5 or sn',
  `time` varchar(50) DEFAULT NULL,
  `handled` int(1) NOT NULL,
  `comment` varchar(3000) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='异常记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_cmd_disk`
--

DROP TABLE IF EXISTS `gui_cmd_disk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_cmd_disk` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `cmd_id` int(10) NOT NULL,
  `db_cab_id` smallint(6) DEFAULT NULL COMMENT 'cab 在数据库中的唯一ID',
  `cab` smallint(6) NOT NULL,
  `level` smallint(2) DEFAULT '0',
  `grp` smallint(2) DEFAULT NULL,
  `disk` smallint(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_cmd_log`
--

DROP TABLE IF EXISTS `gui_cmd_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_cmd_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dst_id` int(10) DEFAULT '0' COMMENT '目标命令id',
  `user_id` int(11) DEFAULT NULL,
  `db_cab_id` smallint(6) DEFAULT '0',
  `cmd` varchar(20) NOT NULL,
  `sub_cmd` varchar(10) NOT NULL,
  `start_time` varchar(500) DEFAULT NULL COMMENT '开始时间',
  `status` int(2) DEFAULT NULL,
  `sub_status` int(2) DEFAULT '0' COMMENT '子状态',
  `stage` varchar(30) DEFAULT NULL,
  `progress` float DEFAULT NULL,
  `progress_time` int(11) DEFAULT NULL,
  `msg` varchar(4096) DEFAULT NULL COMMENT 'json原命令',
  `return_msg` varchar(8192) DEFAULT NULL COMMENT '桥接返回消息',
  `finished` smallint(1) DEFAULT '1' COMMENT '命令完成标识，1：已经完成；0：未完成；',
  `extra_info` varchar(4096) DEFAULT NULL,
  `busy_disks` varchar(4096) DEFAULT NULL,
  `started` tinyint(1) DEFAULT '0' COMMENT '标记命令是否开始',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_config`
--

DROP TABLE IF EXISTS `gui_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_config` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL,
  `value` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_device`
--

DROP TABLE IF EXISTS `gui_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_device` (
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
  `partition` varchar(500) DEFAULT NULL,
  `normal` tinyint(1) DEFAULT '1',
  `protected` tinyint(1) DEFAULT '1',
  `cabinet_id` int(11) DEFAULT NULL,
  `md5_status` smallint(6) DEFAULT NULL COMMENT 'MD5自检状态：-1表示等待，0表示进行中，1表示完成，2表示取消',
  `sn_status` smallint(6) DEFAULT NULL,
  `md5_cmd_id` int(10) DEFAULT '0',
  `sn_cmd_id` int(10) DEFAULT '0',
  `md5_skipped` tinyint(1) DEFAULT '0',
  `busy` tinyint(1) DEFAULT '0',
  `busy_cmd_id` int(10) DEFAULT '0',
  `md5_skip_time` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='the storage closet';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_disk`
--

DROP TABLE IF EXISTS `gui_disk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_disk` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `sn` varchar(20) DEFAULT NULL,
  `md5` varchar(500) DEFAULT NULL,
  `c5` int(10) DEFAULT NULL,
  `file_list` varchar(1000) DEFAULT NULL COMMENT '文件列表存储路径',
  `capacity` int(5) DEFAULT NULL,
  `normal` tinyint(1) DEFAULT '1',
  `md5_changed` int(11) DEFAULT NULL,
  `md5_time` varchar(500) DEFAULT NULL,
  `sn_time` varchar(500) DEFAULT NULL,
  `power_on_count` varchar(32) DEFAULT NULL,
  `power_on_value` varchar(32) DEFAULT NULL,
  `firmware` varchar(32) DEFAULT NULL,
  `health` varchar(8) DEFAULT NULL,
  `temperature` varchar(32) DEFAULT '0',
  `rotation` varchar(32) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_disk_chg_log`
--

DROP TABLE IF EXISTS `gui_disk_chg_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_disk_chg_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `time` varchar(30) DEFAULT NULL,
  `type` varchar(500) DEFAULT NULL,
  `is_new` tinyint(1) DEFAULT '1',
  `obj_id` int(10) NOT NULL,
  `value` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_disk_md5_log`
--

DROP TABLE IF EXISTS `gui_disk_md5_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_disk_md5_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `zu` int(11) NOT NULL,
  `disk` int(11) NOT NULL,
  `disk_id` int(11) NOT NULL,
  `sn` varchar(45) DEFAULT NULL,
  `status` int(11) NOT NULL COMMENT 'status: 0代表成功发出；1代表成功执行；2代表异常；',
  `md5_value` varchar(45) DEFAULT NULL COMMENT '当status为1时，md5_value记录md5值，md5_time记录成功时间\n当status为2时，md5_value记录错误号，md5_time记录失败时间',
  `md5_time` int(11) DEFAULT NULL,
  `cabinet_id` int(11) DEFAULT NULL,
  `cmd_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='忠实记录MD5命令执行过程';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_disk_smart`
--

DROP TABLE IF EXISTS `gui_disk_smart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_disk_smart` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `disk_id` int(10) DEFAULT NULL,
  `attr_id` varchar(5) DEFAULT NULL,
  `c_val` varchar(64) DEFAULT NULL,
  `raw_val` varchar(64) DEFAULT NULL,
  `sts` varchar(64) DEFAULT NULL,
  `thd` varchar(64) DEFAULT NULL,
  `w_val` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='smart value';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_disk_smart_log`
--

DROP TABLE IF EXISTS `gui_disk_smart_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_disk_smart_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` int(11) NOT NULL COMMENT '命令成功发出时间',
  `device_id` int(11) NOT NULL,
  `level` int(11) NOT NULL COMMENT '层',
  `zu` int(11) NOT NULL COMMENT '组',
  `disk` int(11) NOT NULL COMMENT '盘位',
  `disk_id` int(11) NOT NULL,
  `sn` varchar(45) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `smart` varchar(300) DEFAULT NULL COMMENT 'smart解析值',
  `status` int(11) NOT NULL COMMENT '0代表发出成功；1代表执行成功；2代表异常',
  `status_comment` varchar(45) DEFAULT NULL COMMENT '当status为2时，status_comment中记录错误号',
  `disk_status` int(11) DEFAULT NULL,
  `cabinet_id` int(11) DEFAULT NULL,
  `cmd_id` int(11) DEFAULT NULL,
  `health` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='忠实记录DISKINFO执行过程';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_fatal_msg`
--

DROP TABLE IF EXISTS `gui_fatal_msg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_fatal_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg` varchar(4096) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_install_time`
--

DROP TABLE IF EXISTS `gui_install_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_install_time` (
  `id` smallint(3) NOT NULL AUTO_INCREMENT,
  `time` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_level`
--

DROP TABLE IF EXISTS `gui_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_level` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `level` int(5) NOT NULL,
  `protected` int(1) DEFAULT '1' COMMENT '写保护',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='层级表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_restart_time`
--

DROP TABLE IF EXISTS `gui_restart_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_restart_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restart_time` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_run_time_err_log`
--

DROP TABLE IF EXISTS `gui_run_time_err_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_run_time_err_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `cmd_id` int(10) NOT NULL,
  `dismissed` tinyint(1) DEFAULT '0',
  `dismiss_time` varchar(1024) DEFAULT NULL,
  `time` varchar(1024) DEFAULT NULL,
  `user_id` smallint(6) DEFAULT '0',
  `err_code` varchar(5) DEFAULT NULL,
  `err_msg` varchar(1024) DEFAULT NULL,
  `cmd` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_smb`
--

DROP TABLE IF EXISTS `gui_smb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_smb` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `cab_id` int(11) DEFAULT NULL,
  `lvl` int(11) DEFAULT NULL,
  `grp` int(11) DEFAULT NULL,
  `dsk` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_super`
--

DROP TABLE IF EXISTS `gui_super`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_super` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pwd` varchar(500) NOT NULL,
  `name` varchar(100) NOT NULL,
  `locked` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_system_run_log`
--

DROP TABLE IF EXISTS `gui_system_run_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_system_run_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  `msg` varchar(2048) DEFAULT NULL,
  `time` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_test`
--

DROP TABLE IF EXISTS `gui_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_test` (
  `response` varchar(1000) NOT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gui_user`
--

DROP TABLE IF EXISTS `gui_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `avatar` text,
  `email` text,
  `email_code` text,
  `phone` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `register_time` int(11) DEFAULT NULL,
  `last_login_ip` text,
  `last_login_time` int(11) DEFAULT NULL,
  `write` int(11) NOT NULL DEFAULT '0' COMMENT '写权限：0代表无，非0代表有；默认无写权限',
  `locked` int(11) NOT NULL DEFAULT '0',
  `smb_ip` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-08-31 20:31:02
