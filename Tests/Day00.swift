import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day00Tests: XCTestCase {
  func testPart1() throws {
    XCTAssertEqual(
      Day00(
        data: """
          1abc2
          pqr3stu8vwx
          a1b2c3d4e5f
          treb7uchet
          """
      ).part1() as! Int,
      142
    )
  }

  func testPart2ParserVersusNaive() {
    let lines = Day00().data
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: .newlines)
    XCTAssertEqual(
      lines.calibrationValues,
      lines.calibrationValuesNaive
    )
  }

  func testPart2ExampleResult() {
    XCTAssertEqual(
      Day00(
        data: """
          two1nine
          eightwothree
          abcone2threexyz
          xtwone3four
          4nineeightseven2
          zoneight234
          7pqrstsixteen
          """
      ).part2() as! Int,
      281
    )
  }

  func testFirstDigitNaive() {
    XCTAssertEqual("two1nine".firstDigitNaive, 2)
    XCTAssertEqual("eightwothree".firstDigitNaive, 8)
    XCTAssertEqual("abcone2threexyz".firstDigitNaive, 1)
    XCTAssertEqual("xtwone3four".firstDigitNaive, 2)
    XCTAssertEqual("4nineeightseven2".firstDigitNaive, 4)
    XCTAssertEqual("zoneight234".firstDigitNaive, 1)
    XCTAssertEqual("7pqrstsixteen".firstDigitNaive, 7)
  }

  func testStringLastDigitNaive() {
    XCTAssertEqual("two1nine".lastDigitNaive, 9)
    XCTAssertEqual("eightwothree".lastDigitNaive, 3)
    XCTAssertEqual("abcone2threexyz".lastDigitNaive, 3)
    XCTAssertEqual("xtwone3four".lastDigitNaive, 4)
    XCTAssertEqual("4nineeightseven2".lastDigitNaive, 2)
    XCTAssertEqual("zoneight234".lastDigitNaive, 4)
    XCTAssertEqual("7pqrstsixteen".lastDigitNaive, 6)
  }

  func testStringFirstDigit() {
    XCTAssertEqual("two1nine".firstDigit, 2)
    XCTAssertEqual("eightwothree".firstDigit, 8)
    XCTAssertEqual("abcone2threexyz".firstDigit, 1)
    XCTAssertEqual("xtwone3four".firstDigit, 2)
    XCTAssertEqual("4nineeightseven2".firstDigit, 4)
    XCTAssertEqual("zoneight234".firstDigit, 1)
    XCTAssertEqual("7pqrstsixteen".firstDigit, 7)
  }

  func testStringLastDigit() {
    XCTAssertEqual("two1nine".lastDigit, 9)
    XCTAssertEqual("eightwothree".lastDigit, 3)
    XCTAssertEqual("abcone2threexyz".lastDigit, 3)
    XCTAssertEqual("xtwone3four".lastDigit, 4)
    XCTAssertEqual("4nineeightseven2".lastDigit, 2)
    XCTAssertEqual("zoneight234".lastDigit, 4)
    XCTAssertEqual("7pqrstsixteen".lastDigit, 6)
  }

  func testFirstDigitParser() throws {
    var data = "abctwoone"[...]
    XCTAssertEqual(try firstDigitParser.parse(&data), 2)
  }

  func testLastDigitParser() throws {
    var data = String("abctwoone".reversed())[...]
    XCTAssertEqual(try lastDigitParser.parse(&data), 1)
  }

  func testReversedSpelledOutDigitParser() throws {
    var data = String("twoone".reversed())[...]
    XCTAssertEqual(try reversedSpelledOutDigitParser.parse(&data), 1)
  }
}

extension Collection where Element == String {
  var calibrationValuesNaive: [Int] { self.map(\.calibrationValueNaive) }
}

extension String {
  fileprivate var calibrationValueNaive: Int {
    self.firstDigitNaive * 10 + self.lastDigitNaive
  }

  fileprivate var firstDigitNaive: Int {
    var input = self
    while !input.isEmpty {
      for i in 1...9 {
        if input.starts(with: "\(i)") {
          return i
        }
      }
      for s in SpelledOutDigit.allCases {
        if input.starts(with: s.string) {
          return s.rawValue
        }
      }
      input.removeFirst()
    }
    fatalError()
  }

  fileprivate var lastDigitNaive: Int {
    var input = String(self.reversed())
    while !input.isEmpty {
      for i in 1...9 {
        if input.starts(with: "\(i)") {
          return i
        }
      }
      for s in SpelledOutDigit.allCases {
        if input.starts(with: String(s.string.reversed())) {
          return s.rawValue
        }
      }
      input.removeFirst()
    }
    fatalError()
  }
}
