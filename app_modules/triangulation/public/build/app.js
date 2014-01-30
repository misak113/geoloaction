

function TriangulationCtrl($scope, $http, $timeout) {
	var loungeCanvas = document.getElementById("lounge").getContext('2d');
	var apSize = 10;
	$scope.lounge = {};
	$scope.wifiLogs = [];

	$scope.loadData = function () {
		$http.get('load-lounges').success(function (data) {
			// only first
			$scope.lounge = data.lounges.pop();
		});
	};

	$scope.$watch('lounge', function (lounge, loungeBefore) {
		writeApList($scope.lounge.apList);
	});

	var refreshWifiLog = function () {
		$http.get('load-wifi-logs').success(function (data) {
			$scope.wifiLogs = data.logs;
		});
		$timeout(refreshWifiLog, 1000);
	};
	refreshWifiLog();

	var writeApList = function (apList) {
		var width = $scope.lounge.x_length * 100;
		var height = $scope.lounge.y_length * 100;
		loungeCanvas.lineWidth = 2;
		loungeCanvas.fillStyle = '#000'; // blue
		loungeCanvas.strokeStyle = '#555'; // blue
		angular.forEach(apList, function (ap) {
			console.log(width, height, ap);
			var x = width*ap.x_position-apSize/2;
			var y = height*ap.y_position-apSize/2;
			console.log(x, y);
			loungeCanvas.fillRect(x, y, apSize, apSize);
			loungeCanvas.strokeRect(x, y, apSize, apSize);
		});
	};
}