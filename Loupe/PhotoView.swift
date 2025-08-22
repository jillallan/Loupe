//
//  PhotoView.swift
//  Loupe
//
//  Created by Jill Allan on 20/07/2025.
//

import Photos
import SwiftUI

struct PhotoView: View {
    @State private var photoLibraryManager = PhotoLibraryManager()

    @State var selectedIndex: Int = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedIndex) {
                ForEach(Array(photoLibraryManager.assets.enumerated()), id: \.1) { index, asset in
                    FullscreenPhotoView(photoLibraryManager: photoLibraryManager, asset: asset)
                        .tag(index)
                }
            }
//#if os(iOS)
//            .tabViewStyle(.page(indexDisplayMode: .never))
//#endif
            .ignoresSafeArea()
            .navigationTitle("Photos")
            .onAppear() {
                Task {
                    await photoLibraryManager.fetchAssets()
                }
            }
        }
    }
}

struct FullscreenPhotoView: View {
    let photoLibraryManager: PhotoLibraryManager
    let asset: PHAsset
    @State private var loadedPhoto: Image?
    @State private var isHighResLoaded = false
    @State private var targetSize = CGSize(.zero)
    @State private var highResTargetSize = CGSize(.zero)
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    var magnification: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                currentZoom = log(value.magnification)
                //                if zoomScale > 2.0 && !isHighResLoaded {
                //                    Task {
                //                        await photoLibraryManager.requestImage(for: asset, targetSize: highResTargetSize)
                //                    }
                //                }
            }
            .onEnded { value in
                totalZoom += currentZoom
                totalZoom = max(0.5, totalZoom)
                currentZoom = 0
            }
            
    }
    
    @Environment(\.displayScale) var displayScale

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                if let loadedPhoto = loadedPhoto {
                    loadedPhoto
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(currentZoom + totalZoom)
                        .gesture(magnification)
                        .accessibilityZoomAction { action in
                            if action.direction == .zoomIn {
                                totalZoom += 1
                            } else {
                                totalZoom -= 1
                            }
                        }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Photo")
            .onAppear {
                targetSize = CGSize(
                    width: geometry.size.width * displayScale,
                    height: geometry.size.height * displayScale
                )
                highResTargetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                Task {
                    if let loaded = await photoLibraryManager.requestImage(for: asset, targetSize: targetSize) {
                        loadedPhoto = loaded
                    }
                }
            }
            .onDisappear {
                totalZoom = 1.0
            }
        }
    }
}

#Preview {
    PhotoView()
}
