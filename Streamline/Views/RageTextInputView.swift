//
//  RageTextInput.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI
import SwiftUIX

struct RageTextInputView: View {
    @EnvironmentObject var state: AppState
    @State private var opacity = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            Path() { path in
                path.move(to: CGPoint(x: geometry.size.width * state.ratioLeft, y: -geometry.size.height))
                path.addLine(to: CGPoint(x: geometry.size.width * state.ratioLeft, y: geometry.size.height))
            }
            .stroke(Color("LineColor"), lineWidth: 1)
            .opacity(0.0)
            
            Rectangle()
                .foregroundColor(Color("RightSide"))
                .frame(width: geometry.size.width * state.ratioRight, height: geometry.size.height + 100)
                .offset(x: geometry.size.width * state.ratioLeft, y: -geometry.size.height / 2)
                .opacity(0.0)
            
            HStack {
                Text(state.attributedString)
                    .font(.system(size: state.calculatedFontSize()))
                    .truncationMode(.head)
                    .lineLimit(1)
                    .foregroundColor(Color("TextColor"))
                    .frame(width: geometry.size.width * state.ratioLeft, alignment: .trailing)
                    .mask(LinearGradient(gradient: Gradient(colors: [.clear, Color("MaskColor")]), startPoint: .leading, endPoint: .trailing))
                    .offset(x: -8, y: -1)
                
                ZStack {
                    Rectangle()
                        .fill(Color("CursorColor"))
                        .frame(width: 5, height: state.calculatedFontSize() * 1.5)
                        .offset(x: -13)
                }
                
                if(state.umlautModifierTyped) {
                    Text("¨")
                        .font(.system(size: state.calculatedFontSize()))
                        .foregroundColor(Color("TextColor"))
                        .offset(x: -52, y: -(state.calculatedFontSize() / 2 + 5))
                }

            }
            
            // Autocomplete
            AutocompleteView()
                .visible(state.currentlySearching)
                .offset(x: geometry.size.width * state.ratioLeft + (state.calculatedFontSize() / 2) - 15)
        }
    }
}

struct RageTextInput_Previews: PreviewProvider {
    static var previews: some View {
        RageTextInputView()
    }
}
