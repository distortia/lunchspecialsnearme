var express = require('express');
var app = express();
// var db = require('./server/db');

// Handlebars setup
// Using the Main.handlebars as our main layout
var exphbs  = require('express-handlebars');
app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.set('view engine', 'handlebars');

// Sets up static file hosting
app.use(express.static('public'));

// Parsing forms
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: true }));

// Compression
var compression = require('compression');
app.use(compression({filter: shouldCompress}));

function shouldCompress(req, res) {
  if (req.headers['x-no-compression']) {
    // don't compress responses with this request header
    return false
  }

  // fallback to standard filter function
  return compression.filter(req, res)
}

// Routes
app.get('/', function(req, res){
  let status = req.query && req.query.internalError ? 500 : 200;
  res.status(status);
	res.render('index');
});

//Used to checkReCaptchas for queries that are done through script.js (i.e, data that is requiring
//to be verified by reCaptcha that uses a series of ajax requests to post to)  This is so the secret
//key is not exposed.
RecaptchaService = require('./services/recaptcha');

app.post('/recaptcha', function(req, res){
    RecaptchaService.checkResponse(req.body.response, function(error, response){
        if(error){
            console.log.error(error);  
            res.json({error: 'Unknown Error Has Occured'});  
        }
        if(response.success){
            res.json({success: true});
        }
        else{
            res.json({error: 'Invalid reCaptcha'});
        }
    });  
});

//Email Route
EmailService = require('./services/email');

app.post('/help', function(req, res){
		EmailService.sendMail({location: req.body.location, restaurants: req.body.restaurants}, function(error, info){
      if(error){
        res.redirect('/?internalError=An unknown error has occured, please try the request again');
      } else {
        res.redirect('/?thankyou=thanks');
      }
    });
});

// 404 handler
app.use(function(req, res, next) {
  res.render('', {layout: 'error' , error: '404'});
});

// Setup server
app.set('port', process.env.PORT || 3000);
app.listen(app.get('port'), function(){
	console.log("App started on port: " + app.get('port'));
});