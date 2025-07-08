import Foundation
import CryptoKit

class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []

    func addNote(title: String, content: String, key: SymmetricKey) throws {
        let note = try Note(title: title, content: content, key: key)
        notes.append(note)
    }

    func deleteNote(at index: Int) {
        if index < notes.count {
            notes[index].encryptedContent = Data(repeating: 0, count: notes[index].encryptedContent?.count ?? 0)
            notes.remove(at: index)
        }
    }
}
