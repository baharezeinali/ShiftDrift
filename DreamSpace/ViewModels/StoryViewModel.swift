import Foundation
import Combine

@MainActor
class StoryViewModel: ObservableObject {

    // MARK: - Flow state
    @Published var selectedLanguage: StoryLanguage?
    @Published var selectedMood: StoryMood?
    @Published var selectedLength: StoryLength?
    @Published var isGenerating: Bool = false
    @Published var generatedStory: StoryItem?
    @Published var isPlaying: Bool = false
    @Published var sleepTimer: SleepTimer = .off
    @Published var showSleepTimerSheet: Bool = false

    // MARK: - Library
    @Published var recentStories: [StoryItem] = StoryItem.samples
    @Published var favouriteStories: [StoryItem] { didSet { } }

    init() {
        favouriteStories = StoryItem.samples.filter { $0.isFavourite }
    }

    // MARK: - Reset flow
    func resetFlow() {
        selectedLanguage = nil
        selectedMood = nil
        selectedLength = nil
        generatedStory = nil
        isPlaying = false
    }

    // MARK: - Generate story (simulated)
    func generateStory() async {
        guard let lang = selectedLanguage,
              let mood = selectedMood,
              let length = selectedLength else { return }
        isGenerating = true
        // Simulate network/AI delay
        try? await Task.sleep(nanoseconds: 2_500_000_000)
        let story = StoryItem(
            title: storyTitle(mood: mood, language: lang),
            mood: mood,
            language: lang,
            durationMinutes: length.rawValue,
            generatedAt: Date()
        )
        generatedStory = story
        recentStories.insert(story, at: 0)
        isGenerating = false
        isPlaying = true
    }

    private func storyTitle(mood: StoryMood, language: StoryLanguage) -> String {
        let titles: [StoryMood: [String]] = [
            .calm:       ["The Quiet Lake", "A Gentle Breeze", "Still Waters"],
            .romantic:   ["Moonlit Promises", "Letters Never Sent", "Roses at Midnight"],
            .mysterious: ["The Vanishing Door", "Shadows at Dusk", "The Forgotten Key"],
            .historic:   ["The Ancient Road", "Empires of Sand", "The Last Scribe"],
            .poetic:     ["Between Two Silences", "The Echo of Rain", "Words Like Water"],
            .random:     ["A Journey Within", "The Unnamed Path", "Somewhere Soft"],
        ]
        return titles[mood]?.randomElement() ?? "Your Story"
    }

    func toggleFavourite(_ story: StoryItem) {
        if let idx = recentStories.firstIndex(where: { $0.id == story.id }) {
            recentStories[idx].isFavourite.toggle()
        }
        favouriteStories = recentStories.filter { $0.isFavourite }
    }
}
