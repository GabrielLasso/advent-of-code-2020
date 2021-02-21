import strutils, sequtils, algorithm

let
    input = readFile("input").strip().split('\n').mapIt(parseInt(it.strip))
    sorted = input.sorted

var
    dif1, dif3: int
    previous: int

for i in sorted:
    if i - previous == 1:
        dif1 += 1
    if i - previous == 3:
        dif3 += 1
    previous = i

echo dif1 * (dif3 + 1)

var possibleWaysFrom = newSeq[BiggestInt](input.len)

var index = input.len
possibleWaysFrom[index - 1] = 1
for i in sorted.reversed:
    index -= 1
    if (index + 1 < input.len and sorted[index + 1] - i <= 3):
        possibleWaysFrom[index] += possibleWaysFrom[index + 1]
    if (index + 2 < input.len and sorted[index + 2] - i <= 3):
        possibleWaysFrom[index] += possibleWaysFrom[index + 2]
    if (index + 3 < input.len and sorted[index + 3] - i <= 3):
        possibleWaysFrom[index] += possibleWaysFrom[index + 3]

var total: BiggestInt
if (sorted[0] <= 3):
    total += possibleWaysFrom[0]
if (sorted[1] <= 3):
    total += possibleWaysFrom[1]
if (sorted[2] <= 3):
    total += possibleWaysFrom[2]

echo total
