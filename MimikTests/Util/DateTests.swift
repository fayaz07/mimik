//
//  DateTests.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 16/10/25.
//

import XCTest
@testable import Mimik

class DateTests: XCTestCase {
    
    func testJustNow() {
        let now = Date()
        XCTAssertEqual(customRelativeTimeString(from: now), "just now")
    }
    
    func testAFewSecondsAgo() {
        let date = Date().addingTimeInterval(-5)
        XCTAssertEqual(customRelativeTimeString(from: date), "a few seconds ago")
    }

    func testSecondsAgo() {
        let date = Date().addingTimeInterval(-15)
        XCTAssertEqual(customRelativeTimeString(from: date), "15 seconds ago")
    }

    func testOneMinuteAgo() {
        let date = Date().addingTimeInterval(-60)
        XCTAssertEqual(customRelativeTimeString(from: date), "1 minute ago")
    }

    func testMinutesAgo() {
        let date = Date().addingTimeInterval(-5 * 60)
        XCTAssertEqual(customRelativeTimeString(from: date), "5 minutes ago")
    }

    func testOneHourAgo() {
        let date = Date().addingTimeInterval(-3600)
        XCTAssertEqual(customRelativeTimeString(from: date), "an hour ago")
    }

    func testHoursAgo() {
        let date = Date().addingTimeInterval(-3 * 3600)
        XCTAssertEqual(customRelativeTimeString(from: date), "3 hours ago")
    }

    func testYesterday() {
        let date = Date().addingTimeInterval(-24 * 3600)
        XCTAssertEqual(customRelativeTimeString(from: date), "yesterday")
    }

    func testDaysAgo() {
        let date = Date().addingTimeInterval(-3 * 24 * 3600)
        XCTAssertEqual(customRelativeTimeString(from: date), "3 days ago")
    }

    func testLastWeek() {
        let date = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        XCTAssertEqual(customRelativeTimeString(from: date), "last week")
    }

    func testWeeksAgo() {
        let date = Calendar.current.date(byAdding: .weekOfYear, value: -3, to: Date())!
        XCTAssertEqual(customRelativeTimeString(from: date), "3 weeks ago")
    }

    func testOneMonthAgo() {
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        XCTAssertEqual(customRelativeTimeString(from: date), "a month ago")
    }

    func testMonthsAgo() {
        let date = Calendar.current.date(byAdding: .month, value: -5, to: Date())!
        XCTAssertEqual(customRelativeTimeString(from: date), "5 months ago")
    }

    func testOneYearAgo() {
        let date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        XCTAssertEqual(customRelativeTimeString(from: date), "an year ago")
    }

    func testYearsAgo() {
        let date = Calendar.current.date(byAdding: .year, value: -3, to: Date())!
        XCTAssertEqual(customRelativeTimeString(from: date), "3 years ago")
    }
}
