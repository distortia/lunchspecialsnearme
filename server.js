
     //----------\\
   // Server.js \\
  //Base Setup\\
 // yay pyramid \\

//Import our dependencies and packages
var express = require('express');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');

var app = express();

//Configure body-parser
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

//Set server port
var port = process.env.PORT || 8880;

//Setup mongo
mongoose.connect('mongodb://localhost/lsnm');

//configure router and routes
var defaultRoute 	= express.Router();
var companyRoutes 	= require('./app/routes/company');

defaultRoute.get('/', function(req, res){
	res.json({message: "Its' Working!!!!!"});
});

//Register Routes
app.use('/', defaultRoute);
app.use('/company', companyRoutes);

//Start server
app.listen(port);
console.log("Server started at port ", port);


