
var LogLoader = require('./app_modules/wifi-ap/LogLoader');
var mysql = require('mysql');
var l = require('log-dispatch');

var dbname = 'geolocation';
var tableName = 'ap_log';

var loadLogFile = function (connection, callback) {
	var logLoader = LogLoader(connection, tableName);

	var file = 'data/wlan-anon.txt';

	logLoader.loadFileToStorage(file, function () {
		l.info('loaded');
		callback(null, connection);
	})
	.on('stored', function (res) {
		l.d('stored');
	})
	.on('error', function (e) {
		l.error(e);
	});
};


var closeConnection = function (e, connection) {
	connection.end(function (e) {
		l.info('connection ended');
	});
};
var start = function (e) {
	var connection = mysql.createConnection({
		host: 'localhost',
		user: 'root',
		password: '',
		database: dbname
	})
	.on('error', function (e) {
		l.error('Nepodařilo se připojit k databázi mysql', e);
	});
	connection.connect();

	loadLogFile(connection, closeConnection);
};

start();