import strutils, sequtils

let input = readFile("input").strip().split('\n').mapIt(it.strip)

var map = input


proc countAdjacentOccupiedSeats(map: seq[string], i, j, lenght: int): int =
    if (i > 0 and map[i-1][j] == '#'): result += 1
    if (i > 0 and j > 0 and map[i-1][j-1] == '#'): result += 1
    if (j > 0 and map[i][j-1] == '#'): result += 1
    if (i < map.len - 1 and j > 0 and map[i+1][j-1] == '#'): result += 1
    if (i < map.len - 1 and map[i+1][j] == '#'): result += 1
    if (i < map.len - 1 and j < lenght - 1 and map[i+1][j+1] == '#'): result += 1
    if (j < lenght - 1 and map[i][j+1] == '#'): result += 1
    if (i > 0 and j < lenght - 1 and map[i-1][j+1] == '#'): result += 1

proc countVisibleOccupiedSeats(map: seq[string], i, j, lenght: int): int =
    var
        i2 = i
        j2 = j
    while (i2 > 0):
        if (i2 > 0 and map[i2-1][j] == '#'):
            result += 1
            break
        if (i2 > 0 and map[i2-1][j] == 'L'):
            break
        i2 -= 1
    i2 = i
    j2 = j
    while (i2 > 0 and j2 > 0):
        if (i2 > 0 and j2 > 0 and map[i2-1][j2-1] == '#'):
            result += 1
            break
        if (i2 > 0 and j2 > 0 and map[i2-1][j2-1] == 'L'):
            break
        i2 -= 1
        j2 -= 1
    i2 = i
    j2 = j
    while (j2 > 0):
        if (j2 > 0 and map[i2][j2-1] == '#'):
            result += 1
            break
        if (j2 > 0 and map[i2][j2-1] == 'L'):
            break
        j2 -= 1
    i2 = i
    j2 = j
    while (i2 < map.len - 1 and j2 > 0):
        if (i2 < map.len - 1 and j2 > 0 and map[i2+1][j2-1] == '#'):
            result += 1
            break
        if (i2 < map.len - 1 and j2 > 0 and map[i2+1][j2-1] == 'L'):
            break
        i2 += 1
        j2 -= 1
    i2 = i
    j2 = j
    while (i2 < map.len - 1):
        if (i2 < map.len - 1 and map[i2+1][j2] == '#'):
            result += 1
            break
        if (i2 < map.len - 1 and map[i2+1][j2] == 'L'):
            break
        i2 += 1
    i2 = i
    j2 = j
    while (i2 < map.len - 1 and j2 < lenght):
        if (i2 < map.len - 1 and j2 < lenght - 1 and map[i2+1][j2+1] == '#'):
            result += 1
            break
        if (i2 < map.len - 1 and j2  < lenght - 1 and map[i2+1][j2+1] == 'L'):
            break
        i2 += 1
        j2 += 1
    i2 = i
    j2 = j
    while (j2 < lenght):
        if (j2 < lenght - 1 and map[i2][j2+1] == '#'):
            result += 1
            break
        if (j2  < lenght - 1 and map[i2][j2+1] == 'L'):
            break
        j2 += 1
    i2 = i
    j2 = j
    while (i > 0 and j2 < lenght):
        if (i2 > 0 and j2 < lenght - 1 and map[i2-1][j2+1] == '#'):
            result += 1
            break
        if (i2 > 0 and j2 < lenght - 1 and map[i2-1][j2+1] == 'L'):
            break
        i2 -= 1
        j2 += 1

proc step(map: var seq[string]) =
    var tmp: seq[string] = map
    for (i, line) in map.pairs:
        for (j, pos) in line.pairs:
            case pos:
                of 'L':
                    if not ((i > 0 and map[i-1][j] == '#') or
                    (i > 0 and j > 0 and map[i-1][j-1] == '#') or
                    (j > 0 and map[i][j-1] == '#') or
                    (i < map.len - 1 and j > 0 and map[i+1][j-1] == '#') or
                    (i < map.len - 1 and map[i+1][j] == '#') or
                    (i < map.len - 1 and j < line.len - 1 and map[i+1][j+1] == '#') or
                    (j < line.len - 1 and map[i][j+1] == '#') or
                    (i > 0 and j < line.len - 1 and map[i-1][j+1] == '#')
                    ):
                        tmp[i][j] = '#'
                of '#':
                    var counter = map.countAdjacentOccupiedSeats(i, j, line.len)

                    if counter >= 4: tmp[i][j] = 'L'
                else:
                    continue
    map = tmp


proc stepB(map: var seq[string]) =
    var tmp: seq[string] = map
    for (i, line) in map.pairs:
        for (j, pos) in line.pairs:
            case pos:
                of 'L':
                    var counter = map.countVisibleOccupiedSeats(i, j, line.len)

                    if counter == 0:
                        tmp[i][j] = '#'
                of '#':
                    var counter = map.countVisibleOccupiedSeats(i, j, line.len)

                    if counter >= 5: tmp[i][j] = 'L'
                else:
                    continue
    map = tmp

proc countAcupiedSeats(map: seq[string]): int =
    for line in map:
        for pos in line:
            if pos == '#':
                result += 1

var oldMap = map
var changed = true
while changed:
    step(map)
    changed = (map != oldMap)
    oldMap = map

echo countAcupiedSeats map

map = input
oldMap = map
changed = true
while changed:
    stepB(map)
    changed = (map != oldMap)
    oldMap = map

echo countAcupiedSeats map
