import SwiftUI

struct SleepTimerSheet: View {
    @ObservedObject var vm: StoryViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Sleep timer")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white.opacity(0.4))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 16)

            // Options list
            ScrollView {
                VStack(spacing: 2) {
                    ForEach(SleepTimer.allCases) { timer in
                        TimerRow(
                            timer: timer,
                            isSelected: timerMatches(timer)
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                vm.sleepTimer = timer
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                dismiss()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()
        }
    }

    private func timerMatches(_ timer: SleepTimer) -> Bool {
        switch (timer, vm.sleepTimer) {
        case (.off, .off): return true
        case (.endOfSound, .endOfSound): return true
        case (.minutes(let a), .minutes(let b)): return a == b
        default: return false
        }
    }
}

struct TimerRow: View {
    let timer: SleepTimer
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: timerIcon)
                    .font(.system(size: 15))
                    .foregroundColor(isSelected ? Color(hex: "A87FE0") : .white.opacity(0.5))
                    .frame(width: 24)

                Text(timer.label)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "A87FE0"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? Color(hex: "A87FE0").opacity(0.12) : Color.white.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var timerIcon: String {
        switch timer {
        case .off:         return "moon.zzz"
        case .endOfSound:  return "stop.circle"
        case .minutes(let m):
            switch m {
            case 10: return "1.circle"
            case 20: return "2.circle"
            case 30: return "3.circle"
            case 40: return "4.circle"
            case 50: return "5.circle"
            default: return "timer"
            }
        }
    }
}

#Preview {
    SleepTimerSheet(vm: StoryViewModel())
        .preferredColorScheme(.dark)
        .background(Color(hex: "16102E"))
}
