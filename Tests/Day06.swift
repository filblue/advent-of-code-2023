import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

private let exampleData = """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """


final class Day06Tests: XCTestCase {
  func testPart1WithExampleData() throws {
    XCTAssertEqual(
      try Day06(data: exampleData).part1() as! Int,
      6440
    )
  }

  func testPart2WithExampleData() throws {
    XCTAssertEqual(
      try Day06(data: exampleData).part2() as! Int,
      5905
    )
  }
}
