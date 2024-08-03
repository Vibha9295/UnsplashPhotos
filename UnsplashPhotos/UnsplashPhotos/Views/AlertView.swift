//
//  AlertView.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import SwiftUI

struct AlertView: View {
    @Binding var errorMessage: ErrorMessage?
    
    var body: some View {
        if let errorMessage = errorMessage {
            VStack {
                Text("Error")
                    .font(.headline)
                Text(errorMessage.message)
                    .font(.body)
                    .padding()
                Button("OK") {
                    self.errorMessage = nil
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 8)
        }
    }
}
