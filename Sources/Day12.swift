import Algorithms
import CustomDump
import Foundation
import Parsing
import RegexBuilder

typealias Patterns = [(
  rows: [Int],
  vMirror: Int,
  vSmudgeMirror: Int,
  columns: [Int],
  hMirror: Int,
  hSmudgeMirror: Int
)]

struct Day12: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.patterns = makePatterns(from: try! parser.parse(&input))
  }

  private let patterns: Patterns

  func part1() throws -> Any {
    patterns.map { (100 * $0.vMirror) + $0.hMirror }.reduce(0, +)
  }

  func part2() throws -> Any {
    patterns.map { (100 * $0.vSmudgeMirror) + $0.hSmudgeMirror }.reduce(0, +)
  }
}

private func makePatterns(from parsed: [[[Int]]]) -> Patterns {
  var _patterns: [(
    rows: [Int],
    vMirror: Int,
    vSmudgeMirror: Int,
    columns: [Int],
    hMirror: Int,
    hSmudgeMirror: Int
  )] = []
  for pattern in parsed {
    var _rows: [Int] = []
    for row in pattern {
      _rows.append(Int(row.map { "\($0)" }.joined(), radix: 2)!)
    }
    let vXorss = xorss(in: _rows)
    let vMirror = mirrorIndex(in: vXorss)
    let vSmudgeMirror = smudgeMirrorIndex(in: vXorss)

    var _columns: [Int] = []
    for columnIndex in (0 ..< pattern[0].count) {
      var bits: [Int] = []
      for row in pattern {
        bits.append(row[columnIndex])
      }
      _columns.append(Int(bits.map { "\($0)" }.joined(), radix: 2)!)
    }
    let hXorss = xorss(in: _columns)
    let hMirror = mirrorIndex(in: hXorss)
    let hSmudgeMirror = smudgeMirrorIndex(in: hXorss)

    _patterns.append((
      rows: _rows,
      vMirror: vMirror,
      vSmudgeMirror: vSmudgeMirror,
      columns: _columns,
      hMirror: hMirror,
      hSmudgeMirror: hSmudgeMirror
    ))
  }

  return _patterns
}

private func mirrorIndex(in array: [[Int]]) -> Int {
  return array.firstIndex { $0.allSatisfy { $0 == 0 } }.map { $0 + 1 } ?? 0
}

private func smudgeMirrorIndex(in array: [[Int]]) -> Int {
  let smudge = array
    .map { $0.filter { $0 != 0 } }
    .firstIndex {
      ($0.count == 1) && isPowerOfTwo($0[0])
    }
  return smudge.map { $0 + 1 } ?? 0
}

func isPowerOfTwo(_ n: Int) -> Bool {
  return (n > 0) && (n & (n - 1) == 0)
}

private func xorss(in array: [Int]) -> [[Int]] {

  func xors(after index: Int) -> [Int] {
    var result: [Int] = []
    var width = 0
    while true {
      let li = index - width - 1
      guard li >= 0 else { break }
      let ri = index + width
      guard ri < array.count else { break }
      result.append(array[li] ^ array[ri])
      width += 1
    }
    return result
  }

  return (1 ..< (array.count)).map(xors)
}

private let parser: some Parser<Substring, [[[Int]]]> = Many {
  Many {
    Many {
      OneOf {
        ".".map { 0 }
        "#".map { 1 }
      }
    }
    .filter { !$0.isEmpty }
  } separator: {
    Whitespace(1, .vertical)
  }
} separator: {
  Whitespace(2, .vertical)
}
