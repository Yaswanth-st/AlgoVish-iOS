import SwiftUI

struct StackView: View {
    @State private var stack: [(Int, Int)] = []
    @State private var newNumber: String = ""
    let maxElements = 10
    let numbers = Array(1...10) // Virtual keyboard numbers
    
    let theorySentences = [
        "A stack follows LIFO - Last In, First Out.",
        "Push adds an item to the top of the stack.",
        "Pop removes the topmost item from the stack.",
        "The topmost item is the only accessible one.",
        "Stacks are used in function calls and undo actions."
    ]
    @State private var currentSentenceIndex = 0
    
    var body: some View {
        ZStack {
            Image("st10")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                Text("📦 Stack - LIFO")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                
                Text(theorySentences[currentSentenceIndex])
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.green.opacity(0.4))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                            DispatchQueue.main.async {
                                currentSentenceIndex = (currentSentenceIndex + 1) % theorySentences.count
                            }
                        }
                    }
                
                if let topValue = stack.last?.0 {
                    Text("🔸 Top Value: \(topValue)")
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                
                ZStack {
                    Text("LIFO")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .offset(y: 50)
                    
                    HStack(spacing: 5) {
                        ForEach(stack, id: \.0) { element in
                            VStack {
                                Text("\(element.0)")
                                    .font(.body)
                                    .padding(8)
                                    .background(stack.last?.0 == element.0 ? Color.orange : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 3)
                                Text("\(element.1)")
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(height: 60)
                    .padding()
                }
                
                Text("🔢 Choose a number to push or type below!")
                    .font(.headline)
                    .foregroundColor(.black)
                
                VStack(spacing: 5) {
                    HStack(spacing: 8) {
                        ForEach(numbers.prefix(5), id: \.self) { number in
                            Button("\(number)") {
                                withAnimation {
                                    if stack.count < maxElements {
                                        stack.append((number, stack.count))
                                    }
                                }
                            }
                            .buttonStyle(PrimaryButton(color: .green))
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(numbers.suffix(5), id: \.self) { number in
                            Button("\(number)") {
                                withAnimation {
                                    if stack.count < maxElements {
                                        stack.append((number, stack.count))
                                    }
                                }
                            }
                            .buttonStyle(PrimaryButton(color: .green))
                        }
                    }
                }
                
                TextField("Enter a number", text: $newNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 220)
                    .padding()
                    .background(Color.green.opacity(0.4))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                HStack(spacing: 15) {
                    Button("Push") {
                        withAnimation {
                            if stack.count < maxElements, let number = Int(newNumber) {
                                stack.append((number, stack.count))
                                newNumber = ""
                            }
                        }
                    }
                    .buttonStyle(PrimaryButton(color: .green))
                    
                    Button("Pop") {
                        withAnimation {
                            if !stack.isEmpty {
                                stack.removeLast()
                            }
                        }
                    }
                    .buttonStyle(PrimaryButton(color: .red))
                    
                    Button("Reset") {
                        withAnimation {
                            stack.removeAll()
                        }
                    }
                    .buttonStyle(PrimaryButton(color: .gray))
                }
                .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

