const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TokenSchema = new Schema({
    state: {
        type: String,
        required: true
    },
    access_token: {
        type: String,
        required: true
    },
    refresh_token: {
        type: String,
        required: true
    },
    scope: {
        type: String,
        required: true
    },
    expires_in: {
        type: Date,
        default: Date.now,
        required: true
    }
});

const Tokens = mongoose.model('Token', TokenSchema);

module.exports = {
    create: token => Tokens.create(token),
    Tokens,
};
