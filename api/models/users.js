const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    email: {
        type: String,
        required: true,
        unique: true
    },
    name: {
        type: String,
        required: true
    },
    token: {
        type: String,
        required: true,
        unique: true
    },
    kToken: {
        type: String
    },
    createdAt: {
        type: Date,
        default: Date.now,
        required: true
    }
});

const Users = mongoose.model('User', UserSchema);

module.exports = {
    create: user => Users.create(user),
    findOne: user => Users.findOne(user),
    find: user => Users.find(user),
    Users,
};
