import SwiftUI
import SwiftData
import SplashScreenKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showSplash = true
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            MainView()
//                .navigationBarTitleDisplayMode(.large)
//                .safeAreaInset(edge: .top) {
//                    if !showSplash {
//                        Text("detaile")
//                            .font(.largeTitle.bold())
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()
//                            .matchedGeometryEffect(id: "title", in: animation)
//                    }
//                }
//                .opacity(showSplash ? 0 : 1)

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
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
