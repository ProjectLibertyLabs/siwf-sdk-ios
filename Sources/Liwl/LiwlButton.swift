import SwiftUI
import Foundation

@available(macOS 10.15, *)
@available(iOS 15.0, *)
public struct LiwlButton: View {
    var mode: LiwlButtonMode
    var title: String
    var handleAction: () -> Void
    var authUrl: URL?
    
    @State public var showSafariView: Bool = false
    
    public init(
        mode: LiwlButtonMode = .normal,
        title: String = "Sign In With Frequency",
        authUrl: URL?,
        handleAction: @escaping () -> Void
    ) {
        self.mode = mode
        self.title = title
        self.authUrl = authUrl
        self.handleAction = handleAction
    }
        
    func styledButton(backgroundColor: Color, textColor: Color, borderColor: Color, logo: String) -> some View {
        Button(action: {
            Task { await handleAction() }
            
            self.showSafariView = true
        }) {
            HStack(spacing: 10) {
                Image(logo)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 33, height: 33)
                
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
                if let url = authUrl {
                    #if os(iOS)
                        SafariView(url: url)
                    #elseif os(macOS)
                        NSWorkspace.shared.open(url)
                    #endif
                }
            }
        }
    }
    
    public var body: some View {
        switch mode {
        case .normal:
            styledButton(backgroundColor: Color("frequencyTeal"), textColor: .black, borderColor: Color("frequencyTeal"), logo: "frequencyLogo")
        case .dark:
            styledButton(backgroundColor: .black, textColor: .white, borderColor: .black, logo: "frequencyLogoLight")
        case .light:
            styledButton(backgroundColor: .white, textColor: .black, borderColor: .black, logo: "frequencyLogoDark")
        }
    }
}
