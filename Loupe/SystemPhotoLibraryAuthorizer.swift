//
//  SystemPhotoLibraryAuthorizer.swift
//  Loupe
//
//  Created by Jill Allan on 20/07/2025.
//

import Photos

struct SystemPhotoLibraryAuthorizer: PhotoLibraryAuthorizer {
    func authorizationStatus() -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus()
    }
    func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(handler)
    }
}
