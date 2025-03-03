//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable{
    var games: [Game]
}
struct Score: Codable, Hashable{
    var unc: Int
    var opponent: Int
}

struct Game: Codable, Identifiable{
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var score: Score
    var isHomeGame: Bool
    var scoreSummary: String{
        "Score: UNC \(score.unc) - \(score.opponent) \(opponent)"
    }
}

struct ContentView: View {
    @State private var games = [Game]()
    var body: some View {
        List(games){game in
                VStack(alignment: .leading){
                    Text("\(game.team) Basketball vs. \(game.opponent)")
                        .font(.headline)
                    Text(game.scoreSummary)
                    Text("Date: \(game.date)")
                }
            }
            .task{
                await loadData()
    }
}
    func loadData() async{
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball")else{
            print("Invalid URL")
            return
        }
        do{
            let(data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try?
                JSONDecoder().decode(Response.self, from: data){
                games = decodedResponse.games
            }
        }catch{
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
