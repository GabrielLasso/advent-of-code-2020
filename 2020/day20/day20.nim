import
    strutils,
    sequtils,
    tables,
    hashes

type
    Direction = enum North, East, South, West
    Flipped = bool
    Tile = ref object
        flipped: Flipped
        id: uint64
        data: array[10, array[10, bool]]
        neighbours: array[Direction, Tile]
    Sides = array[Direction, array[10, bool]]


proc hash(t: Tile): Hash = int(t.id)

var sidesCache: Table[uint64, Sides]

proc parseTile(str: string): Tile =
    new(result)
    let lines = str.splitLines()
    result.id = lines[0].splitWhitespace()[1].strip(chars = {':'}).parseBiggestUInt
    for i, line in lines[1..^1].pairs:
        for j, value in line.pairs:
            result.data[i][j] = value == '#'

func oposite(d: Direction): Direction =
    case d:
        of North:
            result = South
        of South:
            result = North
        of East:
            result = West
        of West:
            result = East
func toCoord(d: Direction): (int, int) =
    case d:
        of North:
            result = (0,1)
        of South:
            result = (0,-1)
        of East:
            result = (1,0)
        of West:
            result = (-1,0)

func transpose(matrix: array[10, array[10, bool]]): array[10, array[10, bool]] =
    for i, line in matrix.pairs:
        for j, value in line.pairs:
            result[j][i] = value

func reversed(a: array[10, bool]): array[10, bool] =
    for i, e in a:
        result[9-i] = e

func getSides(tile: Tile, sidesCache: var Table[uint64, Sides]): Sides =
    if (sidesCache.hasKey(tile.id)):
        return sidesCache[tile.id]
    result[North]= tile.data[0]
    result[South]= tile.data[^1]
    let t = tile.data.transpose
    result[West]= t[0]
    result[East]= t[^1]
    sidesCache.add(tile.id, result)

func flipSides(sides: Sides): Sides =
    for dir, side in sides:
        result[dir] = side.reversed

func matchSides(tile1, tile2: Tile, sidesCache: var Table[uint64, Sides]): (bool, Direction, Direction, Flipped) =
    let sides1 = tile1.getSides(sidesCache)
    let sides2 = tile2.getSides(sidesCache)
    let sides2Flipped = tile2.getSides(sidesCache).flipSides
    for direction1, side in sides1:
        for direction2, side2 in sides2.pairs:
            if side == side2:
                return (true, direction1, direction2, tile1.flipped)
        for direction2, side2 in sides2Flipped.pairs:
            if side == side2:
                return (true, direction1, direction2, not tile1.flipped)

func countNeighbours(tile: Tile): int =
    for n in tile.neighbours:
        if n != nil:
            result += 1

echo readFile("input").strip.split("\n\n").len
var tiles = readFile("input").strip.split("\n\n").map(parseTile)
var matches = 0
for i, tile1 in tiles.pairs:
    for j, tile2 in tiles[i+1..^1].pairs:
        let match = matchSides(tile1, tile2, sidesCache)
        if match[0]:
            matches += 1
            tiles[i].neighbours[match[1]] = tile2
            tiles[i+j+1].neighbours[match[2]] = tile1
            tiles[i+j+1].flipped = match[3]

func emptyDirs(t: Tile): seq[Direction] =
    for d, n in t.neighbours.pairs:
        if n == nil:
            result.insert d

var step1 = 1'u64
var startingTile: Tile
for tile in tiles:
    if tile.countNeighbours == 2:
        startingTile = tile
        step1 *= tile.id

echo step1

var tileMap: Table[(int, int), Tile]
var explored: Table[Tile, bool]
var fullMap: array[120,array[120,bool]]

func `+`(x, y: (int, int)): (int, int) =
    result = (x[0] + y[0], x[1] + y[1])

proc createMap() =
    var facing: Direction
    for dir, neighbour in startingTile.neighbours.pairs:
        if neighbour != nil:
            facing = dir
            break
    proc recCall(tile: Tile, facing: Direction, coords: (int, int), previous: Tile) =
        if (explored.hasKey(tile)):
            return
        echo tile.id
        echo facing
        explored.add(tile, true)
        tileMap.add(coords, tile)
        var enteringFrom: Direction
        if previous != nil:
            for dir, neighbour in tile.neighbours.pairs:
                if neighbour == previous:
                    enteringFrom = dir
        for dir, neighbour in tile.neighbours.pairs:
            if neighbour != nil:
                let newFacing = if (not tile.flipped):
                    Direction((int(facing) + int(enteringFrom) - int(dir) + 2) mod 4)
                else:
                    Direction((int(facing) - int(enteringFrom) + int(dir) + 2) mod 4)
                recCall(neighbour, newFacing, coords + newFacing.toCoord, tile)
    recCall(startingTile, facing, (0,0), nil)

createMap()
