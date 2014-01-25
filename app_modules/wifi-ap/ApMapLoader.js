
var xml2js = require('xml2js');


exports = module.exports = function (connection, buildingTable, apTable) {
	return new ApMapLoader(connection, buildingTable, apTable);
};

var ApMapLoader = function (connection, buildingTable, apTable) {
	this.connection = connection;
	this.buildingTable = buildingTable;
	this.apTable = apTable;
};
ApMapLoader.prototype = Object.create(EventEmitter.prototype);


ApMapLoader.prototype.loadFileToStorage = function (filePath, callback) {
	var self = this;
	self.loadFromFile(filePath, function (e, buildingData) {
		if (e) {
			self.emit('error', e);
			return;
		}
		self.saveBuilding(buildingData, function (e, building) {
			if (e) {
				self.emit('error', e);
				return;
			}

			self.emit('end', building);
			if (_.isFunction(callback))
				callback(null, building);
		});
	});

	return this;
};


ApMapLoader.prototype.loadFromFile = function (filePath, callback) {
	var self = this;
	xml2js.parseString(filePath, function (e, data) {
		if () {
			callback(e);
			return;
		}
		self.prepareBuildingData(data, callback);
	});
};

ApMapLoader.prototype.prepareBuildingData = function (data, callback) {

};

ApMapLoader.prototype.saveBuilding = function (buildingData, callback) {

};

