
var vows = require('vows');
var mysql = require('mysql');

vows.describe('Loading log from file').addBatch({
	'try load': {
		topic: function () {
			var connection = mysql.createConnection({
				username: 'root',
				password: '',
				dbname: 'wifi_ap',
			});
			var logLoader = LogLoader(connection, 'ap_log');
			logLoader.loadFileToStorage(file, this.callback);
		},
		'emit end': function () {
			console.log('emit ended');
		}
	}
});