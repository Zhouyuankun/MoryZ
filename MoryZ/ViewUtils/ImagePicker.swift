//
//  ImagePicker.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/10.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImagePicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) private var presentationMode // allows you to dismiss the image picker overlay
  @Binding var selectedImage: UIImage // selected image binding
  var sourceType = UIImagePickerController.SourceType.photoLibrary

  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.navigationBar.tintColor = .clear
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator
    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController,
                              context: UIViewControllerRepresentableContext<ImagePicker>) { }

  func makeCoordinator() -> Coordinator {
      Coordinator(self)
  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let control: ImagePicker

    init(_ control: ImagePicker) {
      self.control = control
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
          control.selectedImage = image.fixedOrientation
      }
      control.presentationMode.wrappedValue.dismiss()
    }
  }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode

    var documentTypes: [UTType] // [kUTTypeFolder as String]
    var onDocumentsPicked: (_: URL) -> ()

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        controller = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        controller.allowsMultipleSelection = false
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {

    }

    func makeCoordinator() -> DocumentPickerCoordinator {
        DocumentPickerCoordinator(self)
    }

    class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        let control: DocumentPicker

        init(_ control: DocumentPicker) {
          self.control = control
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let url = urls.first!
            guard url.startAccessingSecurityScopedResource() else {
                    // Handle the failure here.
                    return
                }

                // Make sure you release the security-scoped resource when you finish.
                defer { url.stopAccessingSecurityScopedResource() }
            
            control.onDocumentsPicked(url)
            control.presentationMode.wrappedValue.dismiss()
        }

        
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var animate: Bool
    var style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        animate ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct TextFieldAlert: UIViewControllerRepresentable {
    var onTextSubmited: (_: String) -> ()

    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIAlertController {
        let controller: UIAlertController
        controller = UIAlertController(title: "Title", message: "The title of this diary", preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let field = controller.textFields?.first, let text = field.text, !text.isEmpty else {
                print("hehe")
                return
            }
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            onTextSubmited(trimmedText)
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return controller
    }

    func updateUIViewController(_ uiViewController: UIAlertController, context: UIViewControllerRepresentableContext<TextFieldAlert>) {

    }

}


