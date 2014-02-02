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