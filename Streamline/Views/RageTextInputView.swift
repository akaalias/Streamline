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
                    path.move(to: CGPoint(x: 0, y: state.calculatedFontSize() * 1.5))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: state.calculatedFontSize() * 1.5))
                }
                .stroke(.white, lineWidth: 1)
                .opacity(0.1)

                HStack {
                    Text(state.attributedString)
                        .font(.system(size: state.calculatedFontSize()))
                        .truncationMode(.head)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                        .frame(width: geometry.size.width * state.ratioLeft, alignment: .trailing)
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .leading, endPoint: .trailing))
                        .offset(x: -15)

                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: state.calculatedFontSize() / 2.0, height: state.calculatedFontSize() * 1.5)
                            .opacity(opacity)
                            .onAppear() {
                                withAnimation(.easeInOut(duration: 2).repeatForever()) {
                                    opacity = 0.2
                                }
                            }
                            .offset(x: -23)
                        
                        if(state.umlautModifierTyped) {
                            Text("¨")
                                .font(.system(size: state.calculatedFontSize()))
                                .foregroundColor(.white)
                                .offset(x: -23, y: -(state.calculatedFontSize() / 2 + 5))
                        }
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
