//
//  HomeView.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import SwiftUI

struct HomeView: View {
    @State var selectedIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color(hex: "272B33")
            switch selectedIndex {
            case 0:
                CharactersView()
            case 1:
                LocationView()
            case 2:
                EpisodesView()
            default: 
                CharactersView()
            }
            menu
           
        }.ignoresSafeArea()
    }
    
    // MARK: Menu View
    @ViewBuilder
    var menu: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: UIScreen.main.bounds.width - 150, height: 70)
            .foregroundStyle(.green)
            .overlay {
                HStack(spacing: 20) {
                    VStack {
                        Image(systemName: "figure").onTapGesture {
                            withAnimation {
                                selectedIndex = 0
                            }
                        }
                        selectedIndex == 0 ? Circle().foregroundStyle(.white)
                            .frame(width: 10) : nil
                    }
                    VStack {
                        Image(systemName: "globe.americas.fill").onTapGesture {
                            withAnimation {
                                selectedIndex = 1
                            }
                        }
                        selectedIndex == 1 ? Circle().foregroundStyle(.white)
                            .frame(width: 10) : nil
                    }
                    
                    VStack {
                        Image(systemName: "number")
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = 2
                                }
                            }
                        selectedIndex == 2 ? Circle().foregroundStyle(.white)
                            .frame(width: 10) : nil
                    }
                }
                .font(.title)
            }.offset(y: UIScreen.main.bounds.height / 2.3)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().preferredColorScheme(.dark)
    }
}
