const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const StatsSchema = new Schema({
    name: {
        type: String
    }
});

const Stats = mongoose.model('Stats', StatsSchema);

module.exports = {
    findOne: q => Stats.findOne({}),
    Stats
};
