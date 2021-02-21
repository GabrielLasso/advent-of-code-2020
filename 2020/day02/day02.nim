import strutils, sets

type Rule = object
    min, max: int
    c: char
    password: string

func isValid(password: string, min, max: int, c: char): bool =
    var counter = 0
    for ch in password:
        if ch == c:
            counter += 1
    if min <= counter and counter <= max:
        result = true

func isValid(rule: Rule): bool = 
    result = rule.password.isValid(rule.min, rule.max, rule.c)

func isValid2(password: string, min, max: int, c: char): bool =
    result = password[min - 1] == c xor password[max - 1] == c

func isValid2(rule: Rule): bool = 
    result = rule.password.isValid2(rule.min, rule.max, rule.c)

func parseRule(input: string): Rule = 
    let
        fields = input.split({' ', '-'})
        min = fields[0].parseInt
        max = fields[1].parseInt
        c = fields[2][0]
        pwd = fields[3]
    result.min = min
    result.max = max
    result.c = c
    result.password = pwd

var
    validPasswords: int
    valid2Passwords: int

for line in lines("input"):
    let rule = line.parseRule()
    if (rule.isValid()):
        validPasswords += 1
    if (rule.isValid2()):
        valid2Passwords += 1

echo validPasswords
echo valid2Passwords