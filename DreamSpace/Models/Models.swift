import Foundation

// MARK: - Story Language
enum StoryLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case persian = "Persian"
    case italian = "Italian"
    case spanish = "Spanish"

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .english:  return "🇬🇧"
        case .persian:  return "🇮🇷"
        case .italian:  return "🇮🇹"
        case .spanish:  return "🇪🇸"
        }
    }
}

// MARK: - Story Mood
enum StoryMood: String, CaseIterable, Identifiable {
    case calm      = "Calm"
    case romantic  = "Romantic"
    case mysterious = "Mysterious"
    case historic  = "Historic"
    case poetic    = "Poetic"
    case random    = "Random..."

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .calm:       return "leaf.fill"
        case .romantic:   return "heart.fill"
        case .mysterious: return "moon.stars.fill"
        case .historic:   return "building.columns.fill"
        case .poetic:     return "text.quote"
        case .random:     return "shuffle"
        }
    }
}

// MARK: - Story Length
enum StoryLength: Int, CaseIterable, Identifiable {
    case ten    = 10
    case twenty = 20
    case thirty = 30
    case forty  = 40

    var id: Int { rawValue }
    var label: String { "\(rawValue)'" }
    var description: String {
        switch self {
        case .ten:    return "Quick drift"
        case .twenty: return "Gentle journey"
        case .thirty: return "Deep voyage"
        case .forty:  return "Full escape"
        }
    }
}

// MARK: - Sleep Timer
enum SleepTimer: CaseIterable, Identifiable, Equatable {
    case off
    case minutes(Int)
    case endOfSound

    static var allCases: [SleepTimer] {
        [.off, .minutes(10), .minutes(20), .minutes(30), .minutes(40), .minutes(50), .endOfSound]
    }

    var id: String { label }

    var label: String {
        switch self {
        case .off:            return "Off"
        case .minutes(let m): return "\(m)'"
        case .endOfSound:     return "End of sound"
        }
    }

    static func == (lhs: SleepTimer, rhs: SleepTimer) -> Bool {
        switch (lhs, rhs) {
        case (.off, .off):                       return true
        case (.endOfSound, .endOfSound):         return true
        case (.minutes(let a), .minutes(let b)): return a == b
        default:                                 return false
        }
    }
}

// MARK: - Story Item (for Library / Recents)
struct StoryItem: Identifiable {
    let id = UUID()
    let title: String
    let mood: StoryMood
    let language: StoryLanguage
    let durationMinutes: Int
    let generatedAt: Date
    var isFavourite: Bool = false

    var durationLabel: String { "\(durationMinutes)min" }
}

// MARK: - Noise Type
enum NoiseType: String, CaseIterable, Identifiable {
    case white  = "White noise"
    case brown  = "Brown noise"
    case pink   = "Pink noise"
    case rain   = "Rain"
    case ocean  = "Ocean"
    case forest = "Forest"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .white:  return "waveform"
        case .brown:  return "waveform.path.ecg"
        case .pink:   return "waveform.badge.plus"
        case .rain:   return "cloud.rain.fill"
        case .ocean:  return "water.waves"
        case .forest: return "leaf.fill"
        }
    }
}

struct NoiseItem: Identifiable {
    let id = UUID()
    let type: NoiseType
    var title: String { type.rawValue }
}

// MARK: - Sample Data
extension StoryItem {
    static let samples: [StoryItem] = [
        StoryItem(title: "The Moonlit Forest", mood: .calm, language: .english, durationMinutes: 20, generatedAt: Date()),
        StoryItem(title: "Venice at Dawn", mood: .romantic, language: .italian, durationMinutes: 30, generatedAt: Date().addingTimeInterval(-3600)),
        StoryItem(title: "The Ancient Library", mood: .mysterious, language: .english, durationMinutes: 40, generatedAt: Date().addingTimeInterval(-7200), isFavourite: true),
        StoryItem(title: "A Night in Shiraz", mood: .poetic, language: .persian, durationMinutes: 10, generatedAt: Date().addingTimeInterval(-86400), isFavourite: true),
    ]
}
