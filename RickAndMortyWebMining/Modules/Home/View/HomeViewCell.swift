//
//  HomeViewCell.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 8.04.2024.
//

import SwiftUI

struct HomeViewCell: View {
    var character: Character
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.gray.opacity(0.2))
                .opacity(0.9)
                .frame(height: 120)
            
            HStack {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width / 3, height: 120)
                        .clipped()
                        .cornerRadius(25)
                } placeholder: {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width / 3, height: 120)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.system(size: 16, weight: .semibold))
                    HStack(spacing: 8) {
                        Text("Status:").bold()
                        Text(character.status)
                            
                    }
                    HStack(spacing: 8) {
                        Text("Gender:").bold()
                        Text(character.gender)
                            
                    }
                    HStack(spacing: 8) {
                        Text("Species:").bold()
                        Text(character.species)
                            
                    }
                }
                .font(.system(size: 14))
                .padding()
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                Spacer()
            }
            .frame(height: 120)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    HomeViewCell(character: Character(id: 1, name: "fake", status: "fake", species: "fake", gender: "fake", image: "fake"))
}
