
var _ = require('underscore');
var pg = require('pg');


var INSERT_OR_UPDATE_TEMPLATE = 'WITH new_values (:keys) AS (VALUES :values), '
	+'upsert AS (UPDATE :table t SET :updates FROM new_values nv WHERE :ids RETURNING t.*) '
	+'INSERT INTO :table (:keys) SELECT DISTINCT :keys FROM new_values nv WHERE NOT EXISTS (SELECT 1 FROM upsert t WHERE :ids)';


/**
 *
 * @param {string} table
 * @param {Array} data
 * @return {string} SQL builded
 */
var insertOrUpdate = function (table, data) {
	var ids = getKeys(table);

	var keys = findPossibleKeys(data);
    if (keys.length === 0)
        throw new Error('Data objects must contains any values');

	var values = fillEmptyValues(data, keys);

    // build query
    var sql = ''+INSERT_OR_UPDATE_TEMPLATE;

	var sqlKeys = getSqlKeys(keys);
	var sqlValues = getSqlValues(values);
	var sqlUpdates = getSqlUpdates(keys);
	var sqlIds = getSqlIds(ids, keys);

	sql = sql.replace(/:keys/g, sqlKeys.join(', '));
	sql = sql.replace(/:values/g, sqlValues.join(', '));
	sql = sql.replace(/:table/g, escapeNative(table));
    sql = sql.replace(/:updates/g, sqlUpdates.join(', '));
	sql = sql.replace(/:ids/g, sqlIds.join(' OR '));

    return sql;
};

var findPossibleKeys = function (data) {
	var keys = [];
	data.forEach(function (row) {
		if (typeof row !== 'object')
			throw new Error('All rows in data must by JSON object');
		Object.keys(row).forEach(function (key) {
			if (!_.contains(keys, key)) {
				keys.push(key);
			}
		});
	});
	return keys;
};

var fillEmptyValues = function (data, keys) {
	var values = [];
	data.forEach(function (row) {
		var rowValues = [];
		keys.forEach(function (key) {
			rowValues.push(typeof row[key] !== 'undefined' ?row[key] :null);
		});
		values.push(rowValues);
	});
	return values;
};

var getSqlKeys = function (keys) {
	var sqlKeys = [];
	keys.forEach(function (key) {
		sqlKeys.push(escapeNative(key));
	});
	return sqlKeys;
};

var getSqlValues = function (values) {
	var sqlValues = [];
	values.forEach(function (rowValues) {
		var sqlRowValues = [];
		rowValues.forEach(function (value) {
			sqlRowValues.push(escapeValue(value));
		});
		sqlValues.push('('+sqlRowValues.join(', ')+')')
	});
	return sqlValues;
};

var getSqlUpdates = function (keys) {
	var sqlUpdates = [];
	keys.forEach(function (key) {
		sqlUpdates.push(escapeNative(key)+' = nv.'+escapeNative(key));
	});
	return sqlUpdates;
};

var getSqlIds = function (ids, allowedKeys) {
	var sqlIds = [];
	ids.forEach(function (keys) {
		for (var i in keys) {
			if (!_.contains(allowedKeys, keys[i]))
				return;
		}
		var sqlOneIds = [];
		keys.forEach(function (key) {
			sqlOneIds.push('t.'+escapeNative(key)+' = nv.'+escapeNative(key));
		});
		sqlIds.push(sqlOneIds.join(' AND '));
	});
	return sqlIds;
};

var getKeys = function (table) {
	// @TODO
	return [['ap_log_id'],['ap_code','date_access','role','mac_hash','type']];
};

var escapeNative = function (nativeValue) {
	return '"'+nativeValue+'"';
};

var escapeValue = function (value) {
	if (value == null || typeof value == 'undefined')
		return 'NULL';
	if (_.isNumber(value))
		return value;
	if (value.match(/\d{4,4}-\d{2,2}-\d{2,2} \d{2,2}:\d{2,2}:\d{2,2}/))
		return "TIMESTAMP '"+value+"'";
	return "'"+value+"'";
};

exports = module.exports = {
    insertOrUpdate: insertOrUpdate
};
