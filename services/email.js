var nodemailer = require('nodemailer');
var transporter = nodemailer.createTransport({
	host: 'smtp.mailgun.org',
    port: 2525,
	auth: {
		user: 'postmaster@bluegatr.com',
		pass: '8b1f2bf2da9dbda433830211bbf1d72c'
	}
});

module.exports = {

    sendMail: function(options) {
		var mailOptions = {
			from: 'LSNM <alphaity+lsnm@alphaity.io>',
            // to: 'Nick Stalter <nickstalter@gmail.com>',
			to: 'Alphaity <alphaity@alphaity.io>',
			bcc: '',
			subject: 'New LSNM!', 
			html: '<html><body>' + 
                  '<p>Location: ' +  options.location + '</p>' + 
                  '<p>Resaurant(s): ' + options.restaurants + '</p>' +
                  '</body></html>'
		};

		sendEmailMessage(mailOptions);
    }
};
//Add error logging and correct flash messages
function sendEmailMessage(mailOptions){
	transporter.sendMail(mailOptions, function(error, info){
    	if(error){
        	return console.log(error);
    	}
    	console.log('Message sent: ' + info.response);
	});
}
