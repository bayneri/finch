const express = require('express');
const router = express.Router();
const request = require('request');
const Token = require("../models/tokens");
const User = require('../models/users');
const kuveytConfig = require('../config/kuveyt');

// Auth Kuveyt
router.get('/kuveyt', async (req, res) => {
  const config = { ...req.query };
  console.log(config);
  try {
    if (config.code) {
      const form = {
        'grant_type': 'authorization_code',
        'code': config.code,
        'redirect_uri': kuveytConfig.redirect_uri,
        client_id: kuveytConfig.client_id,
        client_secret: kuveytConfig.client_secret
      };
      request({
        url: kuveytConfig.host,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': `Basic ${new Buffer(kuveytConfig.client_id + ":" + kuveytConfig.client_secret).toString("base64")}`
        },
        form,
        method: 'POST'
      }, (err, res, body) => {
        console.log(body);
        tokenObject = JSON.parse(body);
        if (!err && !tokenObject.error) {
          tokenObject.expires_at = Date.now() + tokenObject.expires_in;
          delete tokenObject.expires_in;
          console.log(tokenObject);

          Token.create(tokenObject).then(token => {
            const email = Buffer.from(tokenObject.state, 'base64').toString('ascii').split(':')[0];
            return User.findOneAndUpdate({ email }, {kToken: token._id});
          });

        } else {
          return;
        }
      });

    }
  } catch (err) {
    console.error(err);
    return;
  }
});

module.exports = router;