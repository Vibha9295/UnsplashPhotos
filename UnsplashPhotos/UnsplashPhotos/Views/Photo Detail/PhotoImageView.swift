//
//  PhotoImageView.swift
//  UnsplashPhotos
//
//  Created by Mac on 03/08/24.
//

import Foundation
import SwiftUI

struct PhotoImageView: View {
    let photo: Photo
    
    var body: some View {
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
    }
}
