import XCTest

@testable import AdventOfCode

final class AdventDayTests: XCTestCase {
  func testInitData() throws {
    let challenge = Day00()
    XCTAssertTrue(challenge.data.starts(with: "nqninenmvnpsz874"))
  }
}
