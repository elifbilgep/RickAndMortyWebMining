//
//  HomeViewCell.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 8.04.2024.
//

import SwiftUI

struct HomeViewCell: View {
    var character: Character
    
    @State private var image: UIImage?
    @State private var shadowColor: Color = .black
    
    var body: some View {
        VStack {
            if image != nil {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 350, height: 180, alignment: .center)
                    .cornerRadius(16)
                    .foregroundColor(Color(hex: "3B3E43"))
                    .overlay {
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150)
                                    .clipShape(
                                        RoundedCornersShape(
                                            corners: [.topLeft, .bottomLeft],
                                            radius: 20
                                        )
                                    )
                            } placeholder: {
                                ProgressView()
                                    .frame(width: UIScreen.main.bounds.width / 3, height: 120)
                                
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(character.name)
                                    .font(.system(size: 24))
                                    .bold()
                                    .foregroundStyle(.whiteTitle)
                                    .multilineTextAlignment(.leading)
                                HStack {
                                    Circle()
                                        .frame(width: 10)
                                        .foregroundStyle(character.status == "Alive" ? .green : .red)
                                    Text(character.status)
                                        .foregroundStyle(.whiteTitle)
                                    Text("- \(character.species)")
                                        .foregroundStyle(.whiteTitle)
                                    
                                }
                                Text("\(character.gender)")
                                    .font(.headline)
                                    .foregroundStyle(.whiteTitle)
                                    .opacity(0.6)
                                
                                
                            }
                            Spacer()
                        }
                        
                    }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            fetchImage()
        }
    }
    private func fetchImage() {
        guard let imageURL = URL(string: character.image) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let uiImage = UIImage(data: data) {
                self.image = uiImage
                
            }
        }.resume()
    }
}

#Preview {
    HomeViewCell(character: Character(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                type: "",
                gender: "Male",
                origin: CharacterLocation(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
                location: CharacterLocation(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                episode: [
                    "https://rickandmortyapi.com/api/episode/1",
                    "https://rickandmortyapi.com/api/episode/2",
                    "https://rickandmortyapi.com/api/episode/3",
                ],
                url: "https://rickandmortyapi.com/api/character/1",
                created: "2017-11-04T18:48:46.250Z"
            ))
}

struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
