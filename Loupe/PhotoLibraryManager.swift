import Photos
import SwiftUI
import Observation

@Observable
@MainActor
class PhotoLibraryManager {
    @MainActor private(set) var assets: [PHAsset] = []
    var authorizationStatus: PHAuthorizationStatus = .notDetermined

    func fetchAssets() async {
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.includeAssetSourceTypes = [
            .typeUserLibrary,
            .typeCloudShared
        ]
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.assets = await MainActor.run { () -> [PHAsset] in
            let result = PHAsset.fetchAssets(
                with: .image,
                options: fetchOptions
            )
            // Assign results to a temporary assets array
            // Then assigns this array to the published one
            // once all updates completed
            // This ensures all updates are completed at once
            // avoiding duplicates and multiple UI updates
            var assets: [PHAsset] = []
            result.enumerateObjects { asset, _, _ in assets.append(asset) }
            return Array(assets.prefix(20))
        }
    }

    func requestImage(for asset: PHAsset, targetSize: CGSize) async -> Image? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false
            options.resizeMode = .exact
            options.isNetworkAccessAllowed = false

            var didResume = false
            
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: options
            ) { uiImage, _ in
                
                guard !didResume else { return }
                didResume = true
                #if os(iOS)
                if let uiImage = uiImage {
                    continuation.resume(returning: Image(uiImage: uiImage))
                } else {
                    continuation.resume(returning: nil)
                }
                #elseif os(macOS)
                if let nsImage = uiImage {
                    continuation.resume(returning: Image(nsImage: nsImage))
                } else {
                    continuation.resume(returning: nil)
                }
                #endif
            }
        }
    }
}

