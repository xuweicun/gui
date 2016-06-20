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
  `status` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sn` (`sn`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cab`
--

LOCK TABLES `gui_cab` WRITE;
/*!40000 ALTER TABLE `gui_cab` DISABLE KEYS */;
INSERT INTO `gui_cab` VALUES (1,'1',NULL,6,6,4,1,0,'0.00','0.00','0','{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.00\",\"device_id\":\"1\",\"electricity\":\"0\",\"levels\":[{\"groups\":[{\"disks\":[\"1\",\"2\",\"4\"],\"id\":\"1\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"4\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"5\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"6\"}],\"humidity\":\"23.23\",\"id\":\"1\",\"temperature\":\"57.66\"},{\"groups\":[{\"disks\":[\"3\"],\"id\":\"1\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"33.39\",\"id\":\"2\",\"temperature\":\"54.86\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"39.146\",\"id\":\"3\",\"temperature\":\"48.92\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"2\"},{\"disks\":[\"4\"],\"id\":\"3\"}],\"humidity\":\"40.151\",\"id\":\"4\",\"temperature\":\"48.50\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"41.04\",\"id\":\"5\",\"temperature\":\"48.46\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"40.64\",\"id\":\"6\",\"temperature\":\"48.65\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"0.00\"}');
/*!40000 ALTER TABLE `gui_cab` ENABLE KEYS */;
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
  `msg` varchar(1000) DEFAULT NULL COMMENT 'json原命令',
  `return_msg` varchar(1000) DEFAULT NULL COMMENT '桥接返回消息',
  `finished` smallint(1) DEFAULT '1' COMMENT '命令完成标识，1：已经完成；0：未完成；',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cmd_log`
--

LOCK TABLES `gui_cmd_log` WRITE;
/*!40000 ALTER TABLE `gui_cmd_log` DISABLE KEYS */;
INSERT INTO `gui_cmd_log` VALUES (1,0,113,'DISKINFO','START','1466220758',0,0,NULL,NULL,'{\"CMD_ID\":\"1\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\"}','{\"CMD_ID\":\"1\",\"SN\":\"Z4Y243GF\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(2,0,113,'DISKINFO','START','1466220798',0,0,NULL,NULL,'{\"CMD_ID\":\"2\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"2\"}','{\"CMD_ID\":\"2\",\"SN\":\"S4Y15A0D\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(3,0,113,'DISKINFO','START','1466220848',0,0,NULL,NULL,'{\"CMD_ID\":\"3\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"4\"}','{\"CMD_ID\":\"3\",\"SN\":\"S4Y12KCK\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(4,0,113,'DISKINFO','START','1466220898',0,0,NULL,NULL,'{\"CMD_ID\":\"4\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\"}','{\"CMD_ID\":\"4\",\"SN\":\"W4Y13CYJ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(5,0,113,'DISKINFO','START','1466220953',0,0,NULL,NULL,'{\"CMD_ID\":\"5\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"2\"}','{\"CMD_ID\":\"5\",\"SN\":\"Z4Y24P74\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(6,0,113,'DISKINFO','START','1466220978',0,0,NULL,NULL,'{\"CMD_ID\":\"6\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"3\"}','{\"CMD_ID\":\"6\",\"SN\":\"W4Y10WS2\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(7,0,113,'DISKINFO','START','1466221028',0,0,NULL,NULL,'{\"CMD_ID\":\"7\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"4\"}','{\"CMD_ID\":\"7\",\"SN\":\"W4Y13CWT\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(8,0,113,'DISKINFO','START','1466221078',0,0,NULL,NULL,'{\"CMD_ID\":\"8\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"3\",\"disk\":\"1\"}','{\"CMD_ID\":\"8\",\"SN\":\"S4Y12ZEZ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(9,0,113,'DISKINFO','START','1466221108',0,0,NULL,NULL,'{\"CMD_ID\":\"9\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"1\"}','{\"CMD_ID\":\"9\",\"SN\":\"S4Y11MJ4\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(10,0,113,'DISKINFO','START','1466221158',0,0,NULL,NULL,'{\"CMD_ID\":\"10\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"2\"}','{\"CMD_ID\":\"10\",\"SN\":\"Z4Y24BXK\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(11,0,113,'DISKINFO','START','1466221183',0,0,NULL,NULL,'{\"CMD_ID\":\"11\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"3\"}','{\"CMD_ID\":\"11\",\"SN\":\"S4Y12PJ1\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(12,0,113,'DISKINFO','START','1466221238',0,0,NULL,NULL,'{\"CMD_ID\":\"12\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"4\"}','{\"CMD_ID\":\"12\",\"SN\":\"S4Y13B8R\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(13,0,113,'DISKINFO','START','1466221288',0,0,NULL,NULL,'{\"CMD_ID\":\"13\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"1\"}','{\"CMD_ID\":\"13\",\"SN\":\"S4Y12VYV\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(14,0,113,'DISKINFO','START','1466221338',0,0,NULL,NULL,'{\"CMD_ID\":\"14\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"2\"}','{\"CMD_ID\":\"14\",\"SN\":\"W4Y13CQ8\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(15,0,113,'DISKINFO','START','1466221388',0,0,NULL,NULL,'{\"CMD_ID\":\"15\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"3\"}','{\"CMD_ID\":\"15\",\"SN\":\"S4Y12PP1\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(16,0,113,'DISKINFO','START','1466221418',0,0,NULL,NULL,'{\"CMD_ID\":\"16\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"16\",\"SN\":\"W4Y13CXS\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(17,0,113,'DISKINFO','START','1466221468',0,0,NULL,NULL,'{\"CMD_ID\":\"17\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"1\"}','{\"CMD_ID\":\"17\",\"SN\":\"S4Y15CC5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(18,0,113,'DISKINFO','START','1466221518',0,0,NULL,NULL,'{\"CMD_ID\":\"18\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"2\"}','{\"CMD_ID\":\"18\",\"SN\":\"Z4Y24H61\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(19,0,113,'DISKINFO','START','1466221543',0,0,NULL,NULL,'{\"CMD_ID\":\"19\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"3\"}','{\"CMD_ID\":\"19\",\"SN\":\"S4Y15C5K\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(20,0,113,'DISKINFO','START','1466221608',0,0,NULL,NULL,'{\"CMD_ID\":\"20\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"4\"}','{\"CMD_ID\":\"20\",\"SN\":\"W4Y11A0G\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(21,0,113,'DISKINFO','START','1466221658',0,0,NULL,NULL,'{\"CMD_ID\":\"21\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"2\",\"group\":\"1\",\"disk\":\"3\"}','{\"CMD_ID\":\"21\",\"SN\":\"5LY3PRKJ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"003E\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0000\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"74\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1),(22,0,113,'DISKINFO','START','1466221688',0,0,NULL,NULL,'{\"CMD_ID\":\"22\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"2\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"22\",\"SN\":\"Z4Y24FM5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1),(23,0,113,'DISKINFO','START','1466221718',0,0,NULL,NULL,'{\"CMD_ID\":\"23\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"3\",\"group\":\"6\",\"disk\":\"4\"}','{\"CMD_ID\":\"23\",\"SN\":\"Z4Y24G06\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1),(24,0,113,'DISKINFO','START','1466221768',0,0,NULL,NULL,'{\"CMD_ID\":\"24\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"4\",\"group\":\"2\",\"disk\":\"4\"}','{\"CMD_ID\":\"24\",\"SN\":\"W4Y13J1X\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1),(25,0,113,'DISKINFO','START','1466221823',0,0,NULL,NULL,'{\"CMD_ID\":\"25\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"4\",\"group\":\"3\",\"disk\":\"4\"}','{\"CMD_ID\":\"25\",\"SN\":\"S4Y15CLR\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1),(26,0,113,'DISKINFO','START','1466221853',0,0,NULL,NULL,'{\"CMD_ID\":\"26\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"5\",\"group\":\"4\",\"disk\":\"4\"}','{\"CMD_ID\":\"26\",\"SN\":\"S4Y15C4F\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1),(27,0,113,'DISKINFO','START','1466221908',0,0,NULL,NULL,'{\"CMD_ID\":\"27\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"5\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"27\",\"SN\":\"S4Y13AM4\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1),(28,0,113,'DISKINFO','START','1466221958',0,0,NULL,NULL,'{\"CMD_ID\":\"28\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"6\",\"group\":\"4\",\"disk\":\"4\"}','{\"CMD_ID\":\"28\",\"SN\":\"Z4Y24H4V\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"6\",\"status\":\"0\",\"substatus\":\"0\"}',1),(29,0,113,'DISKINFO','START','1466221993',0,0,NULL,NULL,'{\"CMD_ID\":\"29\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"6\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"29\",\"SN\":\"Z4Y244LC\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"6\",\"status\":\"0\",\"substatus\":\"0\"}',1),(30,0,113,'BRIDGE','START','1466223036',0,0,'62',90,'{\"CMD_ID\":\"30\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"Z4Y243GF\"},{\"id\":\"2\",\"SN\":\"S4Y15A0D\"},{\"id\":\"4\",\"SN\":\"S4Y12KCK\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"30\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"Z4Y243GF\",\"id\":\"1\"},{\"SN\":\"S4Y15A0D\",\"id\":\"2\"},{\"SN\":\"S4Y12KCK\",\"id\":\"4\"}],\"group\":\"1\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"device1_1_1_1\"},{\"id\":\"2\",\"status\":\"0\",\"value\":\"device1_1_1_2\"},{\"id\":\"4\",\"status\":\"0\",\"value\":\"device1_1_1_4\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(31,0,113,'BRIDGE','START','1466240053',0,0,'62',90,'{\"CMD_ID\":\"31\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"2\",\"group\":\"1\",\"disks\":[{\"id\":\"3\",\"SN\":\"5LY3PRKJ\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"31\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"5LY3PRKJ\",\"id\":\"3\"}],\"group\":\"1\",\"level\":\"2\",\"paths\":[{\"id\":\"3\",\"status\":\"0\",\"value\":\"device1_2_1_3\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(32,0,113,'DISKINFO','START','1466240960',0,0,NULL,NULL,'{\"CMD_ID\":\"32\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\"}','{\"CMD_ID\":\"32\",\"SN\":\"W4Y13CYJ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(33,0,113,'DISKINFO','START','1466240995',0,0,NULL,NULL,'{\"CMD_ID\":\"33\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"2\"}','{\"CMD_ID\":\"33\",\"SN\":\"Z4Y24P74\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(34,0,113,'DISKINFO','START','1466241020',0,0,NULL,NULL,'{\"CMD_ID\":\"34\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"3\"}','{\"CMD_ID\":\"34\",\"SN\":\"W4Y10WS2\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(35,0,113,'FILETREE','START','1466299739',0,0,NULL,NULL,'{\"CMD_ID\":\"35\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"2\",\"mount_path\":\"device1_1_1_2\",\"device_id\":\"1\"}','{\"CMD_ID\":\"35\",\"cmd\":\"FILETREE\",\"device_id\":\"1\",\"disk\":\"2\",\"group\":\"1\",\"level\":\"1\",\"mount_path\":\"device1_1_1_2\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(36,0,113,'FILETREE','START','1466299993',0,0,NULL,NULL,'{\"CMD_ID\":\"36\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"4\",\"mount_path\":\"device1_1_1_4\",\"device_id\":\"1\"}','{\"CMD_ID\":\"36\",\"cmd\":\"FILETREE\",\"device_id\":\"1\",\"disk\":\"4\",\"group\":\"1\",\"level\":\"1\",\"mount_path\":\"device1_1_1_4\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(37,0,113,'DISKINFO','START','1466319182',0,0,NULL,NULL,'{\"CMD_ID\":\"37\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"3\",\"device_id\":\"1\"}','{\"CMD_ID\":\"37\",\"SN\":\"W4Y10WS2\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='the storage closet';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_device`
--

