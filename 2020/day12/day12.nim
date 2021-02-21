import strutils, math

type
    Ship = ref object
        x, y: int
        direction: (int, int)

func rotate(x, y, deg: int): (int, int) =
    result[0] = x * int(cos(degToRad(float(deg)))) - y * int(sin(degToRad(float(deg))))
    result[1] = x * int(sin(degToRad(float(deg)))) + y * int(cos(degToRad(float(deg))))

proc processCommand(ship: Ship, command: string) =
    let c = command[0]
    let num = parseInt(command.substr(1))

    case c:
    of 'N':
        ship.y += num
    of 'S':
        ship.y -= num
    of 'E':
        ship.x += num
    of 'W':
        ship.x -= num
    of 'R':
        ship.direction = rotate(ship.direction[0], ship.direction[1], -num)
    of 'L':
        ship.direction = rotate(ship.direction[0], ship.direction[1], num)
    of 'F':
        ship.x += ship.direction[0] * num
        ship.y += ship.direction[1] * num
    else:
        raise newException(IOError, "Invalid input")

proc processCommandB(ship: Ship, command: string) =
    let c = command[0]
    let num = parseInt(command.substr(1))

    case c:
    of 'N':
        ship.direction[1] += num
    of 'S':
        ship.direction[1] -= num
    of 'E':
        ship.direction[0] += num
    of 'W':
        ship.direction[0] -= num
    of 'R':
        ship.direction = rotate(ship.direction[0], ship.direction[1], -num)
    of 'L':
        ship.direction = rotate(ship.direction[0], ship.direction[1], num)
    of 'F':
        ship.x += ship.direction[0] * num
        ship.y += ship.direction[1] * num
    else:
        raise newException(IOError, "Invalid input")

let input = readFile("input").strip().splitLines()

var ship = new Ship
ship.direction = (1, 0)

for command in input:
    processCommand(ship, command)

echo abs(ship.x) + abs(ship.y)

ship = new Ship
ship.direction = (10, 1)

for command in input:
    processCommandB(ship, command)

echo abs(ship.x) + abs(ship.y)
