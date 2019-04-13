const mongoose = require('mongoose');

exports.connect = () => {
  const host = process.env.DB_HOST;
  const port = process.env.DB_PORT;
  const user = process.env.DB_USER;
  const pass = process.env.DB_PASS;
  const name = process.env.DB_NAME;

  const url = `mongodb://${user}:${pass}@${host}:${port}/${name}`

  mongoose.connect(`${url}`);
  return mongoose.connection;
};
