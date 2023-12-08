import Algorithms
import CustomDump
import Foundation
import Parsing

struct Day07: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    let _input = try! parser.parse(&input)
    self.input = (
      _input.0,
      Dictionary(uniqueKeysWithValues: _input.1.map { ($0.0, [$0.1, $0.2]) })
    )
  }

  private let input: ([Int], [Substring: [Substring]])
  private var steps: [Int] { input.0 }
  private var map: [Substring: [Substring]] { input.1 }

  func part1() throws -> Any {
    minStepsCount(
      isStartNode: { $0 == "AAA" },
      isFinishNode: { $0 == "ZZZ" }
    )
  }

  func part2() throws -> Any {
    minStepsCount(
      isStartNode: { $0.hasSuffix("A") },
      isFinishNode: { $0.hasSuffix("Z") }
    )
  }

  private func minStepsCount(
    isStartNode: (Substring) -> Bool,
    isFinishNode: (Substring) -> Bool
  ) -> Int {
    findAllPossibleRoutes(
      destinations: findAllUniquePaths(
        isStartNode: isStartNode,
        isFinishNode: isFinishNode,
        steps: steps,
        map: map
      )
    )
    .map { $0.values.map(\.1).reduce(1, lcm) }
    .min()!
  }
}

private func findAllPossibleRoutes(
  destinations: [Substring: [(Substring, Int)]]
) -> [[Substring: (Substring, Int)]] {

  func findAllPossibleRoutesIter(
    routes: [Substring: (Substring, Int)],
    destinations: [Substring: [(Substring, Int)]],
    allPossibleRoutes: inout [[Substring: (Substring, Int)]]
  ) {
    guard !destinations.isEmpty else {
      allPossibleRoutes.append(routes)
      return
    }
    let key = destinations.keys.first!
    var dests = destinations[key]!
    while !dests.isEmpty {
      let dest = dests.removeFirst()

      var _routes = routes
      _routes[key] = dest

      var _destinations = destinations
      _destinations[key] = nil

      findAllPossibleRoutesIter(routes: _routes, destinations: _destinations, allPossibleRoutes: &allPossibleRoutes)
    }
  }

  var allPossibleRoutes: [[Substring: (Substring, Int)]] = []
  findAllPossibleRoutesIter(
    routes: [:],
    destinations: destinations,
    allPossibleRoutes: &allPossibleRoutes
  )
  return allPossibleRoutes
}

private func findAllUniquePaths(
  isStartNode: (Substring) -> Bool,
  isFinishNode: (Substring) -> Bool,
  steps: [Int],
  map: [Substring: [Substring]]
) -> [Substring: [(Substring, Int)]] {
  let aNodes = map.keys.filter(isStartNode)
  var destinations: [Substring: [(Substring, Int)]] = [:]
  for aNode in aNodes {
    var visited: Set<Visited> = []
    var _destinations: [(Substring, Int)] = []
    var node: Substring = aNode
    var i = 0
    while true {
      var stepIndex = i % steps.count
      node = map[node]![steps[stepIndex]]
      i += 1
      stepIndex = i % steps.count
      let _visited = Visited(node: node, stepIndex: stepIndex)
      if visited.contains(_visited) {
        break
      }
      visited.insert(_visited)
      _destinations.append((node, i))
    }
    destinations[aNode] = _destinations.filter { isFinishNode($0.0) }
  }
  return destinations
}

private struct Visited: Hashable {
  let node: Substring
  let stepIndex: Int
}

private func gcd(_ x: Int, _ y: Int) -> Int {
  var a = 0
  var b = max(x, y)
  var r = min(x, y)

  while r != 0 {
    a = b
    b = r
    r = a % b
  }
  return b
}

private func lcm(_ x: Int, _ y: Int) -> Int {
  return x / gcd(x, y) * y
}

private let parser: some Parser<Substring, ([Int], [(Substring, Substring, Substring)])> = Parse {
  Many {
    OneOf {
      "L".map { 0 }
      "R".map { 1 }
    }
  }
  Skip { Whitespace(2, .vertical) }
  Many {
    Parse {
      Prefix(3)
      Skip { " = (" }
      Prefix(3)
      Skip { ", " }
      Prefix(3)
      Skip { ")" }
    }
  } separator: {
    Whitespace(1, .vertical)
  }
}
