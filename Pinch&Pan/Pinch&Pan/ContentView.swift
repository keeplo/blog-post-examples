//
//  ContentView.swift
//  Pinch&Pan
//
//  Created by 김용우 on 2023/05/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: { PostPage() },
                label: { Text("Page 보기") }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
