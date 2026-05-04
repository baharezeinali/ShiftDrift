import SwiftUI

struct HomeView: View {
    @StateObject private var vm = StoryViewModel()
    @State private var showCreateFlow = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "0D0D1E"), Color(hex: "1A1040")],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {

                        // MARK: Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ready to sleep?")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Let's create your perfect night.")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.top, 16)

                        // MARK: Create Story Card
                        Button {
                            showCreateFlow = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "7B5EA7"), Color(hex: "4A3580")],
                                            startPoint: .topLeading, endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(height: 140)

                                VStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(.white.opacity(0.15))
                                            .frame(width: 52, height: 52)
                                        Image(systemName: "sparkles")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    }
                                    Text("Create a story with AI")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        // MARK: Recents
                        if !vm.recentStories.isEmpty {
                            SectionHeader(title: "Recents")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(vm.recentStories.prefix(6)) { story in
                                        NavigationLink(destination: PlaybackView(story: story, vm: vm)) {
                                            StoryCard(story: story)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        // MARK: Favourites
                        if !vm.favouriteStories.isEmpty {
                            SectionHeader(title: "Favourites")
                            VStack(spacing: 10) {
                                ForEach(vm.favouriteStories) { story in
                                    NavigationLink(destination: PlaybackView(story: story, vm: vm)) {
                                        FavouriteRow(story: story)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        // MARK: Noise Quick Access
                        SectionHeader(title: "Sounds")
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(NoiseType.allCases) { noise in
                                NoiseChip(noise: noise)
                            }
                        }

                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showCreateFlow) {
                LanguagePickerView(vm: vm)
            }
        }
        .environmentObject(vm)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
    }
}

// MARK: - Story Card (horizontal scroll)
struct StoryCard: View {
    let story: StoryItem
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(story.mood.cardGradient)
                    .frame(width: 110, height: 110)
                Image(systemName: story.mood.icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white.opacity(0.8))
            }
            Text(story.title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(2)
                .frame(width: 110, alignment: .leading)
            Text(story.durationLabel)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

// MARK: - Favourite Row
struct FavouriteRow: View {
    let story: StoryItem
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(story.mood.cardGradient)
                    .frame(width: 50, height: 50)
                Image(systemName: story.mood.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.85))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(story.title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                Text("\(story.mood.rawValue) · \(story.durationLabel) · \(story.language.rawValue)")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
            }
            Spacer()
            Image(systemName: "heart.fill")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "A87FE0"))
        }
        .padding(12)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Noise Chip
struct NoiseChip: View {
    let noise: NoiseType
    @State private var isActive = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) { isActive.toggle() }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: noise.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isActive ? Color(hex: "A87FE0") : .white.opacity(0.6))
                Text(noise.rawValue)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(isActive ? .white : .white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isActive ? Color(hex: "A87FE0").opacity(0.18) : Color.white.opacity(0.06))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isActive ? Color(hex: "A87FE0").opacity(0.5) : Color.clear, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Mood gradient helper
extension StoryMood {
    var cardGradient: LinearGradient {
        switch self {
        case .calm:
            return LinearGradient(colors: [Color(hex: "3A7BD5"), Color(hex: "1E4A8A")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .romantic:
            return LinearGradient(colors: [Color(hex: "C0392B"), Color(hex: "7B1A1A")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .mysterious:
            return LinearGradient(colors: [Color(hex: "2C3E7A"), Color(hex: "0D1535")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .historic:
            return LinearGradient(colors: [Color(hex: "8B6914"), Color(hex: "5A4009")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .poetic:
            return LinearGradient(colors: [Color(hex: "6B3FA0"), Color(hex: "3D1A6E")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .random:
            return LinearGradient(colors: [Color(hex: "1A8A6A"), Color(hex: "0D4535")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
