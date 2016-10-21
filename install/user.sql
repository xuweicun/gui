
DROP TABLE IF EXISTS `gui_user`;
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
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;

