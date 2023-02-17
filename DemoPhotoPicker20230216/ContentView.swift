//
//  ContentView.swift
//  DemoPhotoPicker20230216
//
//  Created by Xavier on 2/16/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var selected: [PhotosPickerItem] = []
    @State var data: Data?
    var body: some View {
        NavigationStack {
            VStack {
                if let data = data, let uiImage = UIImage(data: data) {
                    VStack {
                        HStack {
                            Text("Selected photo: ")
                                .bold()
                            Spacer()
                        }
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .padding()
                }
                Spacer()
                    .frame(height: 50)
                PhotosPicker(selection: $selected, maxSelectionCount: 1, matching: .images) {
                    VStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 45, alignment: .center)
                        Text("Select a photo")
                    }
                }
                .onChange(of: selected) { newValue in
                    guard let selectedItem = selected.first else {
                        return
                    }
                    selectedItem.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                self.data = data
                            } else {
                                print("Found nil in data")
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .navigationTitle("Photo Picker")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
