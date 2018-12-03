import Foundation

extension Sequence {
    
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        return try self.reduce(into: 0) { runningTotal, element in
            if try predicate(element) {
                runningTotal += 1
            }
        }
    }
}

struct Claim {
    var id: Int
    var horizontalExtent: Range<Int>
    var verticalExtent: Range<Int>
    
    init<S>(_ string: S) where S: StringProtocol {
        self.id = 0
        var x = 0
        var y = 0
        var width = 0
        var height = 0
        
        let scanner = Scanner(string: String(string))
        scanner.charactersToBeSkipped = CharacterSet.decimalDigits.inverted
        scanner.scanInt(&self.id)
        scanner.scanInt(&x)
        scanner.scanInt(&y)
        scanner.scanInt(&width)
        scanner.scanInt(&height)
        
        self.horizontalExtent = x..<(x + width)
        self.verticalExtent = y..<(y + height)
    }
}


let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
let inputString = try! String(contentsOf: inputURL, encoding: .utf8)
let inputLines = inputString.split(separator: "\n")


let claims = inputLines.map(Claim.init)

var squares = Array(repeating: Array(repeating: Set<Int>(), count: 1000), count: 1000)

for claim in claims {
    for rowIndex in claim.verticalExtent {
        for columnIndex in claim.horizontalExtent {
            squares[rowIndex][columnIndex].insert(claim.id)
        }
    }
}

let totalOverlapped = squares.reduce(0) { runningTotal, row in
    runningTotal + row.count(where: { $0.count > 1 })
}

print("Part 1:", totalOverlapped)

var isSafe = Array(repeating: true, count: claims.count + 1)

for row in squares {
    for impingingClaims in row {
        if impingingClaims.count > 1 {
            for claimID in impingingClaims {
                isSafe[claimID] = false
            }
        }
    }
}

let safeClaim = isSafe.dropFirst().firstIndex(of: true)!

print("Part 2:", safeClaim)
