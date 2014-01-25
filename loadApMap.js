
var ApMapLoader = require('./app_modules/wifi-ap/ApMapLoader');
var mysql = require('mysql');
var l = require('log-dispatch');
var moment = require('moment');
var each = require('each');

var dbname = 'geolocation';
var loungeTable = 'lounge';
var apTable = 'ap';
var imageTable = 'image';

var dbConfig = {
	host: 'localhost',
	user: 'root',
	password: '',
	database: dbname
};

var loadFiles = function (connection, callback) {
	var apMapLoader = ApMapLoader(connection, loungeTable, apTable, imageTable);

	var files = [
		'data/aps/NB_AP_P.svg',
	];

	var fn = function (file, next) {
		apMapLoader.loadFileToStorage(file, function () {
			l.info('loaded');
			next();
		})
		.on('stored', function (res) {
			process.stdout.write('.');
		})
		.on('error', function (e) {
			l.error(e);
		});
	};

	each(files)
	.on('item', fn)
	.on('error', function () {
		l.error(e);
		callback(e);
	})
	.on('end', function () {
		callback();
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

	loadFiles(connection, function () {
		closeConnection(null, connection);
		l.info(moment.duration(moment().valueOf()-startTime).asSeconds()+" seconds");
	});
};

start();