import strutils

let
    input = readFile("input").strip().split('\n')
    size = len input

var
    acc: int
    instructionPointer: int
    visited = newSeq[bool](size)

proc runProgram(input: seq[string]): bool =
    acc = 0
    instructionPointer = 0
    visited = newSeq[bool](size)
    var terminates = false
    while not visited[instructionPointer]:
        let
            instruction = input[instructionPointer].split(' ')
            action = instruction[0]
            arg = parseInt(instruction[1].strip)
        
        visited[instructionPointer] = true
        if instructionPointer == size - 1:
            terminates = true
        case action:
            of "acc":
                acc += arg
                instructionPointer += 1
            of "jmp":
                instructionPointer += arg
            else:
                instructionPointer += 1
        if terminates:
            return true
    return false

# Part 1
discard runProgram(input)
echo acc

# Part 2
var changedInput = input

for i in 0..size - 1:
    if input[i].find("nop") != -1:
        changedInput[i] = input[i].replace("nop", "jmp")
    elif input[i].find("jmp") != -1:
        changedInput[i] = input[i].replace("jmp", "nop")

    if runProgram(changedInput):
        echo acc

    changedInput[i] = input[i]
