//
//  ContentView.swift
//  SiwfApp
//
//  Created by Claire Olmstead on 12/6/24.
//

import SwiftUI
import Siwf

struct ContentView: View {
    let exampleRequest = SignedRequest.siwfSignedRequest(
        signature: SiwfRequestedSignature(
            publicKey: SiwfPublicKey(encodedValue: "f6cn3CiVQjDjPFhSzHxZC94TJg3A5MY6QBNJRezgCmSUSjw7R"),
            signature: SiwfSignature(encodedValue: "0x52eec2145b5e2ec092a7592ba0ac669b9a05bed43c9144cdee5b3a9f727fde343888a6eccac6848362f5bd6ea4792a7bf160d07e31e9dcd9600ab4433a4d788b"),
            payload: SiwfPayload(
                callback: "http://localhost:3000/login/callback",
                permissions: [
                    7,
                    8,
                    9,
                    10
                  ]
            )
        ),
        credentials: [
            SiwfRequestedCredential.single(SingleCredential(
                    type: "VerifiedGraphKeyCredential",
                    hash: ["bciqmdvmxd54zve5kifycgsdtoahs5ecf4hal2ts3eexkgocyc5oca2y"]
                )),
            SiwfRequestedCredential.anyOf(AnyOfCredentials(anyOf: [
                    SingleCredential(
                        type: "VerifiedEmailAddressCredential",
                        hash: ["bciqe4qoczhftici4dzfvfbel7fo4h4sr5grco3oovwyk6y4ynf44tsi"]
                    ),
                    SingleCredential(
                        type: "VerifiedPhoneNumberCredential",
                        hash: ["bciqjspnbwpc3wjx4fewcek5daysdjpbf5xjimz5wnu5uj7e3vu2uwnq"]
                    )
                ]))
            ]
    )
    
    var encodedSignedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest:  "eyJyZXF1ZXN0ZWRTaWduYXR1cmVzIjp7InB1YmxpY0tleSI6eyJlbmNvZGVkVmFsdWUiOiJmNmNuM0NpVlFqRGpQRmhTekh4WkM5NFRKZzNBNU1ZNlFCTkpSZXpnQ21TVVNqdzdSIiwiZW5jb2RpbmciOiJiYXNlNTgiLCJmb3JtYXQiOiJzczU4IiwidHlwZSI6IlNyMjU1MTkifSwic2lnbmF0dXJlIjp7ImFsZ28iOiJTUjI1NTE5IiwiZW5jb2RpbmciOiJiYXNlMTYiLCJlbmNvZGVkVmFsdWUiOiIweDUyZWVjMjE0NWI1ZTJlYzA5MmE3NTkyYmEwYWM2NjliOWEwNWJlZDQzYzkxNDRjZGVlNWIzYTlmNzI3ZmRlMzQzODg4YTZlY2NhYzY4NDgzNjJmNWJkNmVhNDc5MmE3YmYxNjBkMDdlMzFlOWRjZDk2MDBhYjQ0MzNhNGQ3ODhiIn0sInBheWxvYWQiOnsiY2FsbGJhY2siOiJodHRwOi8vbG9jYWxob3N0OjMwMDAvbG9naW4vY2FsbGJhY2siLCJwZXJtaXNzaW9ucyI6WzcsOCw5LDEwXX19LCJyZXF1ZXN0ZWRDcmVkZW50aWFscyI6W3sidHlwZSI6IlZlcmlmaWVkR3JhcGhLZXlDcmVkZW50aWFsIiwiaGFzaCI6WyJiY2lxbWR2bXhkNTR6dmU1a2lmeWNnc2R0b2FoczVlY2Y0aGFsMnRzM2VleGtnb2N5YzVvY2EyeSJdfSx7ImFueU9mIjpbeyJ0eXBlIjoiVmVyaWZpZWRFbWFpbEFkZHJlc3NDcmVkZW50aWFsIiwiaGFzaCI6WyJiY2lxZTRxb2N6aGZ0aWNpNGR6ZnZmYmVsN2ZvNGg0c3I1Z3JjbzNvb3Z3eWs2eTR5bmY0NHRzaSJdfSx7InR5cGUiOiJWZXJpZmllZFBob25lTnVtYmVyQ3JlZGVudGlhbCIsImhhc2giOlsiYmNpcWpzcG5id3BjM3dqeDRmZXdjZWs1ZGF5c2RqcGJmNXhqaW16NXdudTV1ajdlM3Z1MnV3bnEiXX1dfV0sImFwcGxpY2F0aW9uQ29udGV4dCI6eyJ1cmwiOiJodHRwOi8vbG9jYWxob3N0OjMwMDAvYXBwLWNvbnRleHQuanNvbiJ9fQ")
    
    
    var authData: GenerateAuthData {
        GenerateAuthData(
            signedRequest: encodedSignedRequest,
            additionalCallbackUrlParams: [:],
            options: SiwfOptions(
                endpoint: "testnet"
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary color mode with pre-encoded request
            Siwf.createSignInButton(authData: authData)
            
            // Dark color mode
            Siwf.createSignInButton(mode: .dark, authData: authData)
            
            // Light color mode
            Siwf.createSignInButton(mode: .light, authData: authData)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
