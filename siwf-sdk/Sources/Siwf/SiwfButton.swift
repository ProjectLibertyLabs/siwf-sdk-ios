import SwiftUI
import Foundation
import Models
import Helpers

@available(macOS 10.15, *)
@available(iOS 15.0, *)
public struct SiwfButton: View {
    var mode: SiwfButtonMode
    var authUrl: URL
    
    @State private var title: String = ""
    @State private var backgroundColor: Color = Color(.systemGray)
    @State private var textColor: Color = Color(.white)
    @State private var borderColor: Color = Color(.systemGray)
    @State private var logoImage: UIImage? = nil
    @State public var showSafariView: Bool = false
    
    public init(
        mode: SiwfButtonMode = .primary,
        authUrl: URL
    ) {
        self.mode = mode
        self.authUrl = authUrl
    }
    
    private func fetchAssets() {
        let urlString = "https://projectlibertylabs.github.io/siwf/v2/assets/assets.json"
        
        guard let url = URL(string: urlString) else {
            fatalError("Failed to parse URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
//                TODO: fallback to built in assets
                fatalError("Error fetching assets: \(error)")
            }
            
            guard let data = data else {
                fatalError("No data received")
//                TODO: fallback to built in assets
            }
            
            do {
                let decoder = JSONDecoder()
                let assets = try decoder.decode(Assets.self, from: data)
            
                DispatchQueue.main.async {

                    self.title = assets.content.title
                    
                    switch self.mode {
                    case .primary:
                        self.backgroundColor = Color(hex: assets.colors.primary)
                        self.textColor = Color(hex: assets.colors.light)
                        self.borderColor = Color(hex: assets.colors.primary)
                        if let imageData = Data(base64Encoded: assets.images.logoPrimary),
                           let uiImage = UIImage(data: imageData) {
                            self.logoImage = uiImage
                        }
                        
                    case .dark:
                        self.backgroundColor = Color(hex: assets.colors.dark)
                        self.textColor = Color(hex: assets.colors.light)
                        self.borderColor = Color(hex: assets.colors.dark)
                        if let imageData = Data(base64Encoded: assets.images.logoLight),
                           let uiImage = UIImage(data: imageData) {
                            self.logoImage = uiImage
                        }
                        
                    case .light:
                        self.backgroundColor = Color(hex: assets.colors.light)
                        self.textColor = Color(hex: assets.colors.dark)
                        self.borderColor = Color(hex: assets.colors.dark)
                        if let imageData = Data(base64Encoded: assets.images.logoDark),
                           let uiImage = UIImage(data: imageData) {
                            self.logoImage = uiImage
                        }
                    }
                }
            } catch {
//                TODO: fallback to built in assets
                fatalError("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    public var body: some View {
        Button(action: {
            self.showSafariView = true
        }) {
            HStack(spacing: 10) {
                if let logoImage = logoImage {
                    Image(uiImage: logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 33, height: 33)
                } else {
                    Text("🔄")
                }
                
                Text(title)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 6)
            .padding(.leading, -6)
            .frame(width: 254)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(24)
            .sheet(isPresented: $showSafariView) {
                #if os(iOS)
                    SafariView(url: authUrl)
                #elseif os(macOS)
                    NSWorkspace.shared.open(authUrl)
                #endif
            }
        }
        .onAppear {
            fetchAssets()
        }
    }
}

