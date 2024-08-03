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
            ZStack(alignment: .bottom) {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: photo.urls.thumb)) { image in
                        image
                            .resizable()
                            .cornerRadius(10)
                            .padding([.leading, .trailing], 10)
                    } placeholder: {
                        Color.gray
                            .cornerRadius(10)
                            .padding([.leading, .trailing], 10)
                    }
                }
                .frame(height: 300)
                
                HStack {
                    Text(photo.user.name)
                        .font(.caption)
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: toggleLike) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .red)
                                .padding(10)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(15)
            }
            
            VStack(alignment: .leading) {
                Text(photo.description ?? "No description available.")
                    .padding([.leading, .trailing, .top], 10)
                    .padding(.bottom, 5)
                
                if let createdAt = photo.createdAt {
                    Text("Created at: \(createdAt)")
                        .font(.caption)
                        .padding([.leading, .trailing], 10)
                        .padding(.bottom, 5)
                }
                
                if let portfolioURL = photo.user.portfolioURL, let url = URL(string: portfolioURL) {
                    Link("Visit Profile", destination: url)
                        .padding([.leading, .trailing], 10)
                        .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .padding(.top, 10)
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
