
var _ = require('underscore');
var mysql = require('mysql');


var INSERT_OR_UPDATE_TEMPLATE = 'INSERT INTO :table (:keys) VALUES (:values) ON DUPLICATE KEY UPDATE :updates';


/**
 *
 * @param {string} table
 * @param {Array} data
 * @return {string} SQL builded
 */
var insertOrUpdate = function (table, data) {

    var keys = [];
    // find all possible keys
    data.forEach(function (row) {
        if (typeof row !== 'object')
            throw new Error('All rows in data must by JSON object');
        Object.keys(row).forEach(function (key) {
            if (!_.contains(keys, key)) {
                keys.push(key);
            }
        });
    });

    if (keys.length === 0)
        throw new Error('Data objects must contains any values');

    var values = [];
    // fill empty values
    data.forEach(function (row) {
        keys.forEach(function (key) {
            values.push(typeof row[key] !== 'undefined' ?row[key] :null);
        });
    });

    // build query
    var sql = ''+INSERT_OR_UPDATE_TEMPLATE;
    var inserts = [];

    // table
    sql = sql.replace(':table', '??');
    inserts.push(table);

    // keys
    var sqlKeys = [];
    keys.forEach(function (key) {
        sqlKeys.push('??');
        inserts.push(key);
    });
    sql = sql.replace(':keys', sqlKeys.join(', '));

    // values
    var sqlValues = [];
    values.forEach(function (value) {
        sqlValues.push('?');
        inserts.push(value);
    });
    sql = sql.replace(':values', sqlValues.join(', '));

    // updates
    var sqlUpdates = [];
    keys.forEach(function (key) {
        sqlUpdates.push('?? = VALUES(??)');
        inserts.push(key);
        inserts.push(key);
    });
    sql = sql.replace(':updates', sqlUpdates.join(', '));


    return mysql.format(sql, inserts);
};


exports = module.exports = {
    insertOrUpdate: insertOrUpdate
};
