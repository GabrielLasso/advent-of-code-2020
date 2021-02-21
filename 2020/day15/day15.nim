import strutils, times

let input = readFile("input").strip.split(',')

const size = 30000000

var birthTime: array[size, int]
var hasKey: array[size, bool]
var lastNumber, nextNumber: int

echo "Starting"
let start = getTime()
for i in 0..<size:
    if (i < input.len):
        nextNumber = parseInt(input[i])
    else:
        if not hasKey[lastNumber]:
            nextNumber = 0
        else:
            nextNumber = i - birthTime[lastNumber]
    if (i != 0):
        birthTime[lastNumber] = i
        hasKey[lastNumber] = true
    lastNumber = nextNumber

echo lastNumber

echo "Time taken: ", getTime() - start
