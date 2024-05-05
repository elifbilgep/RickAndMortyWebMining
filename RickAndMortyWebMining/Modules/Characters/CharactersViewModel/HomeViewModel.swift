//
//  HomeViewModel.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

let BASE_URL = "https://rickandmortyapi.com/api"

@MainActor
final class HomeViewModel: ObservableObject {
    private let client = Client()
    @Published private(set) var characters: [Character] = []
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published private var isFetching = false
    
    private var nextPage: Int = 1
    
    var request: URLRequest = {
        let urlString = "\(BASE_URL)/character"
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }()
    
    func fetchCharacters() async {
        do {
            try await fetchCharactersFromPage(page: nextPage)
        } catch {
            handleFetchError(error: error)
        }
    }
    
    private func fetchCharactersFromPage(page: Int) async throws {
        let request = URLRequest(url: URL(string: "\(BASE_URL)/character?page=\(page)")!)
        do {
            let response = try await client.fetch(type: Characters.self, with: request)
            characters.append(contentsOf: response.results)
            nextPage += 1
        } catch {
            handleFetchError(error: error)
        }
    }
    
    private func handleFetchError(error: Error) {
        errorMessage = "\((error as! APIError).customDescription)"
        hasError = true
    }
    
    func shouldFetchNextPage(currentItem: Character) -> Bool {
        if let lastCharacter = characters.last, lastCharacter.id == currentItem.id {
            return true
        }
        return false
    }
    
    func fetchNextPage() {
        guard !isFetching else { return }
        isFetching = true
        Task {
            await fetchCharacters()
            isFetching = false
        }
    }
}
