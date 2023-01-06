//
//  DetailPage.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 29.12.2022.
//

import SwiftUI
import Kingfisher

struct DetailPage: View {
    
    @State var gameDetail: DetailResponseModel?
    @State var viewModel = ViewModel()
    @State var gameId: Int
    @State var gameDetailWebUrl: String = ""
    @State private var showingAlert = false
    @ObservedObject var service = WebService()

    @State private var showWebView = false
    
    var body: some View {
        
        if gameDetail == nil {
            ProgressView()
        }
        
        ScrollView(.vertical, showsIndicators: true, content: {
            
            VStack {
                    
                    KFImage(URL(string: gameDetail?.thumbnail ?? ""))
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .fade(duration: 0.25)
                        .onProgress { receivedSize, totalSize in  }
                        .onSuccess { result in  }
                        .onFailure { error in }
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.size.width - 60, height: 200, alignment: .center)
                        .cornerRadius(20)
                        .padding()
                    
                    VStack {
                        Text("Genre: ")
                            .bold() +
                        Text(gameDetail?.genre ?? "")
                            .foregroundColor(.accentColor)
                        
                        Text("Publisher: ")
                            .bold() +
                        Text(gameDetail?.publisher ?? "")
                            .foregroundColor(.accentColor)
                        
                        Text("Release Date: ")
                            .bold() +
                        Text(gameDetail?.releaseDate.dateToString() ?? "")
                            .foregroundColor(.accentColor)
                        
                        Text("Platform: ")
                            .bold() +
                        Text(gameDetail?.platform ?? "")
                            .foregroundColor(.accentColor)
                    }.padding()
                       
                    HStack {
                        Button {
                            showWebView.toggle()
                        } label: {
                            Image(systemName: "network")
                                .foregroundColor(.white)
                                .frame(width: 60, height: 40, alignment: .center)
                                .scaleEffect(2)
                        }.frame(width: 70, height: 40, alignment: .center)
                            .buttonStyle(.borderedProminent)
                            .padding()
                        .sheet(isPresented: $showWebView) {
                            if let url = URL(string: gameDetail?.freetogameProfileURL ?? "https://www.freetogame.com/") {
                                WebView(url: url)
                            }
                        }
                        
                        Button(action: viewModel.shareButtonAct) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .frame(width: 60, height: 40, alignment: .center)
                                .scaleEffect(2)
                        }.frame(width: 70, height: 40, alignment: .center)
                            .buttonStyle(.borderedProminent)
                            .padding()
                    }
                    
                    Text(gameDetail?.welcomeDescription ?? "")
                            .padding(20)
                    
                    Text("Further Game Images")
                            .padding()
                            .font(.title2)
                    
                    ScrollView(.horizontal, content: {
                        HStack {
                            ForEach(gameDetail?.screenshots ?? [Screenshot](), id: \.self) { furtherImage in
                                KFImage(URL(string: furtherImage.image))
                                    .loadDiskFileSynchronously()
                                    .cacheMemoryOnly()
                                    .fade(duration: 0.25)
                                    .onProgress { receivedSize, totalSize in  }
                                    .onSuccess { result in  }
                                    .onFailure { error in }
                                    .scaledToFit()
                                    .frame(width: 200, height: 150, alignment: .center)
                                    .cornerRadius(10)
                                    .padding(5)
                            }
                        }
                    })
                    
                }
            
            }).onAppear {
                DispatchQueue.main.async {
                    viewModel.getGameDetails(gameId: gameId) { result in
                        switch result {
                        case .success(let success):
                            self.gameDetail = success
                        case .failure(_):
                            showingAlert = true
                        }
                    }
                }
            }
            .navigationTitle(gameDetail?.title ?? "Detail Page")
            .navigationBarTitleDisplayMode(.large)
            .alert("Something went wrong!", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    showingAlert = false
                }
            }
    }
}

struct DetailPage_Previews: PreviewProvider {
    static var previews: some View {
        DetailPage(gameId: 452)
    }
}
