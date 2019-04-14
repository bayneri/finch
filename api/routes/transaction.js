const express = require('express');
const router = express.Router();
const Transaction = require('../models/transactions');

// Update Transaction
router.put('/:_id', async (req, res) => {
    console.log(req.params);
    try {
        Transaction.findOneAndUpdate({
                _id: req.params.id
            },
            req.body
        ).then(transactionResult => {
            res.send(transactionResult);
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

// Get Transactions
router.get('/', async (req, res) => {
    const email = Buffer.from(req.headers.token, 'base64').toString('ascii').split(':')[0];
    try {
        Promise.all([
            Transaction.find({
                    user: email
                }),
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
            )
        ]).then(([transactions, groups]) => {
            transactions.sort((a, b) => (a.createdAt > b.createdAt) ? -1 : ((b.createdAt > a.createdAt) ? 1 : 0)); 
            groups.sort((a, b) => (a._id > b._id) ? -1 : ((b._id > a._id) ? 1 : 0)); 
            let ind = 0;
            for (let i in groups) {
                groups[i].transactions = transactions.slice(ind, ind + groups[i].count);
                groups[i].date = groups[i]._id;
                delete groups[i]._id;
                ind += groups[i].count;
            }

            res.status(200).send({
                transactions: groups
            });
        }).catch(err => {
            console.error(err);
            res.status(400).send('Invalid options');
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

// Get Transaction
router.get('/:id', async (req, res) => {
    try {
        Transaction.findOne({
            _id: req.params.id
        }).then(transactionResult => {
            if (transactionResult) {
                res.send(transactionResult);
            } else {
                throw new Error;
            }
        }).catch(err => {
            console.error(err);
            res.status(400).send('Invalid options');
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

// Create Transactions
router.post('/', async (req, res) => {
    const email = Buffer.from(req.headers.token, 'base64').toString('ascii').split(':')[0];
    const body = {
        ...req.body
    }
    try {
        body.user = email;
        Transaction.create(body).then(transactionResult => {
            res.send(transactionResult);
        }).catch(err => {
            console.error(err);
            res.status(400).send('Invalid options');
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

module.exports = router;