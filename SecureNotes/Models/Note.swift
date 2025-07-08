import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var encryptedContent: Data?
    let createdAt: Date

    init(id: UUID = UUID(), title: String, content: String, key: SymmetricKey, createdAt: Date = Date()) throws {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.encryptedContent = try CryptoManager.encrypt(content, key: key)
    }

    func decryptedContent(key: SymmetricKey) throws -> String {
        guard let encryptedContent = encryptedContent else {
            throw CryptoManager.CryptoError.decryptionFailed
        }
        return try CryptoManager.decrypt(encryptedContent, key: key)
    }
}
