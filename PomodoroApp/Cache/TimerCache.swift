import Foundation

final class TimerCache {
    static let shared = TimerCache()
    private init() {}

    var cachedRemainingSeconds: [String: Int] = [:]

    func save(for goalId: String, seconds: Int) {
        cachedRemainingSeconds[goalId] = seconds
    }

    func load(for goalId: String) -> Int? {
        return cachedRemainingSeconds[goalId]
    }

    func clear(for goalId: String) {
        cachedRemainingSeconds.removeValue(forKey: goalId)
    }
}
