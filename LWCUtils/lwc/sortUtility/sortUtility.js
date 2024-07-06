/*eslint max-params: ["error", 4]*/
/* eslint-disable one-var, @lwc/lwc/no-for-of */
const groupRecordsBySortedField = (fieldName, data) => {
    const recordsBySortedField = [];

    /* eslint-disable id-length */
    for(const a of data) {
        if(recordsBySortedField[a[fieldName]]) {
            recordsBySortedField[a[fieldName]].push(a);
        } else {
            recordsBySortedField[a[fieldName]] = [a];
        }
    }

    return recordsBySortedField;
}

const sortRecords = (sortedFieldOrder, recordsBySortedField) => {
    const sortedData = [];

    /* eslint-disable id-length */
    for(const a of sortedFieldOrder) {
        if(recordsBySortedField[a]) {
            sortedData.push(... recordsBySortedField[a]);
        }
    }

    return sortedData;
}

const sortAlphabetic = (fieldName, data, sortDirection = 'asc') => {
    let sortedFieldOrder = [];
    const recordsBySortedField = groupRecordsBySortedField(fieldName, data);

    if(sortDirection === 'asc') {
        sortedFieldOrder = Object.keys(recordsBySortedField).sort();
    } else if(sortDirection === 'desc') {
        sortedFieldOrder = Object.keys(recordsBySortedField).sort().reverse();
    }

    const sortedData = sortRecords(sortedFieldOrder, recordsBySortedField);

    return sortedData;
}

const sortCustom = (fieldName, data, sortedFieldOrder, sortDirection = 'asc') => {
    const recordsBySortedField = groupRecordsBySortedField(fieldName, data);

    if(sortDirection === 'desc') {
        sortedFieldOrder = sortedFieldOrder.reverse(); // eslint-disable-line no-param-reassign
    }
    
    const sortedData = sortRecords(sortedFieldOrder, recordsBySortedField);

    return sortedData;
}

export { sortAlphabetic, sortCustom }