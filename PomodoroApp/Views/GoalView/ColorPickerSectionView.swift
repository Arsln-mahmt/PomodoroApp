//
//  GoalPickerSectionView.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 15.05.2025.
//
import SwiftUI

struct ColorPickerSectionView: View {
    let availableColors: [String] = [
        "#FFFFFF","#FF6B6B", "#3498DB", "#2ECC71", "#F1C40F",
        "#9B59B6", "#E74C3C", "#8E44AD"
    ]

    @Binding var selectedColor: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(availableColors, id: \.self) { color in
                    Circle()
                        .fill(Color(hex: color))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(selectedColor == color ? 1 : 0), lineWidth: 2)
                        )
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding(.vertical)
        }
    }
}



#Preview {
    struct PreviewWrapper: View {
        @State var selectedColor: String = "#FF6B6B"

        var body: some View {
            Form {
                ColorPickerSectionView(selectedColor: $selectedColor)
            }
        }
    }

    return PreviewWrapper()
}




