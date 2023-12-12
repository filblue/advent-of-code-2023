import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day11Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day11(
        data: """
          ???.### 1,1,3
          .??..??...?##. 1,1,3
          ?#?#?#?#?#?#?#? 1,3,1,6
          ????.#...#... 4,1,1
          ????.######..#####. 1,6,5
          ?###???????? 3,2,1
          """
      ).part1() as! Int,
      21
    )
  }

  func testPart1() throws {
    XCTAssertEqual(
      try Day11().part1() as! Int,
      7460
    )
  }

  func testPart2WithExampleData1() throws {
    XCTAssertEqual(
      try Day11(
        data: """
          .??..??...?##. 1,1,3
          """
      ).part2() as! Int,
      16384
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day11().part2() as! Int,
      6720660274964
    )
  }
}
