
var app = angular.module('triangulation', []);

function TriangulationCtrl($scope, $http, $timeout, Kinetic, loungeStage, apLayer, deviceLayer, circlesLayer, loungeLayer) {
	var apSize = 10;
	var deviceSize = 7;
	$scope.lounge = {};
	$scope.wifiLogs = [];
	$scope.multiplier = 50;
	var width = 640;
	var height = 480;

	$scope.loadData = function () {
		$http.get('load-lounges').success(function (data) {
			// only first
			var lounge = data.lounges.pop();
			width = lounge.x_length * 100;
			height = lounge.y_length * 100;
			$scope.lounge = lounge;
		});
	};

	$scope.$watch('lounge', function () {
		writeLounge($scope.lounge);
		writeApList($scope.lounge.apList);
	});

	$scope.refreshWifiLog = function () {
		$http.get('load-wifi-logs').success(function (data) {
			$scope.wifiLogs = data.logs;
		});
		writeWifiLogs();
		$timeout($scope.refreshWifiLog, 1000);
	};

	var writeLounge = function (lounge) {
		loungeLayer.removeChildren();
		var loungeRect = new Kinetic.Rect({
			x: 0,
			y: 0,
			height: height,
			width: width,
			fill: '#EEE',
			stroke: '#000',
			strokeWidth: 3
		});
		loungeLayer.add(loungeRect);
		loungeLayer.draw();
	};

	var writeApList = function (apList) {
		apLayer.removeChildren();
		angular.forEach(apList, function (ap) {
			var x = getXPosition(ap.x_position);
			var y = getYPosition(ap.y_position);
			var apCircle = new Kinetic.Circle({
				x: x,
				y: y,
				height: apSize,
				fill: '#000',
				stroke: '#555',
				strokeWidth: 2
			});
			apLayer.add(apCircle);
		});
		apLayer.draw();
	};

	var getXPosition = function (x_position) {
		return width*x_position;
	};

	var getYPosition = function (y_position) {
		return height*y_position;
	};

	var writeWifiLogs = function () {
		angular.forEach($scope.wifiLogs, function (wifiLog) {
			writeCircles(wifiLog.apList);
			var devicePosition = calculatePosition(wifiLog.apList);
			writeDevicePosition(devicePosition);
		});
	};

	var writeDevicePosition = function (position) {
		deviceLayer.removeChildren();
		var x = getXPosition(position.x_position);
		var y = getYPosition(position.y_position);
		var deviceCircle = new Kinetic.Circle({
			x: x,
			y: y,
			radius: deviceSize,
			fill: '#157',
			stroke: '#37A',
			strokeWidth: 2
		});
		deviceLayer.add(deviceCircle);
		deviceLayer.draw();
	};

	var calculatePosition = function (logApList) {
		// algoritmus triangulace
		return {
			x_position: 0.4,
			y_position: 0.5
		};
	};


	var writeCircles = function (logApList) {
		circlesLayer.removeChildren();
		angular.forEach(logApList, function (logAp) {
			var size = (1/-logAp.signal_strength) * 100 * $scope.multiplier;
			var circle = new Kinetic.Circle({
				x: getXPosition(logAp.ap.x_position),
				y: getYPosition(logAp.ap.y_position),
				radius: size,
				//fill: 'red',
				stroke: 'black',
				strokeWidth: 1
			});
			circlesLayer.add(circle);
		});
		circlesLayer.draw();
	};

	$scope.$watch('multiplier', function () {
		if ($scope.multiplier < 0)
			$scope.multiplier = 0;
		writeWifiLogs();
	});
}



app.factory('Kinetic', function () {
	var service = Kinetic;
	// delete from global context
	delete Kinetic;
	return service;
});

app.factory('loungeStage', function (Kinetic, loungeLayer, circlesLayer, apLayer, deviceLayer) {
	var stage = new Kinetic.Stage({
		container: 'lounge',
		width: 640,
		height: 480
	});
	stage.add(loungeLayer);
	stage.add(apLayer);
	stage.add(deviceLayer);
	stage.add(circlesLayer);
	return stage;
});

app.factory('loungeLayer', function (Kinetic) {
	return new Kinetic.Layer();
});
app.factory('circlesLayer', function (Kinetic) {
	return new Kinetic.Layer();
});
app.factory('apLayer', function (Kinetic) {
	return new Kinetic.Layer();
});
app.factory('deviceLayer', function (Kinetic) {
	return new Kinetic.Layer();
});