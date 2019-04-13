const express = require('express');
const router = express.Router();
const User = require('../models/users');

// Create User
router.post('/', async (req, res) => {
    const body = { ...req.body };

    const token = Buffer.from(`${body.email}:${body.password}`).toString('base64');
    console.log(token);
    try {
        User.create({
            name: body.name,
            email: body.email,
            token
        }).then(userResult => {
            console.log(userResult);
            res.send({
                name: userResult.name,
                email: userResult.email,
                token: userResult.token
            });
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

// Login User
router.post('/login', async (req, res) => {
    const body = { ...req.body };
    try {
        const token = Buffer.from(`${body.email}:${body.password}`).toString('base64');
        User.findOne({ email: body.email }).then(userResult => {
            if(userResult && userResult.token === token) {
                res.send({
                    name: userResult.name,
                    email: userResult.email,
                    token: userResult.token,
                    kt: (userResult.kToken) ? true : false
                });
            } else {
                throw new Error;
            }
        }).catch(err => {
            console.error(err);
            res.status(400).send('Invalid options');
        })
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

// Get User Profile
router.get('/', async (req, res) => {
    try {
        const email = Buffer.from(req.headers.token, 'base64').toString('ascii').split(':')[0];
        console.log(email);
        User.findOne({ email }).then(userResult => {
            res.status(200).send(userResult);
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

module.exports = router;