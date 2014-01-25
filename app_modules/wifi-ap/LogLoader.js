
var readline = require('readline');
var fs = require('fs');
var stream = require('stream');
var EventEmitter = require('events').EventEmitter;
var _ = require('underscore');
var builder = require('./mysql/builder');
var moment = require('moment');



/**
 * Factory
 * @param {Connection} connection MySQL connection
 * @return {LogLoader}
 */
exports = module.exports = function (connection, table) {
	return new LogLoader(connection, table);
};

/**
 * [LogLoader description]
 * @constructor
 * @param  {Connection} connection
 * @param  {string} table
 */
var LogLoader = function (connection, table) {
	this.connection = connection;
	this.table = table;
	this.rowsBuffer = [];
	this.maxBufferSize = 10000;
};
LogLoader.prototype = Object.create(EventEmitter.prototype);
LogLoader.prototype.TYPE_CONNECTED = 'connected';
LogLoader.prototype.TYPE_DISCONNECTED = 'disconnected';
LogLoader.prototype.TYPE_UNKNOWN = 'unknown';

/**
 * Load Wifi AP log from file to MySQL
 * @param  {string} filePath
 * @param  {Function} callback
 */
LogLoader.prototype.loadFileToStorage = function (filePath, callback) {
	var self = this;
	var fileReadable = fs.createReadStream(filePath);
	var outStream = new stream;
	outStream.readable = true;
	outStream.writable = true;

	var fileReadline = readline.createInterface({
		input: fileReadable,
		output: outStream,
		terminal: false
	});

	fileReadline.on('line', function (line) {
		self.parseLine(line, function (row) {
			self.addLine(row);
		});
	});
	fileReadline.on('close', function () {
		self.storeRowsBuffer(function () {
			self.emit('end');
			if (_.isFunction(callback))
				callback();
		});
	});

	return this;
};

/**
 * [parseLines description]
 * @param  {string}   line
 * @param  {Function} callback
 * @return {[type]}
 */
LogLoader.prototype.parseLine = function (line, callback) {
	var parts = line.split(' ');
	var type = this.mapType(parts[3]);
	var ap_code = typeof parts[8] !== 'undefined' ?parts[8].replace('.', '') :'';
	var row = {
		date_access: moment(parts[0]).format('YYYY-MM-DD HH:mm:ss'),
		role: parts[1],
		mac_hash: parts[2],
		type: type,
		ap_code: ap_code
	};
	callback(row);
};

LogLoader.prototype.mapType = function (type) {
	switch (type) {
		case 'successfully':
			return this.TYPE_CONNECTED;
		case 'discconected':
			return this.TYPE_DISCONNECTED;
		default:
			return this.TYPE_UNKNOWN;
	}
};


LogLoader.prototype.addLine = function (parsedLine) {
	this.rowsBuffer.push(parsedLine);
	if (this.rowsBuffer.length >= this.maxBufferSize) {
		this.storeRowsBuffer();
	}
};

LogLoader.prototype.storeRowsBuffer = function (callback) {
	var self = this;
	var rows = this.cloneArray(this.rowsBuffer);
	this.clearArray(this.rowsBuffer);
	var sql = builder.insertOrUpdate(this.table, rows);
	this.connection.query(sql, function (e, result) {
		if (e) {
			self.emit('error', e)
			return;
		}
		self.emit('stored', result);
		if (_.isFunction(callback))
			callback(null, result);
	});
};

LogLoader.prototype.clearArray = function(array) {
  while (array.length > 0) {
    array.pop();
  }
};
LogLoader.prototype.cloneArray = function(array) {
	return array.slice(0);
};