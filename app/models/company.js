//app/company.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var companySchema = new Schema({
	name: {
		type: String
	},
	address: {
		type: String
	},
	city: {
		type: String
	},
	state: {
		type: String
	},
	zip: {
		type: String
	},
	email: {
		type: String,
		unique: true
	},
	website: {
		type: String
	},
	background: {
		type: String
	},
	phone: {
		type: String
	},
	owner: {
		type: String
	},
	opened: {
		type: String
	},
	closed: {
		type: String
	},
	deliver: {
		type: Boolean
	},
	category: {
		type: String
	}
});

module.exports = mongoose.model('company', companySchema);