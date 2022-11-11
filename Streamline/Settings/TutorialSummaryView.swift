//
//  TutorialSummaryView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 10.11.22.
//

import SwiftUI

struct TutorialSummaryView: View {
    var body: some View {
        Text("Streamline is a stream-of-consciousness one-line writer")
            .font(.title2)
            .padding(5)

        Text("1. Write freely")
        Text("2. Love your mistakes")
        Text("3. Link often")

        Text("A few tips on linking")
            .font(.title2)
            .padding(5)
        
        Text("- **Enter** linking mode by typing `[[`")
        Text("- **Exit** the linking mode with ESC")
        Text("- **Choose** a link with your UP and DOWN arrow keys")
        Text("- **Insert** the link with RETURN")

    }
}

struct TutorialSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialSummaryView()
    }
}
