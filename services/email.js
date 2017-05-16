const nodemailer = require('nodemailer');
const logger = require('./logger');
let transporter = nodemailer.createTransport({
	host: 'smtp.mailgun.org',
  port: 2525,
	auth: {
		user: 'postmaster@bluegatr.com',
		pass: '8b1f2bf2da9dbda433830211bbf1d72c'
	}
});

module.exports = {
    sendMail: function(options, callback) {
  		let mailOptions = {
  			from: 'LSNM <alphaity+lsnm@alphaity.io>',
  			to: 'Alphaity <alphaity@alphaity.io>',
  			bcc: '',
  			subject: 'New LSNM!', 
  			html: `<html><body>
                    <p>Resaurant:  ${options.restaurant} </p>
                    <p>Location:  ${options.location} </p>
                    <p>Day of week: ${options.day} <p>
                    <p>Special ${options.special} <p>
                    </body></html>`
  		};
  		sendEmailMessage(mailOptions, options, callback);
    }
};

function sendEmailMessage(mailOptions, options, callback){
	transporter.sendMail(mailOptions, function(error, info){
    	if(error){
        logger.log.error(`An error occured when sending an email to Alphaity.  They were requesting the location of ${options.location} and the restaurants of ${options.restaurants}`, error);
        callback(error, info); 
      } else{
        callback(null, info);
      }
	});
}
