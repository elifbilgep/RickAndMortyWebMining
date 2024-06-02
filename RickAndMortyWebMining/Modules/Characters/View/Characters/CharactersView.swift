//
//  CharactersView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import SwiftUI

struct CharactersView: View {
    @StateObject var viewModel = CharacterViewModel()
    @State private var searchText = ""
    @State private var showSearchButton = false
    @State private var isOpenSortingSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "272B33")
                VStack() {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rick And Morty").font(.title).fontWeight(.bold)
                            Text("Characters").font(.title2).fontWeight(.bold)
                        }
                        Spacer()
                        // MARK: Sort
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.gray.opacity(0.5))
                            .overlay {
                                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                    .font(.title)
                            }.onTapGesture {
                                viewModel.isOpenFilterSheet = true
                            }
                        // MARK: Filter
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.gray.opacity(0.5))
                            .overlay {
                                Image(systemName: "list.number")
                                    .font(.title)
                            }.onTapGesture {
                                isOpenSortingSheet = true
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
                                        viewModel.resetFilter()
                                        searchText = ""
                                        Task {
                                            do {
                                                try await viewModel.resetSearch()
                                            } catch {
                                                print(error)
                                            }
                                        }
                                        
                                    }
                            }.padding()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        .tint(.white)
                    
                    // MARK: Characters
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 400))
                        ], spacing: 20) {
                            ForEach(viewModel.characters, id: \.id) { character in
                                NavigationLink {
                                    CharacterDetailView(character: character)
                                } label: {
                                    HomeViewCell(character: character)
                                        .onAppear {
                                            Task {
                                                try await viewModel.pagination(currentItem: character)
                                            }
                                        }
                                }
                            }
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width, alignment: .center)
                }
                .task {
                    if searchText == "" || viewModel.isFilterSwitchOn == false {
                        do {
                            try await viewModel.fetchCharacters()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            } .ignoresSafeArea()
                .sheet(isPresented: $viewModel.isOpenFilterSheet, content: {
                    filterSheetView
                })
                .sheet(isPresented: $isOpenSortingSheet, content: {
                    sortingSheetView
                })
        }.preferredColorScheme(.dark)
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
                    try await viewModel.searchCharacter(name: searchText)
                }
            }
    }
    // MARK: Filter Sheet View
    @ViewBuilder
    var filterSheetView: some View {
        VStack {
            Text("Filter").font(.largeTitle).bold()
                .padding(.top, 20)
            Toggle(isOn: $viewModel.isFilterSwitchOn, label: {
                Text("Filter on / off")
            })
            VStack(alignment: .leading) {
                Text("Status").font(.title2)
                Picker("Status", selection: $viewModel.filterStatus) {
                    ForEach(viewModel.statusOptions, id: \.self) { status in
                        Text(status).tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }.padding(.vertical)
            
            VStack(alignment: .leading) {
                Text("Species").font(.title2)
                Picker("Species", selection: $viewModel.filterSpecies) {
                    ForEach(viewModel.speciesOptions, id: \.self) { species in
                        Text(species).tag(species)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }.padding(.vertical)
            
            VStack (alignment: .leading) {
                Text("Gender").font(.title2)
                Picker("Gender", selection: $viewModel.filterGender) {
                    ForEach(viewModel.genderOptions, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }.padding(.vertical)
            
            Button(action: {
                Task {
                    try await viewModel.filterCharacters(searchText: searchText)
                }
                viewModel.filterSwitchOnOff(bool: true)
                viewModel.isOpenFilterSheet = false
            }) {
                Text("Apply Filters")
                    .font(.headline)
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }.padding(.vertical)
            Spacer()
        }.foregroundStyle(.white)
            .padding()
    }
    
    // MARK: Sorting Sheet View
    var sortingSheetView: some View {
        VStack {
            
        }
    }
}

#Preview {
    CharactersView()
}
