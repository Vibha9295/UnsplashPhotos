//
//  PhotoDetailView.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    @Binding var likedPhotos: Set<String>
    
    var isLiked: Bool {
        likedPhotos.contains(photo.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                PhotoImageView(photo: photo)
                PhotoHeaderView(userName: photo.user.name, isLiked: isLiked, toggleLike: toggleLike)
                PhotoDescriptionView(photo: photo)
            }
            .navigationTitle("Photo Detail")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func toggleLike() {
        if isLiked {
            likedPhotos.remove(photo.id)
        } else {
            likedPhotos.insert(photo.id)
        }
    }
}
