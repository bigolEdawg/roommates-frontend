import Foundation
import FirebaseAuth


@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    // add name field
    @Published var name: String = ""
    @Published var dob: String = ""
    
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var displayName: String = ""
//    struct LoginView: View {
//        @StateObject private var authVM = AuthenticationViewModel()
    private var createUser = CreateUser()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
    }

    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                //DispatchQueue.main.async {
                    self.user = user
                    self.displayName = user?.email ?? ""
                //}
            }
        }
    }
    
    deinit {
        if let authStateHandler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(authStateHandler)
        }
    }
}

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
 
            self.user = authResult.user
            self.errorMessage = ""  // Clear any previous errors

            
            print("User \(authResult.user.uid) signed in!")
            return true
        } catch {
            print(error)
            //DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            //}
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            //DispatchQueue.main.async {
                self.user = authResult.user
                self.errorMessage = ""  // Clear any previous errors
            //}
            
            print("User \(authResult.user.uid) signed up!")
            print("Trying the create user function")
            try await createUser.saveToFirestore(uid: authResult.user.uid, name: name)
            return true
        } catch {
            print(error)
            //DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            //}
            return false
        }
    }
    
    func signOut() async -> Bool {
        do {
            try Auth.auth().signOut()
            //DispatchQueue.main.async {
                self.user = nil
                self.errorMessage = ""  // Clear any previous errors
            //}
            print("Signing out")
            return true
        } catch {
            //DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            //}
            print(error)
            return false
        }
    }
    
    func deleteAccount() async -> Bool {
        return true
    }
}
