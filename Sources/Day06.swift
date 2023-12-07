import Algorithms
import CustomDump
import Foundation
import Parsing

struct Day06: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.lines = try! Many {
      Many { cardParser }
      Whitespace()
      Digits()
    } separator: {
      Whitespace(1, .vertical)
    }
    .parse(&input)
  }

  private let lines: [([Int], Int)]

  func part1() throws -> Any {
    totalWinnings(
      lines,
      lines.map(\.0).map(handStrengthBasic)
    )
  }

  func part2() throws -> Any {
    totalWinnings(
      lines.map { ($0.0.replacing(11, to: 1), $0.1) },
      lines.map(\.0).map(handStrengthJoker)
    )
  }
}

private func totalWinnings(_ lines: [([Int], Int)], _ strengths: [Int]) -> Int {
  zip(lines, strengths)
    .sorted { (l: (([Int], Int), Int), r: (([Int], Int), Int)) -> Bool in
      guard l.1 == r.1 else { return l.1 < r.1 }
      return l.0.0.lexicographicallyPrecedes(r.0.0)
    }
    .enumerated()
    .map { $0.element.0.1 * ($0.offset + 1) }
    .reduce(0, +)
}

private func handStrengthJoker(_ hand: [Int]) -> Int {
  guard hand.contains(11) else { return handStrengthBasic(hand) }
  return (2 ... 14)
    .filter { $0 != 11 }
    .map { hand.replacing(11, to: $0) }
    .map(handStrengthBasic)
    .max()!
}

private func handStrengthBasic(_ hand: [Int]) -> Int {
  let grouped = hand.groupedByRanks
  guard grouped.count > 1 else { return 6 }
  switch (grouped[0].count, grouped[1].count) {
  case (4, 1): return 5
  case (3, 2): return 4
  case (3, 1): return 3
  case (2, 2): return 2
  case (2, 1): return 1
  default: return 0
  }
}

private extension Collection where Element == Int {
  var groupedByRanks: [[Int]] {
    Dictionary(grouping: self, by: { $0 }).values.sorted { $0.count > $1.count }
  }
}

private extension Collection where Element: Equatable {
  func replacing(_ from: Element, to: Element) -> [Element] {
    self.reduce(into: [], { $1 == from ? $0.append(to) : $0.append($1) })
  }
}

private let cardParser: some Parser<Substring, Int> = OneOf {
  Digits(1)
  "T".map { 10 }
  "J".map { 11 }
  "Q".map { 12 }
  "K".map { 13 }
  "A".map { 14 }
}
