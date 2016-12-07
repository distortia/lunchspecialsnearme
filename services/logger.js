const winston = require('winston');
const fs = require('fs');
const logDir = 'logs';
if(!fs.existsSync(logDir)){
  fs.mkdirSync(logDir);
}

const logger = new(winston.Logger)({
  transports: [
    new(winston.transports.File)({
      filename: `logs/error_log.log`,
      timestamp: (new Date().toLocaleTimeString()),
      level: 'error'
    })
  ]
});

module.exports.log = logger;