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
                Text(" " + state.searchString.joined())
                    .frame(width: geometry.size.width * state.ratioRight, height: state.defaultFontSize * 1.5, alignment: .leading)
                    .font(.system(size: state.defaultFontSize))
                    .truncationMode(.tail)
                    .lineLimit(1)
                    .padding(0)
                    .background(Color.black.opacity(0.2))
                
                ForEach(state.autocompleteSearchMatches(), id: \.self) { match in
                    Text(" " + match)
                        .frame(width: geometry.size.width * state.ratioRight, height: state.defaultFontSize, alignment: .leading)
                        .background(state.selectedAutocompleteOption == match ? .black : .gray)
                        .foregroundColor(state.selectedAutocompleteOption == match ? .white : .black)
                        .font(.system(size: state.defaultFontSize / 2))
                        .truncationMode(.tail)
                        .lineLimit(1)
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
