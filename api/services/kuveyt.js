const Transaction = require('../models/transactions');

const getTransactions = (user, token) =>  {
    const transactions = [{
        name: 'Carrefour SA',
        totalAmount: 29.04,
        category: 'Market',
        user: user,
        createdAt: new Date((1555237263) * 1000)
    },{
        name: 'Shell',
        totalAmount: 150,
        category: 'Benzin',
        user: user,
        createdAt: new Date((1555214000) * 1000)
    },{
        name: 'Migros Ticaret',
        totalAmount: 132.4,
        category: 'Market',
        user: user,
        createdAt: new Date((1555241414) * 1000)
    }];

    console.log(transactions);
    Transaction.create(transactions[0]).then(tr => {
        console.log(tr);
        console.log(0);
        Transaction.create(transactions[1]).then(() => {
            console.log(1);
            Transaction.create(transactions[2]).then(() => {
                console.log(2);
                return;
            });
        });
    });
}

module.exports = { getTransactions };