
var _ = require('underscore');

exports = module.exports = function (a, b, c) {
	return new ApDataLoader(a, b, c);
};


var ApDataLoader = function (connection, loungeTable, apTable) {
	this.connection = connection;
	this.loungeTable = loungeTable;
	this.apTable = apTable;
};


ApDataLoader.prototype.loadLounges = function (callback) {
	var self = this;
	this.connection.query('SELECT * FROM ?? JOIN ?? USING (lounge_id)', [this.loungeTable, this.apTable],
		function (e, rows) {
			if (e) {
				callback(e);
				return;
			}
			self.createLounges(rows, callback);
		});
};

ApDataLoader.prototype.createLounges = function (rows, callback) {
	var self = this;
	var lounges = [];
	rows.forEach(function (row) {
		var lounge = _.find(lounges, function (lounge) {
			return lounge.lounge_id === row.lounge_id;
		});
		if (typeof lounge === 'undefined') {
			lounge = self.prepareLounge(row);
			lounges.push(lounge);
		}
		lounge.apList.push(self.prepareAp(row));
	});
	callback(null, lounges);
};

ApDataLoader.prototype.prepareLounge = function (row) {
	return {
		lounge_id: row.lounge_id,
		name: row.name,
		code: row.code,
		type: row.type,
		x_length: row.x_length,
		y_length: row.y_length,
		z_length: row.z_length,
		heading: row.heading,
		latitude: row.latitude,
		longitude: row.longitude,
		altitude: row.altitude,
		aspect_ration: row.aspect_ration,
		image_id: row.image_id,
		floor: row.floor,
		apList: []
	};
};

ApDataLoader.prototype.prepareAp = function (row) {
	return {
		ap_id: row.ap_id,
		code: row.code,
		x_position: row.x_position,
		y_position: row.y_position,
		z_position: row.z_postion,
		type: row.type,
		mac: row.mac,
		ssid: row.ssid
	};
};
