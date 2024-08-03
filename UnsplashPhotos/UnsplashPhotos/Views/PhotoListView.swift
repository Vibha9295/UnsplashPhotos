//
//  PhotoListView.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import SwiftUI

struct PhotoListView: View {
    @StateObject private var viewModel = PhotoListViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            TabView {
                // Search Tab
                VStack {
                    SearchBar(text: $searchText, onSearch: searchPhotos)
                    
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5, anchor: .center)
                            .padding()
                    }
                    
                    List(viewModel.photos) { photo in
                        NavigationLink(destination: PhotoDetailView(photo: photo, likedPhotos: $viewModel.likedPhotos)) {
                            PhotoRowView(photo: photo, likedPhotos: $viewModel.likedPhotos, isInLikedList: false)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.fetchPhotos(query: searchText)
                    }
                    .onChange(of: searchText) { newValue in
                        if newValue.isEmpty {
                            viewModel.fetchDefaultPhotos()
                        }
                    }
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
                
                // Liked Photos Tab
                VStack(alignment: .leading) {
                    Text("Likes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .padding(.top)
                    
                    List {
                        ForEach(Array(viewModel.likedPhotos), id: \.self) { photoID in
                            if let photo = viewModel.photos.first(where: { $0.id == photoID }) {
                                PhotoRowView(photo: photo, likedPhotos: $viewModel.likedPhotos, isInLikedList: true)
                                    .listRowBackground(Color.clear)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            removeLikedPhoto(photoID: photoID)
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
            .background(Color(.systemBackground))
            .modifier(TabBarAppearanceModifier(backgroundColor: UIColor.systemBackground))
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $viewModel.showNoResultsAlert) {
                Alert(
                    title: Text("No Results"),
                    message: Text("No photos found for your search query."),
                    dismissButton: .default(Text("OK"))
                )
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
