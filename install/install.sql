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
INSERT INTO `gui_cab` VALUES (1,'1',NULL,6,6,4,1,0,'24.5','93','9.8','{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"9.8\",\"device_id\":\"1\",\"electricity\":\"93\",\"levels\":[{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"42.2\",\"id\":\"1\",\"temperature\":\"38.3\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"44.0\",\"id\":\"2\",\"temperature\":\"37.6\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"43.7\",\"id\":\"3\",\"temperature\":\"37.7\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"46.6\",\"id\":\"4\",\"temperature\":\"36.5\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"44.6\",\"id\":\"5\",\"temperature\":\"37.4\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"42.6\",\"id\":\"6\",\"temperature\":\"38.4\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"24.5\"}','HSX100JG1440001'),(2,'2',NULL,6,6,4,1,0,'24.0','82','9.5','{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"9.5\",\"device_id\":\"2\",\"electricity\":\"82\",\"levels\":[{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"52.2\",\"id\":\"1\",\"temperature\":\"34.6\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"54.0\",\"id\":\"2\",\"temperature\":\"33.9\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"54.6\",\"id\":\"3\",\"temperature\":\"33.7\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"57.1\",\"id\":\"4\",\"temperature\":\"32.9\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"4\"},{\"disks\":[\"1\"],\"id\":\"5\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"46.6\",\"id\":\"5\",\"temperature\":\"36.4\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"}],\"humidity\":\"57.1\",\"id\":\"6\",\"temperature\":\"32.8\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"24.0\"}','HSX100JG1440002');
/*!40000 ALTER TABLE `gui_cab` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_check_conf`
--

LOCK TABLES `gui_check_conf` WRITE;
/*!40000 ALTER TABLE `gui_check_conf` DISABLE KEYS */;
INSERT INTO `gui_check_conf` VALUES (1,'1469366272','sn',1,1,'1469030400','week',1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_check_plan`
--

LOCK TABLES `gui_check_plan` WRITE;
/*!40000 ALTER TABLE `gui_check_plan` DISABLE KEYS */;
INSERT INTO `gui_check_plan` VALUES (1,'sn',0,'1469034000','','1469366272',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_check_start_time`
--

LOCK TABLES `gui_check_start_time` WRITE;
/*!40000 ALTER TABLE `gui_check_start_time` DISABLE KEYS */;
INSERT INTO `gui_check_start_time` VALUES (1,1,'sn','1469366429');
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cmd_log`
--

LOCK TABLES `gui_cmd_log` WRITE;
/*!40000 ALTER TABLE `gui_cmd_log` DISABLE KEYS */;
INSERT INTO `gui_cmd_log` VALUES (1,0,1,'DEVICEINFO','START','1469365199',0,0,NULL,NULL,NULL,'{\"CMD_ID\":\"1\",\"cmd\":\"DEVICEINFO\"}','{\"CMD_ID\":\"1\",\"cabinets\":[{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"1\",\"level_cnt\":\"6\",\"sn\":\"HSX100JG1440001\"},{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"2\",\"level_cnt\":\"6\",\"sn\":\"HSX100JG1440002\"}],\"cmd\":\"DEVICEINFO\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(2,0,1,'DISKINFO','START','1469365271',28,0,NULL,NULL,NULL,'{\"CMD_ID\":\"2\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'md5 is going',NULL),(3,0,1,'DISKINFO','START','1469365392',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"3\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'md5 is going',NULL),(4,0,1,'DISKINFO','START','1469365431',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"4\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'bridging',NULL),(5,0,1,'BRIDGE','STOP','1469365870',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"5\",\"cmd\":\"BRIDGE\",\"subcmd\":\"STOP\",\"level\":\"1\",\"group\":\"2\",\"disks\":[{\"id\":\"1\",\"SN\":\"\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"5\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"\",\"id\":\"1\"}],\"errmsg\":\"disks item SN invalid\",\"group\":\"2\",\"level\":\"1\",\"status\":\"10050\",\"subcmd\":\"STOP\"}',1,NULL,NULL),(6,0,1,'DISKINFO','START','1469365949',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"6\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'bridging',NULL),(7,0,1,'DISKINFO','START','1469366046',-3,0,NULL,NULL,NULL,'{\"CMD_ID\":\"7\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'bridging',NULL),(8,0,0,'DISKINFO','START','1469366432',28,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"8\",\"device_id\":1,\"level\":1,\"group\":1,\"disk\":1,\"subcmd\":\"START\"}',NULL,1,'md5 is going',NULL),(9,0,0,'DISKINFO','START','1469366433',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(10,0,0,'DISKINFO','START','1469366433',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"10\",\"SN\":\"9SZ38ES0\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0400\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(11,0,0,'DISKINFO','START','1469366433',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(12,0,0,'DISKINFO','START','1469366433',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"12\",\"SN\":\"S4Z0AF1K\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(13,0,0,'DISKINFO','START','1469366434',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"13\",\"SN\":\"S4Z0B8ML\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(14,0,0,'DISKINFO','START','1469366434',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(15,0,0,'DISKINFO','START','1469366434',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"15\",\"SN\":\"S4Z0ANA5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(16,0,0,'DISKINFO','START','1469366435',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(17,0,0,'DISKINFO','START','1469366435',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"17\",\"SN\":\"Z4Y24G40\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(18,0,0,'DISKINFO','START','1469366435',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(19,0,0,'DISKINFO','START','1469366435',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(20,0,0,'DISKINFO','START','1469366436',0,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"20\",\"device_id\":1,\"level\":3,\"group\":2,\"disk\":1,\"subcmd\":\"START\"}','{\"CMD_ID\":\"20\",\"SN\":\"S4Z0AGGS\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(21,0,0,'DISKINFO','START','1469366436',28,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"21\",\"device_id\":1,\"level\":3,\"group\":3,\"disk\":1,\"subcmd\":\"START\"}',NULL,1,'md5 is going',NULL),(22,0,0,'DISKINFO','START','1469366436',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"22\",\"SN\":\"W4Z09412\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(23,0,0,'DISKINFO','START','1469366436',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"23\",\"SN\":\"S4Y12ZEZ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(24,0,0,'DISKINFO','START','1469366437',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(25,0,0,'DISKINFO','START','1469366437',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"25\",\"SN\":\"S4Z0A7W5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(26,0,0,'DISKINFO','START','1469366437',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(27,0,0,'DISKINFO','START','1469366438',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"27\",\"SN\":\"PFDB30K2CPQSRB\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"05\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0022\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0008\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"76\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(28,0,0,'DISKINFO','START','1469366438',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(29,0,0,'DISKINFO','START','1469366438',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(30,0,0,'DISKINFO','START','1469366439',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"30\",\"SN\":\"S4Z0AJ8T\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(31,0,0,'DISKINFO','START','1469366439',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(32,0,0,'DISKINFO','START','1469366440',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"32\",\"SN\":\"S4Y139Z2\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(33,0,0,'DISKINFO','START','1469366440',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"33\",\"SN\":\"6SZ1YQNK\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0400\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(34,0,0,'DISKINFO','START','1469366440',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(35,0,0,'DISKINFO','START','1469366440',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"35\",\"SN\":\"W4Z093KQ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(36,0,0,'DISKINFO','START','1469366441',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(37,0,0,'DISKINFO','START','1469366441',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"37\",\"SN\":\"S4Z0B8JR\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(38,0,1,'BRIDGE','STOP','1469366509',0,0,NULL,NULL,NULL,'{\"CMD_ID\":\"38\",\"cmd\":\"BRIDGE\",\"subcmd\":\"STOP\",\"level\":\"1\",\"group\":\"2\",\"disks\":[{\"id\":\"1\",\"SN\":\"AA\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"38\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"\",\"id\":\"1\"}],\"group\":\"2\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"\"}],\"status\":\"0\",\"subcmd\":\"STOP\",\"substatus\":\"0\"}',1,NULL,NULL),(39,0,0,'DISKINFO','START','1469366908',28,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"39\",\"device_id\":1,\"level\":1,\"group\":1,\"disk\":1,\"subcmd\":\"START\"}',NULL,1,'md5 is going',NULL),(40,0,0,'DISKINFO','START','1469366908',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"40\",\"SN\":\"S4Z0B87X\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(41,0,0,'DISKINFO','START','1469366908',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(42,0,0,'DISKINFO','START','1469366909',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(43,0,0,'DISKINFO','START','1469366909',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(44,0,0,'DISKINFO','START','1469366909',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(45,0,0,'DISKINFO','START','1469366909',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(46,0,0,'DISKINFO','START','1469366910',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(47,0,0,'DISKINFO','START','1469366910',28,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"47\",\"device_id\":1,\"level\":3,\"group\":3,\"disk\":1,\"subcmd\":\"START\"}',NULL,1,'md5 is going',NULL),(48,0,0,'DISKINFO','START','1469366910',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(49,0,0,'DISKINFO','START','1469366910',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"49\",\"SN\":\"Z4Y24B2G\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(50,0,0,'DISKINFO','START','1469366911',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(51,0,0,'DISKINFO','START','1469366911',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"51\",\"SN\":\"W1D1BRX0\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"465\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(52,0,0,'DISKINFO','START','1469366911',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(53,0,0,'DISKINFO','START','1469366911',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"53\",\"SN\":\"W4Z093MY\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(54,0,0,'DISKINFO','START','1469366912',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(55,0,0,'DISKINFO','START','1469366912',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(56,0,0,'DISKINFO','START','1469366912',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(57,0,0,'DISKINFO','START','1469366912',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(58,0,0,'DISKINFO','START','1469366913',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(59,0,0,'DISKINFO','START','1469366913',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(60,0,0,'DISKINFO','START','1469366913',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(61,0,0,'DISKINFO','START','1469366914',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(62,0,0,'DISKINFO','START','1469366914',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(63,0,0,'DISKINFO','START','1469366914',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"63\",\"SN\":\"S4Z0ANYB\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(64,0,0,'DISKINFO','START','1469366914',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(65,0,0,'DISKINFO','START','1469366915',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"65\",\"SN\":\"5SZ0QZW7\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0300\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(66,0,0,'DISKINFO','START','1469366915',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(67,0,0,'DISKINFO','START','1469366915',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"67\",\"SN\":\"S4Y12P1L\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(68,0,0,'DISKINFO','START','1469366916',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(69,0,0,'DISKINFO','START','1469367385',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(70,0,0,'DISKINFO','START','1469367385',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(71,0,0,'DISKINFO','START','1469367385',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(72,0,0,'DISKINFO','START','1469367385',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(73,0,0,'DISKINFO','START','1469367386',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(74,0,0,'DISKINFO','START','1469367386',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(75,0,0,'DISKINFO','START','1469367386',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(76,0,0,'DISKINFO','START','1469367386',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(77,0,0,'DISKINFO','START','1469367387',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(78,0,0,'DISKINFO','START','1469367387',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(79,0,0,'DISKINFO','START','1469367387',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(80,0,0,'DISKINFO','START','1469367387',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(81,0,0,'DISKINFO','START','1469367388',0,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"81\",\"device_id\":1,\"level\":4,\"group\":6,\"disk\":1,\"subcmd\":\"START\"}','{\"CMD_ID\":\"81\",\"SN\":\"5QF71KP0\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(82,0,0,'DISKINFO','START','1469367388',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(83,0,0,'DISKINFO','START','1469367388',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"83\",\"SN\":\"Z4Y24F9W\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(84,0,0,'DISKINFO','START','1469367388',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(85,0,0,'DISKINFO','START','1469367389',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(86,0,0,'DISKINFO','START','1469367389',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(87,0,0,'DISKINFO','START','1469367389',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(88,0,0,'DISKINFO','START','1469367390',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(89,0,0,'DISKINFO','START','1469367390',28,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"89\",\"device_id\":2,\"level\":3,\"group\":2,\"disk\":1,\"subcmd\":\"START\"}',NULL,1,'md5 is going',NULL),(90,0,0,'DISKINFO','START','1469367390',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(91,0,0,'DISKINFO','START','1469367390',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(92,0,0,'DISKINFO','START','1469367391',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(93,0,0,'DISKINFO','START','1469367391',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(94,0,0,'DISKINFO','START','1469367391',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(95,0,0,'DISKINFO','START','1469367392',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(96,0,0,'DISKINFO','START','1469367392',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(97,0,0,'DISKINFO','START','1469367392',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"97\",\"SN\":\"S4Z0AGQN\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(98,0,0,'DISKINFO','START','1469367393',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(99,0,1,'DISKINFO','START','1469367519',28,0,NULL,NULL,NULL,'{\"CMD_ID\":\"99\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'md5 is going',NULL),(100,0,1,'DISKINFO','START','1469367534',28,0,NULL,NULL,NULL,'{\"CMD_ID\":\"100\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'md5 is going',NULL),(101,0,1,'MD5','START','1469367597',28,0,NULL,NULL,NULL,'{\"CMD_ID\":\"101\",\"cmd\":\"MD5\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"1\"}',NULL,1,'md5 is going',NULL),(102,0,0,'DISKINFO','START','1469367862',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(103,0,0,'DISKINFO','START','1469367862',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(104,0,0,'DISKINFO','START','1469367862',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(105,0,0,'DISKINFO','START','1469367863',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(106,0,0,'DISKINFO','START','1469367863',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(107,0,0,'DISKINFO','START','1469367863',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(108,0,0,'DISKINFO','START','1469367863',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(109,0,0,'DISKINFO','START','1469367864',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(110,0,0,'DISKINFO','START','1469367864',28,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"110\",\"device_id\":1,\"level\":4,\"group\":1,\"disk\":1,\"subcmd\":\"START\"}',NULL,1,'md5 is going',NULL),(111,0,0,'DISKINFO','START','1469367864',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(112,0,0,'DISKINFO','START','1469367865',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(113,0,0,'DISKINFO','START','1469367865',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(114,0,0,'DISKINFO','START','1469367865',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(115,0,0,'DISKINFO','START','1469367865',0,0,NULL,NULL,NULL,NULL,'{\"CMD_ID\":\"115\",\"SN\":\"5SZ0S63P\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1,NULL,NULL),(116,0,0,'DISKINFO','START','1469367866',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(117,0,0,'DISKINFO','START','1469367866',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(118,0,0,'DISKINFO','START','1469367866',28,0,NULL,NULL,NULL,'{\"cmd\":\"DISKINFO\",\"CMD_ID\":\"118\",\"device_id\":2,\"level\":1,\"group\":6,\"disk\":1,\"subcmd\":\"START\"}',NULL,1,'md5 is going',NULL),(119,0,0,'DISKINFO','START','1469367866',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(120,0,0,'DISKINFO','START','1469367867',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(121,0,0,'DISKINFO','START','1469367867',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(122,0,0,'DISKINFO','START','1469367867',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(123,0,0,'DISKINFO','START','1469367868',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(124,0,0,'DISKINFO','START','1469367868',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(125,0,0,'DISKINFO','START','1469367868',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(126,0,0,'DISKINFO','START','1469367868',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(127,0,0,'DISKINFO','START','1469367869',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(128,0,0,'DISKINFO','START','1469367869',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(129,0,0,'DISKINFO','START','1469367869',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(130,0,0,'DISKINFO','START','1469367870',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(131,0,0,'DISKINFO','START','1469368339',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(132,0,0,'DISKINFO','START','1469368339',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(133,0,0,'DISKINFO','START','1469368339',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(134,0,0,'DISKINFO','START','1469368339',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(135,0,0,'DISKINFO','START','1469368340',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(136,0,0,'DISKINFO','START','1469368340',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(137,0,0,'DISKINFO','START','1469368340',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(138,0,0,'DISKINFO','START','1469368340',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(139,0,0,'DISKINFO','START','1469368341',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(140,0,0,'DISKINFO','START','1469368341',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(141,0,0,'DISKINFO','START','1469368341',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(142,0,0,'DISKINFO','START','1469368342',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(143,0,0,'DISKINFO','START','1469368342',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(144,0,0,'DISKINFO','START','1469368342',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(145,0,0,'DISKINFO','START','1469368342',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(146,0,0,'DISKINFO','START','1469368343',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(147,0,0,'DISKINFO','START','1469368343',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(148,0,0,'DISKINFO','START','1469368343',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(149,0,0,'DISKINFO','START','1469368343',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(150,0,0,'DISKINFO','START','1469368344',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(151,0,0,'DISKINFO','START','1469368344',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(152,0,0,'DISKINFO','START','1469368344',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(153,0,0,'DISKINFO','START','1469368345',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(154,0,0,'DISKINFO','START','1469368345',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(155,0,0,'DISKINFO','START','1469368345',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(156,0,0,'DISKINFO','START','1469368346',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(157,0,0,'DISKINFO','START','1469368346',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(158,0,0,'DISKINFO','START','1469368346',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(159,0,0,'DISKINFO','START','1469368346',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL),(160,0,0,'DISKINFO','START','1469368347',28,0,NULL,NULL,NULL,NULL,NULL,1,'md5 is going',NULL);
/*!40000 ALTER TABLE `gui_cmd_log` ENABLE KEYS */;
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
INSERT INTO `gui_device` VALUES (1,2,1,1,1,7,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(2,2,1,2,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,146,0,0,0,''),(3,2,1,3,1,12,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(4,2,1,4,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,147,0,0,0,''),(5,2,1,5,1,2,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(6,2,1,6,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,148,0,0,0,''),(7,2,2,1,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,149,0,0,0,''),(8,2,2,2,1,4,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(9,2,2,5,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,150,0,0,0,''),(10,2,2,6,1,15,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(11,2,3,1,1,8,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(12,2,3,2,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,151,0,0,0,''),(13,2,3,3,1,13,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(14,2,3,4,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,152,0,0,0,''),(15,2,3,5,1,14,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(16,2,3,6,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,153,0,0,0,''),(17,2,4,1,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,154,0,0,0,''),(18,2,4,2,1,20,1,0,0,'','1469368792','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(19,2,4,3,1,0,1,0,0,'','1469368792','',0,0,'',1,1,2,0,0,0,155,0,0,0,''),(20,2,4,4,1,17,1,0,0,'','1469368793','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(21,2,4,5,1,0,1,0,0,'','1469368793','',0,0,'',1,1,2,0,0,0,156,0,0,0,''),(22,2,4,6,1,19,1,0,0,'','1469368793','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(23,2,5,1,1,0,1,0,0,'','1469368793','',0,0,'',1,1,2,0,0,0,157,0,0,0,''),(24,2,5,4,1,0,1,0,0,'','1469368793','',0,0,'',1,1,2,0,0,0,158,0,0,0,''),(25,2,5,5,1,25,1,0,0,'','1469368793','',0,0,'',1,1,2,0,1,0,0,0,0,0,''),(26,2,5,6,1,0,1,0,0,'','1469368793','',0,0,'',1,1,2,0,0,0,159,0,0,0,''),(27,2,6,1,1,0,1,0,0,'','1469368793','',0,0,'',1,1,2,0,0,0,160,0,0,0,''),(28,1,1,1,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,131,0,0,0,''),(29,1,1,2,1,18,1,0,0,'','1469368786','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"1\",\"group\":\"2\",\"level\":\"1\",\"partitions\":[{\"left\":\"861713140\",\"name\":\"C\",\"total\":\"1953512256\",\"used\":\"1091799116\"}],\"status\":\"0\",\"substatus\":\"0\"}',1,0,1,0,1,0,0,0,0,0,''),(30,1,1,3,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,132,0,0,0,''),(31,1,1,4,1,1,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(32,1,1,5,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,133,0,0,0,''),(33,1,1,6,1,10,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(34,1,2,1,1,5,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(35,1,2,2,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,134,0,0,0,''),(36,1,2,3,1,3,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(37,1,2,4,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,135,0,0,0,''),(38,1,2,5,1,6,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(39,1,2,6,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,136,0,0,0,''),(40,1,3,1,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,137,0,0,0,''),(41,1,3,2,1,9,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(42,1,3,3,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,138,0,0,0,''),(43,1,3,4,1,11,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(44,1,3,5,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,139,0,0,0,''),(45,1,3,6,1,16,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(46,1,4,1,1,0,1,0,0,'','1469368786','',0,0,'',1,1,1,0,0,0,140,0,0,0,''),(47,1,4,2,1,22,1,0,0,'','1469368786','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(48,1,4,3,1,0,1,0,0,'','1469368787','',0,0,'',1,1,1,0,0,0,141,0,0,0,''),(49,1,4,4,1,21,1,0,0,'','1469368787','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(50,1,4,5,1,0,1,0,0,'','1469368787','',0,0,'',1,1,1,0,0,0,142,0,0,0,''),(51,1,4,6,1,23,1,0,0,'','1469368787','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(52,1,5,1,1,0,1,0,0,'','1469368787','',0,0,'',1,1,1,0,0,0,143,0,0,0,''),(53,1,5,2,1,24,1,0,0,'','1469368787','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(54,1,5,3,1,0,1,0,0,'','1469368787','',0,0,'',1,1,1,0,0,0,144,0,0,0,''),(55,1,5,4,1,26,1,0,0,'','1469368787','',0,0,'',1,1,1,0,1,0,0,0,0,0,''),(56,1,5,5,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,0,0,145,0,0,0,NULL),(57,1,5,6,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,-1,0,0,0,0,0,NULL),(58,1,6,1,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,-1,0,0,0,0,0,NULL),(59,1,6,2,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,-1,0,0,0,0,0,NULL),(60,1,6,3,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,-1,0,0,0,0,0,NULL),(61,1,6,4,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,-1,0,0,0,0,0,NULL),(62,1,6,5,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,-1,0,0,0,0,0,NULL),(63,1,6,6,1,NULL,1,0,0,NULL,'1469368787',NULL,0,0,NULL,1,1,1,NULL,-1,0,0,0,0,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk`
--

LOCK TABLES `gui_disk` WRITE;
/*!40000 ALTER TABLE `gui_disk` DISABLE KEYS */;
INSERT INTO `gui_disk` VALUES (1,'9SZ38ES0',NULL,NULL,NULL,298,1,NULL,NULL,'1469366507'),(2,'PFDB30K2CPQSRB',NULL,NULL,NULL,76,1,NULL,NULL,'1469366509'),(3,'S4Z0ANA5',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366515'),(4,'S4Z0AJ8T',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366523'),(5,'S4Z0B8ML',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366523'),(6,'Z4Y24G40',NULL,NULL,NULL,931,1,NULL,NULL,'1469366524'),(7,'S4Y12ZEZ',NULL,NULL,NULL,931,1,NULL,NULL,'1469366528'),(8,'6SZ1YQNK',NULL,NULL,NULL,298,1,NULL,NULL,'1469366534'),(9,'S4Z0AGGS',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366537'),(10,'S4Z0AF1K',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366538'),(11,'W4Z09412',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366540'),(12,'S4Z0A7W5',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366540'),(13,'W4Z093KQ',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366542'),(14,'S4Z0B8JR',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366544'),(15,'S4Y139Z2',NULL,NULL,NULL,931,1,NULL,NULL,'1469366560'),(16,'Z4Y24B2G',NULL,NULL,NULL,931,1,NULL,NULL,'1469366975'),(17,'5SZ0QZW7',NULL,NULL,NULL,298,1,NULL,NULL,'1469366978'),(18,'S4Z0B87X',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366979'),(19,'S4Y12P1L',NULL,NULL,NULL,931,1,NULL,NULL,'1469366980'),(20,'S4Z0ANYB',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366981'),(21,'W4Z093MY',NULL,NULL,NULL,1863,1,NULL,NULL,'1469366984'),(22,'W1D1BRX0',NULL,NULL,NULL,465,1,NULL,NULL,'1469366989'),(23,'5QF71KP0',NULL,NULL,NULL,298,1,NULL,NULL,'1469367458'),(24,'Z4Y24F9W',NULL,NULL,NULL,931,1,NULL,NULL,'1469367458'),(25,'S4Z0AGQN',NULL,NULL,NULL,1863,1,NULL,NULL,'1469367460'),(26,'5SZ0S63P',NULL,NULL,NULL,298,1,NULL,NULL,'1469367927');
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
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8 COMMENT='smart value';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk_smart`
--

LOCK TABLES `gui_disk_smart` WRITE;
/*!40000 ALTER TABLE `gui_disk_smart` DISABLE KEYS */;
INSERT INTO `gui_disk_smart` VALUES (1,1,'05',NULL,NULL,'00000000','0400','0033','24','64','64',1),(2,1,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(3,1,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(4,2,'05',NULL,NULL,'00000000','0000','0033','05','64','64',1),(5,2,'C5',NULL,NULL,'00000000','0000','0022','00','64','64',1),(6,2,'C6',NULL,NULL,'00000000','0000','0008','00','64','64',1),(7,3,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(8,3,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(9,3,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(10,4,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(11,4,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(12,4,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(13,5,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(14,5,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(15,5,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(16,6,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(17,6,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(18,6,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(19,7,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(20,7,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(21,7,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(22,8,'05',NULL,NULL,'00000000','0400','0033','24','64','64',1),(23,8,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(24,8,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(25,9,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(26,9,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(27,9,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(28,10,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(29,10,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(30,10,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(31,11,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(32,11,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(33,11,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(34,12,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(35,12,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(36,12,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(37,13,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(38,13,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(39,13,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(40,14,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(41,14,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(42,14,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(43,15,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(44,15,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(45,15,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(46,16,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(47,16,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(48,16,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(49,17,'05',NULL,NULL,'00000000','0300','0033','24','64','64',1),(50,17,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(51,17,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(52,18,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(53,18,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(54,18,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(55,19,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(56,19,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(57,19,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(58,20,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(59,20,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(60,20,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(61,21,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(62,21,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(63,21,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(64,22,'05',NULL,NULL,'00000000','0000','0033','24','64','64',1),(65,22,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(66,22,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(67,23,'05',NULL,NULL,'00000000','0000','0033','24','64','64',1),(68,23,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(69,23,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(70,24,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(71,24,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(72,24,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(73,25,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(74,25,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(75,25,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(76,26,'05',NULL,NULL,'00000000','0000','0033','24','64','64',1),(77,26,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(78,26,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='忠实记录DISKINFO执行过程';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk_smart_log`
--

LOCK TABLES `gui_disk_smart_log` WRITE;
/*!40000 ALTER TABLE `gui_disk_smart_log` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_fatal_msg`
--

LOCK TABLES `gui_fatal_msg` WRITE;
/*!40000 ALTER TABLE `gui_fatal_msg` DISABLE KEYS */;
INSERT INTO `gui_fatal_msg` VALUES (1,'2016-07-24 13:21:47','empty disk id, when post : {\"CMD_ID\":\"10\",\"SN\":\"9SZ38ES0\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0400\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}'),(2,'2016-07-24 13:21:49','empty disk id, when post : {\"CMD_ID\":\"27\",\"SN\":\"PFDB30K2CPQSRB\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"05\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0022\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0008\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"76\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}'),(3,'2016-07-24 13:21:55','empty disk id, when post : {\"CMD_ID\":\"15\",\"SN\":\"S4Z0ANA5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}'),(4,'2016-07-24 13:22:03','empty disk id, when post : {\"CMD_ID\":\"30\",\"SN\":\"S4Z0AJ8T\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}'),(5,'2016-07-24 13:22:03','empty disk id, when post : {\"CMD_ID\":\"13\",\"SN\":\"S4Z0B8ML\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}'),(6,'2016-07-24 13:22:04','empty disk id, when post : {\"CMD_ID\":\"17\",\"SN\":\"Z4Y24G40\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}'),(7,'2016-07-24 13:22:08','empty disk id, when post : {\"CMD_ID\":\"23\",\"SN\":\"S4Y12ZEZ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}'),(8,'2016-07-24 13:22:14','empty disk id, when post : {\"CMD_ID\":\"33\",\"SN\":\"6SZ1YQNK\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0400\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}'),(9,'2016-07-24 13:22:17','empty disk id, when post : {\"CMD_ID\":\"20\",\"SN\":\"S4Z0AGGS\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}'),(10,'2016-07-24 13:22:18','empty disk id, when post : {\"CMD_ID\":\"12\",\"SN\":\"S4Z0AF1K\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}'),(11,'2016-07-24 13:22:20','empty disk id, when post : {\"CMD_ID\":\"22\",\"SN\":\"W4Z09412\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}'),(12,'2016-07-24 13:22:20','empty disk id, when post : {\"CMD_ID\":\"25\",\"SN\":\"S4Z0A7W5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}'),(13,'2016-07-24 13:22:22','empty disk id, when post : {\"CMD_ID\":\"35\",\"SN\":\"W4Z093KQ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}'),(14,'2016-07-24 13:22:24','empty disk id, when post : {\"CMD_ID\":\"37\",\"SN\":\"S4Z0B8JR\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}'),(15,'2016-07-24 13:22:40','empty disk id, when post : {\"CMD_ID\":\"32\",\"SN\":\"S4Y139Z2\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}'),(16,'2016-07-24 13:29:35','empty disk id, when post : {\"CMD_ID\":\"49\",\"SN\":\"Z4Y24B2G\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}'),(17,'2016-07-24 13:29:38','empty disk id, when post : {\"CMD_ID\":\"65\",\"SN\":\"5SZ0QZW7\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0300\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}'),(18,'2016-07-24 13:29:39','empty disk id, when post : {\"CMD_ID\":\"40\",\"SN\":\"S4Z0B87X\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}'),(19,'2016-07-24 13:29:40','empty disk id, when post : {\"CMD_ID\":\"67\",\"SN\":\"S4Y12P1L\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}'),(20,'2016-07-24 13:29:41','empty disk id, when post : {\"CMD_ID\":\"63\",\"SN\":\"S4Z0ANYB\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}'),(21,'2016-07-24 13:29:44','empty disk id, when post : {\"CMD_ID\":\"53\",\"SN\":\"W4Z093MY\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}'),(22,'2016-07-24 13:29:49','empty disk id, when post : {\"CMD_ID\":\"51\",\"SN\":\"W1D1BRX0\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"465\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}'),(23,'2016-07-24 13:37:38','empty disk id, when post : {\"CMD_ID\":\"81\",\"SN\":\"5QF71KP0\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}'),(24,'2016-07-24 13:37:38','empty disk id, when post : {\"CMD_ID\":\"83\",\"SN\":\"Z4Y24F9W\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}'),(25,'2016-07-24 13:37:40','empty disk id, when post : {\"CMD_ID\":\"97\",\"SN\":\"S4Z0AGQN\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}'),(26,'2016-07-24 13:45:27','empty disk id, when post : {\"CMD_ID\":\"115\",\"SN\":\"5SZ0S63P\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_restart_time`
--

LOCK TABLES `gui_restart_time` WRITE;
/*!40000 ALTER TABLE `gui_restart_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `gui_restart_time` ENABLE KEYS */;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_user`
--

LOCK TABLES `gui_user` WRITE;
/*!40000 ALTER TABLE `gui_user` DISABLE KEYS */;
INSERT INTO `gui_user` VALUES (1,'link','05ca671979059ac068d7a0d1f889bb9a',NULL,NULL,NULL,NULL,1,1468284633,'119.57.116.127',1469367505,1,0),(2,'zhhw','e1a057bc60894e20d61c39dcd6db18dc',NULL,NULL,NULL,NULL,1,1468285671,'123.119.193.54',1469361106,2,0),(3,'chm','5690dddfa28ae085d23518a035707282',NULL,NULL,NULL,NULL,1,1468287899,'192.168.1.30',1469260844,1,0),(4,'zhw','e1a057bc60894e20d61c39dcd6db18dc',NULL,NULL,NULL,NULL,1,1468287908,'192.168.1.30',1468988017,0,0),(5,'wyj','828dcbd61895ef9bc7b1819f60ca99dc',NULL,NULL,NULL,NULL,1,1468287918,'124.65.50.54',1469176469,2,0),(6,'wilson','42768e7ac59b084e5a14abf4b4465abd',NULL,NULL,NULL,NULL,1,1468396837,'123.121.61.51',1469366946,2,0),(7,'xulong','5e6eb03b23b712234ca86fdd3ebb0b38',NULL,NULL,NULL,NULL,1,1468468459,'222.128.26.163',1468469535,2,0),(8,'liuqun','0ab44bd43d6b18fcd5cd928d6faab1b8',NULL,NULL,NULL,NULL,1,1468652701,'23.226.69.153',1468662149,2,0),(9,'ZJW','f01f2101402c21b8d92a924363d1acdd',NULL,NULL,NULL,NULL,1,1468907571,'61.49.233.24',1469158217,2,0),(10,'whg','906f173aef8d24dd1a3a10b50ef1790f',NULL,NULL,NULL,NULL,1,1469167249,'61.49.233.24',1469168847,2,0);
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

-- Dump completed on 2016-07-24 21:59:57
