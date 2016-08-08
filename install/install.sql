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
-- Dumping data for table `gui_admin`
--

LOCK TABLES `gui_admin` WRITE;
/*!40000 ALTER TABLE `gui_admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gui_cab`
--

DROP TABLE IF EXISTS `gui_cab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_cab` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) DEFAULT NULL,
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
  UNIQUE KEY `sn` (`sn`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cab`
--

LOCK TABLES `gui_cab` WRITE;
/*!40000 ALTER TABLE `gui_cab` DISABLE KEYS */;
INSERT INTO `gui_cab` VALUES (1,'1',NULL,6,6,4,1,0,'24.4','95','0.4','{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.4\",\"device_id\":\"1\",\"electricity\":\"95\",\"levels\":[{\"humidity\":\"0.0\",\"id\":\"1\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"2\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"3\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"4\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"5\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"6\",\"temperature\":\"0.0\"}],\"push\":\"1\",\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"24.4\"}','HSX100JG1440001'),(2,'2',NULL,6,6,4,1,0,'24.4','100','0.5','{\"CMD_ID\":\"6\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.5\",\"device_id\":\"2\",\"electricity\":\"100\",\"levels\":[{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"2\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"45.8\",\"id\":\"1\",\"temperature\":\"26.2\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"3\"],\"id\":\"5\"}],\"humidity\":\"46.9\",\"id\":\"2\",\"temperature\":\"25.8\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"3\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"47.2\",\"id\":\"3\",\"temperature\":\"25.7\"},{\"groups\":[{\"disks\":[\"3\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"3\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"2\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"47.5\",\"id\":\"4\",\"temperature\":\"25.6\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"2\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"3\"],\"id\":\"6\"}],\"humidity\":\"47.4\",\"id\":\"5\",\"temperature\":\"25.3\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"}],\"humidity\":\"47.5\",\"id\":\"6\",\"temperature\":\"25.4\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"24.4\"}','HSX100JG1440002');
/*!40000 ALTER TABLE `gui_cab` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cab_caution_log`
--

LOCK TABLES `gui_cab_caution_log` WRITE;
/*!40000 ALTER TABLE `gui_cab_caution_log` DISABLE KEYS */;
INSERT INTO `gui_cab_caution_log` VALUES (1,2,'{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.2\",\"device_id\":\"2\",\"electricity\":\"76\",\"levels\":[{\"humidity\":\"0.0\",\"id\":\"1\",\"temperature\":\"0.0\",\"hum_sts\":\"1\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"2\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"3\",\"temperature\":\"0.0\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"4\",\"temperature\":\"0.0\",\"tmp_sts\":\"2\"},{\"humidity\":\"0.0\",\"id\":\"5\",\"temperature\":\"0.0\",\"tmp_sts\":\"2\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"6\",\"temperature\":\"0.0\"}],\"push\":\"1\",\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"23.4\", \"warning\":\"167772250\", \"channel_error\":\"170\",\"elec_sts\":\"2\", \"curr_sts\":\"2\", \"volt_sts\":\"1\"}',0,0,NULL,'1470642780',NULL),(2,2,'{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.2\",\"device_id\":\"2\",\"electricity\":\"76\",\"levels\":[{\"humidity\":\"0.0\",\"id\":\"1\",\"temperature\":\"0.0\",\"hum_sts\":\"1\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"2\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"3\",\"temperature\":\"0.0\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"4\",\"temperature\":\"0.0\",\"tmp_sts\":\"2\"},{\"humidity\":\"0.0\",\"id\":\"5\",\"temperature\":\"0.0\",\"tmp_sts\":\"2\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"6\",\"temperature\":\"0.0\"}],\"push\":\"1\",\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"23.4\", \"warning\":\"167772250\", \"channel_error\":\"170\",\"elec_sts\":\"2\", \"curr_sts\":\"2\", \"volt_sts\":\"1\"}',0,0,NULL,'1470643349',NULL),(3,2,'{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.2\",\"device_id\":\"2\",\"electricity\":\"76\",\"levels\":[{\"humidity\":\"0.0\",\"id\":\"1\",\"temperature\":\"0.0\",\"hum_sts\":\"1\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"2\",\"temperature\":\"0.0\"},{\"humidity\":\"0.0\",\"id\":\"3\",\"temperature\":\"0.0\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"4\",\"temperature\":\"0.0\",\"tmp_sts\":\"2\"},{\"humidity\":\"0.0\",\"id\":\"5\",\"temperature\":\"0.0\",\"tmp_sts\":\"2\",\"chan_sts\":\"1\"},{\"humidity\":\"0.0\",\"id\":\"6\",\"temperature\":\"0.0\"}],\"push\":\"1\",\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"23.4\", \"warning\":\"167772250\", \"channel_error\":\"170\",\"elec_sts\":\"2\", \"curr_sts\":\"2\", \"volt_sts\":\"1\"}',0,0,NULL,'1470643534',NULL);
/*!40000 ALTER TABLE `gui_cab_caution_log` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_check_conf`
--

LOCK TABLES `gui_check_conf` WRITE;
/*!40000 ALTER TABLE `gui_check_conf` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_check_conf` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_check_plan`
--

LOCK TABLES `gui_check_plan` WRITE;
/*!40000 ALTER TABLE `gui_check_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_check_plan` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_check_start_time`
--

LOCK TABLES `gui_check_start_time` WRITE;
/*!40000 ALTER TABLE `gui_check_start_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_check_start_time` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_chg_log`
--

LOCK TABLES `gui_chg_log` WRITE;
/*!40000 ALTER TABLE `gui_chg_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_chg_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gui_cmd_disk`
--

DROP TABLE IF EXISTS `gui_cmd_disk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_cmd_disk` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `cmd_id` int(10) NOT NULL,
  `cab` smallint(6) NOT NULL,
  `level` smallint(2) DEFAULT '0',
  `grp` smallint(2) DEFAULT NULL,
  `disk` smallint(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cmd_disk`
--

LOCK TABLES `gui_cmd_disk` WRITE;
/*!40000 ALTER TABLE `gui_cmd_disk` DISABLE KEYS */;
INSERT INTO `gui_cmd_disk` VALUES (3,9,2,1,4,2);
/*!40000 ALTER TABLE `gui_cmd_disk` ENABLE KEYS */;
UNLOCK TABLES;

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
  `cmd` varchar(20) NOT NULL,
  `sub_cmd` varchar(10) NOT NULL,
  `start_time` varchar(500) DEFAULT NULL COMMENT '开始时间',
  `status` int(2) DEFAULT NULL,
  `sub_status` int(2) DEFAULT '0' COMMENT '子状态',
  `stage` varchar(30) DEFAULT NULL,
  `progress` float DEFAULT NULL,
  `progress_time` int(11) DEFAULT NULL,
  `msg` varchar(1000) DEFAULT NULL COMMENT 'json原命令',
  `return_msg` varchar(1000) DEFAULT NULL COMMENT '桥接返回消息',
  `finished` smallint(1) DEFAULT '1' COMMENT '命令完成标识，1：已经完成；0：未完成；',
  `extra_info` varchar(256) DEFAULT NULL,
  `busy_disks` varchar(128) DEFAULT NULL,
  `started` tinyint(1) DEFAULT '0' COMMENT '标记命令是否开始',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cmd_log`
--

LOCK TABLES `gui_cmd_log` WRITE;
/*!40000 ALTER TABLE `gui_cmd_log` DISABLE KEYS */;
INSERT INTO `gui_cmd_log` VALUES (1,0,3,'DEVICEINFO','START','1470642760',0,0,NULL,NULL,NULL,'{\"CMD_ID\":\"1\",\"cmd\":\"DEVICEINFO\"}','{\"CMD_ID\":\"1\",\"cabinets\":[{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"1\",\"level_cnt\":\"6\",\"sn\":\"HSX100JG1440001\"},{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"2\",\"level_cnt\":\"6\",\"sn\":\"HSX100JG1440002\"}],\"cmd\":\"DEVICEINFO\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL,1),(2,0,5,'DISKINFO','START','1470649038',0,0,NULL,NULL,NULL,'{\"CMD_ID\":\"2\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"1\"}','{\"CMD_ID\":\"2\",\"SN\":\"S4Z0AC4H\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL,1),(3,0,3,'DISKINFO','START','1470650112',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"3\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"2\"}','{\"CMD_ID\":\"3\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"errmsg\":\"proxy disconnect\",\"group\":\"1\",\"level\":\"1\",\"status\":\"10002\"}',1,NULL,NULL,0),(4,0,3,'DISKINFO','START','1470650186',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"4\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"2\"}','{\"CMD_ID\":\"4\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"errmsg\":\"proxy disconnect\",\"group\":\"1\",\"level\":\"1\",\"status\":\"10002\"}',1,NULL,NULL,0),(5,0,3,'DEVICEINFO','START','1470650309',0,0,NULL,NULL,NULL,'{\"CMD_ID\":\"5\",\"cmd\":\"DEVICEINFO\"}','{\"CMD_ID\":\"5\",\"cabinets\":[{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"1\",\"level_cnt\":\"6\",\"sn\":\"HSX100JG1440001\"},{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"2\",\"level_cnt\":\"6\",\"sn\":\"HSX100JG1440002\"}],\"cmd\":\"DEVICEINFO\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL,1),(6,0,3,'DEVICESTATUS','START','1470650328',0,0,NULL,NULL,NULL,'{\"CMD_ID\":\"6\",\"cmd\":\"DEVICESTATUS\",\"device_id\":\"2\"}','{\"CMD_ID\":\"6\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.5\",\"device_id\":\"2\",\"electricity\":\"100\",\"levels\":[{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"2\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"45.8\",\"id\":\"1\",\"temperature\":\"26.2\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"3\"],\"id\":\"5\"}],\"humidity\":\"46.9\",\"id\":\"2\",\"temperature\":\"25.8\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"3\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"47.2\",\"id\":\"3\",\"temperature\":\"25.7\"},{\"groups\":[{\"disks\":[\"3\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"3\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"2\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"47.5\",\"id\":\"4\",\"temperature\":\"25.6\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"2\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"3\"],\"id\":\"6\"',1,NULL,NULL,1),(7,0,3,'DISKINFO','START','1470650434',0,0,NULL,NULL,NULL,'{\"CMD_ID\":\"7\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"2\"}','{\"CMD_ID\":\"7\",\"SN\":\"W4Z09375\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL,1),(8,0,3,'BRIDGE','START','1470650526',0,0,'58',50,NULL,'{\"CMD_ID\":\"8\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"W4Z09375\"}],\"device_id\":\"2\"}','{\"CMD_ID\":\"8\",\"cmd\":\"BRIDGE\",\"device_id\":\"2\",\"disks\":[{\"SN\":\"\",\"id\":\"1\"}],\"group\":\"1\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"HSX100JG1440002\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1,NULL,NULL,1),(9,0,11,'DISKINFO','START','1470652095',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"9\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"2\",\"device_id\":\"2\"}',NULL,1,NULL,NULL,0);
/*!40000 ALTER TABLE `gui_cmd_log` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_config`
--

