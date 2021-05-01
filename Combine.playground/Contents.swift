import Combine
import Foundation
import UIKit

let myLabel = UILabel()
[1, 2, 3] .publisher.map({ int in
return "Current value: \(int)" })
.sink(receiveValue: { string in myLabel.text = string
    print(myLabel.text)
})

