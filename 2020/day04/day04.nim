import strutils, tables, sequtils, parseutils

let input = readFile "input"

var validPassports = 0

func validatePassport(passport: string, validator: proc(key, val: string): bool): bool =
    var missingKeys = {
        "byr": true,
        "iyr": true,
        "eyr": true,
        "hgt": true,
        "hcl": true,
        "ecl": true,
        "pid": true,
        "cid": false
    }.toTable
    result = true
    for field in passport.split({' ', '\n'}):
        let key = field.split(':')[0]
        let value = field.split(':')[1]
        if (validator(key, value.strip)):
            missingKeys[key] = false
    for isMissing in missingKeys.values:
        if isMissing:
            result = false

func emptyValidator(key, val: string): bool = true

func validator(key, val: string): bool =
    case key:
        of "byr":
            var value: int
            discard val.parseInt(value)
            result = value >= 1920 and value <= 2002
        of "iyr":
            var value: int
            discard val.parseInt(value)
            result = value >= 2010 and value <= 2020
        of "eyr":
            var value: int
            discard val.parseInt(value)
            result = value >= 2020 and value <= 2030
        of "hgt":
            var value: int
            discard val[0..^3].parseInt(value)
            let unit = val[^2..^1]
            case unit:
                of "cm":
                    result = value >= 150 and value <= 193
                of "in":
                    result = value >= 59 and value <= 76
                else:
                    result = false
        of "hcl":
            result = val.len == 7 and val[0] == '#'
        of "ecl":
            result = val in @["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        of "pid":
            result = val.map(isDigit).foldl(a and b) and val.len == 9
        else:
            result = false
    

for passport in input.split("\r\n\r\n"):
    var valid = validatePassport(passport, emptyValidator)

    if valid:
        validPassports += 1

echo validPassports

validPassports = 0
for passport in input.split("\r\n\r\n"):
    var valid = validatePassport(passport, validator)

    if valid:
        validPassports += 1

echo validPassports
