const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    createdAt: {
        type: Date,
        default: Date.now,
        required: true
    }
});

const Users = mongoose.model('User', UserSchema);

module.exports = {
    create: user => Users.create(user),
    Users,
};
