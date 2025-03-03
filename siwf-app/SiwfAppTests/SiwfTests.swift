import XCTest

@testable import Liwl

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

let exampleEncodedSignedRequest = encodeSignedRequest(exampleRequest)

func createRequestUrl(urlBase: String) -> String {
    guard let exampleEncodedSignedRequest = exampleEncodedSignedRequest else {
        return ""
    }
    return urlBase + exampleEncodedSignedRequest
}

func decodeSignedRequest(encodedSignedRequest: String) -> SiwfSignedRequest? {
    do {
        let serialized = try stringFromBase64URL(encodedSignedRequest) // Ensure decoding works
        guard let jsonData = serialized.data(using: .utf8) else {
            return nil
        }
        let jsonObject = try JSONDecoder().decode(SiwfSignedRequest.self, from: jsonData)
        return jsonObject
    } catch {
        print("Error decoding signed request: \(error)")
        return nil
    }
}

func parseRequestUrl(url: String) -> (String, SiwfSignedRequest?) {
    let components = url.split(separator: "signedRequest=").map(String.init)
    guard components.count > 1 else {
        return (components[0], nil)
    }
    return (components[0], decodeSignedRequest(encodedSignedRequest: components[1]))
}

final class GenerateAuthenticationUrlTests: XCTestCase {
    func testGeneratesUrlWithFakeSignedRequestAndNoAdditionalParams() {
        guard let result = generateAuthenticationUrl(signedRequest: exampleRequest, additionalCallbackUrlParams: [:], options: nil) else {
                XCTFail("generateAuthenticationUrl returned nil")
                return
            }
        let expectedResultUrlBase: String = "https://www.frequencyaccess.com/siwa/start?"
        let parsedResult = parseRequestUrl(url: result)
        let resultUrlBase: String = parsedResult.0
        let resultDecodedRequest: SiwfSignedRequest? = parsedResult.1

        XCTAssertEqual(resultUrlBase, expectedResultUrlBase)
        XCTAssertEqual(resultDecodedRequest, exampleRequest)
    }
    
    func testGeneratesUrlWithFakeSignedRequestAndAdditionalParams() {
        guard let result = generateAuthenticationUrl(signedRequest: exampleRequest, additionalCallbackUrlParams: ["abc": "123"], options: nil) else {
                XCTFail("generateAuthenticationUrl returned nil")
                return
            }
        let expectedResultUrlBase: String = "https://www.frequencyaccess.com/siwa/start?abc=123&"
        let parsedResult = parseRequestUrl(url: result)
        let resultUrlBase: String = parsedResult.0
        let resultDecodedRequest: SiwfSignedRequest? = parsedResult.1

        XCTAssertEqual(resultUrlBase, expectedResultUrlBase)
        XCTAssertEqual(resultDecodedRequest, exampleRequest)
    }

    func testGeneratesUrlWhenAdditionalParamsTriesToOverrideSignedRequest() {
        guard let result = generateAuthenticationUrl(
            signedRequest: exampleRequest,
            additionalCallbackUrlParams: ["signedRequest": "123", "abc": "123"],
            options: nil
        ) else {
            XCTFail("generateAuthenticationUrl returned nil")
            return
        }
    
        let expectedResultUrlBase: String = "https://www.frequencyaccess.com/siwa/start?abc=123&"
        let parsedResult = parseRequestUrl(url: result)
        let resultUrlBase: String = parsedResult.0
        let resultDecodedRequest: SiwfSignedRequest? = parsedResult.1

        XCTAssertEqual(resultUrlBase, expectedResultUrlBase)
        XCTAssertEqual(resultDecodedRequest, exampleRequest)
    }

    func testGeneratesUrlWhenAdditionalParamsTriesToOverrideAuthorizationCode() {
        guard let result = generateAuthenticationUrl(
            signedRequest: exampleRequest,
            additionalCallbackUrlParams: ["authorizationCode": "123", "abc": "123"],
            options: nil
        ) else {
            XCTFail("generateAuthenticationUrl returned nil")
            return
        }
        
        let expectedResultUrlBase: String = "https://www.frequencyaccess.com/siwa/start?abc=123&"
        let parsedResult = parseRequestUrl(url: result)
        let resultUrlBase: String = parsedResult.0
        let resultDecodedRequest: SiwfSignedRequest? = parsedResult.1

        XCTAssertEqual(resultUrlBase, expectedResultUrlBase)
        XCTAssertEqual(resultDecodedRequest, exampleRequest)
    }
}
