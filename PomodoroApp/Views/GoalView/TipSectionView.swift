//
//  TipSectionView.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 15.05.2025.
//

import SwiftUI

struct TipsSectionView: View {
    @Binding var tips: [String]

    var body: some View {
        Section(header: Text("Tips")) {
            ForEach(tips.indices, id: \.self) { index in
                TextField("Tip \(index + 1)", text: $tips[index])
            }
            Button("Add Tip") {
                tips.append("")
            }
        }
    }
}
#Preview(traits: .sizeThatFitsLayout) {
    TipsSectionView(
        tips: .constant(["Avoid distractions", "Take short breaks"])
    )
    
    .padding()
}
