import XCTest
import CryptoKit
@testable import SecureNotes

class CryptoManagerTests: XCTestCase {
    func testEncryptionAndDecryption() throws {
        let key = CryptoManager.generateKey()
        let originalContent = "This is a secure note."
        let encryptedData = try CryptoManager.encrypt(originalContent, key: key)
        let decryptedContent = try CryptoManager.decrypt(encryptedData, key: key)
        XCTAssertEqual(originalContent, decryptedContent, "Decrypted content should match original")
    }
}
