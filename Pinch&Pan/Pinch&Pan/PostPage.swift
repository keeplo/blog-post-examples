//
//  PostPage.swift
//  Pinch&Pan
//
//  Created by 김용우 on 2023/05/13.
//

import SwiftUI

struct PostPage: View {
    
    @StateObject var viewModel: PostPageViewModel = .init()
    
    var body: some View {
        VStack() {
            Color.black
                .aspectRatio(1, contentMode: .fill)
                .overlay {
                    TabView(selection: $viewModel.selection) {
                        ForEach(0..<viewModel.images.count, id: \.self) { index in
                            Image(uiImage: viewModel.images[index])
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing) {
                                    Text("워터미크")
                                        .foregroundColor(.white)
                                }
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                }
            
            Divider()
            
            Rectangle()
                .foregroundColor(.gray)
                .frame(height: 150)
            
            Divider()
            
            TextEditor(text: $viewModel.postContext)
            
        }
        .navigationTitle("My Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}

final class PostPageViewModel: ObservableObject {
    @Published var selection: Int = 0
    @Published var images: [UIImage]
    @Published var postContext: String
    
    init() {
        self.images = (0..<4).compactMap({ .init(named: "photo_\($0)") })
        self.postContext = "내용을 적을 수도 있고 안적을 수도 있고 이렇게 주절주절 적을 수도있지"
    }
}

struct PostPage_Previews: PreviewProvider {
    static var previews: some View {
        PostPage()
    }
}
