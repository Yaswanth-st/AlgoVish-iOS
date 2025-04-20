import SwiftUI

struct LearningMenuView: View {
    var body: some View {
        ZStack(alignment: .center) {
            // 🌊 Background Image (Ocean Theme)
            Image("m1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.05)) // Soft overlay

            VStack(alignment: .center, spacing: 30) {
                // 🚀 Creative Title
                Text("🚀 Embark on Your Learning Adventure!")
                    .font(.custom("Papyrus", size: 36))
                    .foregroundColor(.black)
                    .shadow(color: Color.white.opacity(0.8), radius: 8, x: 0, y: 3)
                    .padding(.bottom, 20)

                // 🌊 Ocean-Themed Learning Buttons (Reordered Navigation)
                VStack(alignment: .center, spacing: 40) {
                    LearningOption(title: "🔍 Searching", destination: SearchingAlgorithmsView())
                    LearningOption(title: "📊 Sorting", destination: SortingAlgorithmsView())
                    LearningOption(title: "📦 Stack", destination: StackView())
                    LearningOption(title: "🔄 Queue", destination: QueueView())
                    LearningOption(title: "🔗 Linked List", destination: LinkedListView())
                }
                .frame(width: 350)
                .padding(.top, 20)

                Spacer()
            }
        }
    }
}

// 🌊 Ocean-Themed Gradient Buttons
struct LearningOption<Destination: View>: View {
    let title: String
    let destination: Destination

    @State private var isPressed = false

    var body: some View {
        NavigationLink(destination: destination) { // ✅ Direct Navigation
            Text(title)
                .font(.custom("Papyrus", size: 22))
                .foregroundColor(.black)
                .padding(.vertical, 15)
                .padding(.horizontal, 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            isPressed ? Color(hex: "#005F9E") : Color(hex: "#008CFF"), // Deep Blue
                            isPressed ? Color(hex: "#B3E0FF") : Color.white // Ocean White
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 5)
                .scaleEffect(isPressed ? 0.95 : 1) // Press animation
        }
        .buttonStyle(PlainButtonStyle()) // ✅ Ensures proper styling
    }
}

// 🎨 HEX COLOR SUPPORT
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        default:
            r = 1.0
            g = 1.0
            b = 1.0
        }
        self.init(red: r, green: g, blue: b)
    }
}

