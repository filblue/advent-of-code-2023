import Algorithms
import Foundation
import Parsing

struct Day03: AdventDay {
  var data: String

  var cards: [([Int], [Int])] {
    get throws {
      var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
      return try cardsParser.parse(&input)
    }
  }

  func part1() throws -> Any {
    return try self.cards
      .map(cardPoints)
      .reduce(0, +)
  }

  func part2() throws -> Any {
    var cardsWithCopies: [(Int, ([Int], [Int]))] = try self.cards.map { (1, $0) }
    for i in (0..<cardsWithCopies.count) {
      let matchingCount = countOfMatchingNumbers(cardsWithCopies[i].1)
      guard matchingCount > 0 else { continue }
      for j in ((i + 1) ... (i + matchingCount)) {
        cardsWithCopies[j].0 += cardsWithCopies[i].0
      }
    }
    return cardsWithCopies.map(\.0).reduce(0, +)
  }
}

private func cardPoints(_ card: ([Int], [Int])) -> Int {
  let matching = countOfMatchingNumbers(card)
  guard matching > 0 else { return 0 }
  return Int(pow(2, Double(matching - 1)))
}

private func countOfMatchingNumbers(_ card: ([Int], [Int])) -> Int {
  card.1.countOfMatchingNumbers(card.0)
}

private extension Collection where Element == Int {
  func countOfMatchingNumbers(_ winning: [Int]) -> Int {
    let partitioned = self.partitioned(by: { winning.contains($0) })
    return partitioned.trueElements.count
  }
}

private let cardsParser: some Parser<Substring, [([Int], [Int])]> = Many {
  Skip { PrefixThrough(": ") }
  Many {
    Skip { Prefix { $0.isWhitespace } }
    Digits()
  } separator: {
    Whitespace()
  }
  " | "
  Many {
    Skip { Prefix { $0.isWhitespace } }
    Digits()
  } separator: {
    Whitespace()
  }
} separator: {
  Whitespace(1, .vertical)
}
