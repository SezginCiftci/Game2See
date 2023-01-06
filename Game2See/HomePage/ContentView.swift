//
//  ContentView.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 29.12.2022.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @ObservedObject var service = WebService()
    @State var gameListModel = [MainResponseModel]()
    @State var viewModel = ViewModel()
    @State private var searchText = ""
    @State private var scrollTop = "scrollTop"
    @State private var showingAlert = false
    @State private var selectedSortNumber = 0
    
    var body: some View {
        
        if gameListModel.isEmpty {
            ProgressView()
        }
        
        NavigationView {
            
            List {
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Button {
                                DispatchQueue.main.async {
                                    viewModel.request(with: genre) { result in
                                        switch result {
                                        case .success(let success):
                                            self.gameListModel = success ?? [MainResponseModel]()
                                        case .failure(_):
                                            showingAlert = true
                                        }
                                    }
                                }
                                selectedSortNumber = 0
                            } label: {
                                Text(genre.rawValue)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(.purple)
                                    .font(.body)
                                    .cornerRadius(10)
                            }.alert("Something went wrong!", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) {
                                    showingAlert = false
                                }
                            }
                            
                        }
                    }
                }).id(self.scrollTop)
                
                VStack {
                    Picker("Sort Type", selection: transactionType) {
                        Text("Default").tag(0)
                        Text("Alphabetical").tag(1)
                        Text("Date").tag(2)
                        Text("Popularity").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.yellow)
                }
                
                ForEach(searchResults, id: \.self) { game in
                    
                    NavigationLink(destination: DetailPage(gameId: game.idResponse)) {
                        
                        KFImage.url(URL(string: game.thumbnail))
                            .resizable()
                            .loadDiskFileSynchronously()
                            .cacheMemoryOnly()
                            .fade(duration: 0.25)
                            .onProgress { receivedSize, totalSize in  }
                            .onSuccess { result in  }
                            .onFailure { error in }
                            .scaledToFill()
                            .frame(width: 100, height: 80)
                            .cornerRadius(5)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(game.title)
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                
                                Text(game.releaseDate.dateToString())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        
                        }
                    .padding(5)
                }
            }
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationBarTitle(Text("Game2See")).navigationBarHidden(false).foregroundColor(.orange)
            .onAppear {
                if selectedSortNumber == 0 {
                    self.loadGameListAll()
                }
            }
            .alert("Something went wrong!", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    showingAlert = false
                }
            }
            .refreshable {
                self.loadGameListAll()
            }
        }
    }
    
    var transactionType: Binding<Int> { Binding<Int>(
        get: {
            return selectedSortNumber
        },
        set: {
            switch $0 {
            case 0:
                self.selectedSortNumber = 0
                self.loadGameListAll()
            case 1:
                self.selectedSortNumber = 1
                self.loadGameList(with: .Alphabetical)
            case 2:
                self.selectedSortNumber = 2
                self.loadGameList(with: .ReleaseDate)
                
            default:
                self.selectedSortNumber = 3
                self.loadGameList(with: .Popularity)
            }
            scrollTop = "\(String(selectedSortNumber))"
        })
    }
    
    var searchResults: [MainResponseModel] {
        if searchText.isEmpty {
            return gameListModel
        } else {
            return gameListModel.filter { $0.title.lowercased() .contains(searchText.lowercased())
            }
        }
    }
    
    func loadGameList(with sortType: SortTypes) {
        DispatchQueue.main.async {
            viewModel.request(with: sortType) { result in
                switch result {
                case .success(let success):
                    self.gameListModel = success ?? [MainResponseModel]()
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func loadGameListAll() {
        DispatchQueue.main.async {
            viewModel.request(with: Genre.all) { result in
                switch result {
                case .success(let success):
                    self.gameListModel = success ?? [MainResponseModel]()
                case .failure(_):
                    showingAlert = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
