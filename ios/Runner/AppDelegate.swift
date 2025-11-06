import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Initialize Firebase
    FirebaseApp.configure()
    Messaging.messaging().delegate = self

    // ✅ Setup notification center delegate
    UNUserNotificationCenter.current().delegate = self

    // ✅ Request permission for push notifications (optional but recommended)
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if let error = error {
        print("❌ Notification permission error: \(error.localizedDescription)")
      } else {
        print("✅ Notification permission granted: \(granted)")
      }
    }

    // ✅ Register for remote notifications
    application.registerForRemoteNotifications()

    // ✅ Google Maps setup
    GMSServices.provideAPIKey("AIzaSyAicZRwkffHVARNs1m6LKk_5lsA2LYAb6U")

    // ✅ Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Called when APNs token is registered with Firebase
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // ✅ Called when new FCM token is generated
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("🔥 FCM Token: \(fcmToken ?? "")")
    // Optionally send this token to your backend here
  }

  // ✅ Handle notification payloads
  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    if let messageID = userInfo["gcm.message_id"] {
      print("📩 Message ID: \(messageID)")
    }
    print("📬 Full message: \(userInfo)")
    completionHandler(.newData)
  }
}
