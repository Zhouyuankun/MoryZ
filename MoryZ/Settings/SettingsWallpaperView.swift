//
//  SettingsWallpaperView.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/9.
//

import SwiftUI

struct SettingsWallpaperView: View {
    @AppStorage("wallpaperLightURL") var wallpaperLightURL: URL?
    @AppStorage("wallpaperDarkURL") var wallpaperDarkURL: URL?
    @State var selectedLightPhoto: UIImage
    @State var selectedDarkPhoto: UIImage
    @State var showLight = false
    @State var showDark = false
    
    
    var body: some View {
        VStack {
            Label("Tap label to change", systemImage: "hand.tap")
                .font(.title)
                .padding(.vertical)
            Text("you may need a few minutes to save the photo in background")
                .font(.caption2)
                .foregroundColor(.secondary)
            HStack {
                VStack {
                    HStack {
                        Image(systemName: "sun.max")
                        Text("Light Wallpaper")
                    }
                    .padding()
                    .background(Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        showLight = true
                    }
                    .popover(isPresented: $showLight) {
                        ImagePicker(selectedImage: $selectedLightPhoto)
                        
                        
                    }
                    .onChange(of: selectedLightPhoto, perform: { newValue in
                        wallpaperLightURL = saveImageToDirectoryReturnURL(newValue, name: "day")
                        //selectedLightPhoto = newValue
                    })
                    
                    Image(uiImage:selectedLightPhoto)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 3)
                        .clipped()
                        
                        
                }
                VStack {
                    HStack {
                        Image(systemName: "moon")
                        Text("Dark Wallpaper")
                    }
                    .padding()
                    .background(Color.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        showDark = true
                    }
                    .popover(isPresented: $showDark) {
                        ImagePicker(selectedImage: $selectedDarkPhoto)
                    }
                    .onChange(of: selectedDarkPhoto, perform: { newValue in
                        wallpaperDarkURL = saveImageToDirectoryReturnURL(newValue, name: "night")
                    })
                    
                    Image(uiImage:selectedDarkPhoto)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 3)
                        .clipped()
                        
                }
            }
        }
        .onAppear {
            if let wallpaperLightURL = wallpaperLightURL {
                let data = try! Data(contentsOf: wallpaperLightURL)
                selectedLightPhoto = UIImage(data: data)!
            } else {
                selectedLightPhoto = UIImage(named: "day")!
            }
            if let wallpaperDarkURL = wallpaperDarkURL {
                let data = try! Data(contentsOf: wallpaperDarkURL)
                selectedDarkPhoto = UIImage(data: data)!
            } else {
                selectedDarkPhoto = UIImage(named: "night")!
            }
            

            //if let lightData = Data
//            selectedLightPhoto = UIImage(data: Data(contentsOf: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("day")))
//            selectedDarkPhoto = UIImage(data: Data(contentsOf: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("night")))
        }
    }
    
    func saveImageToDirectoryReturnURL(_ image: UIImage, name: String) -> URL? {
        do {
            let pngData = image.pngData()!
            let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name)
            try pngData.write(to: storeURL)
            return storeURL
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}

struct SettingsWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWallpaperView(selectedLightPhoto: UIImage(named: "day")!, selectedDarkPhoto: UIImage(named: "night")!).environment(\.locale, .init(identifier: "cn"))
    }
}

extension UIImage {
    var fixedOrientation: UIImage {
        guard imageOrientation != .up else { return self }
        
        var transform: CGAffineTransform = .identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform
                .translatedBy(x: size.width, y: size.height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform
                .translatedBy(x: size.width, y: 0).rotated(by: .pi)
        case .right, .rightMirrored:
            transform = transform
                .translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
        case .upMirrored:
            transform = transform
                .translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        guard
            let cgImage = cgImage,
            let colorSpace = cgImage.colorSpace,
            let context = CGContext(
                data: nil, width: Int(size.width), height: Int(size.height),
                bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue
            )
        else { return self }
        context.concatenate(transform)
        
        var rect: CGRect
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
        default:
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        
        context.draw(cgImage, in: rect)
        return context.makeImage().map { UIImage(cgImage: $0) } ?? self
    }
}
