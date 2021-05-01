import Combine
import Foundation
import UIKit

var cancellables = Set<AnyCancellable>()
let firstNotificationName = Notification.Name("first")
let secondNotificationName = Notification.Name("second")
let firstNotification = Notification(name: firstNotificationName)
let secondNotification = Notification(name: secondNotificationName)
let first = NotificationCenter.default.publisher(for: firstNotificationName)
let second = NotificationCenter.default.publisher(for: secondNotificationName)
// create and subscribe to Zip, Merge and CombineLatest

let combined = Publishers.CombineLatest(first, second).sink(receiveValue: { val in
print(val, "combined") }).store(in: &cancellables)

print("send first")
NotificationCenter.default.post(firstNotification)
print("send second")
NotificationCenter.default.post(secondNotification)
print("send third")
NotificationCenter.default.post(firstNotification)
print("send fourth")
NotificationCenter.default.post(secondNotification)
print("send fifth")
NotificationCenter.default.post(secondNotification)


print("send six")
sleep(5)
NotificationCenter.default.post(firstNotification)
