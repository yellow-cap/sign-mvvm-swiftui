import SwiftUI

struct SignView: View {
    @ObservedObject var viewModel: SignViewModel
    
    var body: some View {
        Form {
            Section {
                TextField(StringResources.userNamePlaceholder, text: $viewModel.userName)
            }
            Section {
                SecureField(StringResources.passwordPlaceholder, text: $viewModel.password)
                SecureField(StringResources.verifyPasswordPlaceholder, text: $viewModel.verifyPassword)
           }
            Section {
                Button(action: {
                    print("<<<DEV>> Create account button tapped.")
                }) {
                    Text("\(StringResources.createAccountButtonTitle)")
                    
                }
                .disabled(!viewModel.areUserCredentialsValid)
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
