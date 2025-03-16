import SwiftUI
import SwiftData
import SplashScreenKit

struct ContentView: View {
    @State private var showSplash = true
    @Namespace private var animation

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen(
                    images: [
                        Photo("1"),
                        Photo("2"),
                        Photo("3"),
                        Photo("4"),
                        Photo("5")
                    ],
                    title: "Your AI stylist",
                    product: "detaile",
                    caption: "Always up to date",
                    cta: "Get started"
                ) {
                    withAnimation(.spring(response: 0.9, dampingFraction: 0.8)) {
                        showSplash = false
                    }
                }
                .overlay(
                    Text("detaile")
                        .font(.largeTitle.bold())
                        .matchedGeometryEffect(id: "title", in: animation)
                        .opacity(0)
                        .padding(.top, 500)
                )
            } else {
                MainView()
                PreloadDataView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [WardrobeItem.self, WardrobeCategory.self], inMemory: true)
}


struct PreloadDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [WardrobeCategory]
    
    var body: some View {
        Color.clear.onAppear {
            if categories.map(\.name) != WardrobeCategory.defaultCategories.map(\.name) {
                // If categories don't match default, reset them
                resetCategories()
            }
        }
    }
    
    private func resetCategories() {
        categories.forEach { modelContext.delete($0) } // Remove old categories
        WardrobeCategory.defaultCategories.forEach { modelContext.insert($0) } // Insert new ones
    }
}

