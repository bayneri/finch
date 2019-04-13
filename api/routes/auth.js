const express = require('express');
const router = express.Router();
const request = require('request');
const kuveytConfig = require('../config/kuveyt');

router.get('/kuveyt', async (req, res) => {
  const config = {...req.query};
  try {
    if(config.code) {
      const form = {
        'grant_type': 'authorization_code',
        'code': config.code,
        'redirect_uri': kuveytConfig.redirect_uri
      };
      request.post(kuveytConfig.host, {form}, (err, res, body) => {
        if(!err) {
          // save token
        }
      });

    }
  } catch (err) {
    console.error(err);
    res.status(400).send('Invalid options');
    log(config, null);
  }
});

router.get('/kuveyt/:state', async (req, res) => {
  try {
  } catch (err) {
    console.error(err);
    res.status(400).send('Invalid options');
    log(config, null);
  }
});

module.exports = router;
