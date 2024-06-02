//
//  LocationDetailView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import SwiftUI

struct LocationDetailView: View {
    var location: Location
    @StateObject var viewModel = LocationsViewModel()
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        ZStack {
            Color(hex: "272B33")
            VStack {
                HStack {
                    Image(systemName: "arrow.backward")
                    Text("Back").bold()
                    Spacer()
                }.padding(.top, 60)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Location Detail").font(.largeTitle).fontWeight(.bold)
                        Text(location.name).font(.title).fontWeight(.bold)
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
                .padding(.horizontal ,20)
                
                ScrollView(.vertical) {
                    
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 200)),
                        GridItem(.adaptive(minimum: 200)),
                        
                    ], spacing: 20) {
                        ForEach(viewModel.residents, id: \.id) { character in
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 180, height: 200, alignment: .center)
                                .cornerRadius(16)
                                .padding(.vertical)
                                .overlay {
                                    AsyncImage(url: URL(string: character.image)) { image in
                                        image.resizable()
                                            .cornerRadius(15)
                                            .frame(width: 180, height: 200, alignment: .center)
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                        }
                    }
                    
                }
                Spacer()
            }
            .onAppear(perform: {
                Task {
                    await viewModel.fetchResidents(urlStrings: location.residents)
                }
            })
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
   
    }
}

#Preview {
    LocationDetailView(location: Location(id: 1, name: "Earth (C-137)", type: "Planet", dimension: "Dimension C-137", residents: [
        "https://rickandmortyapi.com/api/character/38",
        "https://rickandmortyapi.com/api/character/45",
        "https://rickandmortyapi.com/api/character/71",
        "https://rickandmortyapi.com/api/character/82",
        "https://rickandmortyapi.com/api/character/83",
        "https://rickandmortyapi.com/api/character/92",
        "https://rickandmortyapi.com/api/character/112",
        "https://rickandmortyapi.com/api/character/114",
        "https://rickandmortyapi.com/api/character/116",
        "https://rickandmortyapi.com/api/character/117",
        "https://rickandmortyapi.com/api/character/120",
        "https://rickandmortyapi.com/api/character/127",
        "https://rickandmortyapi.com/api/character/155",
        "https://rickandmortyapi.com/api/character/169",
        "https://rickandmortyapi.com/api/character/175",
        "https://rickandmortyapi.com/api/character/179",
        "https://rickandmortyapi.com/api/character/186",
        "https://rickandmortyapi.com/api/character/201",
        "https://rickandmortyapi.com/api/character/216",
        "https://rickandmortyapi.com/api/character/239",
        "https://rickandmortyapi.com/api/character/271",
        "https://rickandmortyapi.com/api/character/302",
        "https://rickandmortyapi.com/api/character/303",
        "https://rickandmortyapi.com/api/character/338",
        "https://rickandmortyapi.com/api/character/343",
        "https://rickandmortyapi.com/api/character/356",
        "https://rickandmortyapi.com/api/character/394"],
                                          url: "", created: "2017-11-10T12:42:04.162Z"))
}
