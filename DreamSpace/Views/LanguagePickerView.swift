import SwiftUI

struct LanguagePickerView: View {
    @ObservedObject var vm: StoryViewModel
    @State private var navigateToMood = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0D0D1E"), Color(hex: "1A1040")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 32) {
                // Title
                VStack(alignment: .leading, spacing: 6) {
                    Text("Choose a language")
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Your story will be told in this language.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 8)

                // Language options
                VStack(spacing: 14) {
                    ForEach(StoryLanguage.allCases) { language in
                        LanguageRow(
                            language: language,
                            isSelected: vm.selectedLanguage == language
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                vm.selectedLanguage = language
                            }
                        }
                    }
                }

                Spacer()

                // OK / Next button
                NavigationLink(destination: MoodPickerView(vm: vm), isActive: $navigateToMood) {
                    EmptyView()
                }

                Button {
                    if vm.selectedLanguage != nil { navigateToMood = true }
                } label: {
                    HStack {
                        Text("OK")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        vm.selectedLanguage != nil
                            ? LinearGradient(colors: [Color(hex: "7B5EA7"), Color(hex: "4A3580")], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(vm.selectedLanguage == nil)

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

struct LanguageRow: View {
    let language: StoryLanguage
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(language.flag)
                    .font(.system(size: 26))
                Text(language.rawValue)
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
            .padding(.vertical, 18)
            .background(
                isSelected
                    ? Color(hex: "A87FE0").opacity(0.15)
                    : Color.white.opacity(0.06)
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
        LanguagePickerView(vm: StoryViewModel())
    }
    .preferredColorScheme(.dark)
}
