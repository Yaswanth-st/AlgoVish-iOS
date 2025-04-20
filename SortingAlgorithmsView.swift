import SwiftUI

struct SortingAlgorithmsView: View {
    @State private var numbers: [Int] = []
    @State private var isSorting: Bool = false
    @State private var selectedAlgorithm: String? = nil
    @State private var highlightedIndices: [Int] = []
    @State private var comparisonText: String = ""
    @State private var currentFactIndex: Int = 0
    let algorithms = ["Bubble Sort", "Selection Sort", "Insertion Sort", "Merge Sort"]
    let sortingFacts = [
        "Sorting helps in searching efficiently.",
        "Bubble Sort swaps adjacent elements repeatedly.",
        "Merge Sort divides the array into halves and merges them.",
        "Selection Sort selects the smallest element in each pass.",
        "Insertion Sort places elements in the correct position.",
        "Efficient sorting improves data processing speed.",
    ]
    
    var body: some View {
        ZStack {
            Image("sof")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("Sorting Algorithms")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 30)
                
                Text(sortingFacts[currentFactIndex])
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.bottom, 10)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                            DispatchQueue.main.async {
                                currentFactIndex = (currentFactIndex + 1) % sortingFacts.count
                            }
                        }
                    }
                Spacer()
                Text("Select 7 numbers:")
                    .foregroundColor(.black)
                    .font(.title2)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                    ForEach(1...10, id: \.self) { number in
                        Button(action: {
                            if numbers.count < 7 { numbers.append(number) }
                        }) {
                            Text("\(number)")
                                .font(.title2)
                                .bold()
                                .frame(width: 50, height: 50)
                                .background(numbers.contains(number) ? Color.blue.opacity(0.7) : Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                
                if numbers.count == 7 {
                    Text("Choose a sorting method:")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    Picker("Select Algorithm", selection: $selectedAlgorithm) {
                        ForEach(algorithms, id: \.self) { algo in
                            Text(algo).tag(algo as String?)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                // Display numbers with pop-up effect during sorting
                HStack {
                    ForEach(numbers.indices, id: \.self) { index in
                        Text("\(numbers[index])")
                            .font(.title)
                            .bold()
                            .frame(width: 50, height: 50)
                            .background(highlightedIndices.contains(index) ? Color.purple : Color.pink.opacity(0.7))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .scaleEffect(highlightedIndices.contains(index) ? 1.3 : 1.0)  // Pop-up effect
                            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: highlightedIndices)
                    }
                }
                .padding()
                
                Text(comparisonText)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                
                HStack {
                    Button(action: startSorting) {
                        Text("Sort")
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(isSorting || selectedAlgorithm == nil)
                    
                    Button(action: {
                        numbers.removeAll()
                        highlightedIndices.removeAll()
                        comparisonText = ""
                    }) {
                        Text("Reset")
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
    
    @MainActor
    func startSorting() {
        isSorting = true
        Task {
            switch selectedAlgorithm {
            case "Bubble Sort":
                await bubbleSort()
            case "Selection Sort":
                await selectionSort()
            case "Insertion Sort":
                await insertionSort()
            case "Merge Sort":
                await mergeSort()
            default:
                break
            }
            isSorting = false
        }
    }
    
    @MainActor
    func bubbleSort() async {
        var arr = numbers
        for i in 0..<arr.count {
            for j in 0..<arr.count - i - 1 {
                highlightedIndices = [j, j + 1]
                comparisonText = "Comparing \(arr[j]) and \(arr[j + 1])"
                withAnimation {
                    if arr[j] > arr[j + 1] {
                        arr.swapAt(j, j + 1)
                    }
                }
                try? await Task.sleep(nanoseconds: 500_000_000)
                numbers = arr
            }
        }
        highlightedIndices.removeAll()
    }
    
    @MainActor
    func selectionSort() async {
        var arr = numbers
        for i in 0..<arr.count {
            var minIndex = i
            for j in i+1..<arr.count {
                highlightedIndices = [i, j]
                comparisonText = "Finding min: \(arr[j]) vs \(arr[minIndex])"
                try? await Task.sleep(nanoseconds: 500_000_000)
                if arr[j] < arr[minIndex] {
                    minIndex = j
                }
                numbers = arr
            }
            withAnimation {
                arr.swapAt(i, minIndex)
            }
        }
        highlightedIndices.removeAll()
    }
    
    @MainActor
    func insertionSort() async {
        var arr = numbers
        for i in 1..<arr.count {
            var j = i
            while j > 0 && arr[j] < arr[j - 1] {
                highlightedIndices = [j, j - 1]
                comparisonText = "Inserting \(arr[j]) before \(arr[j - 1])"
                withAnimation {
                    arr.swapAt(j, j - 1)
                }
                j -= 1
                try? await Task.sleep(nanoseconds: 500_000_000)
                numbers = arr
            }
        }
        highlightedIndices.removeAll()
    }
    
    @MainActor
    func mergeSort() async {
        numbers = numbers.sorted()
        comparisonText = "Merge Sort divides and merges arrays efficiently"
    }
}

struct SortingAlgorithmsView_Previews: PreviewProvider {
    static var previews: some View {
        SortingAlgorithmsView()
    }
}

