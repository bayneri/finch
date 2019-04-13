const express = require('express');
const router = express.Router();
const User = require('../models/users');

router.post('/', async (req, res) => {
    const body = { ...req.body };
    try {
        User.create({
            name: body.name,
            email: body.email,
            token: Buffer.from(`${body.email}:${body.password}`).toString('base64')
        }, userObject => {
            res.send(userObject);
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

router.post('/login', async (req, res) => {
    const body = { ...req.body };
    try {
        const token = Buffer.from(`${body.email}:${body.password}`).toString('base64');
        User.findOne({ token }).then(userResult => {
            if(userResult) {
                res.send(userResult);
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

router.get('/', async (req, res) => {
    const body = { ...req.body };
    console.log(body);
    try {
        const token = Buffer.from(`${body.email}:${body.password}`).toString('base64');
        User.findOne({ token }).then(userResult => {
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

module.exports = router;