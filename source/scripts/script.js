$(function(){
    var thankyou = location.search.split('thankyou=')[1];
    if(thankyou){
        genericMessage("We got your Suggestion! Follow our newsletter for more updates!");
    }
});

$(function(){
    var error = location.search.split('error=')[1] || location.search.split('internalError=')[1];
    if(error){
        genericErrorMessage(decodeURI(error));
    }
});

var genericErrorMessage = function(msg){
	swal({  title: "Error",
			text: msg,
			type: "error",
			showCancelButton: false,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Ok",
			closeOnConfirm: true
		},
        function(){
            var clean_uri = location.protocol + "//" + location.host + location.pathname;
            window.history.replaceState({}, document.title, clean_uri);
        }
    );
};

var genericMessage = function(msg){
	swal({  title: "Sucess!",
			text: msg,
			type: "success",
			showCancelButton: false,
            confirmButtonColor: "#AEDEF4",
			confirmButtonText: "Ok",
			closeOnConfirm: true
		},
        function(){
            var clean_uri = location.protocol + "//" + location.host + location.pathname;
            window.history.replaceState({}, document.title, clean_uri);
        }
    );
};

$(function(){
	var $toggle = $('.nav-toggle');
    var $menu = $('.nav-menu');
    $toggle.click(function() {
        $(this).toggleClass('is-active');
        $menu.toggleClass('is-active');
    });
});