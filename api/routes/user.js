const express = require('express');
const router = express.Router();
const User = require('../models/users');
const Transaction = require('../models/transactions');
const Stats = require('../models/stats');

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
                console.error(err);
                res.status(401).send('Unauthorized');
            }
        }).catch(err => {
            console.error(err);
            res.status(500).send('An error occured');
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
        Promise.all([
            User.findOne({ email }),
            Transaction.Transactions.aggregate(
                [{
                        $match: {
                            user: email
                        }
                    },
                    {
                        $group: {
                            _id: {
                                $dateToString: {
                                    format: "%Y-%m-%d",
                                    date: "$createdAt"
                                }
                            },
                            count: {
                                $sum: 1
                            }
                        }
                    }
                ]
            ),
            Stats.findOne({ user: email })
        ]).then(([userResult, transactions, stats]) => {
            for(let transaction of transactions) {
                transaction.user = userResult;
            }

            delete stats._id;
            res.status(200).send(stats);
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

module.exports = router;