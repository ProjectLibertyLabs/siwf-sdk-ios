//
//  SafariView.swift
//
//
//  Created by Claire Olmstead on 12/9/24.
//

import Foundation
import SwiftUI
import SafariServices

/// A SwiftUI wrapper for SFSafariViewController.
public struct SafariView: UIViewControllerRepresentable {
    let url: URL

    // Create and return an SFSafariViewController instance
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    // No updates needed for this view controller
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
