import Algorithms
import Foundation
import Parsing

struct Day04: AdventDay {
  var data: String

  private var map: ([Int], [Mapping]) {
    get {
      var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
      return try! parser.parse(&input)
    }
  }

  func part1() throws -> Any {
    map.0
      .map { ($0 ..< $0+1) }
      .lowestLocation(in: map.1)
  }

  func part2() throws -> Any {
    let map = self.map
    return stride(from: 0, to: map.0.count, by: 2)
      .map { i in (map.0[i] ..< map.0[i]+map.0[i+1]) }
      .lowestLocation(in: map.1)
  }
}

private extension Array where Element == Range<Int> {
  func lowestLocation(in mappings: [Mapping]) -> Int {
    mappings.locations(of: "seed", ranges: self).map(\.lowerBound).min()!
  }
}

private extension Collection where Element == Mapping {
  func locations(
    of type: String,
    ranges: [Range<Int>]
  ) -> [Range<Int>] {
    guard type != "location" else { return ranges }
    let mapping = self.first { $0.source == type }!
    return locations(
      of: mapping.destination,
      ranges: ranges.flatMap { mapping.applyMapping2(from: $0) }
    )
  }
}

private struct Mapping {
  let source: String
  let destination: String
  let ranges: [(Range<Int>, Range<Int>)]

  init(
    _ source: Substring,
    _ destination: Substring,
    _ rangeSpecs: [(Int, Int, Int)]
  ) {
    self.source = String(source)
    self.destination = String(destination)
    self.ranges = rangeSpecs.map { (($1..<$1+$2), ($0..<$0+$2)) }
  }

  func applyMapping2(from source: Range<Int>) -> [Range<Int>] {
    var _sourceRanges = [source]
    var destRanges: [Range<Int>] = []
    while !_sourceRanges.isEmpty {
      let _sourceRange = _sourceRanges.removeFirst()
      var foundOverlap = false
      for range in ranges {
        if range.0.overlaps(_sourceRange) {
          foundOverlap = true
          let clamped = range.0.clamped(to: _sourceRange)
          let l = (_sourceRange.lowerBound ..< clamped.lowerBound)
          if !l.isEmpty { _sourceRanges.append(l) }

          let translatedLowerBound = range.1.lowerBound + (clamped.lowerBound - range.0.lowerBound)
          destRanges.append(translatedLowerBound ..< translatedLowerBound+clamped.count)

          let r = (clamped.upperBound ..< _sourceRange.upperBound)
          if !r.isEmpty { _sourceRanges.append(r) }
        }
      }
      if !foundOverlap {
        destRanges.append(source)
      }
    }
    return destRanges
  }
}

private let parser: some Parser<Substring, ([Int], [Mapping])> = Parse {
  Parse {
    "seeds: "
    Many {
      Digits()
    } separator: {
      Whitespace()
    }
  }
  Skip { Whitespace(2, .vertical) }
  Many {
    Parse(Mapping.init) {
      CharacterSet.letters
      Skip { "-to-" }
      CharacterSet.letters
      Skip { " map:" }
      Skip { Whitespace(1, .vertical) }
      Many {
        Digits()
        Skip { Whitespace() }
        Digits()
        Skip { Whitespace() }
        Digits()
      } separator: {
        Whitespace(1, .vertical)
      }
    }
  } separator: {
    Whitespace(2, .vertical)
  }
}