LOCK TABLES `gui_device` WRITE;
/*!40000 ALTER TABLE `gui_device` DISABLE KEYS */;
INSERT INTO `gui_device` VALUES (1,1,1,1,1,1,1,1,0,NULL,'1466388066','device1_1_1_1',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"1\",\"partitions\":[{\"left\":\"963358964\",\"name\":\"C\",\"total\":\"976758780\",\"used\":\"13399816\"}],\"status\":\"0\",\"substatus\":\"0\"}',1,1),(2,1,1,1,2,2,1,1,0,NULL,'1466388066','device1_1_1_2',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"2\",\"group\":\"1\",\"level\":\"1\",\"partitions\":[{\"left\":\"32582500\",\"name\":\"C\",\"total\":\"156288320\",\"used\":\"123705820\"}],\"status\":\"0\",\"substatus\":\"0\"}',1,1),(3,1,1,1,4,3,1,1,0,NULL,'1466388066','device1_1_1_4',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"4\",\"group\":\"1\",\"level\":\"1\",\"partitions\":[{\"left\":\"971070052\",\"name\":\"C\",\"total\":\"976759804\",\"used\":\"5689752\"}],\"status\":\"0\",\"substatus\":\"0\"}',1,1),(4,1,1,2,1,4,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(5,1,1,2,2,5,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(6,1,1,2,3,6,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(7,1,1,2,4,7,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(8,1,1,3,1,8,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(9,1,1,4,1,9,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(10,1,1,4,2,10,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(11,1,1,4,3,11,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(12,1,1,4,4,12,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(13,1,1,5,1,13,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(14,1,1,5,2,14,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(15,1,1,5,3,15,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(16,1,1,5,4,16,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(17,1,1,6,1,17,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(18,1,1,6,2,18,1,0,0,NULL,'1466388066',NULL,0,0,NULL,1,1),(19,1,1,6,3,19,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(20,1,1,6,4,20,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(21,1,2,1,3,21,1,1,0,NULL,'1466388067','device1_2_1_3',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"3\",\"group\":\"1\",\"level\":\"2\",\"partitions\":[{\"left\":\"18397444\",\"name\":\"C\",\"total\":\"31458300\",\"used\":\"13060856\"},{\"left\":\"44643416\",\"name\":\"G\",\"total\":\"46690300\",\"used\":\"2046884\"}],\"status\":\"0\",\"substatus\":\"0\"}',1,1),(22,1,2,5,4,22,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(23,1,3,6,4,23,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(24,1,4,2,4,24,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(25,1,4,3,4,25,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(26,1,5,4,4,26,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(27,1,5,5,4,27,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(28,1,6,4,4,28,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1),(29,1,6,5,4,29,1,0,0,NULL,'1466388067',NULL,0,0,NULL,1,1);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk`
--

LOCK TABLES `gui_disk` WRITE;
/*!40000 ALTER TABLE `gui_disk` DISABLE KEYS */;
INSERT INTO `gui_disk` VALUES (1,'Z4Y243GF',NULL,NULL,NULL,931),(2,'S4Y15A0D',NULL,NULL,NULL,931),(3,'S4Y12KCK',NULL,NULL,NULL,931),(4,'W4Y13CYJ',NULL,NULL,NULL,931),(5,'Z4Y24P74',NULL,NULL,NULL,931),(6,'W4Y10WS2',NULL,NULL,NULL,931),(7,'W4Y13CWT',NULL,NULL,NULL,931),(8,'S4Y12ZEZ',NULL,NULL,NULL,931),(9,'S4Y11MJ4',NULL,NULL,NULL,931),(10,'Z4Y24BXK',NULL,NULL,NULL,931),(11,'S4Y12PJ1',NULL,NULL,NULL,931),(12,'S4Y13B8R',NULL,NULL,NULL,931),(13,'S4Y12VYV',NULL,NULL,NULL,931),(14,'W4Y13CQ8',NULL,NULL,NULL,931),(15,'S4Y12PP1',NULL,NULL,NULL,931),(16,'W4Y13CXS',NULL,NULL,NULL,931),(17,'S4Y15CC5',NULL,NULL,NULL,931),(18,'Z4Y24H61',NULL,NULL,NULL,931),(19,'S4Y15C5K',NULL,NULL,NULL,931),(20,'W4Y11A0G',NULL,NULL,NULL,931),(21,'5LY3PRKJ',NULL,NULL,NULL,74),(22,'Z4Y24FM5',NULL,NULL,NULL,931),(23,'Z4Y24G06',NULL,NULL,NULL,931),(24,'W4Y13J1X',NULL,NULL,NULL,931),(25,'S4Y15CLR',NULL,NULL,NULL,931),(26,'S4Y15C4F',NULL,NULL,NULL,931),(27,'S4Y13AM4',NULL,NULL,NULL,931),(28,'Z4Y24H4V',NULL,NULL,NULL,931),(29,'Z4Y244LC',NULL,NULL,NULL,931);
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
  `disk_id` smallint(5) NOT NULL,
  `md5` varchar(300) DEFAULT NULL,
  `c5` int(5) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `file_content` varchar(200) DEFAULT NULL COMMENT '内容变化',
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
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8 COMMENT='smart value';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk_smart`
--

LOCK TABLES `gui_disk_smart` WRITE;
/*!40000 ALTER TABLE `gui_disk_smart` DISABLE KEYS */;
INSERT INTO `gui_disk_smart` VALUES (1,1,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(2,1,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(3,1,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(4,2,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(5,2,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(6,2,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(7,3,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(8,3,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(9,3,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(10,4,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(11,4,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(12,4,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(13,5,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(14,5,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(15,5,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(16,6,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(17,6,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(18,6,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(19,7,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(20,7,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(21,7,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(22,8,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(23,8,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(24,8,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(25,9,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(26,9,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(27,9,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(28,10,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(29,10,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(30,10,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(31,11,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(32,11,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(33,11,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(34,12,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(35,12,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(36,12,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(37,13,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(38,13,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(39,13,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(40,14,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(41,14,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(42,14,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(43,15,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(44,15,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(45,15,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(46,16,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(47,16,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(48,16,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(49,17,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(50,17,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(51,17,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(52,18,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(53,18,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(54,18,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(55,19,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(56,19,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(57,19,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(58,20,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(59,20,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(60,20,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(61,21,'05',NULL,NULL,'00000000','0000','0033','24','64','64',1),(62,21,'C5',NULL,NULL,'00000000','0000','003E','00','64','64',1),(63,21,'C6',NULL,NULL,'00000000','0000','0000','00','64','64',1),(64,22,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(65,22,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(66,22,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(67,23,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(68,23,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(69,23,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(70,24,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(71,24,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(72,24,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(73,25,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(74,25,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(75,25,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(76,26,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(77,26,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(78,26,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(79,27,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(80,27,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(81,27,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(82,28,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(83,28,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(84,28,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1),(85,29,'05',NULL,NULL,'00000000','0000','0033','0A','64','64',1),(86,29,'C5',NULL,NULL,'00000000','0000','0012','00','64','64',1),(87,29,'C6',NULL,NULL,'00000000','0000','0010','00','64','64',1);
/*!40000 ALTER TABLE `gui_disk_smart` ENABLE KEYS */;
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
INSERT INTO `gui_restart_time` VALUES (1,1466220590);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_super`
--

LOCK TABLES `gui_super` WRITE;
/*!40000 ALTER TABLE `gui_super` DISABLE KEYS */;
INSERT INTO `gui_super` VALUES (2,'565431c2ff46fff5c450c20276785963','administrator');
/*!40000 ALTER TABLE `gui_super` ENABLE KEYS */;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_user`
--

LOCK TABLES `gui_user` WRITE;
/*!40000 ALTER TABLE `gui_user` DISABLE KEYS */;
INSERT INTO `gui_user` VALUES (113,'admin','0192023a7bbd73250516f069df18b500',NULL,NULL,NULL,NULL,1,1466220442,'119.57.116.127',1466322234,1),(114,'link','c4ca4238a0b923820dcc509a6f75849b',NULL,NULL,NULL,NULL,1,1466388473,'111.202.103.202',1466388488,1);
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

-- Dump completed on 2016-06-20 10:09:32
