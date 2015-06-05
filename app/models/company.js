//app/company.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var companySchema = new Schema({
	name: {
		type: String,
		unique: true
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
	}
});

module.exports = mongoose.model('company', companySchema);