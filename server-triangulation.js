
var express = require('express');
var l = require('log-dispatch');
var mysql = require('mysql');

var triangulation = require('./app_modules/triangulation/index');

var dbname = 'geolocation';
var loungeTable = 'lounge';
var apTable = 'ap';
var wifiLogTable = 'wifi_log';
var wifiLogApTable = 'wifi_log_ap';

var dbConfig = {
	host: 'localhost',
	user: 'root',
	password: '',
	database: dbname
};

var connection = mysql.createConnection(dbConfig)
	.on('error', function (e) {
		l.error('Nepodařilo se připojit k databázi mysql', e);
	});
connection.connect();

var apDataLoader = triangulation.ApDataLoader(connection, loungeTable, apTable);
var wifiLogLoader = triangulation.WifiLogLoader(connection, wifiLogTable, wifiLogApTable, apTable);

var app = express();

app.use(express.static(triangulation.publicPath));

app.get('/load-lounges', function (req, res) {
	apDataLoader.loadLounges(function (e, lounges) {
		if (e) {
			res.send({error: e});
			return;
		}
		res.send({lounges: lounges});
	});
});
app.get('/load-wifi-logs', function (req, res) {
	wifiLogLoader.loadLogs(function (e, logs) {
		if (e) {
			res.send({error: e});
			return;
		}
		res.send({logs: logs});
	});
});

var port = process.argv[2] || 3000;
app.listen(port, function (e) {
	l.info('Server triangulation started on port '+port);
});