//
//  Helper.swift
//  VidGrid
//
//  Created by iMac on 05/08/24.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

typealias Handler = (Result<[Reel], DataError>) -> Void

func readJSONFile(completion: @escaping Handler) {
    
    guard let path = Bundle.main.path(forResource: "reels", ofType: "json") else {
        completion(.failure(.invalidURL))
        return
    }
    
    let url = URL(fileURLWithPath: path)
    
    do {
        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(ReelsResponse.self, from: data)
        completion(.success(response.reels))
    } catch {
        if let dataError = error as? DataError {
            completion(.failure(dataError))
        } else {
            completion(.failure(.network(error)))
        }
    }
}
