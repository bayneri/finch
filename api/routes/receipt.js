const express = require('express');
const router = express.Router();
const Transaction = require('../models/transactions');
const ocrService = require('../services/ocr');

const AWS = require('aws-sdk');
AWS.config.loadFromPath('./config/s3_config.json');
const s3Bucket = new AWS.S3({ params: { Bucket: 'finch-img' } });

// Upload Receipt
router.post('/', async (req, res) => {
    const body = { ...req.body };
    try {
        const buf = new Buffer(body.image.replace(/^data:image\/\w+;base64,/, ""), 'base64');

        const data = {
            Key: body.transactionId,
            Body: buf,
            ContentEncoding: 'base64',
            ContentType: 'image/jpeg',
            ACL: 'public-read'
        };

        s3Bucket.putObject(data, (err, data) => {
            if (err) {
                console.error(err);
                console.error('Error uploading data: ', data);
                res.status(500).send('An error occured');
            } else {

                Transaction.findOne({ _id: body.transactionId }).then(async transaction => {
                    transaction.receiptUrl = `${process.env.S3_BASE_URL}/${encodeURI(body.transactionId)}`;

                    const result = await ocrService(transaction.receiptUrl, 29.04);
                    console.log(result)
                    transaction.items = result.map((el) => {
                        if (el.category == 'None') {
                            return {
                                name: el.name,
                                category: transaction.category,
                                totalAmount: el.totalAmount
                            }
                        }
                        else {
                            return el
                        }
                    });

                    Transaction.findOneAndUpdate({ _id: body.transactionId }, transaction).then(() => {

                        res.status(200).send(transaction);
                    }).catch(err => {
                        res.status(500).send('An error occured');
                    });
                })

            }
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

module.exports = router;