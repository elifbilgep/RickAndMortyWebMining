//
//  LocationView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import SwiftUI

struct LocationView: View {
    @StateObject var viewModel = LocationsViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "272B33")
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rick And Morty").font(.largeTitle).fontWeight(.bold)
                            Text("Locations").font(.title).fontWeight(.bold)
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
                        .padding(.horizontal , 10)
                        .padding(.bottom, 10)
                    
                    // MARK: Image
                    Image("location")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 370)
                        .cornerRadius(15)
                        .padding(.bottom)
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 200)),
                            GridItem(.adaptive(minimum: 200))
                        ], spacing: 20) {
                            ForEach(viewModel.locations, id: \.id) { location in
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
                        
                    }.frame(width: UIScreen.main.bounds.width, alignment: .center)
                    Spacer()
                }
                .task {
                    await viewModel.fetchLocations()
                }
            }
            .ignoresSafeArea()
        }
    
    }
    
}

#Preview {
    LocationView().preferredColorScheme(.dark)
}
