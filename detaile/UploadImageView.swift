import SwiftUI
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftData

struct UploadImageView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isProcessing: Bool = false
    
    private let processingQueue = DispatchQueue(label: "ProcessingQueue")

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "tshirt")
                            .font(.system(size: 22))
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundStyle(.white)
                            .background(Color.secondary)
                            .cornerRadius(12)
                        Text("New items")
                            .font(.title2)
                            .bold()
                        Text("Add new items to your virtual wardrobe by uploading images here. Try to take photos of your clothing items without any other items in the background.")
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical)
                }
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if selectedImage != nil {
                        Text("Upload another image")
                    } else {
                        Text("Upload an image")
                    }
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let selectedItem,
                           let data = try? await selectedItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = fixImageOrientation(uiImage)
                            removeBackground()
                        }
                    }
                }
                
                if isProcessing {
                    ProgressView("Processing...")
                }
            }
        }
    }
    
    private func fixImageOrientation(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up { return image }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? image
    }
    
    private func removeBackground() {
        guard let inputImage = selectedImage, let ciImage = CIImage(image: inputImage) else { return }
        isProcessing = true
        
        processingQueue.async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            let request = VNGenerateForegroundInstanceMaskRequest()
            
            do {
                try handler.perform([request])
                guard let result = request.results?.first else {
                    DispatchQueue.main.async { isProcessing = false }
                    return
                }
                
                let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                let maskCIImage = CIImage(cvPixelBuffer: maskPixelBuffer)
                
                let blendFilter = CIFilter.blendWithMask()
                blendFilter.inputImage = ciImage
                blendFilter.maskImage = maskCIImage
                blendFilter.backgroundImage = CIImage(color: .clear).cropped(to: ciImage.extent)
                
                guard let outputCIImage = blendFilter.outputImage,
                      let cgImage = CIContext().createCGImage(outputCIImage, from: outputCIImage.extent) else {
                    DispatchQueue.main.async { isProcessing = false }
                    return
                }
                
                let finalImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: .up)
                DispatchQueue.main.async {
                    self.selectedImage = finalImage
                    self.isProcessing = false
                    self.saveWardrobeItem(with: finalImage)
                }
            } catch {
                DispatchQueue.main.async { isProcessing = false }
            }
        }
    }
    
    private func saveWardrobeItem(with image: UIImage) {
        guard let imageData = image.pngData() else { return }
        // Create a new WardrobeItem with default values. You can later add an edit screen for more details.
        let newItem = WardrobeItem(title: "New Item",
                                   brand: "Unknown",
                                   colors: [],
                                   type: "Unknown",
                                   note: "",
                                   imageData: imageData,
                                   dateAdded: Date())
        modelContext.insert(newItem)
    }
}

struct UploadImageView_Previews: PreviewProvider {
    static var previews: some View {
        UploadImageView()
    }
}
