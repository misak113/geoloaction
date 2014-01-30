

function TriangulationCtrl($scope, $http, $timeout) {
	var loungeCanvas = document.getElementById("lounge").getContext('2d');
	var apSize = 10;
	var deviceSize = 7;
	$scope.lounge = {};
	$scope.wifiLogs = [];
	var width = 640;//$scope.lounge.x_length * 100;
	var height = 480;//$scope.lounge.y_length * 100;

	$scope.loadData = function () {
		$http.get('load-lounges').success(function (data) {
			// only first
			$scope.lounge = data.lounges.pop();
		});
		refreshWifiLog();
	};

	$scope.$watch('lounge', function (lounge, loungeBefore) {
		writeApList($scope.lounge.apList);
	});

	var refreshWifiLog = function () {
		$http.get('load-wifi-logs').success(function (data) {
			$scope.wifiLogs = data.logs;
		});
		writeWifiLogs();
		$timeout(refreshWifiLog, 1000);
	};

	var writeApList = function (apList) {
		loungeCanvas.lineWidth = 2;
		loungeCanvas.fillStyle = '#000'; // blue
		loungeCanvas.strokeStyle = '#555'; // blue
		angular.forEach(apList, function (ap) {
			var x = width*ap.x_position-apSize/2;
			var y = height*ap.y_position-apSize/2;
			loungeCanvas.fillRect(x, y, apSize, apSize);
			loungeCanvas.strokeRect(x, y, apSize, apSize);
		});
	};

	var writeWifiLogs = function () {
		angular.forEach($scope.wifiLogs, function (wifiLog) {
			var devicePosition = calculatePosition(wifiLog.apList);
			writeDevicePosition(devicePosition);
		});
	};

	var writeDevicePosition = function (position) {
		loungeCanvas.lineWidth = 2;
		loungeCanvas.fillStyle = '#157'; // blue
		loungeCanvas.strokeStyle = '#37A'; // blue

		var x = width*position.x_position-deviceSize/2;
		var y = height*position.y_position-deviceSize/2;
		loungeCanvas.fillRect(x, y, deviceSize, deviceSize);
		loungeCanvas.strokeRect(x, y, deviceSize, deviceSize);

	};

	var calculatePosition = function (logApList) {
		// algoritmus triangulace
		return {
			x_position: 0.4,
			y_position: 0.5
		};
	};
}