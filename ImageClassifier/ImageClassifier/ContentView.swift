//
//  ContentView.swift
//  RealtimeVision
//
//  Created by 김용우 on 2023/07/03.
//

import SwiftUI
import PhotosUI
import Vision

struct ContentView: View {

    @StateObject var viewModel: ViewModel = .init()
    
    var body: some View {
        if let image = viewModel.selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        
        Spacer()
        
        Text(viewModel.prompt)
            .foregroundColor(.green)
        
        Button("Image Picker") {
            viewModel.isPresentedPicker.toggle()
        }
        .sheet(isPresented: $viewModel.isPresentedPicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
    }
    
}

final class ViewModel: ObservableObject {
    
    @Published var prompt: String = "idle"
    @Published var isPresentedPicker: Bool = false
    @Published var selectedImage: UIImage? {
        didSet {
            guard let image = selectedImage else { return }
            prompt = "loding . . ."
            Task {
                switch await predict(by: image) {
                    case .success(let result):
                        await MainActor.run {
                            prompt = result
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    let model: VNCoreMLModel?
    
    init() {
        self.model = try? VNCoreMLModel(for: ImageClassifier(configuration: .init()).model)
    }
    
}

extension ViewModel {
    
    func predict(by image: UIImage) async -> Result<String, ConvertError> {
        guard let model = model,
              let cgImage = image.cgImage else {
            return .failure(.dataBindingFailure)
        }
        
        let request = VNCoreMLRequest(model: model)
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try requestHandler.perform([request])
        } catch {
            return .failure(.predictFailure)
        }
        
        guard let results = request.results else {
            return .failure(.noneClasses)
        }
        
        let result = results
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) : \($0.confidence)%" }).joined(separator: "\n")
        
        return .success(result)
    }
    
}

enum ConvertError: Error {
    case dataBindingFailure
    case predictFailure
    case noneClasses
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
