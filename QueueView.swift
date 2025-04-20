import SwiftUI

struct QueueView: View {
    @State private var queue: [(Int, Int)] = []
    @State private var newNumber: String = ""
    let maxElements = 10

    let theorySentences = [
        "A queue follows FIFO - First In, First Out.",
        "Enqueue adds an element to the end of the queue.",
        "Dequeue removes the front element of the queue.",
        "The front element is the first to leave.",
        "Queues are used in task scheduling and messaging."
    ]
    @State private var currentSentenceIndex = 0

    var body: some View {
        ZStack {
            // 🏞 Brown-Themed Background
            Image("quf")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("🚃 Queue - FIFO")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()

                // Dynamic Theory Content (Now in Orange Shade)
                Text(theorySentences[currentSentenceIndex])
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.orange.opacity(0.5)) // 🔶 Orange Shade
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                            DispatchQueue.main.async {
                                currentSentenceIndex = (currentSentenceIndex + 1) % theorySentences.count
                            }
                        }
                    }

                ZStack {
                    // Gradient FIFO Text
                    Text("FIFO")
                        .font(.system(size: 180, weight: .bold, design: .default))
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.white.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .offset(y: 120)

                    HStack(spacing: 5) {
                        ForEach(queue, id: \.0) { element in
                            VStack {
                                Text("\(element.0)")
                                    .font(.title2)
                                    .padding(10)
                                    .background(queue.first?.0 == element.0 ? Color.orange : Color.brown)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                Text("\(element.1)")
                                    .font(.footnote)
                            }
                        }
                    }
                    .frame(height: 80)
                    .padding()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    .clipped()
                }

                // 🔶 "Choose a Number" Title
                Text("Choose a Number or Type a number")
                    .font(.headline)
                    .foregroundColor(.black)

                // Number Selection in 2 Rows (Now in Orange Shades)
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { num in
                            Button("\(num)") {
                                withAnimation {
                                    if queue.count < maxElements {
                                        queue.append((num, queue.count))
                                    }
                                }
                            }
                            .buttonStyle(QueueButtonStyle())
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(6...10, id: \.self) { num in
                            Button("\(num)") {
                                withAnimation {
                                    if queue.count < maxElements {
                                        queue.append((num, queue.count))
                                    }
                                }
                            }
                            .buttonStyle(QueueButtonStyle())
                        }
                    }
                }

                // Manual Entry TextField
                TextField("Enter a number", text: $newNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 220)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                HStack(spacing: 15) {
                    Button("Enqueue") {
                        withAnimation {
                            if queue.count < maxElements, let number = Int(newNumber) {
                                queue.append((number, queue.count))
                                newNumber = ""
                            }
                        }
                    }
                    .buttonStyle(PrimaryButton(color: .green))

                    Button("Dequeue") {
                        withAnimation {
                            if !queue.isEmpty {
                                queue.removeFirst()
                            }
                        }
                    }
                    .buttonStyle(PrimaryButton(color: .red))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// 🟠 Custom Button Style for Queue Buttons (Orange Shade)
struct QueueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 50)
            .background(Color.orange.opacity(0.8)) // 🔶 Changed to Orange
            .foregroundColor(.black) // Text in Black
            .cornerRadius(10)
            .shadow(radius: 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

