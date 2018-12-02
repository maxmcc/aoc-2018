import Foundation

extension Collection where Element: Hashable {
    
    func elementCounts() -> [Element: Int] {
        var counts = [Element: Int]()
        for element in self {
            counts[element, default: 0] += 1
        }
        return counts
    }
}


struct StringSplit: Hashable {
    var prefix: Substring
    var suffix: Substring
}


let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
let inputString = try String(contentsOf: inputURL, encoding: .utf8)
let inputLines = inputString.split(separator: "\n")


var countWithTwoCharacters = 0
var countWithThreeCharacters = 0

for inputLine in inputLines {
    let counts = inputLine.elementCounts()
    if counts.values.contains(2) {
        countWithTwoCharacters += 1
    }
    if counts.values.contains(3) {
        countWithThreeCharacters += 1
    }
}

countWithTwoCharacters * countWithThreeCharacters


var previouslySeen = Set<StringSplit>()
outer: for inputLine in inputLines {
    for index in inputLine.indices {
        let prefix = inputLine[..<index]
        let suffix = inputLine[inputLine.index(after: index)...]
        let split = StringSplit(prefix: prefix, suffix: suffix)
        if previouslySeen.contains(split) {
            print(split.prefix + split.suffix)
            break outer
        } else {
            previouslySeen.insert(split)
        }
    }
}
