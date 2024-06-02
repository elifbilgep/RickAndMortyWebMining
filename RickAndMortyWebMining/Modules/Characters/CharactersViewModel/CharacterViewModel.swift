//
//  HomeViewModel.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

let BASE_URL = "https://rickandmortyapi.com/api"

enum SortOption: String, CaseIterable, Identifiable {
    case nameAscending = "Name Ascending"
    case nameDescending = "Name Descending"
    
    var id: String { self.rawValue }
}

@MainActor
final class CharacterViewModel: ObservableObject {
    private let client = Client()
    @Published private(set) var characters: [Character] = []
    @Published private(set) var filteredCharacters: [Character] = []
    @Published private(set) var allCharacters: [Character] = []
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published private var isFetching = false
    @Published var filterStatus: String = "All"
    @Published var filterSpecies: String = "All"
    @Published var filterGender: String = "All"
    @Published var isFilterSwitchOn = false
    @Published var isOpenFilterSheet = false
    @Published var isOpenSortingSheet = false
    
    private var nextPage: String?
    private var currentPage: Int = 1
    private var totalPage: Int = 0
    
    // MARK: Fetch
    func fetchCharacters() async throws {
        let request = URLRequest(url: URL(string: "\(BASE_URL)/character?page=\(currentPage)")!)
        do {
            let response = try await client.fetch(type: Characters.self, with: request)
            characters.append(contentsOf: response.results)
            nextPage = response.info.next
            totalPage = response.info.pages ?? 0
        } catch {
            handleFetchError(error: error)
        }
    }
    
    func fetchAllCharacters() async throws {
        while currentPage < totalPage {
            let urlString = "\(BASE_URL)/character?page=\(currentPage)"
            let request = URLRequest(url: URL(string: urlString)!)

            do {
                let response = try await client.fetch(type: Characters.self, with: request)
                allCharacters.append(contentsOf: response.results)
            } catch {
                handleFetchError(error: error)
                break // Exit loop if there's an error to prevent infinite retries
            }
            currentPage += 1
        }
        print(allCharacters)
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
    
    
    // MARK: Sort
    func sortCharacters(by option: SortOption) -> [Character] {
        characters = []
        switch option {
        case .nameAscending:
            return allCharacters.sorted { $0.name < $1.name }
        case .nameDescending:
            return allCharacters.sorted { $0.name > $1.name }
        }
    }
    
    func sort(by option: SortOption) {
       characters = sortCharacters(by: option)
    }
    
    // MARK: Toggle Sheets
    func toggleSortingSheet(with bool: Bool) {
        if bool {
            isOpenSortingSheet = true
        } else {
            isOpenSortingSheet = false
        }
    }
    
    func filterSwitchOnOff(bool: Bool) {
        if bool {
            isFilterSwitchOn = true
        } else {
            isFilterSwitchOn = false
        }
    }
    
}

