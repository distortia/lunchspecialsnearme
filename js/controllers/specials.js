(function (){
	var app = angular.module('lsnm-specials', []);


	// app.controller("SpecialController", ['$http','$scope', function($http,$scope){
	// 	$scope.specials = [];

	// 	$http.get('data/mock-data.json').success(function (data){
	// 		$scope.specials = data;
	// 	});

	// }]);

	app.directive('specialTile', function (){
		return {
			restrict: 'E',
			templateUrl: 'modules/special-tile.html',
		};
	});
})();