proc countTrees(stepX, stepY: int): uint64 =
    var
        x = 0
        y = 0

    for line in lines "input":
        if (y mod stepY != 0):
            y += 1
            continue
        let width = len line
        if line[x mod width] == '#':
            result += 1
        x += stepX
        y += 1

echo countTrees(3,1)
echo countTrees(1,1) * countTrees(3,1) * countTrees(5,1) * countTrees(7,1) * countTrees(1,2)