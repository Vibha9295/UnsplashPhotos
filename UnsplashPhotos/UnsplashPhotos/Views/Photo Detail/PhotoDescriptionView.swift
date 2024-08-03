//
//  PhotoDescriptionView.swift
//  UnsplashPhotos
//
//  Created by Mac on 03/08/24.
//

import Foundation
import SwiftUI

struct PhotoDescriptionView: View {
    let photo: Photo
    
    var body: some View {
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
    }
}
