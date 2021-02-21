import sequtils, strutils, tables, sets, hashes

type
    Range = object
        min, max: int
    Rule = object
        name: string
        ranges: seq[Range]

proc hash(x: Rule): Hash = x.name.hash

let input = readFile("input").strip

var rules: seq[Rule]

for line in input.split("\r\n\r\n")[0].splitLines:
    var rule: Rule
    rule.name = line.split(":")[0]
    for r in line.split(": ")[1].split(" or "):
        var newRange: Range
        newRange.min = parseInt(r.split('-')[0])
        newRange.max = parseInt(r.split('-')[1])
        rule.ranges.add(newRange)
    rules.add(rule)

let tickets = input.split("\r\n\r\n")[2].splitLines[1 .. ^1].mapIt(it.split(',').mapIt(parseInt(it)))

proc isValidField(field: int): HashSet[Rule] =
    for rule in rules:
        for rng in rule.ranges:
            if field >= rng.min and field <= rng.max:
                result.incl(rule)

var validTicket: seq[seq[int]]

var errorRate: int

for ticket in tickets:
    var isValid = true
    for field in ticket:
        if (isValidField(field).len == 0):
            errorRate += field
            isValid = false
    if isValid:
        validTicket.add(ticket)

echo errorRate

var possibilities = initTable[int, HashSet[Rule]]()

for i, rule in rules.pairs:
    possibilities.add(i, rules.toHashSet)

var orderedRules: seq[Rule] = newSeq[Rule](rules.len)

while toSeq(possibilities.values).mapIt(it.len).max > 1:
    for ticket in validTicket:
        for i ,value in ticket.pairs:
            possibilities[i] = possibilities[i] * isValidField(value)
    if toSeq(possibilities.values).mapIt(it.len).filterIt(it > 0).min == 1:
        for i, p in possibilities.pairs:
            if p.len == 1:
                var po = p
                orderedRules[i] = po.pop()
                rules = rules.filterIt(it != orderedRules[i])

let myTicket = input.split("\r\n\r\n")[1].splitLines[1].split(',').mapIt(parseInt(it))

var result = 1'i64

for i, rule in orderedRules.pairs:
    if rule.name.len > 8 and rule.name[0..8] == "departure":
        result *= myTicket[i]

echo result
