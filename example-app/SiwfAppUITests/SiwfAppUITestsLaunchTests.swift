//
//  SiwfAppUITestsLaunchTests.swift
//  SiwfAppUITests
//
//  Created by Claire Olmstead on 12/6/24.
//

import XCTest

final class SiwfAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Check that the navigation title exists
        let navigationTitle = app.navigationBars["SIWF Demo App"]
        XCTAssertTrue(navigationTitle.exists, "Navigation title 'SIWF Demo App' should be visible")
        
        // Look for any SIWF button and wait for it - we just need to verify at least one exists
        XCTAssertTrue(app.buttons.element(boundBy: 0).waitForExistence(timeout: 2.0), "At least one button should be visible")
        XCTAssertGreaterThanOrEqual(
            app.buttons.count,
            3,
            "Expected at least 3 SIWF buttons"
        )
        
        // Take the screenshot as before
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen with SIWF Buttons"
        attachment.lifetime = .deleteOnSuccess
        add(attachment)
    }
}
