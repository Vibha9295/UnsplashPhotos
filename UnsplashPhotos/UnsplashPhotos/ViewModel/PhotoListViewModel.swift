//
//  PhotoListViewModel.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import Combine

class PhotoListViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var likedPhotos: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    @Published var showNoResultsAlert: Bool = false
    
    private let api = UnsplashAPI()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchQuery: String = "" {
        didSet {
            // Handle empty search query
            if searchQuery.isEmpty {
                fetchDefaultPhotos()
            } else {
                // Debounce search query updates
                $searchQuery
                    .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .sink { [weak self] query in
                        self?.fetchPhotos(query: query)
                    }
                    .store(in: &cancellables)
            }
        }
    }
    
    func fetchPhotos(query: String) {
        isLoading = true
        errorMessage = nil
        
        api.fetchPhotos(query: query, page: 1, perPage: 50)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
                self?.showNoResultsAlert = photos.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func fetchDefaultPhotos() {
        let defaultQuery = "nature"
        
        isLoading = true
        errorMessage = nil
        
        api.fetchPhotos(query: defaultQuery, page: 1, perPage: 50)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
                self?.showNoResultsAlert = photos.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func updateLikedPhotos(_ photoID: String) {
        if likedPhotos.contains(photoID) {
            likedPhotos.remove(photoID)
        } else {
            likedPhotos.insert(photoID)
        }
    }
}
