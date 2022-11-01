//
//  AutocompleteView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 28.10.22.
//

import SwiftUI

struct AutocompleteView: View {
    @EnvironmentObject var state: AppState
    @State private var commonSize = CGSize()

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    Text(" " + state.searchStringArray.joined())
                        .frame(width: geometry.size.width * state.ratioRight, height: state.defaultFontSize * 1.5, alignment: .leading)
                        .font(.system(size: state.defaultFontSize))
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(0)
                        .background(Color("ObsidianPurple").opacity(0.4))

                    Text("ESC to dismiss")
                        .foregroundColor(Color("ObsidianPurple"))
                        .frame(maxWidth: 100, alignment: .trailing)
                        .offset(x: commonSize.width - 110, y: commonSize.height - 75)

                }.readSize { textSize in
                    commonSize = textSize
                }
                
                ForEach(state.autocompleteSearchMatches(), id: \.self) { match in
                    Text(" " + match)
                        .frame(width: geometry.size.width * state.ratioRight, height: state.defaultFontSize, alignment: .leading)
                        .background(state.selectedAutocompleteOption == match ? Color("ObsidianPurple").opacity(0.5) : Color("ObsidianPurple").opacity(0.1))
                        .foregroundColor(.white)
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
