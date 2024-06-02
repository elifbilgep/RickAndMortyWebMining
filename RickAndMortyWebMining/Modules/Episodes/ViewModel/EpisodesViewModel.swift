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
    @Published var allEpisodes: [Episode] = []
    var nextPage: String?
    var currentPage = 1
    var totalPage = 0
    // MARK: Fetch
    func fetchEpisodes() async {
        let request = URLRequest(url: NetworkManager().buildURL(urlPath: .episode))
        do {
            let response = try await client.fetch(type: Episodes.self, with: request)
            episodes.append(contentsOf: response.results)
            nextPage = response.info.next
            totalPage = response.info.pages
        } catch {
            handleFetchError(error: error)
        }
    }
    
    
    func fetchAllEpisodes() async throws {
        while currentPage < totalPage {
            let urlString = "\(BASE_URL)/episode/?page=\(currentPage)"
            let request = URLRequest(url: URL(string: urlString)!)

            do {
                let response = try await client.fetch(type: Episodes.self, with: request)
                allEpisodes.append(contentsOf: response.results)
            } catch {
                handleFetchError(error: error)
                break
            }
            currentPage += 1
        }
        print(allEpisodes)
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
    
    // MARK: Error
    private func handleFetchError(error: Error) {
        errorMessage = "\((error as! APIError).customDescription)"
        hasError = true
    }
    
    // MARK: Search
    func searchEpisode(episode: String) async throws {
        episodes = []
        let request = URLRequest(url: URL(string: "\(BASE_URL)/episode/?name=\(episode)")!)
        do {
            let response = try await client.fetch(type: Episodes.self, with: request)
            episodes.append(contentsOf: response.results)
            //nextPage += 1
        } catch {
            handleFetchError(error: error)
        }
    }
    
    func resetSearch() async throws {
        episodes = []
        await fetchEpisodes()
    }
    
    // MARK: Pagination
    func pagination(currentItem: Episode) async throws  {
        if let lastEpisode = episodes.last, lastEpisode.id == currentItem.id {
            try await fetchNextPage()
        }
    }
    
    func fetchNextPage() async throws {
        if let nextPage {
            let request = URLRequest(url: URL(string: nextPage)!)
            let response = try await client.fetch(type: Episodes.self, with: request)
            episodes.append(contentsOf: response.results)
            self.nextPage = response.info.next
        }
    }
    
    // MARK: Filter
    func filterEpsiodes(episode: Int) async throws {
        episodes = []
        let request = URLRequest(url: URL(string: "\(BASE_URL)/episode/\(episode)")!)
        do {
            let response = try await client.fetch(type: Episode.self, with: request)
            episodes.append(response)
        } catch {
            handleFetchError(error: error)
        }
    }
    
    // MARK: Sort
    func sortLocations(by option: SortOption) -> [Episode] {
        episodes = []
        switch option {
        case .nameAscending:
            return allEpisodes.sorted { $0.name < $1.name }
        case .nameDescending:
            return allEpisodes.sorted { $0.name > $1.name }
        }
    }
    
    func sort(by option: SortOption) {
       episodes = sortLocations(by: option)
    }
}
