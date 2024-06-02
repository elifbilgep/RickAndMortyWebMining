import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(hex: "272B33")
            VStack {
                VStack {
                    
                    HStack {
                        Image(systemName: "arrow.backward")
                        Text("Back").bold()
                        
                    }.padding(.top, 60)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                    Text(character.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    AsyncImage(url: URL(string: character.image))
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                    VStack(alignment: .center, spacing: 10) {
                        Text("Status: \(character.status)")
                        Text("Species: \(character.species)")
                        Text("Gender: \(character.gender)")
                        Text("Origin: \(character.origin.name)")
                        Text("Location: \(character.location.name)")
                    }
                }
                
            }
        }   .foregroundStyle(.white)
        
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
    }
    
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(character: Character(
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
                "https://rickandmortyapi.com/api/episode/3"
                // Add more episodes if needed
            ],
            url: "https://rickandmortyapi.com/api/character/1",
            created: "2017-11-04T18:48:46.250Z"
        ))
        
    }
}
