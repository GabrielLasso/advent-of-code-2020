import strutils

var  world: array[-8..13, array[-8..13, array[-8..13, bool]]]
var  world4d: array[-8..13, array[-8..13, array[-8..13, array[-8..13, bool]]]]

proc getAdjacentAliveCells(i, j, k: int): int =
    result = int(world[i-1][j+1][k+1]) + int(world[i][j+1][k+1]) + int(world[i+1][j+1][k+1]) +
             int(world[i-1][j][k+1])   + int(world[i][j][k+1])   + int(world[i+1][j][k+1]) +
             int(world[i-1][j-1][k+1]) + int(world[i][j-1][k+1]) + int(world[i+1][j-1][k+1]) +

             int(world[i-1][j+1][k]) + int(world[i][j+1][k]) + int(world[i+1][j+1][k]) +
             int(world[i-1][j][k])   +                       + int(world[i+1][j][k]) +
             int(world[i-1][j-1][k]) + int(world[i][j-1][k]) + int(world[i+1][j-1][k]) +

             int(world[i-1][j+1][k-1]) + int(world[i][j+1][k-1]) + int(world[i+1][j+1][k-1]) +
             int(world[i-1][j][k-1])   + int(world[i][j][k-1])   + int(world[i+1][j][k-1]) +
             int(world[i-1][j-1][k-1]) + int(world[i][j-1][k-1]) + int(world[i+1][j-1][k-1])

proc getAdjacentAliveCells4d(i, j, k, l: int): int =
    result = int(world4d[i-1][j+1][k+1][l+1]) + int(world4d[i][j+1][k+1][l+1]) + int(world4d[i+1][j+1][k+1][l+1]) +
             int(world4d[i-1][j][k+1][l+1])   + int(world4d[i][j][k+1][l+1])   + int(world4d[i+1][j][k+1][l+1]) +
             int(world4d[i-1][j-1][k+1][l+1]) + int(world4d[i][j-1][k+1][l+1]) + int(world4d[i+1][j-1][k+1][l+1]) +

             int(world4d[i-1][j+1][k][l+1]) + int(world4d[i][j+1][k][l+1]) + int(world4d[i+1][j+1][k][l+1]) +
             int(world4d[i-1][j][k][l+1])   + int(world4d[i][j][k][l+1])   + int(world4d[i+1][j][k][l+1]) +
             int(world4d[i-1][j-1][k][l+1]) + int(world4d[i][j-1][k][l+1]) + int(world4d[i+1][j-1][k][l+1]) +

             int(world4d[i-1][j+1][k-1][l+1]) + int(world4d[i][j+1][k-1][l+1]) + int(world4d[i+1][j+1][k-1][l+1]) +
             int(world4d[i-1][j][k-1][l+1])   + int(world4d[i][j][k-1][l+1])   + int(world4d[i+1][j][k-1][l+1]) +
             int(world4d[i-1][j-1][k-1][l+1]) + int(world4d[i][j-1][k-1][l+1]) + int(world4d[i+1][j-1][k-1][l+1]) +


             int(world4d[i-1][j+1][k+1][l]) + int(world4d[i][j+1][k+1][l]) + int(world4d[i+1][j+1][k+1][l]) +
             int(world4d[i-1][j][k+1][l])   + int(world4d[i][j][k+1][l])   + int(world4d[i+1][j][k+1][l]) +
             int(world4d[i-1][j-1][k+1][l]) + int(world4d[i][j-1][k+1][l]) + int(world4d[i+1][j-1][k+1][l]) +

             int(world4d[i-1][j+1][k][l]) + int(world4d[i][j+1][k][l]) + int(world4d[i+1][j+1][k][l]) +
             int(world4d[i-1][j][k][l])   +                            + int(world4d[i+1][j][k][l]) +
             int(world4d[i-1][j-1][k][l]) + int(world4d[i][j-1][k][l]) + int(world4d[i+1][j-1][k][l]) +

             int(world4d[i-1][j+1][k-1][l]) + int(world4d[i][j+1][k-1][l]) + int(world4d[i+1][j+1][k-1][l]) +
             int(world4d[i-1][j][k-1][l])   + int(world4d[i][j][k-1][l])   + int(world4d[i+1][j][k-1][l]) +
             int(world4d[i-1][j-1][k-1][l]) + int(world4d[i][j-1][k-1][l]) + int(world4d[i+1][j-1][k-1][l]) +


             int(world4d[i-1][j+1][k+1][l-1]) + int(world4d[i][j+1][k+1][l-1]) + int(world4d[i+1][j+1][k+1][l-1]) +
             int(world4d[i-1][j][k+1][l-1])   + int(world4d[i][j][k+1][l-1])   + int(world4d[i+1][j][k+1][l-1]) +
             int(world4d[i-1][j-1][k+1][l-1]) + int(world4d[i][j-1][k+1][l-1]) + int(world4d[i+1][j-1][k+1][l-1]) +

             int(world4d[i-1][j+1][k][l-1]) + int(world4d[i][j+1][k][l-1]) + int(world4d[i+1][j+1][k][l-1]) +
             int(world4d[i-1][j][k][l-1])   + int(world4d[i][j][k][l-1])   + int(world4d[i+1][j][k][l-1]) +
             int(world4d[i-1][j-1][k][l-1]) + int(world4d[i][j-1][k][l-1]) + int(world4d[i+1][j-1][k][l-1]) +

             int(world4d[i-1][j+1][k-1][l-1]) + int(world4d[i][j+1][k-1][l-1]) + int(world4d[i+1][j+1][k-1][l-1]) +
             int(world4d[i-1][j][k-1][l-1])   + int(world4d[i][j][k-1][l-1])   + int(world4d[i+1][j][k-1][l-1]) +
             int(world4d[i-1][j-1][k-1][l-1]) + int(world4d[i][j-1][k-1][l-1]) + int(world4d[i+1][j-1][k-1][l-1])
             

proc updateWorld() =
    var nextInstant = world

    for i in -7..12:
        for j in -7..12:
            for k in -7..12:
                let adjacentAliveCells = getAdjacentAliveCells(i, j, k)
                case world[i][j][k]:
                of true:
                    if adjacentAliveCells != 2 and adjacentAliveCells != 3:
                        nextInstant[i][j][k] = false
                of false:
                    if adjacentAliveCells == 3:
                        nextInstant[i][j][k] = true
    
    world = nextInstant

proc updateWorld4d() =
    var nextInstant = world4d

    for i in -7..12:
        for j in -7..12:
            for k in -7..12:
                for l in -7..12:
                    let adjacentAliveCells = getAdjacentAliveCells4d(i, j, k, l)
                    case world4d[i][j][k][l]:
                    of true:
                        if adjacentAliveCells != 2 and adjacentAliveCells != 3:
                            nextInstant[i][j][k][l] = false
                    of false:
                        if adjacentAliveCells == 3:
                            nextInstant[i][j][k][l] = true
    
    world4d = nextInstant

let input = readFile("input").strip.splitLines

for i, line in input.pairs:
    for j, state in line:
        world[i][j][0] = case state:
            of '.': false
            of '#': true
            else: raise newException(IOError, "Invalid input")
        world4d[i][j][0][0] = world[i][j][0]

var result = 0
for i in 0..<6:
    updateWorld()

for i in -7..12:
    for j in -7..12:
        for k in -7..12:
            if world[i][j][k]:
                result += 1

echo result

result = 0
for i in 0..<6:
    updateWorld4d()

for i in -7..12:
    for j in -7..12:
        for k in -7..12:
            for l in -7..12:
                if world4d[i][j][k][l]:
                    result += 1

echo result
