//
//  PhotoLibraryAuthorizer.swift
//  Loupe
//
//  Created by Jill Allan on 20/07/2025.
//

import Photos

protocol PhotoLibraryAuthorizer {
    func authorizationStatus() -> PHAuthorizationStatus
    func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void)
}
