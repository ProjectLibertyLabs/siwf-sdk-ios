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

func parseRequestUrl(input: String) -> (String, SiwfSignedRequest?) {
    let components = input.split(separator: "=", maxSplits: 1).map(String.init)
    guard components.count > 1 else {
        return (components[0], nil)
    }
    return (components[0], decodeSignedRequest(encodedSignedRequest: components[1]))
}

final class GenerateAuthenticationUrlTests: XCTestCase {
    func testGeneratesUrlWithFakeSignedRequestAndNoAdditionalParams() {
        let result = generateAuthenticationUrl(signedRequest: exampleRequest, additionalCallbackUrlParams: [:], options: nil)
        let expectedResult = createRequestUrl(urlBase: "https://www.frequencyaccess.com/siwa/start?signedRequest=")

        let parsedResult = parseRequestUrl(input: result!)
        let parsedExpectedResult = parseRequestUrl(input: expectedResult)

        let resultUrlBase = parsedResult.0
        let expectedResultUrlBase = parsedExpectedResult.0

        let resultDecodedRequest = parsedResult.1
        let expectedDecodedRequest = parsedExpectedResult.1

        XCTAssertEqual(resultUrlBase, expectedResultUrlBase)
        XCTAssertEqual(resultDecodedRequest, expectedDecodedRequest)
    }
    
//    func testGeneratesUrlWithFakeSignedRequestAndAdditionalParams() {
//        let result = generateAuthenticationUrl(
//            signedRequest: exampleRequest,
//            additionalCallbackUrlParams: ["abc": "123"],
//            options: nil
//        )
//        let requestUrl = "https://www.frequencyaccess.com/siwa/start?abc=123&signedRequest=" + exampleEncodedSignedRequest
//        XCTAssertEqual(result, requestUrl)
//    }
//
//    func testGeneratesUrlWhenAdditionalParamsTriesToOverrideSignedRequest() {
//        let result = generateAuthenticationUrl(
//            signedRequest: exampleRequest,
//            additionalCallbackUrlParams: ["signedRequest": "123", "abc": "123"],
//            options: nil
//        )
//        let requestUrl = "https://www.frequencyaccess.com/siwa/start?signedRequest=testing&abc=" + exampleEncodedSignedRequest
//        XCTAssertEqual(result, requestUrl)
//    }
//
//    func testGeneratesUrlWhenAdditionalParamsTriesToOverrideAuthorizationCode() {
//        let result = generateAuthenticationUrl(
//            signedRequest: exampleRequest,
//            additionalCallbackUrlParams: ["authorizationCode": "123", "abc": "123"],
//            options: nil
//        )
//        let requestUrl = "https://www.frequencyaccess.com/siwa/start?abc=123&signedRequest=" + exampleEncodedSignedRequest
//        XCTAssertEqual(result, requestUrl)
//    }
}
