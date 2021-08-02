import XCTest
@testable import Stride

final class StrideTests: XCTestCase {

    func test() {

        XCTAssertEqual(stride(over: [.low(0), .high(-1)]), [])
        XCTAssertEqual(stride(over: [.low(0), .high(-1)]), [])
        XCTAssertEqual(stride(over: [.high(0), .low(-1)]), [0, -1])

        XCTAssertEqual(stride(over: [.low(0), .high(0)]), [0])
        XCTAssertEqual(stride(over: [.low(10), .high(11)]), [10, 11])

        XCTAssertEqual(stride(over: [.low(0), .high(0)], by: 2), [0])
        XCTAssertEqual(stride(over: [.low(10), .high(11)], by: 2), [10])

        XCTAssertEqual(stride(over: [.low(0), .high(2), .low(1)]), [0, 1, 2, 1])

        let range = 4...9

        XCTAssertEqual(stride(range: range, over: [.low(1), .high(5)]), [])

        XCTAssertEqual(stride(range: range, over: [.low(0), .high(5), .low(1)]), [-4])

        XCTAssertEqual(stride(range: range, over: [.low(1), .high(5), .low(0)]).count, 1)

        XCTAssertEqual(stride(range: range, over: [.low(0), .high(5), .low(0)]).count, 1)

        XCTAssertEqual(stride(range: range, over: [.low(0), .high(10), .low(2)]).count, 9)

        let ps: [Point<Int, Int>] = [(x: (pos: 0, dur: 1), y: 0), (x: (pos: 1, dur: 2), y: 2)]
        let stride = stride(points: ps, duration: 4, over: [.low(0), .high(3), .low(0)])
        XCTAssertEqual(stride.count, 3)
        XCTAssertEqual(stride[0].count, 2)
    }
}
