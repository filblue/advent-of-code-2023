import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day14Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day14(
        data: """
          HASH
          """
      ).part1() as! Int,
      52
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day14(
        data: """
          rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
          """
      ).part1() as! Int,
      1320
    )
  }

  func testPart1() throws {
    XCTAssertEqual(
      try Day14().part1() as! Int,
      504449
    )
  }

  func testPart2WithExampleData1() throws {
    XCTAssertEqual(
      try Day14(
        data: """
          rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
          """
      ).part2() as! Int,
      145
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day14().part2() as! Int,
      262044
    )
  }
}
