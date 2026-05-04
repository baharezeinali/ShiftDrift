import SwiftUI

struct StoryLengthView: View {
    @ObservedObject var vm: StoryViewModel
    @State private var navigateToPlaying = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0D0D1E"), Color(hex: "1A1040")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Story length")
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text("How long should your journey be?")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 8)

                VStack(spacing: 14) {
                    ForEach(StoryLength.allCases) { length in
                        LengthRow(
                            length: length,
                            isSelected: vm.selectedLength == length
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                vm.selectedLength = length
                            }
                        }
                    }
                }

                Spacer()

                NavigationLink(
                    destination: StoryPlayingView(vm: vm),
                    isActive: $navigateToPlaying
                ) { EmptyView() }

                Button {
                    guard vm.selectedLength != nil else { return }
                    Task {
                        await vm.generateStory()
                        navigateToPlaying = true
                    }
                } label: {
                    HStack(spacing: 10) {
                        if vm.isGenerating {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(0.85)
                            Text("Generating...")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16))
                            Text("Generate the story")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        vm.selectedLength != nil && !vm.isGenerating
                            ? LinearGradient(colors: [Color(hex: "7B5EA7"), Color(hex: "4A3580")], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(vm.selectedLength == nil || vm.isGenerating)

                Spacer(minLength: 20)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct LengthRow: View {
    let length: StoryLength
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(length.label)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text(length.description)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                // Visual duration bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 80, height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? Color(hex: "A87FE0") : Color.white.opacity(0.3))
                        .frame(width: CGFloat(length.rawValue) / 40.0 * 80, height: 6)
                }

                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "A87FE0") : Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "A87FE0"))
                            .frame(width: 14, height: 14)
                    }
                }
                .padding(.leading, 12)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .background(isSelected ? Color(hex: "A87FE0").opacity(0.12) : Color.white.opacity(0.06))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Color(hex: "A87FE0").opacity(0.4) : Color.clear, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        StoryLengthView(vm: StoryViewModel())
    }
    .preferredColorScheme(.dark)
}
