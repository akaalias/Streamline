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
        VStack(alignment: .leading) {
            Text(state.searchString.joined())
                .frame(width: 400, height: 64)
                .foregroundColor(.black)
                .font(.system(size: 64))
                .truncationMode(.tail)
                .lineLimit(1)
                .background(.white)
                .padding(0)

            ForEach(state.autocompleteSearchMatches(), id: \.self) { match in
                    Text(match)
                        .frame(width: 400, height: 40)
                        .background(state.selectedAutocompleteOption == match ? .black : .white)
                        .foregroundColor(state.selectedAutocompleteOption == match ? .white : .black)
                        .font(.system(size: 24))
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(0)
            }
            
            Text(state.selectedAutocompleteOption)
        }
    }
}

struct AutocompleteView_Previews: PreviewProvider {
    static var previews: some View {
        AutocompleteView()
    }
}
