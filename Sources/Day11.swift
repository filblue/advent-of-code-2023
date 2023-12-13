import Algorithms
import CustomDump
import Foundation
import Parsing
import RegexBuilder

struct Day11: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.rows = try! parser.parse(&input)

    let data2 = data
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: .newlines)
      .map {
        let c = $0.components(separatedBy: " ")
        return """
          \(Array(repeating: c[0], count: 5).joined(separator: "?")) \
          \(Array(repeating: c[1], count: 5).joined(separator: ","))
          """
      }
      .joined(separator: "\n")
    var input2 = data2.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.rows2 = try! parser.parse(&input2)
  }

  private let rows: [(Substring, [Int])]
  private let rows2: [(Substring, [Int])]

  func part1() throws -> Any {
    sumOfPossibleArrangements(in: rows)
  }

  func part2() throws -> Any {
    sumOfPossibleArrangements(in: rows2)
  }
}

private func sumOfPossibleArrangements(in rows: [(Substring, [Int])]) -> Int {
  rows.map { arrangements($0.0, $0.1[...]) }.reduce(0, +)
}

struct CacheKey: Hashable {
  let row: String
  let numbers: [Int]
}

private var cache: [CacheKey: Int] = [:]

private func arrangements(_ row: Substring, _ numbers: ArraySlice<Int>) -> Int {
  guard !(row.isEmpty && numbers.isEmpty) else { return 1 }
  let cacheKey = CacheKey(row: String(row), numbers: Array(numbers))
  if let cached = cache[cacheKey] {
    return cached
  } else {
    let result = arrangementsMatchingFirstNumber(row, numbers)
      + arrangementsDroppingFirstGround(row, numbers)
    cache[cacheKey] = result
    return result
  }
}

private func arrangementsDroppingFirstGround(
  _ row: Substring,
  _ numbers: ArraySlice<Int>
) -> Int {
  guard row.prefixMatch(of: /[\?.]/) != nil else { return 0 }
  return arrangements(row[row.index(after: row.startIndex)...], numbers)
}

private func arrangementsMatchingFirstNumber(
  _ row: Substring,
  _ numbers: ArraySlice<Int>
) -> Int {
  if !numbers.isEmpty {
    let number = numbers[numbers.startIndex]
    if row.count >= number {
      let regex = Regex {
        Repeat(count: number) {
          One(.anyOf("?#"))
        }
        ChoiceOf {
          One(.anyOf("?."))
          /$/
        }
      }

      if let prefix = row.prefixMatch(of: regex) {
        return arrangements(
          row[prefix.endIndex...],
          numbers.suffix(from: numbers.startIndex + 1)
        )
      }
    }
  }

  return 0
}

private let parser: some Parser<Substring, [(Substring, [Int])]> = Many {
  Prefix { !$0.isWhitespace }
  Whitespace(1, .horizontal)
  Many {
    Int.parser()
  } separator: {
    ","
  }
} separator: {
  Whitespace(1, .vertical)
}
