//
//  Endpoint.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

public protocol Endpoint {
    var path: String { get }
    var queryItems: [String: String] { get }
}
extension Endpoint {
    private var base: String {
        "https://api.themoviedb.org"
    }
    
    private var apiKey: String {
        "api_key"
    }
    
    var apiKeyValue: String {
        return "f6cd5c1a9e6c6b965fdcab0fa6ddd38a"
    }
    
    var urlComponents: URLComponents? {
        guard let components = URLComponents(string: base) else { return nil }
        var newComponents = components
        newComponents.path = path
        newComponents.queryItems = [URLQueryItem(name: apiKey, value: apiKeyValue)]
        newComponents.queryItems?.append(contentsOf: queryItems.map({URLQueryItem(name: $0, value: $1)}))
        return newComponents
    }
}
