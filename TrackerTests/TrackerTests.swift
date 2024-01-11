//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Artem Dubovitsky on 11.01.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersViewControllerLight() {
        
        let trackersViewController = TrackersViewController()
        assertSnapshot(matching: trackersViewController, as: .image)
    }
}
