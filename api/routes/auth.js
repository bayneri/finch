const express = require('express');
const router = express.Router();
const request = require('request');
const Token = require("../models/tokens");
const User = require('../models/users');
const kuveytConfig = require('../config/kuveyt');

// Auth Kuveyt
router.get('/kuveyt', async (req, res) => {
  const config = { ...req.query };
  console.log(res);
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
      }, (err, response, body) => {
        console.log(body);
        let tokenObject = JSON.parse(body);
        if (!err && !tokenObject.error) {
          tokenObject.expires_at = Date.now() + tokenObject.expires_in;
          delete tokenObject.expires_in;
          tokenObject.state = config.state;
          tokenObject.scope = config.scope;
          console.log(tokenObject);

          Token.create(tokenObject).then(token => {
            const email = Buffer.from(token.state, 'base64').toString('ascii').split(':')[0];
            console.log(email);
            User.findOneAndUpdate({ email }, {kToken: token._id}).then(() => {
              return res.redirect(`KTInventOAuth://?token=${tokenObject.access_token}`)
            })
          });

        } else {
          return res.redirect(`KTInventOAuth://`)
        }
      });

    }
  } catch (err) {
    console.error(err);
    return res.redirect(`KTInventOAuth://`)
  }
});

module.exports = router;