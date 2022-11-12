//
//  TutorialView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 07.11.22.
//

import SwiftUI

struct TutorialView: View {
    let markdown: LocalizedStringKey = """
    **Stream-of-consciousness, one-line writing will teach you how to:**
    
    1. Write freely
    2. Love your mistakes
    3. Link often
    
    **A few tips on linking:**

    - **Enter** linking mode by typing `[[`
    - **Exit** the linking mode with ESC
    - **Choose** a link with your UP and DOWN arrow keys
    - **Insert** the link into your stream with RETURN
    
    PS: Full tutorial coming soon. [Please let me know](mailto:alexis.rondeau@gmail.com) what you struggle most with!
    """
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(markdown)
                .padding(5)
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
