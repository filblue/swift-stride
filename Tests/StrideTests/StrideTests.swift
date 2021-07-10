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

        let ex: [Int] = [5, 4, 9, 7]

        XCTAssertEqual(stride(ex, over: [.low(1), .high(5)]), [])

        XCTAssertEqual(stride(ex, over: [.low(0), .high(5), .low(1)]), [-4])

        XCTAssertEqual(stride(ex, over: [.low(1), .high(5), .low(0)]).count, 1)

        XCTAssertEqual(stride(ex, over: [.low(0), .high(5), .low(0)]).count, 1)

        XCTAssertEqual(stride(ex, over: [.low(0), .high(10), .low(2)]).count, 9)
    }
}
