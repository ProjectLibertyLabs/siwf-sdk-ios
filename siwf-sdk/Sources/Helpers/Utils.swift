//
//  Utils.swift
//  
//
//  Created by Claire Olmstead on 2/10/25.
//

import Foundation

let TO_BASE64URL: [String] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_").map { String($0) }

func stringToBase64URL(_ str: String) -> String {
    var base64: [String] = []
    var queue = 0
    var queuedBits = 0

    func emitter(_ byte: UInt8) {
        queue = (queue << 8) | Int(byte)
        queuedBits += 8

        while queuedBits >= 6 {
            let pos = (queue >> (queuedBits - 6)) & 63
            base64.append(TO_BASE64URL[pos])
            queuedBits -= 6
        }
    }

    stringToUTF8(str, emitter)

    if queuedBits > 0 {
        queue = queue << (6 - queuedBits)
        queuedBits = 6

        while queuedBits >= 6 {
            let pos = (queue >> (queuedBits - 6)) & 63
            base64.append(TO_BASE64URL[pos])
            queuedBits -= 6
        }
    }

    return base64.joined()
}

let FROM_BASE64URL: [Int] = {
    var lookup = Array(repeating: -1, count: 128)
    let base64URLChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    
    for (i, char) in base64URLChars.enumerated() {
        lookup[Int(char.asciiValue!)] = i
    }
    
    return lookup
}()

func stringFromBase64URL(_ str: String) throws -> String {
    var conv: [Character] = []
    
    func emit(_ codepoint: Int) {
        if let scalar = UnicodeScalar(codepoint) {
            conv.append(Character(scalar))
        }
    }
    
    var state = UTF8State()
    var queue = 0
    var queuedBits = 0
    
    for (i, char) in str.enumerated() {
        guard let asciiValue = char.asciiValue, asciiValue < 128 else {
            throw NSError(domain: "Invalid Base64-URL character", code: i, userInfo: nil)
        }
        
        let bits = FROM_BASE64URL[Int(asciiValue)]
        
        if bits > -1 {
            // Valid Base64-URL character
            queue = (queue << 6) | bits
            queuedBits += 6
            
            while queuedBits >= 8 {
                stringFromUTF8((queue >> (queuedBits - 8)) & 0xff, &state, emit)
                queuedBits -= 8
            }
        } else if bits == -2 {
            // Ignore spaces, tabs, newlines, =
            continue
        } else {
            throw NSError(domain: "Invalid Base64-URL character \(char) at position \(i)", code: i, userInfo: nil)
        }
    }
    
    return String(conv)
}

// Helper struct to track UTF-8 decoding state
struct UTF8State {
    var utf8seq = 0
    var codepoint = 0
}

// Decodes UTF-8 bytes into characters
func stringFromUTF8(_ byte: Int, _ state: inout UTF8State, _ emit: (Int) -> Void) {
    if byte & 0x80 == 0 { // 1-byte character (ASCII)
        emit(byte)
    } else if byte & 0xC0 == 0x80 { // Continuation byte
        state.codepoint = (state.codepoint << 6) | (byte & 0x3F)
        state.utf8seq -= 1
        if state.utf8seq == 0 {
            emit(state.codepoint)
        }
    } else { // Start of multi-byte sequence
        let mask = [0x00, 0x7F, 0x1F, 0x0F, 0x07]
        let length = [0, 1, 2, 3, 4]
        
        let leadingOnes = byte.leadingZeroBitCount - 24
        state.utf8seq = length[leadingOnes]
        state.codepoint = byte & mask[leadingOnes]
    }
}


func stringToUTF8(_ str: String, _ emitter: (UInt8) -> Void) {
    if let data = str.data(using: .utf8) {
        for byte in data {
            emitter(byte)
        }
    }
}
