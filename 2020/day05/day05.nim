import algorithm, strutils, sequtils

let input = readFile("input").split('\n').mapIt(strip(it))

proc decodeSeatNumber(codified: string): int =
    if codified.len != 10: return
    let codifiedRow = codified[0..6]
    let codifiedColumn = codified[7..9]
    var
        row = 0
        column = 0
        i = 1
    for letter in codifiedRow.reversed:
        if letter == 'B':
            row += i
        i *= 2

    i = 1
    for letter in codifiedColumn.reversed:
        if letter == 'R':
            column += i
        i *= 2
    result = row * 8 + column

let seats = input.map(decodeSeatNumber).filterIt(it > 0)

echo max(seats)

var prevSeat = min(seats)
for seat in seats.sorted:
    if seat - prevSeat == 2:
        echo seat - 1
    prevSeat = seat
