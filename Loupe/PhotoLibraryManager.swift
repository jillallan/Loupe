//
//  PhotoLibraryManager.swift
//  Loupe
//
//  Created by Jill Allan on 20/07/2025.
//

import Foundation
import Photos

struct PhotoLibraryManager {
    let authorizer: PhotoLibraryAuthorizer

    func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) async {
        let status = authorizer.authorizationStatus()
        
        if status == .notDetermined {
            let newStatus = await withCheckedContinuation { continuation in
                authorizer.requestAuthorization { status in
                    continuation.resume(returning: status)
                }
            }
            handler(newStatus)
        } else {
            handler(status)
        }
    }
}
