import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            WelcomeView()
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper navigation on iPad
    }
}   

