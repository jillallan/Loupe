//
//  PhotoView.swift
//  Loupe
//
//  Created by Jill Allan on 20/07/2025.
//

import Photos
import SwiftUI

struct PhotoView: View {
    let photos = [
        Image(.train1),
        Image(.train2),
        Image(.train3),
        Image(.train1),
        Image(.train2),
        Image(.train3),
        Image(.train2),
        Image(.train1),
    ]

    @State var selectedIndex: Int = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(photos.indices, id: \.self) { index in
                FullscreenPhotoView(photo: photos[index])
                    .tag(index)
            }
        }

        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }

}

struct FullscreenPhotoView: View {
    let photo: Image

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            photo
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    PhotoView()
}
