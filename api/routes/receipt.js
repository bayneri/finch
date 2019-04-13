const express = require('express');
const router = express.Router();

const AWS = require('aws-sdk');
AWS.config.loadFromPath('./config/s3_config.json');
const s3Bucket = new AWS.S3( { params: {Bucket: 'finch-img'} } );

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
                const imageUrl = `${process.env.S3_BASE_URL}/${encodeURI(body.transactionId)}`;
                console.log(imageUrl);

                res.send({imageUrl});
            }
        });
    } catch (err) {
        console.error(err);
        res.status(400).send('Invalid options');
    }
});

module.exports = router;