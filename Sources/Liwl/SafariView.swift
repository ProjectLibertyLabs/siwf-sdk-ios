#if os(iOS) // Only compile for iOS

import SwiftUI
import SafariServices

public struct SafariView: UIViewControllerRepresentable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    @available(iOS 13.0, *)  // Ensures it only compiles on iOS
    public func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    @available(iOS 13.0, *)
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

#endif // End of iOS-only check
