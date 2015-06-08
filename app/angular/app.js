(function (){
	var app = angular.module('lsnm', ['lsnm-specials']);

	app.controller('LsnmController', ['$http', function ($http){
		var lsnm = this;
		lsnm.specials = [];

		$http.get('app/angular/mock-data.json').success(function (data){
			lsnm.specials = data;
		});
	}]);
})();