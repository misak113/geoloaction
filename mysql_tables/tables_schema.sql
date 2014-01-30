-- Adminer 3.7.1 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = '+01:00';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DELIMITER ;;

DROP PROCEDURE IF EXISTS `count_ap_for_mac_hash`;;
CREATE PROCEDURE `count_ap_for_mac_hash`()
select mac_hash, count(*) as count_ap, sum(count_connected_on_ap)
from 
(
select count(*) as count_connected_on_ap, ap_log.*
from ap_log
group by mac_hash, ap_code
order by count_connected_on_ap desc
) a
group by mac_hash
order by count_ap desc;;

DROP PROCEDURE IF EXISTS `mac_most_connected_ap`;;
CREATE PROCEDURE `mac_most_connected_ap`()
select @i:=@i+1 as '#', mac_hash, ap_code, max_count_connected
from
(
select  a.*, max(count_connected) as max_count_connected
from (

(select mac_hash, count(*) as count_connected,
ap_code
from ap_log 
where type = 'connected'
group by mac_hash, ap_code
order by count(*) desc) a


) 

group by mac_hash

having count_connected = max_count_connected

order by mac_hash, count_connected desc
) b

order by max_count_connected desc;;

DELIMITER ;

DROP TABLE IF EXISTS `ap`;
CREATE TABLE `ap` (
  `ap_id` int(11) NOT NULL AUTO_INCREMENT,
  `lounge_id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `x_position` int(11) NOT NULL COMMENT 'relativní x pozice ap v hale (vyjádření v jednotkové stupnici)',
  `y_position` int(11) NOT NULL COMMENT 'relativní y pozice ap v hale (vyjádření v jednotkové stupnici)',
  `z_position` int(11) DEFAULT NULL COMMENT 'relativní z pozice ap v hale (vyjádření v jednotkové stupnici)',
  `type` varchar(50) NOT NULL,
  `mac` varchar(50) NOT NULL,
  `ssid` varchar(50) NOT NULL,
  PRIMARY KEY (`ap_id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `mac` (`mac`),
  KEY `lounge_id` (`lounge_id`),
  CONSTRAINT `ap_ibfk_1` FOREIGN KEY (`lounge_id`) REFERENCES `lounge` (`lounge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `ap`
CHANGE `x_position` `x_position` float NOT NULL COMMENT 'relativní x pozice ap v hale (vyjádření v jednotkové stupnici)' AFTER `code`,
CHANGE `y_position` `y_position` float NOT NULL COMMENT 'relativní y pozice ap v hale (vyjádření v jednotkové stupnici)' AFTER `x_position`,
CHANGE `z_position` `z_position` float NULL COMMENT 'relativní z pozice ap v hale (vyjádření v jednotkové stupnici)' AFTER `y_position`,
COMMENT=''; -- 0.501 s

DROP TABLE IF EXISTS `compass_log`;
CREATE TABLE `compass_log` (
  `compass_log_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) NOT NULL,
  `heading` float NOT NULL,
  `accuracy` float NOT NULL,
  `date_recorded` datetime NOT NULL,
  PRIMARY KEY (`compass_log_id`),
  KEY `device_id` (`device_id`),
  CONSTRAINT `compass_log_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`)
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
  `north_rotation` float DEFAULT NULL COMMENT 'natočení haly vůči severu v radiánech',
  `latitude` float DEFAULT NULL COMMENT 'zeměpisná šířka středu haly',
  `longitude` float DEFAULT NULL COMMENT 'zeměpisná délka středu haly',
  `altitude` float DEFAULT NULL COMMENT 'zeměpisná výška středu haly',
  `aspect_ratio` float NOT NULL COMMENT 'poměr stran x/y (duplikace z x_length/y_length pokud jsou zadané)',
  `image_id` int(11) NOT NULL COMMENT 'obrázek půdorysu haly',
  `floor` int(11) DEFAULT NULL COMMENT 'patro haly v budově',
  PRIMARY KEY (`lounge_id`),
  UNIQUE KEY `code` (`code`),
  KEY `image_id` (`image_id`),
  CONSTRAINT `lounge_ibfk_1` FOREIGN KEY (`image_id`) REFERENCES `image` (`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `lounge`
CHANGE `north_rotation` `heading` float NULL COMMENT 'natočení haly vůči severu v radiánech' AFTER `z_length`,
COMMENT=''; -- 0.442 s

ALTER TABLE `lounge`
CHANGE `image_id` `image_id` int(11) NULL COMMENT 'obrázek půdorysu haly' AFTER `aspect_ratio`,
COMMENT=''; -- 0.373 s

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
  `signal_strength` float NOT NULL,
  PRIMARY KEY (`wifi_log_ap_id`),
  KEY `wifi_log_id` (`wifi_log_id`),
  KEY `mac` (`mac`),
  KEY `ssid` (`ssid`),
  CONSTRAINT `wifi_log_ap_ibfk_1` FOREIGN KEY (`wifi_log_id`) REFERENCES `wifi_log` (`wifi_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2014-01-27 00:20:54

CREATE TABLE `connectivity_log` (
  `connectivity_log_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `device_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  `date_recorded` date NOT NULL,
  FOREIGN KEY (`device_id`) REFERENCES `device` (`device_id`)
) COMMENT='' ENGINE='InnoDB'; -- 0.383 s


-- Adminer 3.7.1 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = '+01:00';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

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


-- 2014-01-30 21:47:52