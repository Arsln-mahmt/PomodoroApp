import Foundation

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            updateLanguage()
            refreshUI = true // Arayüzü yenile
        }
    }
    @Published var refreshUI = false // Arayüz yenileme için
    
    private var currentLanguageCode: String = "en"
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            selectedLanguage = savedLanguage
        } else {
            selectedLanguage = "English"
        }
        updateLanguage()
    }
    
    private func updateLanguage() {
        switch selectedLanguage {
        case "English":
            currentLanguageCode = "en"
        case "Türkçe":
            currentLanguageCode = "tr"
        default:
            currentLanguageCode = "en"
        }
        
        UserDefaults.standard.set([currentLanguageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        print("Dil güncellendi: \(currentLanguageCode)") // Hata ayıklama için
    }
    
    func localizedString(forKey key: String, comment: String) -> String {
        guard let bundlePath = Bundle.main.path(forResource: currentLanguageCode, ofType: "lproj"),
              let bundle = Bundle(path: bundlePath) else {
            print("Bundle bulunamadı: \(currentLanguageCode)")
            return NSLocalizedString(key, comment: comment) // Varsayılan dil
        }
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: comment)
        print("Çevrilen metin: \(key) -> \(localizedString)") // Hata ayıklama için
        return localizedString
    }
}
