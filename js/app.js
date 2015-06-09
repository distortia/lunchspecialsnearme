(function (){
	var app = angular.module('lsnm', ['lsnm-specials']);

	app.controller('LsnmController', ['$http', '$scope', function ($http,$scope){
		$scope.title = 'LSNM DEMO';
		$scope.tagline = 'Lets Break things(gently)';
		var lsnm = this;
		$scope.lsnm.specials = [];

		$http.get('data/mock-data.json').success(function (data){
			$scope.lsnm.specials = data;
		});
	}]);
})();