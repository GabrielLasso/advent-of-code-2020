import strutils, sequtils, tables, math

proc areThereBussesAvailable(timestamp: int, busses: openArray[int]): (bool, int) =
    for bus in busses:
        if timestamp mod bus == 0:
            return (true, bus)
    return (false, 0)

let input = readFile("input").strip().splitLines()
let initialTime = parseInt(input[0])
let ids = input[1].split(',')
var busses: Table[int, int]

for i, id in ids.pairs:
    if id != "x":
        busses[i] = parseInt(id)

var now = initialTime
var bus: int

# while(not now.areThereBussesAvailable(toSeq busses.values)[0]):
    # now += 1

bus = now.areThereBussesAvailable(toSeq busses.values)[1]
echo (now - initialTime) * bus

func modInv(a, m: int64): int64 =
    for x in 2..<m:
        if ((((a * x) mod m) + m) mod m) == 1:
            return x
    return 0

var a_i: seq[int64]
var m_i: seq[int64]
var mcomp_i: seq[int64]
var b_i: seq[int64]

for (a, m) in busses.pairs:
    a_i.add int64(-a)
    m_i.add int64(m)

let m: int64 = m_i.foldl(a * b)

for i in m_i:
    mcomp_i.add int64(float(m) / float(i))

for i in 0..<a_i.len:
    b_i.add modInv(mcomp_i[i], m_i[i])

var result: int64

for i in 0..<a_i.len:
    result += a_i[i] * b_i[i] * mcomp_i[i]

echo a_i
echo b_i
echo m_i
echo mcomp_i
echo ((result mod m) + m) mod m

echo modInv(247, 17)
