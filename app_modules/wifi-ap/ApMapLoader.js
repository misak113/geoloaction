
var xml2js = require('xml2js');
var fs = require('fs');
var EventEmitter = require('events').EventEmitter;
var _ = require('underscore');


exports = module.exports = function (connection, loungeTable, apTable, imageTable) {
	return new ApMapLoader(connection, loungeTable, apTable, imageTable);
};

var ApMapLoader = function (connection, loungeTable, apTable, imageTable) {
	this.connection = connection;
	this.loungeTable = loungeTable;
	this.apTable = apTable;
	this.imageTable = imageTable;
};
ApMapLoader.prototype = Object.create(EventEmitter.prototype);
ApMapLoader.prototype.TYPE_HALL = 'hall';
ApMapLoader.prototype.TYPE_WIFI = 'wifi';


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
	fs.readFile(filePath, function (e, xml) {
		if (e) {
			callback(e);
			return;
		}
		xml2js.parseString(xml, function (e, data) {
			if (e) {
				callback(e);
				return;
			}
			var code = filePath.split('/').pop().replace('.svg', '').replace('_', '-').toLowerCase();
			self.prepareBuildingData(data, code, callback);
		});
	});
};

ApMapLoader.prototype.prepareBuildingData = function (data, code, callback) {
	var normalized = this.normalizeGroups(data.svg.g[0].g);
	var groups = normalized.groups;
	var image = normalized.image;
	var imageSrc = image.$['xlink:href'].split(',');
	var mimeType = imageSrc[0].split(/(:|;)/)[1];

	var building = {
		name: null,
		code: code,
		type: this.TYPE_HALL,
		x_length: null,
		y_length: null,
		z_length: null,
		north_rotation: null,
		latitude: null,
		longitude: null,
		altitude: null,
		aspect_ration: parseFloat(data.svg.$.width.replace('in', '')) / parseFloat(data.svg.$.height.replace('in', '')),
		floor: null,
		image: {
			base64: imageSrc[1],
			width: image.$.width,
			height: image.$.height,
			mime_type: mimeType
		},
		aps: []
	};
	
	groups.forEach(function (g) {
		var ap = {
			code: g[1].desc,
			x_position: null,
			y_position: null,
			z_position: null,
			type: self.TYPE_WIFI
		};
	});
};

ApMapLoader.prototype.normalizeGroups = function (gList) {
	var self = this;
	var image = null;
	var groups = [];
	gList.forEach(function (g) {
		if (_.any(g.g, function (subG) { 
			return subG.$['v:groupContext'] === 'group'; 
		})) {
			var normalized = self.normalizeGroups(g.g);
			groups = groups.concat(normalized.groups);
			if (normalized.image !== null) 
				image = normalized.image;
		} else if (g.$['v:groupContext'] === 'group') {
			groups.push(g);
		} else if (typeof g.image !== 'undefined') {
			image = g.image[0];
		}
	});
	return { groups: groups, image: image };
};

ApMapLoader.prototype.saveBuilding = function (buildingData, callback) {

};

