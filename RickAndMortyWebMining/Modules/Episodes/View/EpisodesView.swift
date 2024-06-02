//
//  EpisodesView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import SwiftUI

struct EpisodesView: View {
    @StateObject var viewModel = EpisodesViewModel()
    @State private var searchText = ""
    @State private var showSearchButton = false
    @State private var isFilterSheetOpen = false
    @State private var selectedNumber: Int = 1
    
    var body: some View {
        ZStack {
            Color(hex: "272B33")
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Rick And Morty").font(.title).fontWeight(.bold)
                        Text("Episodes").font(.title2).fontWeight(.bold)
                    }
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.gray.opacity(0.5))
                        .overlay {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .font(.title)
                        }
                        .onTapGesture {
                            isFilterSheetOpen = true
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
                            TextField("Search", text: $searchText)
                                .foregroundColor(.white)
                                .onChange(of: searchText) { oldValue, newValue in
                                    withAnimation {
                                        if newValue != "" {
                                            showSearchButton = true
                                        } else {
                                            showSearchButton = false
                                        }
                                    }
                                }
                            Spacer()
                            showSearchButton ? searchButton
                            : nil
                            Image(systemName: "xmark").foregroundStyle(.white)
                                .onTapGesture {
                                    searchText = ""
                                    Task {
                                        try await viewModel.resetSearch()
                                    }
                                }
                        }.padding()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    .tint(.white)
                // MARK: Episodes
                ScrollView {
                    ForEach(viewModel.episodes, id: \.id) { episode in
                        EpisodeCell(episode: episode)
                            .onAppear {
                                Task {
                                    try await viewModel.pagination(currentItem: episode)
                                }
                            }
                    }
                }
            }
            .task {
                if searchText == "" {
                    await viewModel.fetchEpisodes()
                }
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isFilterSheetOpen) {
            filterSheet
        }
    }
    
    // MARK: Filter Sheet
    var filterSheet: some View {
        VStack {
            Text("Filter")
                .font(.largeTitle)
                .bold()
            Text("Selected Episode: \(selectedNumber)")
                .font(.headline)
                .padding()
            Picker("Select a number", selection: $selectedNumber) {
                ForEach(1...51, id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }.pickerStyle(.wheel)
            Button("Filter", action: {
                Task {
                    do {
                        try await viewModel.filterEpsiodes(episode: selectedNumber)
                    } catch {
                        print(error)
                    }
                }
                isFilterSheetOpen = false
            }
            ).buttonStyle(.borderedProminent)
                .tint(.green)
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
        }
        .padding()
    }
    
    // MARK: Search Button
    @ViewBuilder
    var searchButton: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 100, height: 40)
            .foregroundStyle(.green)
            .overlay {
                Text("Search")
                    .foregroundStyle(.white)
            }.onTapGesture {
                Task {
                    try await viewModel.searchEpisode(episode: searchText)
                }
            }
    }
}

#Preview {
    EpisodesView()
}

struct EpisodeCell: View {
    var episode: Episode
    var body: some View {
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
