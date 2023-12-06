import Algorithms
import Foundation
import Parsing

struct Day05: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.races = try! Parse {
      Skip { "Time:" }
      Many {
        Skip { Whitespace() }
        Digits()
      }
      Skip { Whitespace(1, .vertical); "Distance:" }
      Many {
        Skip { Whitespace() }
        Digits()
      }
    }
    .map { Array(zip($0.0, $0.1)) }
    .parse(&input)
  }

  private let races: [(Int, Int)]

  func part1() throws -> Any {
    waysToBeatTheRecord(races).reduce(1, *)
  }

  func part2() throws -> Any {
    waysToBeatTheRecord(
      [(
        Int(races.map(\.0).map(String.init).joined())!,
        Int(races.map(\.1).map(String.init).joined())!
      )]
    )[0]
  }
}

private func waysToBeatTheRecord(_ races: [(Int, Int)]) -> [Int] {
  var waysToBeatTheRecord: [Int] = []
  for (time, recordDistance) in races {
    var _waysToBeatTheRecord = 0
    for holdT in (1 ... time) {
      let d = (time - holdT) * holdT
      if d > recordDistance {
        _waysToBeatTheRecord += 1
      }
    }
    waysToBeatTheRecord.append(_waysToBeatTheRecord)
  }
  return waysToBeatTheRecord
}
