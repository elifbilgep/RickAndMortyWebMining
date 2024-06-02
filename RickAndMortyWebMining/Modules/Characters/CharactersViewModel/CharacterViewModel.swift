//
//  HomeViewModel.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

let BASE_URL = "https://rickandmortyapi.com/api"

@MainActor
final class CharacterViewModel: ObservableObject {
    private let client = Client()
    @Published private(set) var characters: [Character] = []
    @Published private(set) var filteredCharacters: [Character] = []
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published private var isFetching = false
    @Published var filterStatus: String = "All"
    @Published var filterSpecies: String = "All"
    @Published var filterGender: String = "All"
    @Published var isFilterSwitchOn = false
    @Published var isOpenFilterSheet = false
    
    private var nextPage: String?
    private var currentPage: Int = 1
    
    // MARK: Fetch
    func fetchCharacters() async throws {
        let request = URLRequest(url: URL(string: "\(BASE_URL)/character?page=\(currentPage)")!)
        do {
            let response = try await client.fetch(type: Characters.self, with: request)
            characters.append(contentsOf: response.results)
            nextPage = response.info.next
        } catch {
            handleFetchError(error: error)
        }
    }
    
    // MARK: Pagianation
    func pagination(currentItem: Character) async throws  {
        if let lastCharacter = characters.last, lastCharacter.id == currentItem.id {
            try await fetchNextPage()
        }
    }
    
    func fetchNextPage() async throws {
        if let nextPage {
            let request = URLRequest(url: URL(string: nextPage)!)
            let response = try await client.fetch(type: Characters.self, with: request)
            characters.append(contentsOf: response.results)
        }
    }
    
    // MARK: Error
    private func handleFetchError(error: Error) {
        errorMessage = "\((error as! APIError).customDescription)"
        hasError = true
        print(errorMessage)
    }
    
    // MARK: Search
    func searchCharacter(name: String) async throws {
        characters = []
        isFilterSwitchOn = false
        let request = URLRequest(url: URL(string: "\(BASE_URL)/character/?name=\(name)")!)
        do {
            let response = try await client.fetch(type: Characters.self, with: request)
            characters.append(contentsOf: response.results)
        } catch {
            handleFetchError(error: error)
        }
    }
    
    // MARK: Reset
    func resetSearch() async throws {
        characters = []
        currentPage = 1
    }
    
    func resetFilter() {
        self.filterGender = "All"
        self.filterStatus = "All"
        self.filterSpecies = "All"
       filterSwitchOnOff(bool: false)
    }
    
    // MARK: Filter
    let statusOptions = ["All", "Alive", "Dead", "Unknown"]
    let speciesOptions = ["All", "Human", "Alien", "Other", "Unkown"]
    let genderOptions = ["All", "Male", "Female", "Other", "Unknown"]
    
    func filterCharacters(searchText: String) async throws{
        characters = []
        let request = URLRequest(url: createURL(searchText: searchText)!)
        do {
            let response = try await client.fetch(type: Characters.self, with: request)
            characters.append(contentsOf: response.results)
            self.nextPage = response.info.next
        } catch {
            handleFetchError(error: error)
        }
    }
    
    // MARK: url parh
    func createURL(searchText: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "/api/character/"
        
        // Query parameters
        let queryItems = [
            URLQueryItem(name: "gender", value: filterGender == "All" ? nil : filterGender),
            URLQueryItem(name: "status", value: filterStatus == "All" ? nil : filterStatus),
            URLQueryItem(name: "species", value: filterSpecies == "All" ? nil : filterSpecies),
            URLQueryItem(name: "name", value: searchText == "" ? nil : searchText)
            // Add more query parameters as needed
        ]
        
        components.queryItems = queryItems
        return components.url
    }
    
    func filterSwitchOnOff(bool: Bool) {
        if bool {
            isFilterSwitchOn = true
        } else {
            isFilterSwitchOn = false
        }
    }

}

