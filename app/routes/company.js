module.exports = (function(){
	'use strict';

	var router = require('express').Router();

	//pull in company model
	var Company = require('../models/company');


	//router middleware
	router.use(function(req, res, next){
		next();
	});

	router.route('/')
		.post(function(req, res){
			//Create company object for saving to database
			var companyObj = {
				name: 		req.body.name,
				address: 	req.body.address,
				city: 		req.body.city,
				state: 		req.body.state,
				zip: 		req.body.zip,
				email: 		req.body.email,
				website: 	req.body.website,
				background: 	req.body.background,
				phone: 	req.body.phone,
				owner: 		req.body.owner
			};
			//Create company from attributes above
			var company = new Company(companyObj);
			//Save company to db
			company.save(function(err){
				if (err) res.send(err);
				res.json({message: 'Company Created!'});
			});
		}) // end post route
		.get(function(req, res){
			//Get all companies
			Company.find(function(err, companies){
				if (err) res.send(err);
				res.json(companies);
			});
		}); //end get route

	router.route('/:company_id')
		.get(function(req, res){
			Company.findById(req.params.company_id, function(err, company){
				if (err) res.send(err);
				res.json(company);
			});
		}) // End get
		.put(function(req, res){
			//Create the companyObj again to get all the attributes
			var companyObj = {
				name: 		req.body.name,
				address: 	req.body.address,
				city: 		req.body.city,
				state: 		req.body.state,
				zip: 		req.body.zip,
				email: 		req.body.email,
				website: 	req.body.website,
				background: 	req.body.background,
				phone: 	req.body.phone,
				owner: 		req.body.owner
			};
			//Find company and update it with new attributes
			Company.findByIdAndUpdate(req.params.company_id, companyObj, function(err, company){
				if (err) res.send(err);
				res.json({message: 'Company Updated'});
			});
		}) // End Put
		.delete(function(req, res){
			Company.remove({_id: req.params.company_id}, function (err, company){
					if (err) res.send(err);
					res.json({message: 'Company Deleted'});
			}) ;
		}); // End Delete
	return router;
})();