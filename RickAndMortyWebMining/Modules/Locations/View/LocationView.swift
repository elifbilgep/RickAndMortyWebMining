//
//  LocationView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import SwiftUI

struct LocationView: View {
    @StateObject var viewModel = LocationsViewModel()
    @State private var searchText = ""
    @State private var showSearchButton = false
    @State private var isOpenFilterSheet = false
    @State private var isOpenSortingSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "272B33")
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rick And Morty").font(.title).fontWeight(.bold)
                            Text("Locations").font(.title2).fontWeight(.bold)
                        }
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.gray.opacity(0.5))
                            .overlay {
                                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                    .font(.title)
                            }.onTapGesture {
                                isOpenFilterSheet = true
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
                    
                    // MARK: Image
                    Image("location")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 370)
                        .cornerRadius(15)
                        .padding(.bottom)
                    
                    // MARK: Locations
                    ScrollViewReader { scrollView in
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 200)),
                                GridItem(.adaptive(minimum: 200))
                            ], spacing: 20) {
                                ForEach(viewModel.locations, id: \.id) { location in
                                    LocationCell(location: location)
                                        .onAppear {
                                            Task {
                                                
                                              try await viewModel.pagination(currentItem: location)
                                            }
                                        }
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width, alignment: .center)
                        Spacer()
                    }
                }
                .task {
                    if searchText == "" {
                        await viewModel.fetchLocations()
                    }
                }
                
            }
            .ignoresSafeArea()
            .sheet(isPresented: $isOpenFilterSheet ) {
                filterSheetView
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
            HStack {
                Text("Type:").font(.title3)
                Spacer()
                Picker("Type", selection: $viewModel.filterType) {
                    ForEach(viewModel.typeOptions, id: \.self) { status in
                        Text(status).tag(status)
                    }
                }
                .pickerStyle(.menu)
                .tint(.white)
            }.padding(.vertical)
            
            
            Button(action: {
                Task {
                   await viewModel.filterLocation()
                }
                viewModel.filterSwitchOnOff(bool: true)
                isOpenFilterSheet = false
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
                    do {
                        try await viewModel.searchLocation(location: searchText)
                    } catch {
                        print(error)
                    }
                }
            }
    }
}

#Preview {
    LocationView().preferredColorScheme(.dark)
}

struct LocationCell:  View {
    var location: Location
    
    var body: some View {
        NavigationLink {
            LocationDetailView(location: location)
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 180, height: 60)
                .foregroundStyle(Color(hex: "3B3E43"))
                .overlay {
                    VStack{
                        Text(location.name)
                        Text("\(location.type)").opacity(0.6)
                        
                    }.padding()
                        .font(.body)
                }
        }.tint(.white)
    }
}
