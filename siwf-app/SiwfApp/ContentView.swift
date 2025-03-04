//
//  ContentView.swift
//  SiwfApp
//
//  Created by Claire Olmstead on 12/6/24.
//

import SwiftUI
import Siwf

struct ContentView: View {
    let exampleRequest = SiwfSignedRequest(
        requestedSignatures: SiwfRequestedSignature(
            publicKey: SiwfPublicKey(encodedValue: "examplePublicKey"),
            signature: SiwfSignature(encodedValue: "exampleEncodedSignature"),
            payload: SiwfPayload(
                callback: "https://www.google.com",
                permissions: [1, 2, 3]
            )
        )
    )
    
    var authData: GenerateAuthData {
        GenerateAuthData(
            signedRequest: exampleRequest,
            additionalCallbackUrlParams: [:],
            options: nil
        )
    }
    
    var authEncodedRequest: String = "eyJyZXF1ZXN0ZWRTaWduYXR1cmVzIjp7InB1YmxpY0tleSI6eyJlbmNvZGVkVmFsdWUiOiJmNmJNRVh2ZDZkaHNuM0R1c2V3OGhmUm5Dc0ZlaEpMQzhkTkZpQWpHNEhoeTNFZVd6IiwiZW5jb2RpbmciOiJiYXNlNTgiLCJmb3JtYXQiOiJzczU4IiwidHlwZSI6IlNyMjU1MTkifSwic2lnbmF0dXJlIjp7ImFsZ28iOiJTUjI1NTE5IiwiZW5jb2RpbmciOiJiYXNlMTYiLCJlbmNvZGVkVmFsdWUiOiIweDNjZGJkNGZhY2ZmMmQ3MDIzNzBjNmI5OWMwOGU2MDhhM2YwNGU4MzI4MzdhMmE1NjA3YjRkOTc4ZjJjZjZiNGRmNDJjY2E0MmJjMTc0NzViNTJkY2JkZDViMGIyOGIxOTE4OGNhMzViMzQ0N2U1MmViNjg5MTcyNDY4MzEwZDg2In0sInBheWxvYWQiOnsiY2FsbGJhY2siOiJodHRwczovL2V4YW1wbGUuY29tIiwicGVybWlzc2lvbnMiOls3LDgsOSwxMF19fSwicmVxdWVzdGVkQ3JlZGVudGlhbHMiOlt7ImFueU9mIjpbeyJ0eXBlIjoiVmVyaWZpZWRFbWFpbEFkZHJlc3NDcmVkZW50aWFsIiwiaGFzaCI6WyJiY2lxZTRxb2N6aGZ0aWNpNGR6ZnZmYmVsN2ZvNGg0c3I1Z3JjbzNvb3Z3eWs2eTR5bmY0NHRzaSJdfSx7InR5cGUiOiJWZXJpZmllZFBob25lTnVtYmVyQ3JlZGVudGlhbCIsImhhc2giOlsiYmNpcWpzcG5id3BjM3dqeDRmZXdjZWs1ZGF5c2RqcGJmNXhqaW16NXdudTV1ajdlM3Z1MnV3bnEiXX1dfSx7InR5cGUiOiJWZXJpZmllZEdyYXBoS2V5Q3JlZGVudGlhbCIsImhhc2giOlsiYmNpcW1kdm14ZDU0enZlNWtpZnljZ3NkdG9haHM1ZWNmNGhhbDJ0czNlZXhrZ29jeWM1b2NhMnkiXX1dLCJhcHBsaWNhdGlvbkNvbnRleHQiOnsidXJsIjoiaHR0cHM6Ly9leGFtcGxlLmNvbS9jb250ZXh0Lmpzb24ifX0"
    
    var body: some View {
        Siwf.createSignInButton(mode: .primary, authEncodedRequest: authEncodedRequest)
        Siwf.createSignInButton(mode: .dark, authData: authData)
        Siwf.createSignInButton(mode: .light, authData: authData)
    }
}

#Preview {
    ContentView()
}
