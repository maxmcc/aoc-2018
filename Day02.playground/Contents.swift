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


func main() {
    let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
    let inputString = try! String(contentsOf: inputURL, encoding: .utf8)
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

    print("Part 1:", countWithTwoCharacters * countWithThreeCharacters)
    
    
    var previouslySeen = Set<StringSplit>()
    for line in inputLines {
        for index in line.indices {
            let prefix = line[..<index]
            let suffix = line[line.index(after: index)...]
            let split = StringSplit(prefix: prefix, suffix: suffix)
            if previouslySeen.contains(split) {
                print("Part 2:", split.prefix + split.suffix)
                return
            } else {
                previouslySeen.insert(split)
            }
        }
    }
}

main()
