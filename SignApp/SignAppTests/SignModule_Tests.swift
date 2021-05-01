import XCTest
import Combine

@testable import SignApp
class SignModuleTests: XCTestCase {
    var viewModel: SignViewModel!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        viewModel = SignViewModel(accountFetcher: AccountFetcherMock())
        subscriptions = []
    }
    
    func test_validation_succcess() {
        // setup
        let validUserName = "validUserName"
        let validPassword = "validPassword"
        var expectedValues = [false, true]
        let expectation = expectation(description: "All values received")
        

        viewModel.$areUserCredentialsValid
            .print()
            .sink(receiveValue: { value in
                // assert
                guard let expectedValue = expectedValues.first else {
                    XCTFail("The publisher emitted more values than expected.")
                    
                    return
                }
            
                guard expectedValue == value else {
                    XCTFail("Expected received value \(value) to match first expected value \(expectedValue)")
                    
                    return
                }
            
                expectedValues = Array(expectedValues.dropFirst())
            
                if (expectedValues.isEmpty) {
                    expectation.fulfill()
                }
                
            })
            .store(in: &subscriptions)
        
        // action
        viewModel.userName = validUserName
        viewModel.password = validPassword
        viewModel.verifyPassword = validPassword

        waitForExpectations(timeout: 3, handler: nil)
    }
    
    
    func test_validation_fail_invalid_name() {
        // setup
        let invalidUserName = "x"
        let validUserName = "validUserName"
        let validPassword = "validPassword"
        var expectedValues = [false, true, false]
        let expectation = expectation(description: "All values received")
        
        viewModel.userName = validUserName
        viewModel.password = validPassword
        viewModel.verifyPassword = validPassword
        
        viewModel.$areUserCredentialsValid
            .print()
            .sink(receiveValue: { value in
                // assert
                guard let expectedValue = expectedValues.first else {
                    XCTFail("The publisher emitted more values than expected.")
                    
                    return
                }
            
                guard expectedValue == value else {
                    XCTFail("Expected received value \(value) to match first expected value \(expectedValue)")
                    
                    return
                }
            
                expectedValues = Array(expectedValues.dropFirst())
            
                if (expectedValues.isEmpty) {
                    expectation.fulfill()
                }
                
            })
            .store(in: &subscriptions)
        
        // action
        DispatchQueue.global().asyncAfter(wallDeadline: .now() + 2) { [unowned self] in
            self.viewModel.userName = invalidUserName
        }


        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_validation_fail_invalid_password() {
        // setup
        let validUserName = "validUserName"
        let validPassword = "validPassword"
        let invalidPassword = "x"
        var expectedValues = [false, true, false]
        let expectation = expectation(description: "All values received")
        
        viewModel.userName = validUserName
        viewModel.password = validPassword
        viewModel.verifyPassword = validPassword
        
        viewModel.$areUserCredentialsValid
            .print()
            .sink(receiveValue: { value in
                // assert
                guard let expectedValue = expectedValues.first else {
                    XCTFail("The publisher emitted more values than expected.")
                    
                    return
                }
            
                guard expectedValue == value else {
                    XCTFail("Expected received value \(value) to match first expected value \(expectedValue)")
                    
                    return
                }
            
                expectedValues = Array(expectedValues.dropFirst())
            
                if (expectedValues.isEmpty) {
                    expectation.fulfill()
                }
                
            })
            .store(in: &subscriptions)
        
        // action
        DispatchQueue.global().asyncAfter(wallDeadline: .now() + 2) { [unowned self] in
            self.viewModel.password = invalidPassword
        }


        waitForExpectations(timeout: 3, handler: nil)
    }
}
