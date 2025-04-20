import SwiftUI

// ✅ Neon Button Style
struct NeonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.blue.opacity(0.8), radius: 10, x: 0, y: 0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// ✅ Singly Linked List Node
class SinglyNode: Identifiable {
    let id = UUID()
    var value: Int
    var next: SinglyNode?
    
    init(value: Int) {
        self.value = value
    }
}

// ✅ Singly Linked List
class SinglyLinkedList: ObservableObject {
    @Published var head: SinglyNode?
    
    func insert(value: Int) {
        let newNode = SinglyNode(value: value)
        if head == nil {
            head = newNode
        } else {
            var current = head
            while current?.next != nil {
                current = current?.next
            }
            current?.next = newNode
        }
    }
    
    func delete() {
        if head != nil {
            head = head?.next
        }
    }
    
    func getNodes() -> [SinglyNode] {
        var nodes: [SinglyNode] = []
        var current = head
        while current != nil {
            if let unwrappedNode = current {
                nodes.append(unwrappedNode)
            }
            current = current?.next
        }
        return nodes
    }
}

// ✅ Doubly Linked List Node
class DoublyNode: Identifiable {
    let id = UUID()
    var value: Int
    var next: DoublyNode?
    var prev: DoublyNode?
    
    init(value: Int) {
        self.value = value
    }
}

// ✅ Doubly Linked List
class DoublyLinkedList: ObservableObject {
    @Published var head: DoublyNode?
    
    func insert(value: Int) {
        let newNode = DoublyNode(value: value)
        if head == nil {
            head = newNode
        } else {
            var current = head
            while current?.next != nil {
                current = current?.next
            }
            current?.next = newNode
            newNode.prev = current
        }
    }
    
    func delete() {
        if head != nil {
            head = head?.next
            head?.prev = nil
        }
    }
    
    func getNodes() -> [DoublyNode] {
        var nodes: [DoublyNode] = []
        var current = head
        while current != nil {
            if let unwrappedNode = current {
                nodes.append(unwrappedNode)
            }
            current = current?.next
        }
        return nodes
    }
}

// ✅ Theory Content (Auto-Changing Every 2 Seconds)
let theorySentences = [
    "A Linked List is a linear data structure.",
    "Each node contains a value and a reference to the next node.",
    "Linked Lists allow dynamic memory allocation.",
    "Unlike arrays, linked lists do not require contiguous memory."
]

let singlyTheory = [
    "Singly Linked List nodes are connected in one direction.",
    "Each node has a pointer to the next node only."
]

let doublyTheory = [
    "Doubly Linked List nodes have pointers to both previous and next nodes.",
    "This allows traversal in both forward and backward directions."
]

// ✅ Main View
struct LinkedListView: View {
    @StateObject private var singlyLinkedList = SinglyLinkedList()
    @StateObject private var doublyLinkedList = DoublyLinkedList()
    
    @State private var theoryText = theorySentences[0]
    @State private var theoryIndex = 0
    @State private var singlyTheoryIndex = 0
    @State private var doublyTheoryIndex = 0
    
    var body: some View {
        ZStack {
            // 📌 Background Image
            Image("ll2")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .opacity(5)
            
            VStack(spacing: 20) {
                // 🏷️ Title
                Text("🔗 Linked List Visualizer")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                
                // 📜 Theory (Auto-Changes)
                Text(theoryText)
                    .font(.headline)
                    .foregroundColor(.black)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                            DispatchQueue.main.async {
                                theoryIndex = (theoryIndex + 1) % theorySentences.count
                                theoryText = theorySentences[theoryIndex]
                            }
                        }
                    }
                
                // 🔹 Singly Linked List Section
                Text("🟡 Singly Linked List")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.pink)
                
                Text(singlyTheory[singlyTheoryIndex])
                    .foregroundColor(.black)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                            DispatchQueue.main.async {
                                singlyTheoryIndex = (singlyTheoryIndex + 1) % singlyTheory.count
                            }
                        }
                    }
                
                // 📌 Visualization
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(singlyLinkedList.getNodes()) { node in
                            Text("\(node.value)")
                                .font(.headline)
                                .padding()
                                .background(Color.yellow)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                            
                            if node.next != nil {
                                Image(systemName: "arrow.right")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                
                // 🟠 Doubly Linked List Section
                Text("🟠 Doubly Linked List")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.pink)
                
                Text(doublyTheory[doublyTheoryIndex])
                    .foregroundColor(.black)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                            DispatchQueue.main.async {
                                doublyTheoryIndex = (doublyTheoryIndex + 1) % doublyTheory.count
                            }
                        }
                    }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(doublyLinkedList.getNodes()) { node in
                            if node.prev != nil {
                                Image(systemName: "arrow.left")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                            
                            Text("\(node.value)")
                                .font(.headline)
                                .padding()
                                .background(Color.orange)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                            
                            if node.next != nil {
                                Image(systemName: "arrow.right")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                
                // 🔘 Buttons
                HStack {
                    Button("Insert Node") {
                        let newValue = Int.random(in: 1...99)
                        singlyLinkedList.insert(value: newValue)
                        doublyLinkedList.insert(value: newValue)
                    }
                    .buttonStyle(NeonButtonStyle())
                    
                    Button("Delete Node") {
                        singlyLinkedList.delete()
                        doublyLinkedList.delete()
                    }
                    .buttonStyle(NeonButtonStyle())
                }
            }
        }
    }
}

#Preview {
    LinkedListView()
}

