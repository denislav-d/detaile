import SwiftUI
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageUploaderView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var processedImage: UIImage? = nil
    @State private var isProcessing: Bool = false
    
    private let processingQueue = DispatchQueue(label: "ProcessingQueue")
    
    var body: some View {
        VStack {
            if let imageToShow = processedImage ?? selectedImage {
                Image(uiImage: imageToShow)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Select an Image")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .onChange(of: selectedItem) {
                Task {
                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = fixImageOrientation(uiImage)
                        processedImage = nil // Reset processed image
                    }
                }
            }
            
            if selectedImage != nil {
                Button(action: removeBackground) {
                    Text(isProcessing ? "Processing..." : "Remove Background")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isProcessing ? Color.gray : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(isProcessing)
            }
        }
        .padding()
    }
    
    private func fixImageOrientation(_ image: UIImage) -> UIImage {
        // Check if the image needs fixing
        if image.imageOrientation == .up {
            return image
        }
        
        // Create drawing context
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        // Get normalized image
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? image
    }
    
    private func removeBackground() {
        guard let selectedImage = selectedImage,
              let inputCIImage = CIImage(image: selectedImage) else {
            print("Failed to create CIImage")
            return
        }
        
        isProcessing = true
        
        processingQueue.async {
            let handler = VNImageRequestHandler(ciImage: inputCIImage)
            let request = VNGenerateForegroundInstanceMaskRequest()
            
            do {
                try handler.perform([request])
                
                guard let result = request.results?.first else {
                    print("No observations found")
                    DispatchQueue.main.async {
                        isProcessing = false
                    }
                    return
                }
                
                let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                let maskCIImage = CIImage(cvPixelBuffer: maskPixelBuffer)
                
                let blendFilter = CIFilter.blendWithMask()
                blendFilter.inputImage = inputCIImage
                blendFilter.maskImage = maskCIImage
                blendFilter.backgroundImage = CIImage(color: .clear).cropped(to: inputCIImage.extent)
                
                guard let outputCIImage = blendFilter.outputImage,
                      let cgImage = CIContext().createCGImage(outputCIImage, from: outputCIImage.extent) else {
                    print("Failed to create output image")
                    DispatchQueue.main.async {
                        isProcessing = false
                    }
                    return
                }
                
                // Create final image with proper orientation
                let finalImage = UIImage(cgImage: cgImage, scale: selectedImage.scale, orientation: .up)
                
                DispatchQueue.main.async {
                    self.processedImage = finalImage
                    self.isProcessing = false
                }
            } catch {
                print("Error during background removal: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isProcessing = false
                }
            }
        }
    }
}

struct ImageUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploaderView()
    }
}
