import strutils, sets

let input = readFile "input"
let groups = input.split("\r\n\r\n")

proc countGroupAnswersAnyoneAnswered(groupAnswers: string): int =
    var answers: HashSet[char]
    answers.init()

    for a in groupAnswers:
        if a.isAlphaAscii:
            answers.incl a
    
    result = len answers


proc countGroupAnswersEveryoneAnswered(groupAnswers: string): int =
    var answers: HashSet[HashSet[char]]
    answers.init()

    for answer in groupAnswers.split('\n'):
        var answered: HashSet[char]
        answered.init()
        for a in answer:
            if a.isAlphaAscii:
                answered.incl a
        answers.incl answered
    
    var intersection = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm','n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'].toHashSet
    for answer in answers:
        intersection = intersection * answer
    result = len intersection

var total = 0
for group in groups:
    total += countGroupAnswersAnyoneAnswered(group)

echo total

total = 0
for group in groups:
    total += countGroupAnswersEveryoneAnswered(group)

echo total
