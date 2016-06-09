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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cab`
--

LOCK TABLES `gui_cab` WRITE;
/*!40000 ALTER TABLE `gui_cab` DISABLE KEYS */;
INSERT INTO `gui_cab` VALUES (3,'1',NULL,6,6,4,1,0,'0.00','0.00','0','{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.00\",\"device_id\":\"1\",\"electricity\":\"0\",\"levels\":[{\"groups\":[{\"disks\":[\"1\",\"2\",\"4\"],\"id\":\"1\"},{\"disks\":[\"2\",\"3\",\"4\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"4\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"5\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"6\"}],\"humidity\":\"50.134\",\"id\":\"1\",\"temperature\":\"51.11\"},{\"groups\":[{\"disks\":[\"3\"],\"id\":\"1\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"54.85\",\"id\":\"2\",\"temperature\":\"49.63\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"53.102\",\"id\":\"3\",\"temperature\":\"49.51\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"2\"},{\"disks\":[\"4\"],\"id\":\"3\"}],\"humidity\":\"53.152\",\"id\":\"4\",\"temperature\":\"49.56\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"54.41\",\"id\":\"5\",\"temperature\":\"49.51\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"53.115\",\"id\":\"6\",\"temperature\":\"49.53\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"0.00\"}'),(4,'2',NULL,6,6,4,1,0,'0.00','0.00','0','{\"CMD_ID\":\"0\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.00\",\"device_id\":\"2\",\"electricity\":\"0\",\"levels\":[{\"groups\":[{\"disks\":[\"1\"],\"id\":\"1\"},{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"51.131\",\"id\":\"1\",\"temperature\":\"50.82\"},{\"groups\":[{\"disks\":[\"1\",\"4\"],\"id\":\"1\"},{\"disks\":[\"1\"],\"id\":\"6\"}],\"humidity\":\"53.114\",\"id\":\"2\",\"temperature\":\"49.80\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\"],\"id\":\"4\"}],\"humidity\":\"53.133\",\"id\":\"3\",\"temperature\":\"49.71\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"1\"},{\"disks\":[\"4\"],\"id\":\"2\"}],\"humidity\":\"54.83\",\"id\":\"4\",\"temperature\":\"49.47\"},{\"groups\":[{\"disks\":[\"1\"],\"id\":\"3\"}],\"humidity\":\"55.67\",\"id\":\"5\",\"temperature\":\"49.39\"},{\"groups\":[{\"disks\":[\"1\",\"4\"],\"id\":\"6\"}],\"humidity\":\"54.81\",\"id\":\"6\",\"temperature\":\"49.22\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"0.00\"}');
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
) ENGINE=InnoDB AUTO_INCREMENT=528 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_cmd_log`
--

