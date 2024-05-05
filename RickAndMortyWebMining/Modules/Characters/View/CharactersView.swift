//
//  CharactersView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import SwiftUI

struct CharactersView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "272B33")
                VStack() {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rick And Morty").font(.largeTitle).fontWeight(.bold)
                            Text("Characters").font(.title).fontWeight(.bold)
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
                    .padding(.top, 60)
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
                        .padding(.horizontal ,20)
                        .padding(.bottom, 10)
                    
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 400))
                        ], spacing: 20) {
                            ForEach(viewModel.characters, id: \.id) { character in
                                NavigationLink {
                                    CharacterDetailView(character: character)
                                } label: {
                                    HomeViewCell(character: character).onAppear {
                                        if viewModel.shouldFetchNextPage(currentItem: character) {
                                            viewModel.fetchNextPage()
                                        }
                                    }
                                }
                            }
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width, alignment: .center)
                }
                .task {
                    await viewModel.fetchCharacters()
                }
            } .ignoresSafeArea()
        }
    }
}

#Preview {
    CharactersView()
}
