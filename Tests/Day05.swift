import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

private let exampleData = """
  Time:      7  15   30
  Distance:  9  40  200
  """


final class Day05Tests: XCTestCase {
  func testPart1WithExampleData() throws {
    XCTAssertEqual(
      try Day05(data: exampleData).part1() as! Int,
      288
    )
  }

  func testPart2WithExampleData() throws {
    XCTAssertEqual(
      try Day05(data: exampleData).part2() as! Int,
      71503
    )
  }
}
