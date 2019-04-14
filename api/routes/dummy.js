const express = require('express');
const router = express.Router();
const kuveytService = require('../services/kuveyt');

router.post('/', async (req, res) => {
    console.log("here");
    try {
        const email = Buffer.from(req.headers.token, 'base64').toString('ascii').split(':')[0];
        console.log(email);
        kuveytService.getTransactions(email, req.headers.token);

        res.send();
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

module.exports = router;