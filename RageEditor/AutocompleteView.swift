//
//  AutocompleteView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 28.10.22.
//

import SwiftUI

struct AutocompleteView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: .leading) {
                Text(state.searchString.joined())
                    .frame(width: geometry.size.width * 0.4, height: 108)
                    .font(.system(size: 64))
                    .truncationMode(.tail)
                    .lineLimit(1)
                    .background(.gray)
                    .foregroundColor(.black)
                    .padding(0)
                
                ForEach(state.autocompleteSearchMatches(), id: \.self) { match in
                    Text(match)
                        .frame(width: geometry.size.width * 0.4, height: 42)
                        .background(state.selectedAutocompleteOption == match ? .black : .white)
                        .foregroundColor(state.selectedAutocompleteOption == match ? .white : .black)
                        .font(.system(size: 24))
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(0)
                }
            }
        }
    }
}

struct AutocompleteView_Previews: PreviewProvider {
    static var previews: some View {
        AutocompleteView()
    }
}
