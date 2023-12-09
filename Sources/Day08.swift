import Algorithms
import CustomDump
import Foundation
import Parsing

struct Day08: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.input = try! parser.parse(&input)
  }

  private let input: [[Int]]

  func part1() throws -> Any {
    input
      .map(diffs)
      .map { $0.map { $0.last! }.reduce(0, +) }
      .reduce(0, +)
  }

  func part2() throws -> Any {
    input
      .map(diffs)
      .map { $0.map { $0.first! }.reversed().reduce(0, { $1 - $0 }) }
      .reduce(0, +)
  }
}

private func diffs(_ xs: [Int]) -> [[Int]] {
  func diffsIter(_ xs: [Int], _ aggr: inout [[Int]]) {
    aggr.append(xs)
    if !xs.allSatisfy({ $0 == 0 }) {
    let _diffs = xs.adjacentPairs().map { $0.1 - $0.0 }
      diffsIter(_diffs, &aggr)
    }
  }
  var result: [[Int]] = []
  diffsIter(xs, &result)
  return result
}

private let parser: some Parser<Substring, [[Int]]> = Parse {
  Many {
    Many {
      Int.parser()
    } separator: {
      Whitespace(1, .horizontal)
    }
  } separator: {
    Whitespace(1, .vertical)
  }
}
