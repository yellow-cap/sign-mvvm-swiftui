import Combine
import Foundation
import UIKit

class Counter {
    @Published var publishedValue = 1
    var subjectValue = CurrentValueSubject<Int, Never>(1)
}

let c = Counter()
c.$publishedValue
    .sink(receiveValue: { int in
        print("Current published value \(c.publishedValue), received value \(int)")
})

c.subjectValue
    .sink(receiveValue: { int in
        print("Current subject value \(c.subjectValue.value), received value \(int)")
})


c.publishedValue = 2
c.subjectValue.value = 2

