//
//  Client.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

final class Client: GenericAPI {
    let session: URLSession
    
    init(configureation: URLSessionConfiguration){
        self.session = URLSession(configuration: configureation)
    }
    
    convenience init() {
        self.init(configureation: .default)
    }
}
