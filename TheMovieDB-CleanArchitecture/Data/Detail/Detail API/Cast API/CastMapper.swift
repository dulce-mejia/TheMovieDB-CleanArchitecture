//
//  CastMapper.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

final class CastMapper {

    struct CreditsDTO: Codable {
        var id: Int
        var cast: [CastDTO]
    }

    struct CastDTO: Codable {
        var name: String
        var profilePath: String?

        var cast: Cast {
            Cast(name: name, profilePath: profilePath)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteCastLoader.Result {

        guard response.isOK else {
            return .failure(RemoteCastLoader.Error.invalidData)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(CreditsDTO.self, from: data)
            return .success(result.cast.map { $0.cast })
        } catch {
            return .failure(RemoteCastLoader.Error.invalidData)
        }
    }
}
