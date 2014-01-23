
var readline = require('readline');
var fs = require('fs');
var EventEmitter = require('events').EventEmitter;
var _ = require('underscore');
var builder = require('./mysql/builder');



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
	this.maxBufferSize = 20;
};
LogLoader.prototype = Object.create(EventEmitter.prototype);

/**
 * Load Wifi AP log from file to MySQL
 * @param  {string} filePath
 * @param  {Function} callback
 */
LogLoader.prototype.loadFileToStorage = function (filePath, callback) {
	var self = this;
	var fileReadable = fs.createReadStream(filePath);
	fileReadable.on('line', function (line) {
		self.parseLine(line, self.addLine);
	});
	fileReadable.on('end', function () {
		self.storeRowsBuffer(function () {
			self.emit('end');
			if (_.isFunction(callback))
				callback();
		});
	});
	fileReadable.read(100);
};

/**
 * [parseLines description]
 * @param  {string}   line
 * @param  {Function} callback
 * @return {[type]}
 */
LogLoader.prototype.parseLine = function (line, callback) {

};


LogLoader.prototype.addLine = function (parsedLine) {
	this.rows.push(parsedLine);
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
		self.emit('stored', e, result);
		if (_.isFunction(callback))
			callback(e, result);
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