//
//  EpisodesViewModel.swift
//  RickAndMortyWebMining
//
//  Created by Aykut Türkyılmaz on 5.05.2024.
//

import Foundation

@MainActor
final class EpisodesViewModel: ObservableObject {
    private let client = Client()
    
    @Published private(set) var episodes: [Episode] = []
    @Published private(set) var characters: [Character] = []
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published private var isFetching = false
    
    func fetchEpisodes() async {
        let request = URLRequest(url: NetworkManager().buildURL(urlPath: .episode))
        do {
            let response = try await client.fetch(type: Episodes.self, with: request)
            episodes.append(contentsOf: response.results)
        } catch {
            handleFetchError(error: error)
        }
    }
    
    func fetchCharacters(urlStrings: [String]) async {
        for urlString in urlStrings {
            print(urlString)
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            do {
                let response = try await client.fetch(type: Character.self, with: request)
                characters.append(response)
            } catch {
                handleFetchError(error: error)
            }
        }
    }
    
    private func handleFetchError(error: Error) {
        errorMessage = "\((error as! APIError).customDescription)"
        hasError = true
    }
}
