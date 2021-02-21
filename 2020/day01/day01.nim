import strutils, sequtils, parseutils

let input = readFile("input").split('\n').mapIt(strip(it)).map(parseInt)

for (i, _) in input.pairs:
    for (j, _) in input[i .. ^1].pairs:
        if (input[i] + input[i + j] == 2020):
            echo input[i] * input[i + j]


for (i, _) in input.pairs:
    for (j, _) in input[i .. ^1].pairs:
        for (k, _) in input[i+j .. ^1].pairs:
            if (input[i] + input[i + j] + input[i + j + k] == 2020):
                echo input[i] * input[i + j] * input[i + j + k]