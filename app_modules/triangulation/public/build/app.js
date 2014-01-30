

function TriangulationCtrl($scope, $http) {
	var loungeCanvas = document.getElementById("lounge").getContext('2d');
	var apSize = 10;
	$scope.lounge = {};

	$scope.loadData = function () {
		$http.get('load-data').success(function (data) {
			// only first
			$scope.lounge = data.lounges.pop();
		});
	};

	$scope.$watch('lounge', function (lounge, loungeBefore) {
		writeApList($scope.lounge.apList);
	});

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