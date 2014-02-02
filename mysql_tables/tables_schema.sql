
-- Adminer 3.7.1 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = '+01:00';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `ap`;
CREATE TABLE `ap` (
	`ap_id` int(11) NOT NULL AUTO_INCREMENT,
	`lounge_id` int(11) NOT NULL,
	`code` varchar(50) NOT NULL,
	`x_position` float NOT NULL COMMENT 'relativní x pozice ap v hale (vyjádření v jednotkové stupnici)',
	`y_position` float NOT NULL COMMENT 'relativní y pozice ap v hale (vyjádření v jednotkové stupnici)',
	`z_position` float DEFAULT NULL COMMENT 'relativní z pozice ap v hale (vyjádření v jednotkové stupnici)',
	`type` varchar(50) NOT NULL,
	`mac` varchar(50) NOT NULL,
	`ssid` varchar(50) NOT NULL,
	PRIMARY KEY (`ap_id`),
	UNIQUE KEY `code` (`code`),
	UNIQUE KEY `mac` (`mac`),
	KEY `lounge_id` (`lounge_id`),
	CONSTRAINT `ap_ibfk_1` FOREIGN KEY (`lounge_id`) REFERENCES `lounge` (`lounge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ap_boost`;
CREATE TABLE `ap_boost` (
	`ap_boost_id` int(11) NOT NULL AUTO_INCREMENT,
	`ap_id` int(11) NOT NULL,
	`heading` float NOT NULL COMMENT 'světová strana s upravenou sílou signálu',
	`multiplier` float NOT NULL COMMENT 'násobitel síly signálu',
	PRIMARY KEY (`ap_boost_id`),
	KEY `ap_id` (`ap_id`),
	CONSTRAINT `ap_boost_ibfk_1` FOREIGN KEY (`ap_id`) REFERENCES `ap` (`ap_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `compass_log`;
CREATE TABLE `compass_log` (
	`compass_log_id` int(11) NOT NULL AUTO_INCREMENT,
	`device_id` int(11) NOT NULL,
	`heading` float NOT NULL COMMENT 'natočení vůči severu',
	`accuracy` float NOT NULL COMMENT 'přesnost',
	`date_recorded` datetime NOT NULL,
	PRIMARY KEY (`compass_log_id`),
	KEY `device_id` (`device_id`),
	CONSTRAINT `compass_log_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `connectivity_log`;
CREATE TABLE `connectivity_log` (
	`connectivity_log_id` int(11) NOT NULL AUTO_INCREMENT,
	`device_id` int(11) NOT NULL,
	`type` varchar(50) NOT NULL,
	`value` varchar(50) NOT NULL,
	`date_recorded` date NOT NULL,
	PRIMARY KEY (`connectivity_log_id`),
	KEY `device_id` (`device_id`),
	CONSTRAINT `connectivity_log_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
	`contact_id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(50) NOT NULL,
	`phone_number` varchar(50) DEFAULT NULL,
	PRIMARY KEY (`contact_id`),
	UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `device`;
CREATE TABLE `device` (
	`device_id` int(11) NOT NULL AUTO_INCREMENT,
	`mac` varchar(50) NOT NULL,
	`mac_hash` varchar(50) NOT NULL,
	`uuid` varchar(50) NOT NULL,
	`imei` varchar(50) NOT NULL,
	`platform` varchar(50) NOT NULL,
	`model` varchar(50) NOT NULL,
	PRIMARY KEY (`device_id`),
	UNIQUE KEY `mac_hash` (`mac_hash`),
	UNIQUE KEY `uuid` (`uuid`),
	UNIQUE KEY `imei` (`imei`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `device_contact`;
CREATE TABLE `device_contact` (
	`device_id` int(11) NOT NULL,
	`contact_id` int(11) NOT NULL,
	PRIMARY KEY (`device_id`,`contact_id`),
	KEY `contact_id` (`contact_id`),
	CONSTRAINT `device_contact_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`),
	CONSTRAINT `device_contact_ibfk_2` FOREIGN KEY (`contact_id`) REFERENCES `contact` (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `device_use_contact`;
CREATE TABLE `device_use_contact` (
	`device_id` int(11) NOT NULL,
	`contact_id` int(11) NOT NULL,
	PRIMARY KEY (`device_id`,`contact_id`),
	KEY `contact_id` (`contact_id`),
	CONSTRAINT `device_use_contact_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`),
	CONSTRAINT `device_use_contact_ibfk_2` FOREIGN KEY (`contact_id`) REFERENCES `contact` (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `gps_log`;
CREATE TABLE `gps_log` (
	`gps_log_id` int(11) NOT NULL AUTO_INCREMENT,
	`device_id` int(11) NOT NULL,
	`longitude` float NOT NULL,
	`latitude` float NOT NULL,
	`altitude` float NOT NULL,
	`accuracy` float NOT NULL,
	`altitude_accuracy` float NOT NULL,
	`speed` float NOT NULL,
	`heading` float NOT NULL,
	`date_recorded` datetime NOT NULL,
	PRIMARY KEY (`gps_log_id`),
	KEY `device_id` (`device_id`),
	CONSTRAINT `gps_log_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `identity`;
CREATE TABLE `identity` (
	`identity_id` int(11) NOT NULL AUTO_INCREMENT,
	`first_name` varchar(50) NOT NULL,
	`last_name` varchar(50) NOT NULL,
	PRIMARY KEY (`identity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `identity_has_device`;
CREATE TABLE `identity_has_device` (
	`identity_id` int(11) NOT NULL,
	`device_id` int(11) NOT NULL,
	PRIMARY KEY (`identity_id`,`device_id`),
	KEY `device_id` (`device_id`),
	CONSTRAINT `identity_has_device_ibfk_1` FOREIGN KEY (`identity_id`) REFERENCES `identity` (`identity_id`),
	CONSTRAINT `identity_has_device_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
	`image_id` int(11) NOT NULL AUTO_INCREMENT,
	`file_path` varchar(255) DEFAULT NULL COMMENT 'relativní či absolutní cesta nebo uri',
	`base64` int(11) DEFAULT NULL COMMENT 'vyjádření obrázku v kódování base64',
	`width` int(11) DEFAULT NULL COMMENT 'px',
	`height` int(11) DEFAULT NULL COMMENT 'px',
	`mime_type` int(11) DEFAULT NULL,
	PRIMARY KEY (`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `lounge`;
CREATE TABLE `lounge` (
	`lounge_id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(50) DEFAULT NULL,
	`code` varchar(50) NOT NULL,
	`type` varchar(50) NOT NULL,
	`x_length` float DEFAULT NULL COMMENT 'šířka haly v metrech',
	`y_length` float DEFAULT NULL COMMENT 'délka haly v metrech',
	`z_length` float DEFAULT NULL COMMENT 'výška haly v metrech',
	`heading` float DEFAULT NULL COMMENT 'natočení haly vůči severu v radiánech',
	`latitude` float DEFAULT NULL COMMENT 'zeměpisná šířka středu haly',
	`longitude` float DEFAULT NULL COMMENT 'zeměpisná délka středu haly',
	`altitude` float DEFAULT NULL COMMENT 'zeměpisná výška středu haly',
	`aspect_ratio` float NOT NULL COMMENT 'poměr stran x/y (duplikace z x_length/y_length pokud jsou zadané)',
	`image_id` int(11) DEFAULT NULL COMMENT 'obrázek půdorysu haly',
	`floor` int(11) DEFAULT NULL COMMENT 'patro haly v budově',
	PRIMARY KEY (`lounge_id`),
	UNIQUE KEY `code` (`code`),
	KEY `image_id` (`image_id`),
	CONSTRAINT `lounge_ibfk_1` FOREIGN KEY (`image_id`) REFERENCES `image` (`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `wifi_log`;
CREATE TABLE `wifi_log` (
	`wifi_log_id` int(11) NOT NULL AUTO_INCREMENT,
	`device_id` int(11) NOT NULL,
	`date_recorded` datetime NOT NULL,
	PRIMARY KEY (`wifi_log_id`),
	KEY `device_id` (`device_id`),
	CONSTRAINT `wifi_log_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `wifi_log_ap`;
CREATE TABLE `wifi_log_ap` (
	`wifi_log_ap_id` int(11) NOT NULL AUTO_INCREMENT,
	`wifi_log_id` int(11) NOT NULL,
	`mac` varchar(50) NOT NULL,
	`ssid` varchar(50) NOT NULL,
	`signal_strength` float NOT NULL COMMENT 'síla signálu v dBm, 100% = -35, 1% = -95',
	PRIMARY KEY (`wifi_log_ap_id`),
	KEY `wifi_log_id` (`wifi_log_id`),
	KEY `mac` (`mac`),
	KEY `ssid` (`ssid`),
	CONSTRAINT `wifi_log_ap_ibfk_1` FOREIGN KEY (`wifi_log_id`) REFERENCES `wifi_log` (`wifi_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2014-02-02 16:11:11

ALTER TABLE `ap_log`
CHANGE `ap_code` `ap_code` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'kód ap wifi routeru' AFTER `ap_log_id`,
CHANGE `date_access` `date_access` datetime NOT NULL COMMENT 'datum pořízení logu' AFTER `ap_code`,
CHANGE `role` `role` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'Role ve které zařízení vystupuje. Zatím pouze Client' AFTER `date_access`,
CHANGE `mac_hash` `mac_hash` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'zahashovaná mac adresa zařízení' AFTER `role`,
CHANGE `type` `type` varchar(50) COLLATE 'utf8_general_ci' NOT NULL COMMENT 'typ záznamu. připojen, odpojen z ap' AFTER `mac_hash`,
COMMENT=''; -- 15.572 s
