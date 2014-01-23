
var vows = require('vows');
var mysql = require('mysql');
var assert = require('assert');

var LogLoader = require('../LogLoader');

vows.describe('Loading log from file').addBatch({
	'try load connections': {
		topic: function () {
			var connection = mysql.createConnection({
				host: 'localhost',
				username: 'root',
				password: '',
				database: 'wifi_ap',
			});
			connection.connect();
			var logLoader = LogLoader(connection, 'ap_log');
			this.callback(null, logLoader);
		},
		'logLoader created': function (e, logLoader) {
			var file = 'data/wifi-ap.log';
			logLoader.loadFileToStorage(file, this.callback);
		},
		'loaded file': {
			topic: function (logLoader) {
				var file = __dir+'/data/wifi-ap.log';
				logLoader.loadFileToStorage(file, this.callback);
			},
			'emit end': function (e) {
				assert.isUndefined(e);
			}
		}
	}
})
.export(module)
;