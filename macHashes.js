
var crypto = require('crypto');
var l = require('log-dispatch');
var moment = require('moment');
var mysql = require('mysql');
var _ = require('underscore');

var hashes = crypto.getHashes();

var dbname = 'geolocation';
var tableName = 'ap_log';

var dbConfig = {
	host: 'localhost',
	user: 'root',
	password: '',
	database: dbname
};

var macs = [
	'bc:cf:cc:02:26:a0',
];
macs.forEach(function (mac) {
	macs.push(mac.toUpperCase());
});
var macHashes = [];


var containsInApLog = function (mac_hash, callback) {
	var same = false;
	macHashes.forEach(function (macHash) {
		if (mac_hash.replace(macHash, '') != mac_hash)
			same = true;
	});
	callback(same);
};

var compareMacs = function (callback) {
	macs.forEach(function (mac) {
		l.log('mac', {mac: mac});

		hashes.forEach(function (hash) {
			try {
				var sum = crypto.createHash(hash);
				sum.update(mac);
				var base64 = sum.digest('base64');
				var binary = sum.digest('binary');
				var hex = sum.digest('hex');
			} catch (e) {
				//l.error(hash, 'not-supported');
				return;
			}
			//l.info(hash, {hash: bin});
			var resConains = function (contains) {
				if (contains) {
					l.warn('Found same:', {mac: mac, hash: hash});
				}
			};
			containsInApLog(base64, resConains);
			containsInApLog(binary, resConains);
			containsInApLog(hex, resConains);
		});
	});
};


var closeConnection = function (e, connection) {
	connection.end(function (e) {
		l.info('connection ended');
	});
};
var start = function (e) {
	var startTime = moment().valueOf();
	var connection = mysql.createConnection(dbConfig)
	.on('error', function (e) {
		l.error('Nepodařilo se připojit k databázi mysql', e);
	});
	connection.connect();

	var sql = 'SELECT DISTINCT mac_hash AS mac_hash FROM ??';

	connection.query(sql, [tableName], function (e, result) {
		if (e) {
			l.error('Nastala chyba při získávání mac_hash', e);
			return;
		}
		result.forEach(function (row) {
			macHashes.push(row['mac_hash']);
		});
		//l.log('mac hashes', macHashes);
		compareMacs();
		var ended = function () {
			closeConnection(null, connection);
			l.info(moment.duration(moment().valueOf()-startTime).asSeconds()+" seconds");
		};
		ended();
	});
};

start();