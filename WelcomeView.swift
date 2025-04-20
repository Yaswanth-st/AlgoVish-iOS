import SwiftUI

struct WelcomeView: View {
    @State private var gradientColors: [Color] = [.green, .blue, .pink, .purple, .cyan]
    @State private var animateGradient = false

    var body: some View {
        NavigationView {
            ZStack {
                // 🌟 Background Image (White & Blue)
                Image("bg4")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                     // Subtle contrast overlay
                
                VStack(spacing: 30) {
                    // 📌 DATAiO at the very top
                    Text("AlgoVish ")
                        .font(.system(size: 70, weight: .black, design: .rounded)) // Huge Font
                        .foregroundColor(.black) // Black Text
                        .shadow(color: Color.white.opacity(2), radius: 5, x: 0, y: 5) // White glow effect
                        .padding(.top, 10) // Push it to the top
                    
                    
                    // 🌊 "Ready to Learn?" with bold shadow effects
                    Text("visualize. learn. master.")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundColor(.black) // Black Text
                        .shadow(color: Color.white.opacity(0.7), radius: 8, x: 0, y: 3) // Blue glow effect
                        .padding(.bottom, 10)

                    Spacer()

                    // 🎓 "START LEARNING" button at the bottom (above footer)
                    NavigationLink(destination: LearningMenuView()) {
                        Text("📚 START LEARNING")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing)
                                    .animation(Animation.linear(duration: 3).repeatForever(autoreverses: true), value: animateGradient)
                            )
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.8), radius: 12, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
                            )
                            .frame(width: 350) // Centering
                    }
                    .onAppear {
                        animateGradient.toggle()
                        withAnimation {
                            gradientColors.shuffle()
                        }
                    }
                    
                    // ✨ Footer - Created by (Golden Glow Effect)
                    VStack {
                        ElegantFooterText(text: " Created with ❤️ by Yaswanth S T ", color: .black, size: 14)
                            .shadow(color: Color.yellow.opacity(0.9), radius: 6, x: 0, y: 0) // Gold Glow
                        
                        ElegantFooterText(text: "  Apple Swift Student Challenge 2025 🌟", color: .black, size: 14)
                            .shadow(color: Color.orange.opacity(0.9), radius: 6, x: 0, y: 0) // Golden-Orange Glow
                    }
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// 🌿 Elegant Footer Text with Stylish Glow
struct ElegantFooterText: View {
    var text: String
    var color: Color
    var size: CGFloat

    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .thin))
            .foregroundColor(color)
    }
}

#Preview {
    WelcomeView()
}

