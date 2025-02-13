import SwiftUI
import Foundation

@available(macOS 10.15, *)
@available(iOS 15.0, *)
public struct LiwlButton2: View {
    
    // MARK: - PROPERTIES
    @State private var showSafariView = false
    @State private var signedRequest: SiwfSignedRequest

    // logo, colors, text all pulled in dynamically (user only chooses light/dark/normal)
//    private let logo: UIImageAsset
    private let style: LiwlButtonStyle
    private let titleKey: String
    private let authUrl: URL

    // MARK: - INITIALIZER
    
    /// - Parameters:
    ///   - style: The style of the button (affects text and background colors).
    ///   - url: The website URL to open on click.
    public init(style: LiwlButtonStyle = .normal, signedRequest: SiwfSignedRequest, titleKey: String = "Sign in with Frequency") {
        self.style = style
        self.titleKey = titleKey
        self.authUrl = URL(string: generateAuthenticationUrl(signedRequest: signedRequest, additionalCallbackUrlParams: [:], options: nil)!)!
    }
    
    // MARK: - VIEW BODY
    
    public var body: some View {
        switch style {
        case .normal:
            if #available(iOS 16.0, *) {
                styledButton(backgroundColor: Color("frequencyTeal"), textColor: Color.black, borderColor: Color("frequencyTeal"), logo: "frequencyLogo")
            }
        case .dark:
            if #available(iOS 16.0, *) {
                styledButton(backgroundColor: Color.black, textColor: Color.white, borderColor: Color.black, logo: "frequencyLogoLight")
            }
        case .light:
                if #available(iOS 16.0, *) {
                    styledButton(backgroundColor: Color.white, textColor: Color.black, borderColor: Color.black, logo: "frequencyLogoDark")
                }
        }
    }
}

// MARK: - FILE PRIVATE

fileprivate extension LiwlButton2 {
    func styledButton(backgroundColor: Color, textColor: Color, borderColor: Color, logo: String) -> some View {
        return Button(action: {Task { await handleAction() }}) {
            HStack(spacing: 10) {
                Image(logo)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 33, height: 33)
                
                Text(titleKey)
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
        }
        .sheet(isPresented: $showSafariView) {
            if let url = self.authUrl {
                #if os(iOS)
                    SafariView(url: url)
                #elseif os(macOS)
                    VStack {
                        Text("Opening browser...")
                            .onAppear {
                                NSWorkspace.shared.open(url)
                            }
                    }
                #endif
            } else {
                Text("Invalid URL")
            }
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    func parseLiwlResponse(from data: Data) -> LiwlResponse? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(LiwlResponse.self, from: data)
            return response
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    func handleAction () async {
        await setRedirectUrl()
        self.showSafariView = true
    }
    
    func setRedirectUrl() async {
        print("START: \(authUrl as Any)")
        if (authUrl == nil) {
            let urlString = "http://localhost:3013/v2/accounts/siwf?credentials=VerifiedGraphKeyCredential&credentials=VerifiedEmailAddressCredential&credentials=VerifiedPhoneNumberCredential&permissions=dsnp.broadcast%40v2&permissions=dsnp.private-follows%40v1&permissions=dsnp.reply%40v2&permissions=dsnp.reaction%40v1&permissions=dsnp.tombstone%40v2&permissions=dsnp.update%40v2&permissions=frequency.default-token-address%40v1&callbackUrl=http%3A%2F%2Flocalhost%3A3000%2Flogin%2Fcallback"
            
            do {
                let url = URL(string: urlString)
                let (data, _) = try await URLSession.shared.data(from: url!)
                
                // Parse the JSON response
                if let liwlResponse = parseLiwlResponse(from: data) {
                    print("********************** liwlResponse.signedRequest: \(liwlResponse.signedRequest)")
                    print("********************** liwlResponse.redirectUrl: \(liwlResponse.redirectUrl)")
                    print("********************** liwlResponse.frequencyRpcUrl: \(liwlResponse.frequencyRpcUrl)")
                    
                    DispatchQueue.main.async {
                        if let url = URL(string: liwlResponse.redirectUrl) {
                            self.redirectUrl = url
                        } else {
                            print("Invalid redirect URL")
                        }
                    }
                } else {
                    print("Failed to parse the response")
                }
            } catch {
                print("Error fetching LIWL callback: \(error)")
            }
        }
    }
}
