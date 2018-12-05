import Foundation

extension Collection where Element == UInt8 {

    func reduced() -> [UInt8] {
        return self.reduce(into: []) { result, x in
            if let y = result.last, x ^ y == 32 {
                result.removeLast()
            } else {
                result.append(x)
            }
        }
    }
}

let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
let inputString = try! String(contentsOf: inputURL, encoding: .utf8).split(separator: "\n").first!


print("Part 1:", inputString.utf8.reduced().count)


let shortest = (65 as UInt8...90).map { byte -> Int in
    let string = inputString.utf8.filter { $0 != byte && $0 != byte | 32 }
    return string.reduced().count
}.min()!

print("Part 2:", shortest)
