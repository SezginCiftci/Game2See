//
//  Service.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 29.12.2022.
//

import Foundation

class WebService: ObservableObject {
    
    @Published var gameList: [MainResponseModel] = []
    
    func downloadGames(url: URL, completion: @escaping (Result<[MainResponseModel]?, DownloadError>) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                completion(.failure(.badUrl))
                return
            }
            do {
                let cryptoData = try JSONDecoder().decode([MainResponseModel].self, from: data)
                completion(.success(cryptoData))
            } catch {
                completion(.failure(.dataParseError))
            }
        }.resume()
    }
    
    func downloadGameDetail(url: URL, completion: @escaping (Result<DetailResponseModel?, DownloadError>) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                completion(.failure(.badUrl))
                return
            }
            do {
                let cryptoData = try JSONDecoder().decode(DetailResponseModel.self, from: data)
                completion(.success(cryptoData))
            } catch {
                completion(.failure(.dataParseError))
            }
        }.resume()
    }
}


enum DownloadError: Error {
    case badUrl
    case noData
    case dataParseError
}
