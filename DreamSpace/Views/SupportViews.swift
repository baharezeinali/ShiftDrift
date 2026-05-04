import SwiftUI

// MARK: - Library View
struct LibraryView: View {
    @StateObject private var vm = StoryViewModel()
    @State private var selectedTab: LibraryTab = .stories

    enum LibraryTab: String, CaseIterable {
        case stories = "Stories"
        case noise   = "Sounds"
        case downloads = "Downloads"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "0D0D1E"), Color(hex: "1A1040")],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Text("Library")
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 12)

                    // Tab bar
                    HStack(spacing: 8) {
                        ForEach(LibraryTab.allCases, id: \.self) { tab in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedTab = tab }
                            } label: {
                                Text(tab.rawValue)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.5))
                                    .padding(.horizontal, 16).padding(.vertical, 7)
                                    .background(selectedTab == tab ? Color(hex: "7B5EA7") : Color.white.opacity(0.07))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(vm.recentStories) { story in
                                NavigationLink(destination: PlaybackView(story: story, vm: vm)) {
                                    SearchStoryCard(story: story)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        Spacer(minLength: 80)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0D0D1E"), Color(hex: "1A1040")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Avatar
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "7B5EA7"), Color(hex: "4A3580")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 80)
                            Text("👤")
                                .font(.system(size: 36))
                        }
                        Text("Good night 🌙")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Free plan · 2 stories remaining this week")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .padding(.top, 32)

                    // Upgrade card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Upgrade to Pro")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        Text("Unlimited stories, all sounds, sleep insights & watchOS companion.")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.white.opacity(0.65))
                        Button { } label: {
                            Text("Start free trial")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(LinearGradient(colors: [Color(hex: "7B5EA7"), Color(hex: "4A3580")], startPoint: .leading, endPoint: .trailing))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(16)
                    .background(Color(hex: "A87FE0").opacity(0.12))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color(hex: "A87FE0").opacity(0.25), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)

                    // Stats
                    HStack(spacing: 12) {
                        StatCard(label: "Stories heard", value: "12")
                        StatCard(label: "Hours of sleep", value: "24h")
                        StatCard(label: "Nights tracked", value: "8")
                    }
                    .padding(.horizontal, 20)

                    // Settings rows
                    VStack(spacing: 2) {
                        SettingsRow(icon: "moon.fill", label: "Sleep schedule")
                        SettingsRow(icon: "heart.fill", label: "Health & HealthKit")
                        SettingsRow(icon: "bell.fill", label: "Notifications")
                        SettingsRow(icon: "lock.fill", label: "Privacy")
                        SettingsRow(icon: "questionmark.circle.fill", label: "Help & Support")
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 80)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct StatCard: View {
    let label: String
    let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct SettingsRow: View {
    let icon: String
    let label: String
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "A87FE0"))
                .frame(width: 32)
            Text(label)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.25))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.bottom, 2)
    }
}

// MARK: - Color extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview("Library") {
    LibraryView().preferredColorScheme(.dark)
}

#Preview("Profile") {
    ProfileView().preferredColorScheme(.dark)
}
