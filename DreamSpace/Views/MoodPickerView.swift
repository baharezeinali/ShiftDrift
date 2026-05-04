import SwiftUI

struct MoodPickerView: View {
    @ObservedObject var vm: StoryViewModel
    @State private var navigateToLength = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0D0D1E"), Color(hex: "1A1040")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mood")
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text("What feeling should your story carry?")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 8)

                VStack(spacing: 12) {
                    ForEach(StoryMood.allCases) { mood in
                        MoodRow(
                            mood: mood,
                            isSelected: vm.selectedMood == mood
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                vm.selectedMood = mood
                            }
                        }
                    }
                }

                Spacer()

                NavigationLink(destination: StoryLengthView(vm: vm), isActive: $navigateToLength) {
                    EmptyView()
                }

                Button {
                    if vm.selectedMood != nil { navigateToLength = true }
                } label: {
                    HStack {
                        Text("Next")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        vm.selectedMood != nil
                            ? LinearGradient(colors: [Color(hex: "7B5EA7"), Color(hex: "4A3580")], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(vm.selectedMood == nil)

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

struct MoodRow: View {
    let mood: StoryMood
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? mood.cardGradient : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: 40, height: 40)
                    Image(systemName: mood.icon)
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.5))
                }
                Text(mood.rawValue)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
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
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 15)
            .background(
                isSelected ? Color(hex: "A87FE0").opacity(0.12) : Color.white.opacity(0.06)
            )
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
        MoodPickerView(vm: StoryViewModel())
    }
    .preferredColorScheme(.dark)
}
