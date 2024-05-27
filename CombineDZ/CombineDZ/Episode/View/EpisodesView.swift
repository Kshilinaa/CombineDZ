//
//  EpisodesView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 27.05.2024.
//

import SwiftUI

struct EpisodeView: View {
    var episodes: [Episode] = []
    
    //MARK: - EnvironmentObject
    @EnvironmentObject var viewModel: TaskViewModel

    //MARK: - Body
    var body: some View {
        LazyVStack(spacing: 55) {
            ForEach(episodes, id: \.name) { episode in
                VStack(alignment: .leading) {
                    if let index = episodes.firstIndex(where: { $0.name == episode.name }) {
                        if index < viewModel.characterImages.count && index < viewModel.characterNames.count {
                            viewModel.characterImages[index]
                                .resizable()
                                .frame(width: 311, height: 232)
                            Spacer()
                            Text(viewModel.characterNames[index])
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                        }
                    }
                    Spacer()
                    HStack {
                        Image("playIcon")
                        Text("\(episode.name) | ")
                        +
                        Text(episode.episode)
                        Spacer()
                        Image("heart")
                    }
                    .padding(.horizontal)
                    .frame(width: 311, height: 71)
                    .background(.episodeName)
                }
                .frame(width: 311, height: 357)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 2.5, x: 0, y: 3)
                )
                
            }
            
        }
        
    }
}
#Preview {
    EpisodeView()
}
