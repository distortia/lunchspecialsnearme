(function (){
	var app = angular.module('lsnm-specials', []);

	app.directive('specialTile', function (){
		return {
			restrict: 'E',
			templateUrl: 'app/angular/special-tile.html',
		};
	});
})();