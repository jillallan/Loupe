//
//  MockPhotoLibraryAuthorizer.swift
//  LoupeTests
//
//  Created by Jill Allan on 20/07/2025.
//

import Photos
@testable import Loupe

class MockPhotoLibraryAuthorizer: PhotoLibraryAuthorizer {
    var status: PHAuthorizationStatus = .notDetermined
    var didRequestAuthorization = false
    var onRequestAuthorization: ((PHAuthorizationStatus) -> Void)?

    func authorizationStatus() -> PHAuthorizationStatus {
        status
    }
    func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        didRequestAuthorization = true
        onRequestAuthorization?(status)
        handler(status)
    }
}

