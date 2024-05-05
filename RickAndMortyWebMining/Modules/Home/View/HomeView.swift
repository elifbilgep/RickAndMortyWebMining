//
//  HomeView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollViewReader {scrollView in
                ScrollView(showsIndicators: true) {
                    LazyVStack {
                        ForEach(viewModel.characters, id: \.id) { character in
                            HomeViewCell(character: character).onAppear {
                                if viewModel.shouldFetchNextPage(currentItem: character) {
                                    viewModel.fetchNextPage()
                                }
                            }
                        }
                    }
                    .padding()
                    .task {
                        await viewModel.fetchCharacters()
                    }
                    .alert("", isPresented: $viewModel.hasError) {} message: {
                        Text(viewModel.errorMessage)
                    }
                }
                .navigationTitle("Rick & Morty")
                .navigationBarTitleDisplayMode(.automatic)
            }
        }
    }
}

#Preview {
    HomeView()
}
