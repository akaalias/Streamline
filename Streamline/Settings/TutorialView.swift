//
//  TutorialView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 07.11.22.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        VStack(alignment: .leading) {
            TutorialSummaryView()

            Text("PS: Full tutorial coming soon. [Please let me know](mailto:alexis.rondeau@gmail.com) what you struggle most with!")
                .padding(5)
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
