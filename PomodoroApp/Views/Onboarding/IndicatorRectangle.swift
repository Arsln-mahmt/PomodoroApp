//
//  IndicatorRectangle.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 19.04.2025.
//

import SwiftUI

struct IndicatorRectangle: View {
    var isActive: Bool
    
    var body: some View {
        Capsule()
            .fill(isActive ? Color.black : Color.gray.opacity(0.3))
            .animation(.easeInOut, value: isActive)
    }
}

#Preview {
    IndicatorRectangle(isActive: true)
}
