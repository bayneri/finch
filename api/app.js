const express = require('express');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const db = require('./helpers/db');
const cluster = require('cluster');

const app = express();

// Load the variables in .env file to the process.env
dotenv.config();

if (cluster.isMaster && process.env.NODE_ENV!='test') { // cluster to handle a large volume of requests
  console.log('Server is active. Forking workers now.');
  const cpuCount = require('os').cpus().length - 1;
  for (let i = 0; i < cpuCount; i++) {
    cluster.fork();
  }
  cluster.on('exit', function (worker) {
    console.log('Worker %s has died! Creating a new one.', worker.id);
    cluster.fork();
  });
} else {
  // Connect to the db and listen if success
  db
    .connect()
    .on('error', console.error)
    .on('disconnected', db.connect)
    .once('open', () => {
      app.listen(process.env.PORT || 5000, '0.0.0.0');
      console.log(`Listening on port: ${process.env.PORT}`);
    });

  // Configure Middlewares
  app.use(morgan(process.env.LOGGING_LEVEL || 'tiny'));
  app.use(bodyParser.json({ limit: '500mb' }));
  app.use(bodyParser.urlencoded({
    extended: true
  }));
  app.use(bodyParser.text());
  app.use(bodyParser.json({
    type: 'application/json'
  }));

  // Configure Routes
  app.use('/auth', require('./routes/auth'));
  app.use('/user', require('./routes/user'));
  app.use('/transaction', require('./routes/transaction'));
  app.use('/receipt', require('./routes/receipt'));
}

module.exports = app; //for testing