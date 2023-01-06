//
//  ViewModel.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 29.12.2022.
//

import UIKit
import SwiftUI

class ViewModel: ObservableObject {
    
    @State var service = WebService()
    private var gameDetailWebUrl = ""
    
    func shareButtonAct() {
        if let url = URL(string: gameDetailWebUrl) {
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(activityController, animated: true)
        }
    }
    
    func request(with sortType: SortTypes, completion: @escaping (Result<[MainResponseModel]?, DownloadError>) -> ()) {
        DispatchQueue.main.async {
            let url = URL(string: "\(ConstantsApi.baseUrl)\(ConstantsApi.mainList)\(ConstantsApi.gamesSort)\(sortType.rawValue)") ?? URL(fileURLWithPath: "\(ConstantsApi.baseUrl)\(ConstantsApi.mainList)\(ConstantsApi.gamesSort)\(sortType.rawValue)")
            self.service.downloadGames(url: url) { result in
                switch result {
                case .success(let succes):
                    completion(.success(succes))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func request(with category: Genre, completion: @escaping (Result<[MainResponseModel]?, DownloadError>) -> ()) {
        DispatchQueue.main.async {
            self.service.downloadGames(url: self.configureUrlString(category: category)) { result in
                switch result {
                case .success(let succes):
                    completion(.success(succes))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func configureGenre(category: Genre) -> String {
        let categotyStr = category.rawValue.lowercased()
        return categotyStr.contains(" ") ? categotyStr.replacingOccurrences(of: " ", with: "-") : categotyStr
    }
    
    func configureUrlString(category: Genre) -> URL {
        let mainUrlString = "\(ConstantsApi.baseUrl)\(ConstantsApi.mainList)"
        if category != .all {
            let urlString = "\(ConstantsApi.baseUrl)\(ConstantsApi.mainList)\(ConstantsApi.gamesCategory)\(self.configureGenre(category: category))"
            if let url = URL(string: urlString) {
                return url
            }
        }
        return URL(string: mainUrlString) ?? URL(fileURLWithPath: mainUrlString)
    }
    
    func getGameDetails(gameId: Int, completion: @escaping (Result<DetailResponseModel?, DownloadError>) -> ()) {
        let urlString = "\(ConstantsApi.baseUrl)\(ConstantsApi.gamesDetail)\(gameId)"
        if let url = URL(string: urlString) {
            DispatchQueue.main.async {
                self.service.downloadGameDetail(url: url) { result in
                    switch result {
                    case .success(let success):
                        completion(.success(success))
                        self.gameDetailWebUrl = success?.freetogameProfileURL ?? "\(ConstantsApi.baseUrl)"
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

enum SortTypes: String, CaseIterable {
    case Default = "default"
    case Alphabetical = "alphabetical"
    case ReleaseDate = "release-date"
    case Popularity = "popularity"
}
