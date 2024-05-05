//
//  LocationsViewModel.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import Foundation

@MainActor
final class LocationsViewModel: ObservableObject {
    private let client = Client()
    
    @Published private(set) var locations: [Location] = []
    @Published private(set) var residents: [Character] = []
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published private var isFetching = false
    
    func fetchLocations() async {
        let request = URLRequest(url: NetworkManager().buildURL(urlPath: .location))
        do {
            let response = try await client.fetch(type: Locations.self, with: request)
            locations.append(contentsOf: response.results)
        } catch {
            handleFetchError(error: error)
        }
    }
    
    func fetchResidents(urlStrings: [String]) async {
        for urlString in urlStrings {
            print(urlString)
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            do {
                let response = try await client.fetch(type: Character.self, with: request)
                residents.append(response)
            } catch {
                handleFetchError(error: error)
            }
        }
    }
    
    
    //    func fetchNextPage(page: String) {
    //        do {
    //
    //        } catch {
    //            handleFetchError(error: error)
    //        }
    //    }
    
    private func handleFetchError(error: Error) {
        errorMessage = "\((error as! APIError).customDescription)"
        hasError = true
    }
}
