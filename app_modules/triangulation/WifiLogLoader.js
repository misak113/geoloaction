
var _ = require('underscore');

exports = module.exports = function (a, b, c, d) {
	return new WifiLogLoader(a, b, c, d);
};


var WifiLogLoader = function (connection, wifiLogTable, wifiLogApTable, apTable) {
	this.connection = connection;
	this.wifiLogTable = wifiLogTable;
	this.wifiLogApTable = wifiLogApTable;
	this.apTable = apTable;
};


WifiLogLoader.prototype.loadLogs = function (callback) {
	var self = this;
	this.connection.query('SELECT * FROM ?? JOIN ?? USING (wifi_log_id) JOIN ?? USING (mac)', [this.wifiLogTable, this.wifiLogApTable, this.apTable],
		function (e, rows) {
			if (e) {
				callback(e);
				return;
			}
			self.createLogs(rows, callback);
		});
};

WifiLogLoader.prototype.createLogs = function (rows, callback) {
	var self = this;
	var logs = [];
	rows.forEach(function (row) {
		var log = _.find(logs, function (log) {
			return log.wifi_log_id === row.wifi_log_id;
		});
		if (typeof log === 'undefined') {
			log = self.prepareLog(row);
			logs.push(log);
		}
		log.apList.push(self.prepareLogAp(row));
	});
	callback(null, logs);
};

WifiLogLoader.prototype.prepareLog = function (row) {
	return {
		wifi_log_id: row.wifi_log_id,
		device_id: row.device_id,
		date_recorded: row.date_recorded,
		apList: []
	};
};

WifiLogLoader.prototype.prepareLogAp = function (row) {
	return {
		wifi_log_ap_id: row.wifi_log_ap_id,
		mac: row.mac,
		ssid: row.ssid,
		signal_strength: row.signal_strength,
		ap: {
			ap_id: row.ap_id,
			code: row.code,
			x_position: row.x_position,
			y_position: row.y_position,
			z_position: row.z_postion,
			type: row.type,
			mac: row.mac,
			ssid: row.ssid
		}
	};
};
