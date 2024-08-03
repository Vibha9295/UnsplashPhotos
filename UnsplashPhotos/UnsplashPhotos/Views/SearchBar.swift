//
//  SearchBar.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search photos", text: $text, onEditingChanged: { isEditing in
                if !isEditing {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onSearch()
                    }
                }
            })
            .accessibilityIdentifier("SearchField") // Ensure this identifier is used in tests
            
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button(action: {
                text = ""
                onSearch()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .padding(8)
                    .foregroundColor(.gray)
            }
            .accessibilityIdentifier("ClearButton") // Added identifier for clear button

        }
        .padding(.top)
    }
}
