import strutils, lists, sequtils

let
    input = readFile("input").strip().split('\n').mapIt(parseBiggestInt(it.strip))
    size = len input

var last25 = initSinglyLinkedList[BiggestInt]()
var k: BiggestInt

for i in 0..24:
    last25.append(input[i])

proc hasPairThatAddsTo(list: SinglyLinkedList[BiggestInt], x: BiggestInt): bool =
    for i in list:
        if list.contains(x - i):
            return true
    return false

proc findSubsequenceWithSum(sequence: seq[BiggestInt], desiredSum: BiggestInt): (int, int) =
    while sequence[result[0]..result[1]].foldl(a + b) != desiredSum:
        if sequence[result[0]..result[1]].foldl(a + b) < desiredSum:
            result[1] += 1
        else:
            result[0] += 1

for i in 25..size-1:
    let value = input[i]
    if not last25.hasPairThatAddsTo(value):
        echo value
        k = value
        break
    last25.head = last25.head.next
    last25.append value

let (lo, hi) = input.findSubsequenceWithSum(k)
echo input[lo..hi].max() + input[lo..hi].min()
