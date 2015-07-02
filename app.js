/**
* app Module
*
* Description
*/
(function (){
var app = angular.module('LSNM', ['ngRoute']);


app.config(['$routeProvider', function($routeProvider) {
	$routeProvider
	.when('/', {
		templateUrl: './home.html',
		controller: 'MainController'
	})

	.when('/specials', {
                	templateUrl : './specials.html',
                	controller: 'SpecialsController'
            })

	.when('/profile', {
		templateUrl: './profile.html',
		controller: 'ProfileController'
	});
}]);

app.controller('MainController', ['$scope', function($scope){
	$scope.message = 'This is the Home message';
}]);

app.controller('SpecialsController', ['$scope','$http', function($scope, $http){
	$scope.message =  'This is the Specials page';


	$scope.specials = [];
	$http.get('./mock-data.json').success(function(data){
		$scope.specials = data;
	});

}]);

app.controller('ProfileController', ['$scope', function($scope){
	$scope.message = 'This is the profile page';
}]);

})();