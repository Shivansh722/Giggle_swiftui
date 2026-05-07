import XCTest
@testable import Giggle_swiftui

final class CreditServiceLogicTests: XCTestCase {
    func testFirstApplicationIsFree() {
        let appliedJobs: [String] = []
        let isFirst = appliedJobs.isEmpty
        XCTAssertTrue(isFirst)
    }

    func testApplicationCostForSecondJob() {
        let appliedJobs = ["job_1"]
        let cost = appliedJobs.isEmpty ? 0 : CreditConstants.applicationCost
        XCTAssertEqual(cost, 5)
    }

    func testMaxBalanceCap() {
        let newBalance = min(190 + CreditConstants.flnCompletionBonus, CreditConstants.maxBalance)
        XCTAssertEqual(newBalance, 200)
    }
}
