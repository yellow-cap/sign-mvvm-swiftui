import SwiftUI

struct SignView: View {
    @ObservedObject var viewModel: SignViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("User name", text: $viewModel.userName)
            }
            Section {
              SecureField("Password", text: $viewModel.password)
              SecureField("Confirm password", text: $viewModel.confirmPassword)
           }
            Section {
                Button(action: { }) {
                    Text("Sign up")
                    
                }
                .disabled(!viewModel.isValid)
            }
        }
    }
}

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView(
            viewModel: SignViewModel(
                accountFetcher: AccountFetcherMock()
            )
        )
    }
}
