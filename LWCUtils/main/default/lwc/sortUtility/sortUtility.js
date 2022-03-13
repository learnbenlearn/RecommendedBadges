const sortData = (fieldName, sortDirection, data) => {
    let newData = []
    let sortedFieldValues = []

    for(let a of data){
        sortedFieldValues.push(a[fieldName])
    }

    if(sortDirection === 'asc') {
        sortedFieldValues = sortedFieldValues.sort()
    } else if(sortDirection === 'desc') {
        sortedFieldValues = sortedFieldValues.sort().reverse()
    }

    for(let a of data) {
        newData[sortedFieldValues.indexOf(a[fieldName])] = a

        // janky solution to still sort when field values are identical (e.g. a lot of people have passed cert so we don't want to
        // continually overwrite the value at that index or newData will be emtpyish and lonely)
        sortedFieldValues[sortedFieldValues.indexOf(a[fieldName])] = null
    }

    return newData  
}

export { sortData }