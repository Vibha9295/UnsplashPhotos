//
//  PhotoListView.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//
import SwiftUI

struct PhotoListView: View {
    @StateObject private var viewModel = PhotoListViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            TabView {
                SearchTabView(searchText: $searchText, viewModel: viewModel)
                LikedTabView(likedPhotos: $viewModel.likedPhotos, photos: viewModel.photos, removeLikedPhoto: removeLikedPhoto)
            }
            .background(Color(.systemBackground))
            .modifier(TabBarAppearanceModifier(backgroundColor: UIColor.systemBackground))
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $viewModel.showNoResultsAlert) {
                Alert(title: Text("No Results"), message: Text("No photos found for your search query."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func searchPhotos() {
        viewModel.searchQuery = searchText
    }

    private func removeLikedPhoto(photoID: String) {
        viewModel.updateLikedPhotos(photoID)
    }
}
