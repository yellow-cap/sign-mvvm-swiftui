import SwiftUI

@main
struct SignApp: App {
    var body: some Scene {
        WindowGroup {
            SignView(
                viewModel: SignViewModel(
                    accountFetcher: AccountFetcherMock())
            )
        }
    }
}
