
var LogLoader = require('./app_modules/wifi-ap/LogLoader');
var mysql = require('mysql');
var l = require('log-dispatch');
var moment = require('moment');

var dbname = 'geolocation';
var tableName = 'ap_log';

var dbConfig = {
	host: 'localhost',
	user: 'root',
	password: '',
	database: dbname
};

var loadLogFile = function (connection, callback) {
	var logLoader = LogLoader(connection, tableName);

	var file = 'data/wlan-anon.txt';

	logLoader.loadFileToStorage(file, function () {
		l.info('loaded');
		callback();
	})
	.on('stored', function (res) {
		//l.d('stored');
		process.stdout.write('.');
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
	var startTime = moment().valueOf();
	var connection = mysql.createConnection(dbConfig)
	.on('error', function (e) {
		l.error('Nepodařilo se připojit k databázi mysql', e);
	});
	connection.connect();

	loadLogFile(connection, function () {
		closeConnection(null, connection);
		l.info(moment.duration(moment().valueOf()-startTime).asSeconds()+" seconds");
	});
};

start();