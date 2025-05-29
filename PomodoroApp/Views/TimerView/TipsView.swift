import SwiftUI

struct TipsView: View {
    let tips: [String]
    @State private var checkedTips: Set<Int> = []

    var body: some View {
        let validTips = tips.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        if validTips.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tips")
                    .font(.headline)
                    .padding(.bottom, 4)

                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(validTips.indices, id: \.self) { index in
                            HStack {
                                Text(checkedTips.contains(index) ? "☑︎" : "☐")
                                    .font(.system(size: 18))
                                    .onTapGesture {
                                        toggleTip(at: index)
                                    }

                                Text("\(index + 1). \(validTips[index])")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        toggleTip(at: index)
                                    }
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }

    private func toggleTip(at index: Int) {
        if checkedTips.contains(index) {
            checkedTips.remove(index)
        } else {
            checkedTips.insert(index)
        }
    }
}

#Preview {
    TipsView(tips: [
        "Stay focused.",
        "Take short breaks.",
        "Write down distractions.",
        "Use noise-cancelling headphones.",
        "Stay hydrated.",
        "Review your goals."
    ])
}
