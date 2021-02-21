import npeg, tables, strutils, sequtils

type
    RuleKind = enum Character, Sequence, Choice
    Rule = ref object
        case kind: RuleKind:
        of Character: letter: char
        of Sequence: ids: seq[int]
        of Choice: rule1, rule2: Rule

var currentRule: Rule
var rules: Table[int, Rule]
var messages: seq[string]
let parser = peg("rules"):
    rules <- *rule * "\r\n" * *message
    rule <- >+Digit * ": " * (ch | choice | sequence) * "\r\n":
        rules[parseInt($1)] = currentRule
    ch <- '"' * >Alpha * '"':
        currentRule = Rule(kind: Character, letter: ($1)[0])
    choice <- >sequence * " | " * >sequence:
        currentRule = Rule(kind: Choice,
                           rule1: Rule(kind: Sequence, ids: ($1).split(
                                   ' ').mapIt(parseInt(it))),
                           rule2: Rule(kind: Sequence, ids: ($2).split(
                                   ' ').mapIt(parseInt(it))))
    sequence <- +Digit * *(' ' * +Digit):
        currentRule = Rule(kind: Sequence, ids: ($0).split(' ').mapIt(parseInt(it)))
    message <- >+Alpha * "\r\n":
        messages.add($1)

echo parser.matchFile("input")

proc matchLen(message: string, rule = rules[0]): int =
    if message.len == 0: return 0
    case rule.kind:
    of Character:
        if message[0] == rule.letter: return 1 else: return 0
    of Choice:
        return max(matchLen(message, rule.rule1), matchLen(message, rule.rule2))
    of Sequence:
        var index = 0
        for id in rule.ids:
            let match = matchLen(message[index..message.len - 1], rules[id])
            if match == 0:
                return 0
            index += match
        return index

proc isValid(message: string): bool =
    message.matchLen() == message.len

echo messages.filter(isValid).len

# Rule 0 is 8 11, which is (42 | 42 8) (42 31 | 42 11 31) or, equivalently, 42+ 41{n} 31{n}
proc isValid2(message: string): bool =
    var matches42 = 0
    var matches31 = 0
    var index = 0
    while message[index..message.high].matchLen(rules[42]) > 0:
        matches42 += 1
        index += message[index..message.high].matchLen(rules[42])
    while message[index..message.high].matchLen(rules[31]) > 0:
        matches31 += 1
        index += message[index..message.high].matchLen(rules[31])
    return matches42 > matches31 and matches31 > 0 and index == message.len

echo messages.filter(isValid2).len
