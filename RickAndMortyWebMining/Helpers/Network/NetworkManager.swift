//
//  NetworkManager.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

enum URLPath: String {
    case character = "character"
    case location = "location"
    case episode = "episode"
}

struct NetworkRequest {
    let method: HTTPMethod
    let url: URL
}

class NetworkManager {
    final let baseUrl = URL(string:  "https://rickandmortyapi.com/api/")
    
    func buildURL(urlPath: URLPath) -> URL? {
        if let baseUrl {
            let requestURL = baseUrl.appending(path: urlPath.rawValue)
            return requestURL
        } else {
            return nil
        }
    }
}

extension NetworkRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}
