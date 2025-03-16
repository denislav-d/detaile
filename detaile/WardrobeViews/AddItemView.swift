//
//  AddItemView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 16.03.25.
//

import SwiftUI
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var brand: String = ""
    @State private var colors: String = ""
    @State private var type: String = ""
    @State private var note: String = ""
    
    @State private var selectedPickerItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isProcessing: Bool = false
    @State private var selectedCategoryId: UUID? = nil
    
    @Query private var categories: [WardrobeCategory]
    
    private let processingQueue = DispatchQueue(label: "ProcessingQueue")
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Title", text: $title)
                    TextField("Brand", text: $brand)
                    TextField("Colors (comma separated)", text: $colors)
                    TextField("Type", text: $type)
                    TextField("Note", text: $note)
                }
                
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategoryId) {
                        ForEach(categories) { category in
                            Text(category.name).tag(category.id as UUID?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Image")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                    }
                    
                    PhotosPicker(selection: $selectedPickerItem, matching: .images) {
                        Text(selectedImage == nil ? "Select Image" : "Change Image")
                    }
                    .onChange(of: selectedPickerItem) {
                        Task {
                            if let selectedPickerItem,
                               let data = try? await selectedPickerItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                let fixedImage = fixImageOrientation(uiImage)
                                selectedImage = fixedImage
                                removeBackground(from: fixedImage)
                            }
                        }
                    }
                    
                    if isProcessing {
                        ProgressView("Processing Image...")
                    }
                }
            }
            .navigationTitle("Add New Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { addItem() }
                        .disabled(isProcessing || title.isEmpty)
                }
            }
            .onAppear {
                if selectedCategoryId == nil, let firstCategory = categories.first {
                    selectedCategoryId = firstCategory.id
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
    
    private func removeBackground(from image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
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
                let finalImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
                DispatchQueue.main.async {
                    self.selectedImage = finalImage
                    self.isProcessing = false
                }
            } catch {
                DispatchQueue.main.async { self.isProcessing = false }
            }
        }
    }
    
    private func addItem() {
        guard let image = selectedImage,
              let imageData = image.pngData() else { return }
        let newItem = WardrobeItem(
            title: title,
            brand: brand,
            colors: colors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            type: type,
            note: note,
            imageData: imageData,
            dateAdded: Date()
        )
        if let selectedCategoryId = selectedCategoryId,
           let category = categories.first(where: { $0.id == selectedCategoryId }) {
            newItem.category = category
            category.items.append(newItem)
        }
        modelContext.insert(newItem)
        dismiss()
    }
}

#Preview {
    AddItemView()
        .modelContainer(for: [WardrobeItem.self, WardrobeCategory.self], inMemory: true)
}
