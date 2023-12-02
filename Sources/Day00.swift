import Foundation
import Parsing

struct Day00: AdventDay {
  var data: String

  func part1() -> Any {
    var data = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    let parser: some Parser<Substring, Int> = Many(into: 0, +=) {
      Parse {
        Skip { CharacterSet.letters }
        Many {
          Digits(1)
          Skip { CharacterSet.letters }
        }
      }
      .map { $0.first! * 10 + $0.last! }
    } separator: {
      Whitespace(1, .vertical)
    }
    return try! parser.parse(&data)
  }

  func part2() -> Any {
    data.sumOfCalibrationValues
  }
}

extension String {
  var sumOfCalibrationValues: Int {
    self
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: .newlines)
      .calibrationValues
      .reduce(0, +)
  }
}

extension Collection where Element == String {
  var calibrationValues: [Int] { self.map(\.calibrationValue) }
}

extension String {
  var calibrationValue: Int {
    self.firstDigit * 10 + self.lastDigit
  }

  var firstDigit: Int {
    var input = self[...]
    return try! firstDigitParser.parse(&input)
  }

  var lastDigit: Int {
    var input = String(self.reversed())[...]
    return try! lastDigitParser.parse(&input)
  }
}

let lastDigitParser: some Parser<Substring, Int> = Many {
  OneOf {
    reversedSpelledOutDigitParser
    Digits(1)
    Skip { First().filter { !$0.isNewline } }.map { _ in 0 }
  }
}
  .map { $0.first(where: { $0 > 0 })! }

let reversedSpelledOutDigitParser: some Parser<Substring, Int> = OneOf {
  for d in SpelledOutDigit.allCases {
    String(d.string.reversed()).map { d.rawValue }
  }
}

let firstDigitParser: some Parser<Substring, Int> = Many {
  OneOf {
    spelledOutDigitParser
    Digits(1)
    Skip { First().filter { !$0.isNewline } }.map { _ in 0 }
  }
}
.map { $0.first(where: { $0 > 0 })! }

let spelledOutDigitParser: some Parser<Substring, Int> = OneOf {
  for d in SpelledOutDigit.allCases {
    d.string.map { d.rawValue }
  }
}

enum SpelledOutDigit: Int, CaseIterable {
  case one = 1
  case two
  case three
  case four
  case five
  case six
  case seven
  case eight
  case nine

  var string: String { "\(self)" }
}
