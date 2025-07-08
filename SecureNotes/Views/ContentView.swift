import SwiftUI
import CryptoKit

struct ContentView: View {
    @StateObject private var viewModel = NoteViewModel()
    @State private var title = ""
    @State private var content = ""
    @State private var isAuthenticated = false
    @State private var key: SymmetricKey?

    var body: some View {
        NavigationView {
            if isAuthenticated {
                VStack {
                    TextField("Note Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextEditor(text: $content)
                        .frame(height: 200)
                        .border(Color.gray, width: 1)
                        .padding()
                    Button(action: {
                        do {
                            if let key = key {
                                try viewModel.addNote(title: title, content: content, key: key)
                                title = ""
                                content = ""
                            }
                        } catch {
                            print("Error adding note: \(error)")
                        }
                    }) {
                        Text("Save Note")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    List {
                        ForEach(viewModel.notes) { note in
                            VStack(alignment: .leading) {
                                Text(note.title)
                                    .font(.headline)
                                Text("Created: \(note.createdAt, formatter: dateFormatter)")
                                    .font(.caption)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { viewModel.deleteNote(at: $0) }
                        })
                    }
                }
                .navigationTitle("SecureNotes")
            } else {
                Text("Authenticating...")
                    .onAppear {
                        KeychainManager.authenticateWithBiometrics { success, error in
                            isAuthenticated = success
                            if let error = error {
                                print("Authentication error: \(error)")
                            }
                            if success && key == nil {
                                key = CryptoManager.generateKey()
                            }
                        }
                    }
            }
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
