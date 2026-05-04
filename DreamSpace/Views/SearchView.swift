import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @State private var selectedFilter: SearchFilter = .all
    @StateObject private var vm = StoryViewModel()

    enum SearchFilter: String, CaseIterable {
        case all = "All"
        case stories = "Stories"
        case noise = "Noise"
    }

    var filteredStories: [StoryItem] {
        let stories = vm.recentStories
        if query.isEmpty { return stories }
        return stories.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0D0D1E"), Color(hex: "1A1040")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 15))
                        TextField("", text: $query, prompt:
                            Text("Search here").foregroundColor(.white.opacity(0.3))
                        )
                        .foregroundColor(.white)
                        .font(.system(size: 15, design: .rounded))
                        if !query.isEmpty {
                            Button { query = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.4))
                            }.buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    // Filter avatar circle
                    Circle()
                        .fill(Color(hex: "7B5EA7"))
                        .frame(width: 38, height: 38)
                        .overlay(
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 14)

                // Filter chips
                HStack(spacing: 8) {
                    ForEach(SearchFilter.allCases, id: \.self) { filter in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedFilter = filter }
                        } label: {
                            Text(filter.rawValue)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(selectedFilter == filter ? .white : .white.opacity(0.5))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 7)
                                .background(selectedFilter == filter ? Color(hex: "7B5EA7") : Color.white.opacity(0.07))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                // Results grid
                ScrollView(showsIndicators: false) {
                    if selectedFilter != .noise {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 14
                        ) {
                            ForEach(filteredStories) { story in
                                NavigationLink(destination: PlaybackView(story: story, vm: vm)) {
                                    SearchStoryCard(story: story)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    if selectedFilter != .stories {
                        VStack(alignment: .leading, spacing: 12) {
                            if selectedFilter == .all {
                                Text("Sounds")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                            }
                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 14
                            ) {
                                ForEach(NoiseType.allCases) { noise in
                                    NoiseSearchCard(noise: noise)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 80)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchStoryCard: View {
    let story: StoryItem
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(story.mood.cardGradient)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.2, contentMode: .fit)
                Image(systemName: story.mood.icon)
                    .font(.system(size: 34))
                    .foregroundColor(.white.opacity(0.8))
            }
            Text(story.title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(2)
            Text(story.durationLabel)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(.white.opacity(0.45))
        }
    }
}

struct NoiseSearchCard: View {
    let noise: NoiseType
    @State private var isActive = false
    var body: some View {
        Button { withAnimation(.spring(response: 0.3)) { isActive.toggle() } } label: {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isActive ? Color(hex: "A87FE0").opacity(0.25) : Color.white.opacity(0.07))
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.2, contentMode: .fit)
                    Image(systemName: noise.icon)
                        .font(.system(size: 34))
                        .foregroundColor(isActive ? Color(hex: "A87FE0") : .white.opacity(0.6))
                }
                Text(noise.rawValue)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(isActive ? .white : .white.opacity(0.6))
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack { SearchView() }
        .preferredColorScheme(.dark)
}
