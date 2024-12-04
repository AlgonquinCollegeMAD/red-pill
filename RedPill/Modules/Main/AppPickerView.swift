//
//  PhotoPicker.swift
//  Firebase Storage Demo
//
//  Created by Vladimir Cezar on 2024.12.03.
//

import SwiftUI
import PhotosUI

struct AppPickerView: View {
  @Binding var selectedImage: UIImage?
  @State private var selectedPickerItem: PhotosPickerItem?
  
  var body: some View {
    PhotosPicker("Pick a Photo", selection: $selectedPickerItem, matching: .images)
      .onChange(of: selectedPickerItem) { oldValue, newValue in
        Task {
          await loadImage(from: newValue)
        }
      }
  }
  
  private func loadImage(from pickerItem: PhotosPickerItem?) async {
    guard let pickerItem = pickerItem else { return }
    
    do {
      if let data = try await pickerItem.loadTransferable(type: Data.self),
         let image = UIImage(data: data) {
        selectedImage = image
      }
    } catch {
      print("Failed to load image: \(error.localizedDescription)")
    }
  }
}
