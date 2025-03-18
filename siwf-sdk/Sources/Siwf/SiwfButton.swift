import SwiftUI
import Foundation

/// A customizable Sign-In With Frequency (SIWF) button.
///
/// - Parameters:
///   - mode: The visual style of the button (Primary, Dark, Light).
///   - authUrl: The authentication URL that the button triggers.
@available(iOS 15.0, *)
public struct SiwfButton: View {
    let mode: SiwfButtonMode
    let authUrl: URL
    
    @ObservedObject private var siwfCoordinator = Siwf.shared
    @State public var showSafariView: Bool = false
    @State private var buttonStyle: ButtonStyles
    
    public init(
           mode: SiwfButtonMode,
           authUrl: URL
       ) {
           self.mode = mode
           self.authUrl = authUrl
           _buttonStyle = State(initialValue: getButtonStyle(mode: mode, assets: getLocalAssets()))
       }
    
    public var body: some View {
        Button(action: {
            debugPrint("SIWF Button tapped. Opening authentication URL: \(authUrl.absoluteString)")
            self.showSafariView = true
            siwfCoordinator.safariViewActive = true
        }) {
            HStack(spacing: 10) {
                if let logoImage = buttonStyle.logoImage {
                    Image(uiImage: logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 33, height: 33)
                } else {
                    Text("🔄")
                }
                
                Text(buttonStyle.title)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 6)
            .padding(.leading, -6)
            .frame(width: 254)
            .background(buttonStyle.backgroundColor)
            .foregroundColor(buttonStyle.textColor)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(buttonStyle.borderColor, lineWidth: 2)
            )
            .cornerRadius(24)
            .sheet(isPresented: $showSafariView) {
                SafariView(url: authUrl)
            }
        }
        .onAppear {
            Task {
                print("⏳ Fetching SIWF assets...")
                if let remoteAssets = try? await getRemoteAssets() {
                    // If we get remote remote assets, set button styles to latest
                    buttonStyle = getButtonStyle(mode: mode, assets: remoteAssets)
                }
            }
        }
        .onChange(of: siwfCoordinator.safariViewActive) { active in
            if !active && showSafariView {
                debugPrint("❌ SafariView dismissed. Updating state.")
                showSafariView = false
            }
        }
    }
}
