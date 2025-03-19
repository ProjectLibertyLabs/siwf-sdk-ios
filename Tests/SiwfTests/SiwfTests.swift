import XCTest
@testable import Siwf

final class SiwfTests: XCTestCase {
    
    private func createSampleSiwfRequestedSignature() -> SiwfRequestedSignature {
        let publicKey = SiwfPublicKey(encodedValue: "testPublicKey123")
        let signature = SiwfSignature(encodedValue: "testSignature456")
        let payload = SiwfPayload(callback: "https://example.com/callback", permissions: [1, 2, 3])
        
        return SiwfRequestedSignature(publicKey: publicKey, signature: signature, payload: payload)
    }
    
    private func createSampleRequestedCredential() -> SiwfRequestedCredential {
        .single(SingleCredential(type: "test-credential", hash: ["abc123", "def456"]))
    }
    
    // MARK: - Test Cases
    
    func testGenerateAuthUrlWithEncodedSignedRequest() {
        // Arrange
        let encodedRequestString = "encodedTestRequest123"
        let signedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest: encodedRequestString)
        let options = Options(endpoint: "mainnet")
        let authRequest = GenerateAuthRequest(
            signedRequest: signedRequest,
            additionalCallbackUrlParams: ["param1": "value1", "param2": "value2"],
            options: options
        )
        
        // Act
        let url = generateAuthUrl(authRequest: authRequest)
        
        // Assert
        XCTAssertTrue(url.absoluteString.contains("https://www.frequencyaccess.com/siwa/start"))
        XCTAssertTrue(url.absoluteString.contains("param1=value1"))
        XCTAssertTrue(url.absoluteString.contains("param2=value2"))
        XCTAssertTrue(url.absoluteString.contains("signedRequest=encodedTestRequest123"))
    }
    
    func testGenerateAuthUrlWithSiwfSignedRequest() {
        // Arrange
        let requestedSignature = createSampleSiwfRequestedSignature()
        let requestedCredentials = [createSampleRequestedCredential()]
        let signedRequest = SignedRequest.siwfSignedRequest(
            requestedSignatures: requestedSignature,
            requestedCredentials: requestedCredentials
        )
        let options = Options(endpoint: "mainnet")
        let authRequest = GenerateAuthRequest(
            signedRequest: signedRequest,
            additionalCallbackUrlParams: nil,
            options: options
        )
        
        // Act
        let url = generateAuthUrl(authRequest: authRequest)
        
        // Assert
        XCTAssertTrue(url.absoluteString.contains("https://www.frequencyaccess.com/siwa/start"))
        XCTAssertTrue(url.absoluteString.contains("signedRequest="))
        // We can't easily test the exact encoded value since it involves JSON encoding
    }
    
    func testGenerateAuthUrlWithTestnetEnvironment() {
        // Arrange
        let signedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest: "testRequest")
        let options = Options(endpoint: "testnet")
        let authRequest = GenerateAuthRequest(
            signedRequest: signedRequest,
            additionalCallbackUrlParams: nil,
            options: options
        )
        
        // Act
        let url = generateAuthUrl(authRequest: authRequest)
        
        // Assert
        XCTAssertTrue(url.absoluteString.contains("https://testnet.frequencyaccess.com/siwa/start"))
    }
    
    func testGenerateAuthUrlWithCustomEnvironment() {
        // Arrange
        let signedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest: "testRequest")
        let options = Options(endpoint: "https://custom.example.com")
        let authRequest = GenerateAuthRequest(
            signedRequest: signedRequest,
            additionalCallbackUrlParams: nil,
            options: options
        )
        
        // Act
        let url = generateAuthUrl(authRequest: authRequest)
        
        // Assert
        XCTAssertTrue(url.absoluteString.contains("https://custom.example.com/start"))
    }
    
    func testGenerateAuthUrlFiltersReservedParams() {
        // Arrange
        let signedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest: "testRequest")
        let options = Options(endpoint: "mainnet")
        let authRequest = GenerateAuthRequest(
            signedRequest: signedRequest,
            additionalCallbackUrlParams: [
                "validParam": "validValue",
                "signedRequest": "shouldBeFiltered",
                "authorizationCode": "shouldAlsoBeFiltered"
            ],
            options: options
        )
        
        // Act
        let url = generateAuthUrl(authRequest: authRequest)
        
        // Assert
        XCTAssertTrue(url.absoluteString.contains("validParam=validValue"))
        XCTAssertFalse(url.absoluteString.contains("signedRequest=shouldBeFiltered"))
        XCTAssertFalse(url.absoluteString.contains("authorizationCode=shouldAlsoBeFiltered"))
        XCTAssertTrue(url.absoluteString.contains("signedRequest=testRequest"))
    }
    
    func testGenerateAuthUrlWithNoOptions() {
        // Arrange
        let signedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest: "testRequest")
        let authRequest = GenerateAuthRequest(
            signedRequest: signedRequest,
            additionalCallbackUrlParams: nil,
            options: nil
        )
        
        // Act
        let url = generateAuthUrl(authRequest: authRequest)
        
        // Assert
        // Should default to mainnet
        XCTAssertTrue(url.absoluteString.contains("https://www.frequencyaccess.com/siwa/start"))
    }

    func testGenerateAuthUrlWithSpecialCharactersInParams() {
        // Arrange
        let signedRequest = SignedRequest.siwfEncodedSignedRequest(encodedSignedRequest: "testRequest")
        let options = Options(endpoint: "mainnet")
        let authRequest = GenerateAuthRequest(
            signedRequest: signedRequest,
            additionalCallbackUrlParams: ["special": "value with spaces & symbols!"],
            options: options
        )
        
        // Act
        let url = generateAuthUrl(authRequest: authRequest)
        
        // Assert
        XCTAssertTrue(url.absoluteString.contains("special="))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let specialParam = components?.queryItems?.first(where: { $0.name == "special" })
        XCTAssertEqual(specialParam?.value, "value with spaces & symbols!")
    }
}
