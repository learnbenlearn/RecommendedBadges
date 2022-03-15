const sortAlphabetic = (fieldName, data, sortDirection = 'asc') => {
    let sortedFieldOrder = [];

    let recordsBySortedField = groupRecordsBySortedField(fieldName, data);

    if(sortDirection === 'asc') {
        sortedFieldOrder = Object.keys(recordsBySortedField).sort();
    } else if(sortDirection === 'desc') {
        sortedFieldOrder = Object.keys(recordsBySortedField).sort().reverse();
    }

    let sortedData = sortRecords(sortedFieldOrder, recordsBySortedField);

    return sortedData;
}

const sortCustom = (fieldName, data, sortedFieldOrder, sortDirection = 'asc') => {
    let recordsBySortedField = groupRecordsBySortedField(fieldName, data);

    if(sortDirection === 'desc') {
        sortedFieldOrder = sortedFieldOrder.reverse();
    }
    
    let sortedData = sortRecords(sortedFieldOrder, recordsBySortedField);

    return sortedData;
}

let groupRecordsBySortedField = (fieldName, data) => {
    let recordsBySortedField = [];

    for(let a of data) {
        if(recordsBySortedField[a[fieldName]]) {
            recordsBySortedField[a[fieldName]].push(a);
        } else {
            recordsBySortedField[a[fieldName]] = [a];
        }
    }

    return recordsBySortedField;
}

let sortRecords = (sortedFieldOrder, recordsBySortedField) => {
    let sortedData = [];

    for(let a of sortedFieldOrder) {
        if(recordsBySortedField[a]) {
            sortedData.push(... recordsBySortedField[a]);
        }
    }

    return sortedData;
}

export { sortAlphabetic, sortCustom }
