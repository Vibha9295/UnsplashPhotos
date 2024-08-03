//
//  PhotoListView.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//
import SwiftUI

import SwiftUI

struct PhotoListView: View {
    @StateObject private var viewModel = PhotoListViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    SearchBar(text: $searchText, onSearch: searchPhotos)
                    
                    if viewModel.isLoading && viewModel.photos.isEmpty {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5, anchor: .center)
                            .padding()
                    }
                    
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
                .navigationTitle("Photos")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .onAppear {
                    if searchText.isEmpty {
                        viewModel.fetchDefaultPhotos()
                    }
                }
                
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