LOCK TABLES `gui_config` WRITE;
/*!40000 ALTER TABLE `gui_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_config` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COMMENT='the storage closet';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_device`
--

LOCK TABLES `gui_device` WRITE;
/*!40000 ALTER TABLE `gui_device` DISABLE KEYS */;
INSERT INTO `gui_device` VALUES (1,2,1,1,1,2,1,1,0,NULL,'1470650384','HSX100JG1440002',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"2\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"1\",\"partitions\":[{\"left\":\"488301168\",\"name\":\"C\",\"total\":\"488384000\",\"used\":\"82832\"}],\"push\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,1,2,NULL,NULL,0,0,0,1,8,NULL),(2,2,1,2,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(3,2,1,3,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(4,2,1,4,2,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,1,9,NULL),(5,2,1,5,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(6,2,1,6,4,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(7,2,2,1,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(8,2,2,2,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(9,2,2,4,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(10,2,2,5,3,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(11,2,3,1,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(12,2,3,2,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(13,2,3,3,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(14,2,3,4,1,NULL,1,0,0,NULL,'1470650384','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(15,2,3,5,3,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(16,2,3,6,1,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(17,2,4,1,3,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(18,2,4,2,1,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(19,2,4,3,3,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(20,2,4,4,1,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(21,2,4,5,2,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(22,2,4,6,1,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(23,2,5,1,1,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(24,2,5,4,2,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(25,2,5,5,1,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(26,2,5,6,3,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(27,2,6,1,1,NULL,1,0,0,NULL,'1470650385','',0,0,NULL,1,1,2,NULL,NULL,0,0,0,0,0,NULL),(28,1,1,1,1,1,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,1,2,NULL),(29,1,1,1,3,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,1,2,NULL),(30,1,1,2,1,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(31,1,1,3,1,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(32,1,1,5,1,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(33,1,1,6,1,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(34,1,2,1,1,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(35,1,2,2,1,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(36,1,2,3,1,NULL,0,0,0,NULL,'1470647681','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(37,1,2,4,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(38,1,2,5,3,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(39,1,2,6,2,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(40,1,3,1,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(41,1,3,2,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(42,1,3,3,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(43,1,3,4,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(44,1,3,5,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(45,1,3,6,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(46,1,4,1,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(47,1,4,2,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(48,1,4,3,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(49,1,4,4,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(50,1,4,5,3,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(51,1,4,6,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(52,1,5,1,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(53,1,5,2,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(54,1,5,3,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(55,1,5,4,3,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(56,1,5,5,1,NULL,0,0,0,NULL,'1470647682','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(57,1,5,6,4,NULL,0,0,0,NULL,'1470647683','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(58,1,6,1,3,NULL,0,0,0,NULL,'1470647683','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(59,1,6,2,1,NULL,0,0,0,NULL,'1470647683','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(60,1,6,3,1,NULL,0,0,0,NULL,'1470647683','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(61,1,6,4,2,NULL,0,0,0,NULL,'1470647683','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(62,1,6,5,1,NULL,0,0,0,NULL,'1470647683','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL),(63,1,6,6,3,NULL,0,0,0,NULL,'1470647683','',0,0,NULL,1,1,1,NULL,NULL,0,0,0,0,0,NULL);
/*!40000 ALTER TABLE `gui_device` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk`
--

LOCK TABLES `gui_disk` WRITE;
/*!40000 ALTER TABLE `gui_disk` DISABLE KEYS */;
INSERT INTO `gui_disk` VALUES (1,'S4Z0AC4H',NULL,NULL,NULL,1863,1,NULL,NULL,'1470649117'),(2,'W4Z09375',NULL,NULL,NULL,1863,1,NULL,NULL,'1470650513');
/*!40000 ALTER TABLE `gui_disk` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_disk_chg_log`
--

LOCK TABLES `gui_disk_chg_log` WRITE;
/*!40000 ALTER TABLE `gui_disk_chg_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_disk_chg_log` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_disk_md5_log`
--

LOCK TABLES `gui_disk_md5_log` WRITE;
/*!40000 ALTER TABLE `gui_disk_md5_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_disk_md5_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gui_disk_smart`
--

DROP TABLE IF EXISTS `gui_disk_smart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gui_disk_smart` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `disk_id` int(10) DEFAULT NULL,
  `attrname` varchar(5) DEFAULT NULL,
  `explanation` varchar(20) DEFAULT NULL,
  `value` varchar(20) DEFAULT NULL,
  `dat` varchar(500) DEFAULT NULL,
  `ex_dat` varchar(500) DEFAULT NULL,
  `flag` varchar(50) DEFAULT NULL,
  `thd` varchar(50) DEFAULT NULL,
  `val` varchar(50) DEFAULT NULL,
  `w_val` varchar(50) DEFAULT NULL,
  `normal` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='smart value';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk_smart`
--

LOCK TABLES `gui_disk_smart` WRITE;
/*!40000 ALTER TABLE `gui_disk_smart` DISABLE KEYS */;
INSERT INTO `gui_disk_smart` VALUES (1,1,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(2,1,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(3,1,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(4,2,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(5,2,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(6,2,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1);
/*!40000 ALTER TABLE `gui_disk_smart` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='忠实记录DISKINFO执行过程';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk_smart_log`
--

LOCK TABLES `gui_disk_smart_log` WRITE;
/*!40000 ALTER TABLE `gui_disk_smart_log` DISABLE KEYS */;
INSERT INTO `gui_disk_smart_log` VALUES (1,1470649117,1,1,1,1,1,'S4Z0AC4H',1863,'[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}]',1,'',0,1,2),(2,1470650513,2,1,1,1,2,'W4Z09375',1863,'[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}]',1,'',0,2,7);
/*!40000 ALTER TABLE `gui_disk_smart_log` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_fatal_msg`
--

LOCK TABLES `gui_fatal_msg` WRITE;
/*!40000 ALTER TABLE `gui_fatal_msg` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_fatal_msg` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_install_time`
--

LOCK TABLES `gui_install_time` WRITE;
/*!40000 ALTER TABLE `gui_install_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_install_time` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_level`
--

LOCK TABLES `gui_level` WRITE;
/*!40000 ALTER TABLE `gui_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_level` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_restart_time`
--

LOCK TABLES `gui_restart_time` WRITE;
/*!40000 ALTER TABLE `gui_restart_time` DISABLE KEYS */;
INSERT INTO `gui_restart_time` VALUES (1,1470650272);
/*!40000 ALTER TABLE `gui_restart_time` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_smb`
--

LOCK TABLES `gui_smb` WRITE;
/*!40000 ALTER TABLE `gui_smb` DISABLE KEYS */;
INSERT INTO `gui_smb` VALUES (1,11,2,1,1,1,2),(2,20,2,1,1,1,2),(3,9,2,1,1,1,2);
/*!40000 ALTER TABLE `gui_smb` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_super`
--

LOCK TABLES `gui_super` WRITE;
/*!40000 ALTER TABLE `gui_super` DISABLE KEYS */;
INSERT INTO `gui_super` VALUES (4,'565431c2ff46fff5c450c20276785963','useradmin',0),(5,'565431c2ff46fff5c450c20276785963','logadmin',0);
/*!40000 ALTER TABLE `gui_super` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_system_run_log`
--

LOCK TABLES `gui_system_run_log` WRITE;
/*!40000 ALTER TABLE `gui_system_run_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_system_run_log` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gui_test`
--

LOCK TABLES `gui_test` WRITE;
/*!40000 ALTER TABLE `gui_test` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_test` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_user`
--

LOCK TABLES `gui_user` WRITE;
/*!40000 ALTER TABLE `gui_user` DISABLE KEYS */;
INSERT INTO `gui_user` VALUES (1,'link','05ca671979059ac068d7a0d1f889bb9a',NULL,NULL,NULL,NULL,1,1468284633,'111.202.103.202',1470642735,1,0,'172.'),(2,'zhhw','e1a057bc60894e20d61c39dcd6db18dc',NULL,NULL,NULL,NULL,1,1468285671,'192.168.1.62',1470636349,2,0,NULL),(3,'chm','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,1,1468287899,'192.168.1.30',1470650773,2,0,NULL),(4,'zhw','e1a057bc60894e20d61c39dcd6db18dc',NULL,NULL,NULL,NULL,1,1468287908,'192.168.1.30',1468988017,0,0,NULL),(5,'wyj','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,1,1468287918,'192.168.1.30',1470650921,2,0,NULL),(6,'wilson','42768e7ac59b084e5a14abf4b4465abd',NULL,NULL,NULL,NULL,1,1468396837,'125.33.164.162',1470658960,2,0,NULL),(7,'xulong','5e6eb03b23b712234ca86fdd3ebb0b38',NULL,NULL,NULL,NULL,1,1468468459,'222.128.26.163',1468469535,2,0,NULL),(8,'liuqun','0ab44bd43d6b18fcd5cd928d6faab1b8',NULL,NULL,NULL,NULL,1,1468652701,'23.226.69.153',1468662149,2,0,NULL),(9,'ZJW','f01f2101402c21b8d92a924363d1acdd',NULL,NULL,NULL,NULL,1,1468907571,'125.34.220.61',1469528611,2,0,NULL),(10,'whg','906f173aef8d24dd1a3a10b50ef1790f',NULL,NULL,NULL,NULL,0,1469167249,'61.49.233.24',1469168847,2,0,NULL),(11,'yzh','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,1,1469612892,'192.168.1.33',1470651250,2,0,NULL),(12,'test','c23b2ed66eedb321c5bcfb5e3724b978',NULL,NULL,NULL,NULL,1,1470441939,NULL,NULL,0,0,NULL),(13,'test1','05ca671979059ac068d7a0d1f889bb9a',NULL,NULL,NULL,NULL,1,1470443769,NULL,NULL,0,0,NULL),(14,'sdf','dc76f80133986029d8d0e5d7ea62a339',NULL,NULL,NULL,NULL,1,1470454866,NULL,NULL,0,0,NULL),(15,'user1647','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,0,1470473295,NULL,NULL,0,0,NULL),(16,'user1655','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,0,1470473740,NULL,NULL,0,0,NULL),(17,'user1702','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,0,1470474135,NULL,NULL,0,0,NULL),(18,'user1753','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,0,1470477204,NULL,NULL,0,0,NULL),(19,'user1837','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,0,1470479854,NULL,NULL,0,0,NULL),(20,'user081541','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,1,1470642122,NULL,NULL,0,0,NULL);
/*!40000 ALTER TABLE `gui_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-08-08 21:20:02
