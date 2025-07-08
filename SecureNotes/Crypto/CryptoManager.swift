import CryptoKit
import Foundation

class CryptoManager {
    static func generateKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }

    static func encrypt(_ content: String, key: SymmetricKey) throws -> Data {
        let data = content.data(using: .utf8)!
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    static func decrypt(_ encryptedData: Data, key: SymmetricKey) throws -> String {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw CryptoError.decryptionFailed
        }
        return decryptedString
    }

    enum CryptoError: Error {
        case decryptionFailed
    }
}
