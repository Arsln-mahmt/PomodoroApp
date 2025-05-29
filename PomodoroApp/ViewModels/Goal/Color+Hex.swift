import SwiftUI

extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255
        let blue = Double(rgbValue & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue)
    }

    /// Açık renk mi?
    var isLight: Bool {
        // Luminance hesapla (insan gözüne göre ağırlıklı)
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)

        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.7
    }

    /// Tema rengine göre otomatik kontrast rengi döndür
    var contrastingForeground: Color {
        return isLight ? .black : .white
    }
}
