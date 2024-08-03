//
//  SearchTabView.swift
//  UnsplashPhotos
//
//  Created by Mac on 03/08/24.
//

import Foundation
import SwiftUI

struct SearchTabView: View {
    @Binding var searchText: String
    @ObservedObject var viewModel: PhotoListViewModel
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, onSearch: searchPhotos)
            photoList
        }
        .navigationTitle("Photos")
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
        .onAppear {
            if searchText.isEmpty {
                viewModel.fetchDefaultPhotos()
            }
        }
    }
    
    private var photoList: some View {
        List {
            ForEach(viewModel.photos) { photo in
                NavigationLink(destination: PhotoDetailView(photo: photo, likedPhotos: $viewModel.likedPhotos)) {
                    PhotoRowView(photo: photo, likedPhotos: $viewModel.likedPhotos, isInLikedList: false)
                }
                .listRowBackground(Color.clear)
                .onAppear {
                    if photo.id == viewModel.photos.last?.id {
                        viewModel.fetchNextPage()
                    }
                }
            }
            
            if viewModel.isLoading && !viewModel.photos.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func searchPhotos() {
        viewModel.searchQuery = searchText
    }
}
