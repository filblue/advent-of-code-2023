import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

private let exampleData = """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

final class Day02Tests: XCTestCase {
  func testPart1WithExampleData() throws {
    XCTAssertEqual(
      try Day02(data: exampleData).part1() as! Int,
      4361
    )
  }

  func testPart2WithExampleData() throws {
    XCTAssertEqual(
      try Day02(data: exampleData).part2() as! Int,
      467835
    )
  }
}

