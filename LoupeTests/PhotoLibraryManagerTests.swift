//
//  PhotoLibraryManagerTests.swift
//  LoupeTests
//
//  Created by Jill Allan on 20/07/2025.
//

import Photos
import Testing
@testable import Loupe

@Suite("Photo Library Authorization")
struct PhotoLibraryManagerAuthorizationTests {

    @Test("Prompts when status is not determined")
    func testPromptsWhenStatusNotDetermined() async throws {
        // Arrange: set up a mock with .notDetermined
        let mockAuthorizer = MockPhotoLibraryAuthorizer()
        mockAuthorizer.status = .notDetermined
        let manager = PhotoLibraryManager(authorizer: mockAuthorizer)
        var didPrompt = false


        mockAuthorizer.onRequestAuthorization = { _ in didPrompt = true }
        
        // Act
        await manager.requestAuthorization { _ in }

        // Assert
        #expect(didPrompt, "Authorization prompt should be triggered when status is not determined.")
    }

    @Test("Handles all determined authorization statuses correctly")
    func testHandlesAuthorizationStatuses() async throws {
//        let cases: [(status: PHAuthorizationStatus, description: String)] = [
//            (.authorized, "Manager should recognize access is granted when status is authorized."),
//            (.denied, "Manager should recognize access is denied when status is denied."),
//            (.limited, "Manager should recognize access is limited when status is limited."),
//            (.restricted, "Manager should recognize access is restricted when status is restricted.")
//        ]

        let cases: [PHAuthorizationStatus] = [
            .authorized, .denied, .limited, .restricted
        ]

        for testCase in cases {
            let mockAuthorizer = MockPhotoLibraryAuthorizer()
            mockAuthorizer.status = testCase
            let manager = PhotoLibraryManager(authorizer: mockAuthorizer)
            var receivedStatus: PHAuthorizationStatus? = nil

            await manager.requestAuthorization { status in
                receivedStatus = status
            }

            #expect(
                receivedStatus == testCase,
                "Manager should recognize access is granted when status is authorized \(testCase)."
            )
        }
    }
}

