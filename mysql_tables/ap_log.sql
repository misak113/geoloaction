-- Adminer 3.7.1 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = '+01:00';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `ap_log`;
CREATE TABLE `ap_log` (
  `ap_log_id` int(11) NOT NULL AUTO_INCREMENT,
  `ap_code` varchar(50) NOT NULL,
  `date_access` datetime NOT NULL,
  `role` varchar(50) NOT NULL,
  `mac_hash` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`ap_log_id`),
  UNIQUE KEY `ap_code_date_access_role_mac_hash_type` (`ap_code`,`date_access`,`role`,`mac_hash`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2014-01-25 15:09:42


ALTER TABLE `ap_log`
CHANGE `ap_code` `ap_code` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'kód ap wifi routeru' AFTER `ap_log_id`,
CHANGE `date_access` `date_access` datetime NOT NULL COMMENT 'datum pořízení logu' AFTER `ap_code`,
CHANGE `role` `role` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'Role ve které zařízení vystupuje. Zatím pouze Client' AFTER `date_access`,
CHANGE `mac_hash` `mac_hash` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'zahashovaná mac adresa zařízení' AFTER `role`,
CHANGE `type` `type` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'typ záznamu. připojen, odpojen z ap' AFTER `mac_hash`,
COMMENT=''; -- 15.572 s
