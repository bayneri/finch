const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TransactionSchema = new Schema({
    user: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: true
    },
    category: {
        type: String,
        required: true
    },
    totalAmount: {
        type: Number,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now(),
        required: true
    },
    items: {
        type: [Object]
    },
    receiptUrl: {
        type: String
    }
});

const Transactions = mongoose.model('Transaction', TransactionSchema);

module.exports = {
    create: transaction => Transactions.create(transaction),
    findOne: transaction => Transactions.findOne(transaction),
    find: (query, select, options) => Transactions.find(query, select, options),
    findOneAndUpdate: (query, params) => Transactions.findOneAndUpdate(query, params),
    Transactions,
};
