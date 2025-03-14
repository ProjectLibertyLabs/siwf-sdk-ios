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
    let authUrl: URL?
    
    
    @State private var buttonStyle1 = getButtonStyle(mode: SiwfButtonMode.primary, assets: getLocalAssets())

    var body: some View {
        Button(action: openAuthUrl) {
            HStack(spacing: 10) {
                if let logo = buttonStyle.logoImage {
                    Image(uiImage: logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 33, height: 33)
                } else {
                    Text("🔄")
                        .font(.system(size: 24))
                }
                Text(buttonStyle.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(uiColor: buttonStyle.textColor))
            }
            .padding()
            .frame(height: 50)
            .background(Color(uiColor: buttonStyle.backgroundColor))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(uiColor: buttonStyle.borderColor), lineWidth: 2)
            )
        }
        .padding(8)
        .disabled(authUrl == nil || authUrl?.absoluteString.isEmpty == true)
        .task {
            print("⏳ Fetching SIWF assets...")
            if let assets = await getRemoteAssets() {
                buttonStyle = getButtonStyle(mode: mode, assets: assets)
            }
        }
    }

    /// Opens the authentication URL in the default browser.
    private func openAuthUrl() {
        guard let url = authUrl else { return }
        print("🔗 Opening authentication URL: \(url)")
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("❌ Error opening authentication URL.")
        }
    }
}