LOCK TABLES `gui_cmd_log` WRITE;
/*!40000 ALTER TABLE `gui_cmd_log` DISABLE KEYS */;
INSERT INTO `gui_cmd_log` VALUES (445,0,0,'DEVICEINFO','START','1465349790',0,0,NULL,NULL,'{\"CMD_ID\":\"445\",\"cmd\":\"DEVICEINFO\"}','{\"CMD_ID\":\"445\",\"cabinets\":[{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"1\",\"level_cnt\":\"6\"},{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"2\",\"level_cnt\":\"6\"}],\"cmd\":\"DEVICEINFO\",\"status\":\"0\",\"substatus\":\"0\"}',1),(446,0,109,'DEVICESTATUS','START','1465350061',0,0,NULL,NULL,'{\"CMD_ID\":\"446\",\"cmd\":\"DEVICESTATUS\",\"device_id\":\"1\"}','{\"CMD_ID\":\"446\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.00\",\"device_id\":\"1\",\"electricity\":\"0\",\"levels\":[{\"groups\":[{\"disks\":[\"1\",\"2\",\"4\"],\"id\":\"1\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"4\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"5\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"6\"}],\"humidity\":\"54.114\",\"id\":\"1\",\"temperature\":\"50.71\"},{\"groups\":[{\"disks\":[\"3\"],\"id\":\"1\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"64.72\",\"id\":\"2\",\"temperature\":\"49.35\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"57.64\",\"id\":\"3\",\"temperature\":\"49.28\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"2\"},{\"disks\":[\"4\"],\"id\":\"3\"}],\"humidity\":\"57.114\",\"id\":\"4\",\"temperature\":\"49.32\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"64.64\",\"id\":\"5\",\"temperature\":\"49.20\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"57.113\",\"id\":\"6\",\"temperature\":\"49.21\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"0.00\"}',1),(447,0,109,'DEVICESTATUS','START','1465350189',0,0,NULL,NULL,'{\"CMD_ID\":\"447\",\"cmd\":\"DEVICESTATUS\",\"device_id\":\"1\"}','{\"CMD_ID\":\"447\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.00\",\"device_id\":\"1\",\"electricity\":\"0\",\"levels\":[{\"groups\":[{\"disks\":[\"1\",\"2\",\"4\"],\"id\":\"1\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"4\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"5\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"6\"}],\"humidity\":\"54.89\",\"id\":\"1\",\"temperature\":\"50.77\"},{\"groups\":[{\"disks\":[\"3\"],\"id\":\"1\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"64.85\",\"id\":\"2\",\"temperature\":\"49.32\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"57.64\",\"id\":\"3\",\"temperature\":\"49.28\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"2\"},{\"disks\":[\"4\"],\"id\":\"3\"}],\"humidity\":\"57.121\",\"id\":\"4\",\"temperature\":\"49.32\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"64.51\",\"id\":\"5\",\"temperature\":\"49.22\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"57.113\",\"id\":\"6\",\"temperature\":\"49.20\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"0.00\"}',1),(448,0,109,'DEVICESTATUS','START','1465350406',40,0,NULL,NULL,'{\"CMD_ID\":\"448\",\"cmd\":\"DEVICESTATUS\",\"device_id\":\"2\"}',NULL,1),(449,0,110,'DISKINFO','START','1465351338',0,0,NULL,NULL,'{\"CMD_ID\":\"449\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"1\"}','{\"CMD_ID\":\"449\",\"SN\":\"Z4Y243GF\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(450,0,110,'BRIDGE','START','1465351645',0,0,'62',90,'{\"CMD_ID\":\"450\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"Z4Y243GF\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"450\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"Z4Y243GF\",\"id\":\"1\"}],\"group\":\"1\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"device1_1_1_1\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(451,0,109,'DISKINFO','START','1465366292',0,0,NULL,NULL,'{\"CMD_ID\":\"451\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\",\"device_id\":\"1\"}','{\"CMD_ID\":\"451\",\"SN\":\"W4Y13CYJ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(452,0,109,'DISKINFO','START','1465368280',0,0,NULL,NULL,'{\"CMD_ID\":\"452\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"device_id\":\"2\"}','{\"CMD_ID\":\"452\",\"SN\":\"5SZ0QZW7\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0300\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(453,0,109,'DEVICEINFO','START','1465368320',0,0,NULL,NULL,'{\"CMD_ID\":\"453\",\"cmd\":\"DEVICEINFO\"}','{\"CMD_ID\":\"453\",\"cabinets\":[{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"1\",\"level_cnt\":\"6\"},{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"2\",\"level_cnt\":\"6\"}],\"cmd\":\"DEVICEINFO\",\"status\":\"0\",\"substatus\":\"0\"}',1),(454,0,109,'DISKINFO','START','1465368355',25,0,NULL,NULL,'{\"CMD_ID\":\"454\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"2\"}',NULL,1),(455,0,109,'DISKINFO','START','1465368360',25,0,NULL,NULL,'{\"CMD_ID\":\"455\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"4\"}',NULL,1),(456,0,109,'DISKINFO','START','1465368365',0,0,NULL,NULL,'{\"CMD_ID\":\"456\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\"}','{\"CMD_ID\":\"456\",\"SN\":\"W4Y13CYJ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(457,0,109,'DISKINFO','START','1465368435',0,0,NULL,NULL,'{\"CMD_ID\":\"457\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"2\"}','{\"CMD_ID\":\"457\",\"SN\":\"Z4Y24P74\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(458,0,109,'DISKINFO','START','1465368485',0,0,NULL,NULL,'{\"CMD_ID\":\"458\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"3\"}','{\"CMD_ID\":\"458\",\"SN\":\"W4Y10WS2\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(459,0,109,'DEVICESTATUS','START','1465368509',40,0,NULL,NULL,'{\"CMD_ID\":\"459\",\"cmd\":\"DEVICESTATUS\",\"device_id\":\"2\"}',NULL,1),(460,0,109,'DISKINFO','START','1465369769',0,0,NULL,NULL,'{\"CMD_ID\":\"460\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\"}','{\"CMD_ID\":\"460\",\"SN\":\"5SZ0QZW7\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0300\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"298\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(461,0,109,'DISKINFO','START','1465369829',0,0,NULL,NULL,'{\"CMD_ID\":\"461\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"4\"}','{\"CMD_ID\":\"461\",\"SN\":\"S4Z0ANA5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(462,0,109,'DISKINFO','START','1465369889',0,0,NULL,NULL,'{\"CMD_ID\":\"462\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"2\",\"group\":\"1\",\"disk\":\"1\"}','{\"CMD_ID\":\"462\",\"SN\":\"PFDB30K2CPQSRB\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"05\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0022\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0008\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"76\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1),(463,0,109,'DISKINFO','START','1465369959',0,0,NULL,NULL,'{\"CMD_ID\":\"463\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"2\",\"group\":\"1\",\"disk\":\"4\"}','{\"CMD_ID\":\"463\",\"SN\":\"W4Z093KQ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1),(464,0,109,'DISKINFO','START','1465370009',0,0,NULL,NULL,'{\"CMD_ID\":\"464\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"2\",\"group\":\"6\",\"disk\":\"1\"}','{\"CMD_ID\":\"464\",\"SN\":\"S4Z0AGE3\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1),(465,0,109,'DISKINFO','START','1465370074',0,0,NULL,NULL,'{\"CMD_ID\":\"465\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"3\",\"group\":\"3\",\"disk\":\"1\"}','{\"CMD_ID\":\"465\",\"SN\":\"S4Z0B7W3\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1),(466,0,109,'DISKINFO','START','1465370139',0,0,NULL,NULL,'{\"CMD_ID\":\"466\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"3\",\"group\":\"4\",\"disk\":\"1\"}','{\"CMD_ID\":\"466\",\"SN\":\"S4Z0AEE6\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1),(467,0,109,'DISKINFO','START','1465370189',0,0,NULL,NULL,'{\"CMD_ID\":\"467\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"4\",\"group\":\"1\",\"disk\":\"4\"}','{\"CMD_ID\":\"467\",\"SN\":\"S4Z0A7TR\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1),(468,0,109,'DISKINFO','START','1465370269',0,0,NULL,NULL,'{\"CMD_ID\":\"468\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"4\",\"group\":\"2\",\"disk\":\"4\"}','{\"CMD_ID\":\"468\",\"SN\":\"S4Z0AEL0\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1),(469,0,109,'DISKINFO','START','1465370314',0,0,NULL,NULL,'{\"CMD_ID\":\"469\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"5\",\"group\":\"3\",\"disk\":\"1\"}','{\"CMD_ID\":\"469\",\"SN\":\"S4Z0A7W5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1),(470,0,109,'DISKINFO','START','1465370374',0,0,NULL,NULL,'{\"CMD_ID\":\"470\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"6\",\"group\":\"6\",\"disk\":\"1\"}','{\"CMD_ID\":\"470\",\"SN\":\"S4Z09A2J\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"6\",\"status\":\"0\",\"substatus\":\"0\"}',1),(471,0,109,'DISKINFO','START','1465370454',0,0,NULL,NULL,'{\"CMD_ID\":\"471\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"level\":\"6\",\"group\":\"6\",\"disk\":\"4\"}','{\"CMD_ID\":\"471\",\"SN\":\"S4Z0B877\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"1863\",\"cmd\":\"DISKINFO\",\"device_id\":\"2\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"6\",\"status\":\"0\",\"substatus\":\"0\"}',1),(472,0,109,'DISKINFO','START','1465370567',25,0,NULL,NULL,'{\"CMD_ID\":\"472\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"2\"}',NULL,1),(473,0,109,'DISKINFO','START','1465370572',25,0,NULL,NULL,'{\"CMD_ID\":\"473\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"4\"}',NULL,1),(474,0,109,'DISKINFO','START','1465370577',0,0,NULL,NULL,'{\"CMD_ID\":\"474\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"1\"}','{\"CMD_ID\":\"474\",\"SN\":\"W4Y13CYJ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(475,0,109,'DISKINFO','START','1465370627',0,0,NULL,NULL,'{\"CMD_ID\":\"475\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"2\"}','{\"CMD_ID\":\"475\",\"SN\":\"Z4Y24P74\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(476,0,109,'DISKINFO','START','1465370667',0,0,NULL,NULL,'{\"CMD_ID\":\"476\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"3\"}','{\"CMD_ID\":\"476\",\"SN\":\"W4Y10WS2\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(477,0,109,'DISKINFO','START','1465370727',0,0,NULL,NULL,'{\"CMD_ID\":\"477\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"4\"}','{\"CMD_ID\":\"477\",\"SN\":\"W4Y13CWT\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(478,0,109,'DISKINFO','START','1465370817',0,0,NULL,NULL,'{\"CMD_ID\":\"478\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"3\",\"disk\":\"1\"}','{\"CMD_ID\":\"478\",\"SN\":\"S4Y12ZEZ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(479,0,109,'DISKINFO','START','1465370872',0,0,NULL,NULL,'{\"CMD_ID\":\"479\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"1\"}','{\"CMD_ID\":\"479\",\"SN\":\"S4Y11MJ4\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(480,0,109,'DISKINFO','START','1465370907',0,0,NULL,NULL,'{\"CMD_ID\":\"480\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"2\"}','{\"CMD_ID\":\"480\",\"SN\":\"Z4Y24BXK\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(481,0,109,'DISKINFO','START','1465370992',0,0,NULL,NULL,'{\"CMD_ID\":\"481\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"3\"}','{\"CMD_ID\":\"481\",\"SN\":\"S4Y12PJ1\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(482,0,109,'DISKINFO','START','1465371027',0,0,NULL,NULL,'{\"CMD_ID\":\"482\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"4\"}','{\"CMD_ID\":\"482\",\"SN\":\"S4Y13B8R\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(483,0,109,'DISKINFO','START','1465371092',0,0,NULL,NULL,'{\"CMD_ID\":\"483\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"1\"}','{\"CMD_ID\":\"483\",\"SN\":\"S4Y12VYV\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(484,0,109,'DISKINFO','START','1465371167',0,0,NULL,NULL,'{\"CMD_ID\":\"484\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"2\"}','{\"CMD_ID\":\"484\",\"SN\":\"W4Y13CQ8\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(485,0,109,'DISKINFO','START','1465371212',0,0,NULL,NULL,'{\"CMD_ID\":\"485\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"3\"}','{\"CMD_ID\":\"485\",\"SN\":\"S4Y12PP1\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(486,0,109,'DISKINFO','START','1465371267',0,0,NULL,NULL,'{\"CMD_ID\":\"486\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"486\",\"SN\":\"W4Y13CXS\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(487,0,109,'DISKINFO','START','1465371342',0,0,NULL,NULL,'{\"CMD_ID\":\"487\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"1\"}','{\"CMD_ID\":\"487\",\"SN\":\"S4Y15CC5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"1\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(488,0,109,'DISKINFO','START','1465371392',0,0,NULL,NULL,'{\"CMD_ID\":\"488\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"2\"}','{\"CMD_ID\":\"488\",\"SN\":\"Z4Y24H61\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(489,0,109,'DISKINFO','START','1465371432',0,0,NULL,NULL,'{\"CMD_ID\":\"489\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"3\"}','{\"CMD_ID\":\"489\",\"SN\":\"S4Y15C5K\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(490,0,109,'DISKINFO','START','1465371537',0,0,NULL,NULL,'{\"CMD_ID\":\"490\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"1\",\"group\":\"6\",\"disk\":\"4\"}','{\"CMD_ID\":\"490\",\"SN\":\"W4Y11A0G\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(491,0,109,'DISKINFO','START','1465371587',0,0,NULL,NULL,'{\"CMD_ID\":\"491\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"2\",\"group\":\"1\",\"disk\":\"3\"}','{\"CMD_ID\":\"491\",\"SN\":\"5LY3PRKJ\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"24\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"003E\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0000\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"74\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"3\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1),(492,0,109,'DISKINFO','START','1465371627',0,0,NULL,NULL,'{\"CMD_ID\":\"492\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"2\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"492\",\"SN\":\"Z4Y24FM5\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"2\",\"status\":\"0\",\"substatus\":\"0\"}',1),(493,0,110,'WRITEPROTECT','STOP','1465371677',0,0,NULL,NULL,'{\"CMD_ID\":\"493\",\"cmd\":\"WRITEPROTECT\",\"subcmd\":\"STOP\",\"level\":\"1\",\"device_id\":\"1\"}',NULL,1),(494,0,109,'DISKINFO','START','1465371717',0,0,NULL,NULL,'{\"CMD_ID\":\"494\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"3\",\"group\":\"6\",\"disk\":\"4\"}','{\"CMD_ID\":\"494\",\"SN\":\"Z4Y24G06\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"6\",\"level\":\"3\",\"status\":\"0\",\"substatus\":\"0\"}',1),(495,0,109,'DISKINFO','START','1465371757',0,0,NULL,NULL,'{\"CMD_ID\":\"495\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"4\",\"group\":\"2\",\"disk\":\"4\"}','{\"CMD_ID\":\"495\",\"SN\":\"W4Y13J1X\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"2\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1),(496,0,109,'DISKINFO','START','1465371822',0,0,NULL,NULL,'{\"CMD_ID\":\"496\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"4\",\"group\":\"3\",\"disk\":\"4\"}','{\"CMD_ID\":\"496\",\"SN\":\"S4Y15CLR\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"3\",\"level\":\"4\",\"status\":\"0\",\"substatus\":\"0\"}',1),(497,0,109,'DISKINFO','START','1465371867',0,0,NULL,NULL,'{\"CMD_ID\":\"497\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"5\",\"group\":\"4\",\"disk\":\"4\"}','{\"CMD_ID\":\"497\",\"SN\":\"S4Y15C4F\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1),(498,0,109,'DISKINFO','START','1465371932',0,0,NULL,NULL,'{\"CMD_ID\":\"498\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"5\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"498\",\"SN\":\"S4Y13AM4\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"5\",\"status\":\"0\",\"substatus\":\"0\"}',1),(499,0,109,'DISKINFO','START','1465371987',0,0,NULL,NULL,'{\"CMD_ID\":\"499\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"6\",\"group\":\"4\",\"disk\":\"4\"}','{\"CMD_ID\":\"499\",\"SN\":\"Z4Y24H4V\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"4\",\"level\":\"6\",\"status\":\"0\",\"substatus\":\"0\"}',1),(500,0,109,'DISKINFO','START','1465372077',0,0,NULL,NULL,'{\"CMD_ID\":\"500\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"level\":\"6\",\"group\":\"5\",\"disk\":\"4\"}','{\"CMD_ID\":\"500\",\"SN\":\"Z4Y244LC\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"5\",\"level\":\"6\",\"status\":\"0\",\"substatus\":\"0\"}',1),(501,0,109,'BRIDGE','START','1465373118',0,0,'62',90,'{\"CMD_ID\":\"501\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"2\",\"group\":\"1\",\"disks\":[{\"id\":\"3\",\"SN\":\"5LY3PRKJ\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"501\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"5LY3PRKJ\",\"id\":\"3\"}],\"group\":\"1\",\"level\":\"2\",\"paths\":[{\"id\":\"3\",\"status\":\"0\",\"value\":\"device1_2_1_3\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(502,0,109,'BRIDGE','START','1465373142',0,0,'62',90,'{\"CMD_ID\":\"502\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"5SZ0QZW7\"}],\"device_id\":\"2\"}','{\"CMD_ID\":\"502\",\"cmd\":\"BRIDGE\",\"device_id\":\"2\",\"disks\":[{\"SN\":\"5SZ0QZW7\",\"id\":\"1\"}],\"group\":\"1\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"device2_1_1_1\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(503,0,109,'BRIDGE','START','1465373183',0,0,'62',90,'{\"CMD_ID\":\"503\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"2\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"PFDB30K2CPQSRB\"},{\"id\":\"4\",\"SN\":\"W4Z093KQ\"}],\"device_id\":\"2\"}','{\"CMD_ID\":\"503\",\"cmd\":\"BRIDGE\",\"device_id\":\"2\",\"disks\":[{\"SN\":\"PFDB30K2CPQSRB\",\"id\":\"1\"},{\"SN\":\"W4Z093KQ\",\"id\":\"4\"}],\"group\":\"1\",\"level\":\"2\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"device2_2_1_1\"},{\"id\":\"4\",\"status\":\"0\",\"value\":\"device2_2_1_4\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(504,0,109,'BRIDGE','STOP','1465373348',0,0,NULL,NULL,'{\"CMD_ID\":\"504\",\"cmd\":\"BRIDGE\",\"subcmd\":\"STOP\",\"level\":\"2\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"PFDB30K2CPQSRB\"},{\"id\":\"4\",\"SN\":\"W4Z093KQ\"}],\"device_id\":\"2\"}','{\"CMD_ID\":\"504\",\"cmd\":\"BRIDGE\",\"device_id\":\"2\",\"disks\":[{\"SN\":\"PFDB30K2CPQSRB\",\"id\":\"1\"},{\"SN\":\"W4Z093KQ\",\"id\":\"4\"}],\"group\":\"1\",\"level\":\"2\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"�\"},{\"id\":\"4\",\"status\":\"0\",\"value\":\"\"}],\"status\":\"0\",\"subcmd\":\"STOP\",\"substatus\":\"0\"}',1),(505,0,109,'MD5','START','1465373445',-2,0,NULL,62.02,'{\"CMD_ID\":\"505\",\"cmd\":\"MD5\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"2\",\"disk\":\"2\",\"device_id\":\"1\"}','{\"CMD_ID\":\"505\",\"cmd\":\"MD5\",\"device_id\":\"1\",\"disk\":\"2\",\"group\":\"2\",\"level\":\"1\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(506,0,109,'MD5','START','1465373459',-2,0,NULL,61.58,'{\"CMD_ID\":\"506\",\"cmd\":\"MD5\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"4\",\"disk\":\"2\",\"device_id\":\"1\"}','{\"CMD_ID\":\"506\",\"cmd\":\"MD5\",\"device_id\":\"1\",\"disk\":\"2\",\"group\":\"4\",\"level\":\"1\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(507,0,109,'BRIDGE','START','1465373618',30,0,'55',40,'{\"CMD_ID\":\"507\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"6\",\"group\":\"6\",\"disks\":[{\"id\":\"1\",\"SN\":\"S4Z09A2J\"},{\"id\":\"4\",\"SN\":\"S4Z0B877\"}],\"device_id\":\"2\"}','{\"CMD_ID\":\"507\",\"cmd\":\"BRIDGE\",\"device_id\":\"2\",\"disks\":[{\"SN\":\"\",\"id\":\"1\"},{\"SN\":\"\",\"id\":\"4\"}],\"errmsg\":\"physical error\",\"group\":\"6\",\"level\":\"6\",\"paths\":[{\"errno\":\"30\",\"id\":\"1\",\"status\":\"30\"},{\"errno\":\"30\",\"id\":\"4\",\"status\":\"30\"}],\"status\":\"30\",\"subcmd\":\"START\"}',1),(508,0,109,'FILETREE','START','1465373695',0,0,NULL,NULL,'{\"CMD_ID\":\"508\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"mount_path\":\"device1_1_1_1\",\"device_id\":\"1\"}','{\"CMD_ID\":\"508\",\"cmd\":\"FILETREE\",\"device_id\":\"1\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"1\",\"mount_path\":\"device1_1_1_1\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(509,0,109,'DEVICESTATUS','START','1465373942',0,0,NULL,NULL,'{\"CMD_ID\":\"509\",\"cmd\":\"DEVICESTATUS\",\"device_id\":\"1\"}','{\"CMD_ID\":\"509\",\"cmd\":\"DEVICESTATUS\",\"current\":\"0.00\",\"device_id\":\"1\",\"electricity\":\"0\",\"levels\":[{\"groups\":[{\"disks\":[\"1\",\"2\",\"4\"],\"id\":\"1\"},{\"disks\":[\"2\",\"3\",\"4\"],\"id\":\"2\"},{\"disks\":[\"1\"],\"id\":\"3\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"4\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"5\"},{\"disks\":[\"1\",\"2\",\"3\",\"4\"],\"id\":\"6\"}],\"humidity\":\"24.57\",\"id\":\"1\",\"temperature\":\"55.93\"},{\"groups\":[{\"disks\":[\"3\"],\"id\":\"1\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"35.153\",\"id\":\"2\",\"temperature\":\"52.20\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"6\"}],\"humidity\":\"39.152\",\"id\":\"3\",\"temperature\":\"48.33\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"2\"},{\"disks\":[\"4\"],\"id\":\"3\"}],\"humidity\":\"40.56\",\"id\":\"4\",\"temperature\":\"48.29\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"40.89\",\"id\":\"5\",\"temperature\":\"48.22\"},{\"groups\":[{\"disks\":[\"4\"],\"id\":\"4\"},{\"disks\":[\"4\"],\"id\":\"5\"}],\"humidity\":\"40.17\",\"id\":\"6\",\"temperature\":\"48.20\"}],\"status\":\"0\",\"substatus\":\"0\",\"voltage\":\"0.00\"}',1),(510,0,109,'BRIDGE','START','1465376043',30,0,'55',40,'{\"CMD_ID\":\"510\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"6\",\"group\":\"6\",\"disks\":[{\"id\":\"1\",\"SN\":\"S4Z09A2J\"},{\"id\":\"4\",\"SN\":\"S4Z0B877\"}],\"device_id\":\"2\"}','{\"CMD_ID\":\"510\",\"cmd\":\"BRIDGE\",\"device_id\":\"2\",\"disks\":[{\"SN\":\"\",\"id\":\"1\"},{\"SN\":\"\",\"id\":\"4\"}],\"errmsg\":\"physical error\",\"group\":\"6\",\"level\":\"6\",\"paths\":[{\"errno\":\"30\",\"id\":\"1\",\"status\":\"30\"},{\"errno\":\"30\",\"id\":\"4\",\"status\":\"30\"}],\"status\":\"30\",\"subcmd\":\"START\"}',1),(511,0,109,'FILETREE','START','1465376130',0,0,NULL,NULL,'{\"CMD_ID\":\"511\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"mount_path\":\"device1_1_1_1\",\"device_id\":\"1\"}','{\"CMD_ID\":\"511\",\"cmd\":\"FILETREE\",\"device_id\":\"1\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"1\",\"mount_path\":\"device1_1_1_1\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(512,0,109,'FILETREE','START','1465376138',0,0,NULL,NULL,'{\"CMD_ID\":\"512\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"2\",\"group\":\"1\",\"disk\":\"3\",\"mount_path\":\"device1_2_1_3\",\"device_id\":\"1\"}','{\"CMD_ID\":\"512\",\"cmd\":\"FILETREE\",\"device_id\":\"1\",\"disk\":\"3\",\"group\":\"1\",\"level\":\"2\",\"mount_path\":\"device1_2_1_3\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(513,0,109,'BRIDGE','STOP','1465376162',0,0,NULL,NULL,'{\"CMD_ID\":\"513\",\"cmd\":\"BRIDGE\",\"subcmd\":\"STOP\",\"level\":\"1\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"Z4Y243GF\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"513\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"Z4Y243GF\",\"id\":\"1\"}],\"group\":\"1\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"�\"}],\"status\":\"0\",\"subcmd\":\"STOP\",\"substatus\":\"0\"}',1),(514,0,109,'BRIDGE','STOP','1465376168',0,0,NULL,NULL,'{\"CMD_ID\":\"514\",\"cmd\":\"BRIDGE\",\"subcmd\":\"STOP\",\"level\":\"2\",\"group\":\"1\",\"disks\":[{\"id\":\"3\",\"SN\":\"5LY3PRKJ\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"514\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"5LY3PRKJ\",\"id\":\"3\"}],\"group\":\"1\",\"level\":\"2\",\"paths\":[{\"id\":\"3\",\"status\":\"0\",\"value\":\"�\"}],\"status\":\"0\",\"subcmd\":\"STOP\",\"substatus\":\"0\"}',1),(515,0,109,'BRIDGE','START','1465376306',0,0,'62',90,'{\"CMD_ID\":\"515\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"6\",\"disks\":[{\"id\":\"1\",\"SN\":\"S4Y15CC5\"},{\"id\":\"2\",\"SN\":\"Z4Y24H61\"},{\"id\":\"3\",\"SN\":\"S4Y15C5K\"},{\"id\":\"4\",\"SN\":\"W4Y11A0G\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"515\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"S4Y15CC5\",\"id\":\"1\"},{\"SN\":\"Z4Y24H61\",\"id\":\"2\"},{\"SN\":\"S4Y15C5K\",\"id\":\"3\"},{\"SN\":\"W4Y11A0G\",\"id\":\"4\"}],\"group\":\"6\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"device1_1_6_1\"},{\"id\":\"2\",\"status\":\"0\",\"value\":\"device1_1_6_2\"},{\"id\":\"3\",\"status\":\"0\",\"value\":\"device1_1_6_3\"},{\"id\":\"4\",\"status\":\"0\",\"value\":\"device1_1_6_4\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(516,0,109,'FILETREE','START','1465376346',0,0,NULL,NULL,'{\"CMD_ID\":\"516\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"1\",\"mount_path\":\"device2_1_1_1\",\"device_id\":\"2\"}','{\"CMD_ID\":\"516\",\"cmd\":\"FILETREE\",\"device_id\":\"2\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"1\",\"mount_path\":\"device2_1_1_1\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(517,0,109,'BRIDGE','START','1465376376',0,0,'62',90,'{\"CMD_ID\":\"517\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"6\",\"group\":\"6\",\"disks\":[{\"id\":\"1\",\"SN\":\"S4Z09A2J\"},{\"id\":\"4\",\"SN\":\"S4Z0B877\"}],\"device_id\":\"2\"}','{\"CMD_ID\":\"517\",\"cmd\":\"BRIDGE\",\"device_id\":\"2\",\"disks\":[{\"SN\":\"S4Z09A2J\",\"id\":\"1\"},{\"SN\":\"S4Z0B877\",\"id\":\"4\"}],\"group\":\"6\",\"level\":\"6\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"device2_6_6_1\"},{\"id\":\"4\",\"status\":\"0\",\"value\":\"device2_6_6_4\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(518,0,109,'FILETREE','START','1465376600',0,0,NULL,NULL,'{\"CMD_ID\":\"518\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"6\",\"group\":\"6\",\"disk\":\"4\",\"mount_path\":\"device2_6_6_4\",\"device_id\":\"2\"}','{\"CMD_ID\":\"518\",\"cmd\":\"FILETREE\",\"device_id\":\"2\",\"disk\":\"4\",\"group\":\"6\",\"level\":\"6\",\"mount_path\":\"device2_6_6_4\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(519,0,109,'FILETREE','START','1465376645',0,0,NULL,NULL,'{\"CMD_ID\":\"519\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"6\",\"group\":\"6\",\"disk\":\"4\",\"mount_path\":\"device2_6_6_4\",\"device_id\":\"2\"}','{\"CMD_ID\":\"519\",\"cmd\":\"FILETREE\",\"device_id\":\"2\",\"disk\":\"4\",\"group\":\"6\",\"level\":\"6\",\"mount_path\":\"device2_6_6_4\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(520,0,109,'FILETREE','START','1465376650',0,0,NULL,NULL,'{\"CMD_ID\":\"520\",\"cmd\":\"FILETREE\",\"subcmd\":\"START\",\"level\":\"6\",\"group\":\"6\",\"disk\":\"1\",\"mount_path\":\"device2_6_6_1\",\"device_id\":\"2\"}','{\"CMD_ID\":\"520\",\"cmd\":\"FILETREE\",\"device_id\":\"2\",\"disk\":\"1\",\"group\":\"6\",\"level\":\"6\",\"mount_path\":\"device2_6_6_1\",\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(521,0,109,'DEVICEINFO','START','1465376804',0,0,NULL,NULL,'{\"CMD_ID\":\"521\",\"cmd\":\"DEVICEINFO\"}','{\"CMD_ID\":\"521\",\"cabinets\":[{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"2\",\"level_cnt\":\"6\"}],\"cmd\":\"DEVICEINFO\",\"status\":\"0\",\"substatus\":\"0\"}',1),(522,0,109,'DEVICEINFO','START','1465376829',0,0,NULL,NULL,'{\"CMD_ID\":\"522\",\"cmd\":\"DEVICEINFO\"}','{\"CMD_ID\":\"522\",\"cabinets\":[{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"1\",\"level_cnt\":\"6\"},{\"disk_cnt\":\"4\",\"group_cnt\":\"6\",\"id\":\"2\",\"level_cnt\":\"6\"}],\"cmd\":\"DEVICEINFO\",\"status\":\"0\",\"substatus\":\"0\"}',1),(523,0,109,'BRIDGE','START','1465377016',30,0,NULL,NULL,'{\"CMD_ID\":\"523\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"5\",\"group\":\"5\",\"disks\":[{\"id\":\"4\",\"SN\":\"S4Y13AM4\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"523\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"\",\"id\":\"4\"}],\"errmsg\":\"physical error\",\"group\":\"5\",\"level\":\"5\",\"paths\":[{\"errno\":\"30\",\"id\":\"4\",\"status\":\"30\"}],\"status\":\"30\",\"subcmd\":\"START\"}',1),(524,0,110,'BRIDGE','START','1465396714',0,0,'62',90,'{\"CMD_ID\":\"524\",\"cmd\":\"BRIDGE\",\"subcmd\":\"START\",\"level\":\"1\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"Z4Y243GF\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"524\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"Z4Y243GF\",\"id\":\"1\"}],\"group\":\"1\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"device1_1_1_1\"}],\"status\":\"0\",\"subcmd\":\"START\",\"substatus\":\"0\"}',1),(525,0,110,'BRIDGE','STOP','1465396898',0,0,NULL,NULL,'{\"CMD_ID\":\"525\",\"cmd\":\"BRIDGE\",\"subcmd\":\"STOP\",\"level\":\"1\",\"group\":\"1\",\"disks\":[{\"id\":\"1\",\"SN\":\"Z4Y243GF\"}],\"device_id\":\"1\"}','{\"CMD_ID\":\"525\",\"cmd\":\"BRIDGE\",\"device_id\":\"1\",\"disks\":[{\"SN\":\"Z4Y243GF\",\"id\":\"1\"}],\"group\":\"1\",\"level\":\"1\",\"paths\":[{\"id\":\"1\",\"status\":\"0\",\"value\":\"�\"}],\"status\":\"0\",\"subcmd\":\"STOP\",\"substatus\":\"0\"}',1),(526,0,110,'DISKINFO','START','1465396944',0,0,NULL,NULL,'{\"CMD_ID\":\"526\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"2\",\"device_id\":\"1\"}','{\"CMD_ID\":\"526\",\"SN\":\"S4Y15A0D\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"2\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1),(527,0,110,'DISKINFO','START','1465401987',0,0,NULL,NULL,'{\"CMD_ID\":\"527\",\"cmd\":\"DISKINFO\",\"level\":\"1\",\"group\":\"1\",\"disk\":\"4\",\"device_id\":\"1\"}','{\"CMD_ID\":\"527\",\"SN\":\"S4Y12KCK\",\"SmartAttrs\":[{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0033\",\"id\":\"05\",\"thd\":\"0A\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0012\",\"id\":\"C5\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"},{\"dat\":\"00000000\",\"ex_dat\":\"0000\",\"flag\":\"0010\",\"id\":\"C6\",\"thd\":\"00\",\"val\":\"64\",\"w_val\":\"64\"}],\"capacity\":\"931\",\"cmd\":\"DISKINFO\",\"device_id\":\"1\",\"disk\":\"4\",\"disk_status\":\"0\",\"group\":\"1\",\"level\":\"1\",\"status\":\"0\",\"substatus\":\"0\"}',1);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8 COMMENT='the storage closet';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_device`
--

LOCK TABLES `gui_device` WRITE;
/*!40000 ALTER TABLE `gui_device` DISABLE KEYS */;
INSERT INTO `gui_device` VALUES (42,1,1,1,1,42,1,0,0,NULL,'1465432621','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"1\",\"partitions\":[{\"left\":\"971243840\",\"name\":\"C\",\"total\":\"976758780\",\"used\":\"5514940\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(43,1,1,1,2,81,1,0,0,NULL,'1465432621','',0,0,NULL),(44,1,1,1,4,82,1,0,0,NULL,'1465432621','',0,0,NULL),(45,1,1,2,1,43,0,0,0,NULL,'1465373979','',0,0,NULL),(46,1,1,2,2,45,1,0,0,NULL,'1465432621','',0,0,NULL),(47,1,1,2,3,46,1,0,0,NULL,'1465432621','',0,0,NULL),(48,1,1,2,4,58,1,0,0,NULL,'1465432621','',0,0,NULL),(49,1,1,3,1,59,1,0,0,NULL,'1465432621','',0,0,NULL),(50,1,1,4,1,60,1,0,0,NULL,'1465432621','',0,0,NULL),(51,1,1,4,2,61,1,0,0,NULL,'1465432621','',0,0,NULL),(52,1,1,4,3,62,1,0,0,NULL,'1465432621','',0,0,NULL),(53,1,1,4,4,63,1,0,0,NULL,'1465432621','',0,0,NULL),(54,1,1,5,1,64,1,0,0,NULL,'1465432621','',0,0,NULL),(55,1,1,5,2,65,1,0,0,NULL,'1465432621','',0,0,NULL),(56,1,1,5,3,66,1,0,0,NULL,'1465432621','',0,0,NULL),(57,1,1,5,4,67,1,0,0,NULL,'1465432621','',0,0,NULL),(58,1,1,6,1,68,1,0,0,NULL,'1465432621','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"1\",\"group\":\"6\",\"level\":\"1\",\"partitions\":[{\"left\":\"975128168\",\"name\":\"C\",\"total\":\"976759804\",\"used\":\"1631636\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(59,1,1,6,2,69,1,0,0,NULL,'1465432621','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"2\",\"group\":\"6\",\"level\":\"1\",\"partitions\":[{\"left\":\"135897964\",\"name\":\"C\",\"total\":\"156287996\",\"used\":\"20390032\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(60,1,1,6,3,70,1,0,0,NULL,'1465432621','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"3\",\"group\":\"6\",\"level\":\"1\",\"partitions\":[{\"left\":\"969002708\",\"name\":\"C\",\"total\":\"976759804\",\"used\":\"7757096\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(61,1,1,6,4,71,1,0,0,NULL,'1465432621','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"4\",\"group\":\"6\",\"level\":\"1\",\"partitions\":[{\"left\":\"132110948\",\"name\":\"C\",\"total\":\"156287996\",\"used\":\"24177048\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(62,1,2,1,3,72,1,0,0,NULL,'1465432621','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"1\",\"disk\":\"3\",\"group\":\"1\",\"level\":\"2\",\"partitions\":[{\"left\":\"18397444\",\"name\":\"C\",\"total\":\"31458300\",\"used\":\"13060856\"},{\"left\":\"44643416\",\"name\":\"G\",\"total\":\"46690300\",\"used\":\"2046884\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(63,1,2,5,4,73,1,0,0,NULL,'1465432621','',0,0,NULL),(64,1,3,6,4,74,1,0,0,NULL,'1465432621','',0,0,NULL),(65,1,4,2,4,75,1,0,0,NULL,'1465432621','',0,0,NULL),(66,1,4,3,4,76,1,0,0,NULL,'1465432621','',0,0,NULL),(67,1,5,4,4,77,1,0,0,NULL,'1465432622','',0,0,NULL),(68,1,5,5,4,78,1,0,0,NULL,'1465432622','',0,0,NULL),(69,1,6,4,4,79,1,0,0,NULL,'1465432622','',0,0,NULL),(70,1,6,5,4,80,1,0,0,NULL,'1465432622','',0,0,NULL),(71,2,1,1,1,44,1,0,0,NULL,'1465432626','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"2\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"1\",\"partitions\":[{\"left\":\"222088\",\"name\":\"C\",\"total\":\"156288320\",\"used\":\"156066232\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(72,2,1,6,4,47,1,0,0,NULL,'1465432626','',0,0,NULL),(73,2,2,1,1,48,1,0,0,NULL,'1465432626','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"2\",\"disk\":\"1\",\"group\":\"1\",\"level\":\"2\",\"partitions\":[{\"left\":\"76511512\",\"name\":\"C\",\"total\":\"80415740\",\"used\":\"3904228\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(74,2,2,1,4,49,1,0,0,NULL,'1465432626','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"2\",\"disk\":\"4\",\"group\":\"1\",\"level\":\"2\",\"partitions\":[{\"left\":\"122080352\",\"name\":\"C\",\"total\":\"156287996\",\"used\":\"34207644\"},{\"left\":\"820357956\",\"name\":\"D\",\"total\":\"820470780\",\"used\":\"112824\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(75,2,2,6,1,50,1,0,0,NULL,'1465432626','',0,0,NULL),(76,2,3,3,1,51,1,0,0,NULL,'1465432627','',0,0,NULL),(77,2,3,4,1,52,1,0,0,NULL,'1465432627','',0,0,NULL),(78,2,4,1,4,53,1,0,0,NULL,'1465432627','',0,0,NULL),(79,2,4,2,4,54,1,0,0,NULL,'1465432627','',0,0,NULL),(80,2,5,3,1,55,1,0,0,NULL,'1465432627','',0,0,NULL),(81,2,6,6,1,56,1,0,0,NULL,'1465432627','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"2\",\"disk\":\"1\",\"group\":\"6\",\"level\":\"6\",\"partitions\":[{\"left\":\"1940079180\",\"name\":\"C\",\"total\":\"1953512444\",\"used\":\"13433264\"}],\"status\":\"0\",\"substatus\":\"0\"}'),(82,2,6,6,4,57,1,0,0,NULL,'1465432627','',0,0,'{\"CMD_ID\":\"0\",\"cmd\":\"PARTSIZE\",\"device_id\":\"2\",\"disk\":\"4\",\"group\":\"6\",\"level\":\"6\",\"partitions\":[{\"left\":\"1953365036\",\"name\":\"C\",\"total\":\"1953512444\",\"used\":\"147408\"}],\"status\":\"0\",\"substatus\":\"0\"}');
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
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk`
--

LOCK TABLES `gui_disk` WRITE;
/*!40000 ALTER TABLE `gui_disk` DISABLE KEYS */;
INSERT INTO `gui_disk` VALUES (42,'Z4Y243GF',NULL,NULL,NULL,931),(43,'W4Y13CYJ',NULL,NULL,NULL,931),(44,'5SZ0QZW7',NULL,NULL,NULL,298),(45,'Z4Y24P74',NULL,NULL,NULL,931),(46,'W4Y10WS2',NULL,NULL,NULL,931),(47,'S4Z0ANA5',NULL,NULL,NULL,1863),(48,'PFDB30K2CPQSRB',NULL,NULL,NULL,76),(49,'W4Z093KQ',NULL,NULL,NULL,1863),(50,'S4Z0AGE3',NULL,NULL,NULL,1863),(51,'S4Z0B7W3',NULL,NULL,NULL,1863),(52,'S4Z0AEE6',NULL,NULL,NULL,1863),(53,'S4Z0A7TR',NULL,NULL,NULL,1863),(54,'S4Z0AEL0',NULL,NULL,NULL,1863),(55,'S4Z0A7W5',NULL,NULL,NULL,1863),(56,'S4Z09A2J',NULL,NULL,NULL,1863),(57,'S4Z0B877',NULL,NULL,NULL,1863),(58,'W4Y13CWT',NULL,NULL,NULL,931),(59,'S4Y12ZEZ',NULL,NULL,NULL,931),(60,'S4Y11MJ4',NULL,NULL,NULL,931),(61,'Z4Y24BXK',NULL,NULL,NULL,931),(62,'S4Y12PJ1',NULL,NULL,NULL,931),(63,'S4Y13B8R',NULL,NULL,NULL,931),(64,'S4Y12VYV',NULL,NULL,NULL,931),(65,'W4Y13CQ8',NULL,NULL,NULL,931),(66,'S4Y12PP1',NULL,NULL,NULL,931),(67,'W4Y13CXS',NULL,NULL,NULL,931),(68,'S4Y15CC5',NULL,NULL,NULL,931),(69,'Z4Y24H61',NULL,NULL,NULL,931),(70,'S4Y15C5K',NULL,NULL,NULL,931),(71,'W4Y11A0G',NULL,NULL,NULL,931),(72,'5LY3PRKJ',NULL,NULL,NULL,74),(73,'Z4Y24FM5',NULL,NULL,NULL,931),(74,'Z4Y24G06',NULL,NULL,NULL,931),(75,'W4Y13J1X',NULL,NULL,NULL,931),(76,'S4Y15CLR',NULL,NULL,NULL,931),(77,'S4Y15C4F',NULL,NULL,NULL,931),(78,'S4Y13AM4',NULL,NULL,NULL,931),(79,'Z4Y24H4V',NULL,NULL,NULL,931),(80,'Z4Y244LC',NULL,NULL,NULL,931),(81,'S4Y15A0D',NULL,NULL,NULL,931),(82,'S4Y12KCK',NULL,NULL,NULL,931);
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
  `normal` varchar(20) DEFAULT NULL COMMENT '安全值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='smart value';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_disk_smart`
--

LOCK TABLES `gui_disk_smart` WRITE;
/*!40000 ALTER TABLE `gui_disk_smart` DISABLE KEYS */;
INSERT INTO `gui_disk_smart` VALUES (1,81,'05',NULL,NULL,NULL),(2,81,'C5',NULL,NULL,NULL),(3,81,'C6',NULL,NULL,NULL),(4,82,'05',NULL,NULL,NULL),(5,82,'C5',NULL,NULL,NULL),(6,82,'C6',NULL,NULL,NULL);
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
INSERT INTO `gui_restart_time` VALUES (1,1465395446);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_super`
--

LOCK TABLES `gui_super` WRITE;
/*!40000 ALTER TABLE `gui_super` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gui_user`
--

LOCK TABLES `gui_user` WRITE;
/*!40000 ALTER TABLE `gui_user` DISABLE KEYS */;
INSERT INTO `gui_user` VALUES (109,'admin','0192023a7bbd73250516f069df18b500',NULL,NULL,NULL,NULL,1,1465347309,NULL,1465368256,1),(110,'link','c4ca4238a0b923820dcc509a6f75849b',NULL,NULL,NULL,NULL,1,1465349002,NULL,1465396867,1),(111,'wilson','40bea8d637cdf2c1b07fcf0630482b73',NULL,NULL,NULL,NULL,1,1465369864,NULL,NULL,0);
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

-- Dump completed on 2016-06-09  8:37:45
