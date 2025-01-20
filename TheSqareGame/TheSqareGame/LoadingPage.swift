import SwiftUI

struct LoadingPage: View {
    @Binding var isLoading: Bool
    @State private var showPlayButton = false // Track when to show the Play button

    var body: some View {
        VStack {
            if showPlayButton {
                NavigationLink(destination: ContentView()) {
                    Text("Play")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                VStack {
                    Text("Loading...")
                        .font(.largeTitle)
                        .padding()

                    ProgressView()
                        .scaleEffect(2.0)
                        .padding()
                }
            }
        }
        .onAppear {
            // Show the Play button after 30 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                showPlayButton = true
            }
        }
    }
}

// Preview
#Preview {
    NavigationView {
        LoadingPage(isLoading: .constant(true))
    }
}
