//
//  EpisodesView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import SwiftUI

struct EpisodesView: View {
    @StateObject var viewModel = EpisodesViewModel()
    var body: some View {
        ZStack {
            Color(hex: "272B33")
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Rick And Morty").font(.largeTitle).fontWeight(.bold)
                        Text("Episodes").font(.title).fontWeight(.bold)
                    }
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.gray.opacity(0.5))
                        .overlay {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .font(.title)
                        }
                }
                .padding(.top ,60)
                .padding(.horizontal ,20)
                
                
                // MARK: Search
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 60)
                    .foregroundStyle(.gray.opacity(0.4))
                    .overlay {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                            Spacer()
                        }.padding()
                    }
                    .padding(.horizontal , 10)
                    .padding(.bottom, 10)
                
                ScrollView {
                    ForEach(viewModel.episodes, id: \.id) { episode in
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: UIScreen.main.bounds.width - 30, height: 60)
                            .foregroundStyle(Color(hex: "3B3E43"))
                            .overlay {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(episode.name).bold()
                                        Text(episode.episode)
                                        
                                    }
                                    Spacer()
                                   
                                }.padding()
                            }
                    }
                }
                
            }
            .task {
                await viewModel.fetchEpisodes()
            }
          
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EpisodesView()
}
