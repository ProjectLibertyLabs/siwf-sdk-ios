//
//  ContentView.swift
//  SiwfApp
//
//  Created by Claire Olmstead on 12/6/24.
//

import SwiftUI
import Siwf

/**
 * AuthScreen - Displays sign-in buttons
 *
 * Includes examples of Signed Requests and Encoded Signed Requests
 */
struct ContentView: View {
    // Example signed request with public key, signature, and callback URL
    let signedRequest = SignedRequest.siwfSignedRequest(
        requestedSignatures: SiwfRequestedSignature(
            publicKey: SiwfPublicKey(encodedValue: "f6cn3CiVQjDjPFhSzHxZC94TJg3A5MY6QBNJRezgCmSUSjw7R"),
            signature: SiwfSignature(encodedValue: "0xceb09d9c50b66edfd4fea0ec2515754857b500ba1af4725318cc1a7fc15aef08e8df2c8a1560683f3bce0630aaee159648a305f452de751978a47da568235e83"),
            payload: SiwfPayload(
                callback: "siwfdemoapp://login",
                permissions: [
                    7,
                    8,
                    9,
                    10
                  ]
            )
        ),
        requestedCredentials: [
            // Graph Key Credential (Required)
            SiwfRequestedCredential.single(SingleCredential(
                    type: "VerifiedGraphKeyCredential",
                    hash: ["bciqmdvmxd54zve5kifycgsdtoahs5ecf4hal2ts3eexkgocyc5oca2y"]
                )),
            // AnyOfRequired - The user must provide at least one of these credentials
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
    
    // Alternative: Encoded signed request version
    var encodedSignedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest:  "eyJyZXF1ZXN0ZWRTaWduYXR1cmVzIjp7InB1YmxpY0tleSI6eyJlbmNvZGVkVmFsdWUiOiJmNmNuM0NpVlFqRGpQRmhTekh4WkM5NFRKZzNBNU1ZNlFCTkpSZXpnQ21TVVNqdzdSIiwiZW5jb2RpbmciOiJiYXNlNTgiLCJmb3JtYXQiOiJzczU4IiwidHlwZSI6IlNyMjU1MTkifSwic2lnbmF0dXJlIjp7ImFsZ28iOiJTUjI1NTE5IiwiZW5jb2RpbmciOiJiYXNlMTYiLCJlbmNvZGVkVmFsdWUiOiIweGNlYjA5ZDljNTBiNjZlZGZkNGZlYTBlYzI1MTU3NTQ4NTdiNTAwYmExYWY0NzI1MzE4Y2MxYTdmYzE1YWVmMDhlOGRmMmM4YTE1NjA2ODNmM2JjZTA2MzBhYWVlMTU5NjQ4YTMwNWY0NTJkZTc1MTk3OGE0N2RhNTY4MjM1ZTgzIn0sInBheWxvYWQiOnsiY2FsbGJhY2siOiJzaXdmZGVtb2FwcDovL2xvZ2luIiwicGVybWlzc2lvbnMiOls3LDgsOSwxMF19fSwicmVxdWVzdGVkQ3JlZGVudGlhbHMiOlt7InR5cGUiOiJWZXJpZmllZEdyYXBoS2V5Q3JlZGVudGlhbCIsImhhc2giOlsiYmNpcW1kdm14ZDU0enZlNWtpZnljZ3NkdG9haHM1ZWNmNGhhbDJ0czNlZXhrZ29jeWM1b2NhMnkiXX0seyJhbnlPZiI6W3sidHlwZSI6IlZlcmlmaWVkRW1haWxBZGRyZXNzQ3JlZGVudGlhbCIsImhhc2giOlsiYmNpcWU0cW9jemhmdGljaTRkemZ2ZmJlbDdmbzRoNHNyNWdyY28zb292d3lrNnk0eW5mNDR0c2kiXX0seyJ0eXBlIjoiVmVyaWZpZWRQaG9uZU51bWJlckNyZWRlbnRpYWwiLCJoYXNoIjpbImJjaXFqc3BuYndwYzN3ang0ZmV3Y2VrNWRheXNkanBiZjV4amltejV3bnU1dWo3ZTN2dTJ1d25xIl19XX1dfQ")
    
    
    var authRequest: GenerateAuthRequest {
        GenerateAuthRequest(
            signedRequest: signedRequest, // Switch to encodedSignedRequest if needed
            additionalCallbackUrlParams: [:],
            options: Options(
                endpoint: "testnet" // Switch to "mainnet" if needed
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary Sign-In Button (Default)
            Siwf.createSignInButton(authRequest: authRequest)
            
            // Dark-themed Sign-In Button
            Siwf.createSignInButton(mode: .dark, authRequest: authRequest)
            
            // Light-themed Sign-In Button (Uses non-encoded request)
            Siwf.createSignInButton(mode: .light, authRequest: authRequest)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
