const txn = require('./txn');
const request = require('request');
let date = 1549944180;

const createTxn = ind => {
    const transaction = {
        name: txn[ind].name,
        totalAmount: txn[ind].totalAmount,
        category: txn[ind].category,
        user: txn[ind].user,
        items: txn[ind].items,
        createdAt: new Date((date + ind * 43200) * 1000)
    };

    request({
        url: 'http://localhost:5000/transaction',
        headers: {
          'Content-Type': 'application/json',
          'token': `aGFsaWxAY2V0aW5lci5tZTp0ZXN0MTIzNDU2`
        },
        form: transaction,
        method: 'POST'
      }, (err, res, body) => {
          if(err) {
              console.log(err);
          }
          if(ind % 5 == 0) {
              console.log(ind);
          }
          createTxn(ind + 1);
      });
}

createTxn(1);