import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day07Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day07(
        data: """
          RL

          AAA = (BBB, CCC)
          BBB = (DDD, EEE)
          CCC = (ZZZ, GGG)
          DDD = (DDD, DDD)
          EEE = (EEE, EEE)
          GGG = (GGG, GGG)
          ZZZ = (ZZZ, ZZZ)
          """
      ).part1() as! Int,
      2
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day07(
        data: """
          LLR

          AAA = (BBB, BBB)
          BBB = (AAA, ZZZ)
          ZZZ = (ZZZ, ZZZ)
          """
      ).part1() as! Int,
      6
    )
  }

  func testPart2WithExampleData() throws {
    XCTAssertEqual(
      try Day07(
        data: """
          LR

          11A = (11B, XXX)
          11B = (XXX, 11Z)
          11Z = (11B, XXX)
          22A = (22B, XXX)
          22B = (22C, 22C)
          22C = (22Z, 22Z)
          22Z = (22B, 22B)
          XXX = (XXX, XXX)
          """
      ).part2() as! Int,
      6
    )
  }

  func testPart1() throws {
    XCTAssertEqual(
      try Day07().part1() as! Int,
      24253
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day07().part2() as! Int,
      12357789728873
    )
  }
}
