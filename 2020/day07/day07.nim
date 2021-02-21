import strutils, tables, sets, hashes

type Bag = ref object
    name: string
    content: seq[(int, Bag)]
    containedBy: HashSet[Bag]

proc hash(bag: Bag): Hash =
    result = bag.name.hash

var allBags: Table[string, Bag]

let input = readFile("input").strip().split('\n')

proc trimBagName(bagName: var string) =
    bagName = bagName.substr(0, bagName.find("bag") - 1).strip

proc initBags() =
    for line in input:
        var bag: Bag
        bag = new Bag
        bag.name = line.split("contain")[0]
        trimBagName(bag.name)
        allBags[bag.name] = bag

proc processBags() =
    for line in input:
        var bagName = line.split("contain")[0]
        trimBagName(bagName)
        var bag = allBags[bagName]
        for content in line.split("contain")[1].split(','):
            if (content.find("no other bags") != -1):
                continue
            var name = content.strip.strip(chars = Digits).strip
            trimBagName name
            let insideBag = allBags[name]
            bag.content.add (parseInt content.strip.split(' ')[0], insideBag)
            insideBag.containedBy.incl bag

proc getAllBagsThatContains(bag: Bag): HashSet[Bag] =
    var searching: HashSet[Bag]
    searching.incl(bag)
    var current = bag
    while len(searching) != 0:
        result = result + current.containedBy
        current = searching.pop
        searching = searching + current.containedBy

proc countBagsInside(bag: Bag): int =
    for insideBag in bag.content:
        result += insideBag[0] + insideBag[0] * countBagsInside(insideBag[1])

initBags()
processBags()
echo getAllBagsThatContains(allBags["shiny gold"]).len
echo countBagsInside(allBags["shiny gold"])
