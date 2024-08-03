//
//  PhotoListViewModel.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import Combine
import Foundation
import Combine

class PhotoListViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var likedPhotos: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    @Published var showNoResultsAlert: Bool = false
    
    private let api: UnsplashAPI
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchQuery: String = "" {
        didSet {
            if searchQuery.isEmpty {
                fetchDefaultPhotos()
            } else {
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
    
    var currentPage: Int = 1
    private var hasMorePages: Bool = true
    
    init(api: UnsplashAPI = UnsplashAPI()) {
        self.api = api
    }
    
    func fetchPhotos(query: String, page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        print("Fetching Photos - Page: \(page), Query: \(query)")
        
        api.fetchPhotos(query: query, page: page, perPage: 50)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("API Call Failed: \(error.localizedDescription)")
                    self?.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] photos in
                print("API Call Succeeded - Photos Count: \(photos.count)") 
                if page == 1 {
                    self?.photos = photos
                } else {
                    self?.photos.append(contentsOf: photos)
                }
                self?.hasMorePages = !photos.isEmpty
                self?.showNoResultsAlert = photos.isEmpty
            }
            .store(in: &cancellables)
    }

    
    func fetchDefaultPhotos() {
        currentPage = 1
        hasMorePages = true
        fetchPhotos(query: "nature", page: currentPage)
    }
    
    func fetchNextPage() {
        guard hasMorePages && !isLoading else { return }
        currentPage += 1
        if searchQuery.isEmpty {
            fetchPhotos(query: "nature", page: currentPage)

        }else{
            fetchPhotos(query: searchQuery, page: currentPage)

        }
    }
    
    func updateLikedPhotos(_ photoID: String) {
        if likedPhotos.contains(photoID) {
            likedPhotos.remove(photoID)
        } else {
            likedPhotos.insert(photoID)
        }
    }
}
