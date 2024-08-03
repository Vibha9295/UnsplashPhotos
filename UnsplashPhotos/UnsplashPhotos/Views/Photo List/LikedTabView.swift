//
//  LikedTabView.swift
//  UnsplashPhotos
//
//  Created by Mac on 03/08/24.
//

import Foundation
import SwiftUI

struct LikedTabView: View {
    @Binding var likedPhotos: Set<String>
    var photos: [Photo]
    var removeLikedPhoto: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Likes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.top)
            
            List {
                ForEach(Array(likedPhotos), id: \.self) { photoID in
                    if let photo = photos.first(where: { $0.id == photoID }) {
                        PhotoRowView(photo: photo, likedPhotos: $likedPhotos, isInLikedList: true)
                            .listRowBackground(Color.clear)
                            .swipeActions {
                                Button(role: .destructive) {
                                    removeLikedPhoto(photoID)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .tabItem {
            Label("Liked", systemImage: "heart.fill")
        }
    }
}
