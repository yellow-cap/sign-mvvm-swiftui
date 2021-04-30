import SwiftUI

struct SignView: View {
    @ObservedObject var viewModel: SignViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("User name", text: $viewModel.userName)
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
