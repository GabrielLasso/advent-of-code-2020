import strutils, parseutils, strscans, tables, algorithm, sequtils

let input = readFile("input").strip().splitLines()

var mem: Table[int64, int64]

var mask: string

var pos, val: int

proc applyMask(mem: var Table[int64, int64], mask: string, pos, val: int) =
    var maskedVal: int64 = val
    var e: int64 = 1
    var i = 35
    for bit in mask.reversed:
        case bit
        of 'X':
            e *= 2
            i -= 1
            continue
        of '0':
            if val.toBin(36)[i] == '1':
                maskedVal -= e
        of '1':
            if val.toBin(36)[i] == '0':
                maskedVal += e
        else:
            raise newException(IOError, "Invalid input")
        
        e *= 2
        i -= 1
        
    mem[pos] = maskedVal

proc applyMaskB(mem: var Table[int64, int64], mask: string, pos, val: int64) =
    if mask.filterIt(it == '0').len == mask.len:
        mem[pos] = val
    var processedMask = mask
    var e: int64 = 1
    var i = 35
    for bit in mask.reversed:
        case bit
        of 'X':
            var newPos = pos
            processedMask[i] = '0'
            if pos.toBin(36)[i] == '0':
                newPos += e
            else:
                newPos -= e
            mem.applyMaskB(processedMask, pos, val)
            mem.applyMaskB(processedMask, newPos, val)
            return
        of '0':
            e *= 2
            i -= 1
            continue
        of '1':
            var newPos = pos
            processedMask[i] = '0'
            if pos.toBin(36)[i] == '0':
                newPos += e
            mem.applyMaskB(processedMask, newPos, val)
            return
        else:
            raise newException(IOError, "Invalid input")
        
        e *= 2
        i -= 1


for line in input:
    if line.scanf("mask = $+", mask):
        discard
    elif line.scanf("mem[$i] = $i", pos, val):
        mem.applyMask(mask, pos, val)
    else:
        raise newException(IOError, "Invalid input")
echo toSeq(mem.values).foldl(a + b)
mem.clear()

for line in input:
    if line.scanf("mask = $+", mask):
        discard
    elif line.scanf("mem[$i] = $i", pos, val):
        mem.applyMaskB(mask, pos, val)
    else:
        raise newException(IOError, "Invalid input")
echo toSeq(mem.values).foldl(a + b)
