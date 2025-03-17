#if os(iOS) // Only compile for iOS

import SwiftUI
import SafariServices

/// A SwiftUI wrapper for `SFSafariViewController`, allowing web content to be displayed within the app.
/// This is used for the authentication flow, opening web pages securely.
///
/// - Note: This is only available on iOS.
/// - Parameters:
///   - url: The URL to be loaded in the Safari view.
public struct SafariView: UIViewControllerRepresentable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    @available(iOS 13.0, *)
    public func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    @available(iOS 13.0, *)
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

#endif
