import SwiftUI
import Foundation

@available(macOS 10.15, *)
@available(iOS 15.0, *)
public struct LiwlButton: View {
    var style: LiwlButtonStyle
    var title: String
    var handleAction: () -> Void
    
    @Binding var url: URL?
    @Binding var showSafariView: Bool

    public init(style: LiwlButtonStyle = .normal, title: String = "Log In With Liberty", handleAction: @escaping () -> Void, url: Binding<URL?>, showSafariView: Binding<Bool>) {
        self.style = style
        self.title = title
        self.handleAction = handleAction
        self._url = url
        self._showSafariView = showSafariView
    }
    
    func styledButton(backgroundColor: Color, textColor: Color, borderColor: Color, logo: String) -> some View {
        Button(action: { Task { await handleAction() } }) {
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
                if let authUrl = url {
                    #if os(iOS)
                        SafariView(url: authUrl)
                    #elseif os(macOS)
                        NSWorkspace.shared.open(authUrl)
                    #endif
                }
            }
        }
    }
    
    public var body: some View {
        switch style {
        case .normal:
            styledButton(backgroundColor: Color("frequencyTeal"), textColor: .black, borderColor: Color("frequencyTeal"), logo: "frequencyLogo")
        case .dark:
            styledButton(backgroundColor: .black, textColor: .white, borderColor: .black, logo: "frequencyLogoLight")
        case .light:
            styledButton(backgroundColor: .white, textColor: .black, borderColor: .black, logo: "frequencyLogoDark")
        }
    }
}
