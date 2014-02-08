
var LogLoader = require('./app_modules/wifi-ap/LogLoader');
var Client = require('pg').Client;
var l = require('log-dispatch');
var moment = require('moment');
var builder = require('./app_modules/postgres/builder');

var dbname = 'Geoanalysis';
var schema = 'mobile';
var tableName = 'ap_log';

var dbConfig = {
	host: 'localhost',
	user: 'postgres',
	password: 'misak',
	database: dbname
};

var loadLogFile = function (client, callback) {
	var logLoader = LogLoader(function (sql, cb) { client.query(sql, cb); }, tableName, builder);

	var file = 'data/wlan-anon.txt';

	logLoader.loadFileToStorage(file, function () {
		l.info('loaded');
		callback();
	})
	.on('stored', function (res) {
		process.stdout.write('.');
	})
	.on('error', function (e) {
		l.error(e);
	});
};


var closeConnection = function (e, client) {
	client.on('drain', function () {
		l.info('connection ended');
	});
	client.end();
};
var start = function (e) {
	var startTime = moment().valueOf();
	var client = new Client(dbConfig);
	client.on('error', function (e) {
		l.error('Nepodařilo se připojit k databázi mysql', e);
	});
	client.connect();
	client.query('SET search_path TO '+schema+';');
	loadLogFile(client, function () {
		closeConnection(null, client);
		l.info(moment.duration(moment().valueOf()-startTime).asSeconds()+" seconds");
	});
};

start();