import SwiftUI

struct SearchingAlgorithmsView: View {
    @State private var numbers: [Int] = []
    @State private var selectedNumber: Int? = nil
    @State private var sortedNumbers: [Int] = []
    @State private var searchResult: String = "🔍 Select up to 6 numbers!"
    @State private var highlightedIndex: Int? = nil
    @State private var omittedIndices: Set<Int> = []
    @State private var isMatched: Bool = false
    @State private var showSortingPrompt: Bool = false
    @State private var showSorted: Bool = false

    var body: some View {
        ZStack {
            Image("sef") // Background Image
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            LinearGradient(colors: [Color.black.opacity(0.3), Color.clear],
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("🔎 Searching Algorithms")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.indigo)
                    .shadow(radius: 0)

                // Theory Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("📖 Understand")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.purple)

                    Text("🔹 **Linear Search**: Checks each element one by one. It's simple but slow for large datasets.")
                    Text("🔹 **Binary Search**: Works on **sorted lists** by repeatedly splitting the range in half, making it much faster.")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.2)))
                .padding(.horizontal)
                .foregroundColor(.black)

                // Number Display (Before Sorting)
                VStack {
                    Text("🔢 Numbers:")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)

                    if showSortingPrompt {
                        Text("📌 Sorting numbers in ascending order...")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                            .padding()
                    } else {
                        HStack {
                            ForEach((showSorted ? sortedNumbers : numbers).indices, id: \.self) { index in
                                Text("\(showSorted ? sortedNumbers[index] : numbers[index])")
                                    .font(.title2)
                                    .bold()
                                    .frame(width: 45, height: 45) // Reduced size
                                    .background(highlightedIndex == index ? (isMatched ? Color.green : Color.red) : Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                                    .scaleEffect(highlightedIndex == index ? 1.3 : 1.0)
                                    .animation(.spring(), value: highlightedIndex)
                            }
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.2)))
                .padding()

                // Step 2: Choose target number
                if numbers.count == 6 {
                    Text("🎯 Select a number to search")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack {
                        ForEach(numbers, id: \.self) { num in
                            Button(action: {
                                selectedNumber = num
                                searchResult = "🔍 Searching for \(num)... Choose a method!"
                            }) {
                                Text("\(num)")
                                    .font(.title2)
                                    .bold()
                                    .frame(width: 50, height: 50) // Reduced size
                                    .background(selectedNumber == num ? Color.green.opacity(0.8) : Color.white.opacity(0.5))
                                    .foregroundColor(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("🎯 Choose numbers (Tap to add)")
                        .font(.headline)
                        .foregroundColor(.black)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) { // Reduced spacing
                        ForEach(0..<10, id: \.self) { num in
                            Button(action: {
                                if numbers.count < 6 {
                                    numbers.append(num)
                                }
                            }) {
                                Text("\(num)")
                                    .font(.title2)
                                    .bold()
                                    .frame(width: 50, height: 50) // Reduced size
                                    .background(Color.purple.opacity(0.6))
                                    .foregroundColor(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .padding()
                }

                // Search Buttons
                if selectedNumber != nil {
                    HStack {
                        Button("🔍 Linear Search") {
                            Task {
                                await linearSearch(target: selectedNumber!)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)

                        Button("🔍 Binary Search") {
                            Task {
                                await startBinarySearch(target: selectedNumber!)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                    }
                    .padding()
                }

                // Search Result Display
                Text(searchResult)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .foregroundColor(.black)

                // Clear Button (Fixed Position)
                Button("🗑️ Clear Numbers") {
                    numbers.removeAll()
                    selectedNumber = nil
                    searchResult = "🔍 Select up to 6 numbers!"
                    highlightedIndex = nil
                    omittedIndices = []
                    isMatched = false
                    showSorted = false
                    showSortingPrompt = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .padding()
                .padding(.bottom, 10) // Ensuring proper spacing
            }
        }
    }

    // 🔍 Linear Search
    @MainActor
    func linearSearch(target: Int) async {
        highlightedIndex = nil
        isMatched = false
        searchResult = "🔍 Searching..."

        for (index, num) in numbers.enumerated() {
            highlightedIndex = index
            try? await Task.sleep(nanoseconds: 500_000_000)

            if num == target {
                isMatched = true
                searchResult = "✅ Found at index \(index)"
                return
            }
            isMatched = false
        }
        searchResult = "❌ Not found"
    }

    // 🔍 Binary Search with Sorting Prompt
    @MainActor
    func startBinarySearch(target: Int) async {
        showSortingPrompt = true
        try? await Task.sleep(nanoseconds: 2_000_000_000) // ⏳ Show sorting message for 2 seconds
        showSortingPrompt = false

        sortedNumbers = numbers.sorted()
        showSorted = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await binarySearch(target: target)
    }

    @MainActor
    func binarySearch(target: Int) async {
        var low = 0
        var high = sortedNumbers.count - 1
        omittedIndices = []

        while low <= high {
            let mid = (low + high) / 2
            highlightedIndex = mid
            try? await Task.sleep(nanoseconds: 500_000_000)

            if sortedNumbers[mid] == target {
                isMatched = true
                searchResult = "✅ Found at index \(mid) in sorted list"
                return
            } else if sortedNumbers[mid] < target {
                omittedIndices.formUnion(low...mid)
                low = mid + 1
            } else {
                omittedIndices.formUnion(mid...high)
                high = mid - 1
            }
        }
        searchResult = "❌ Not found"
    }
}

