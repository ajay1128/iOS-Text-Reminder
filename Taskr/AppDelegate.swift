import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let completeAction = UIMutableUserNotificationAction()
        completeAction.identifier = "ACTION_COMPLETE"
        completeAction.title = "Complete"
        completeAction.activationMode = .background
        completeAction.isAuthenticationRequired = true
        completeAction.isDestructive = true
        
        let taskCategory = UIMutableUserNotificationCategory()
        taskCategory.identifier = "TASK_CATEGORY"
        taskCategory.setActions([completeAction], for: .default)

        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: [taskCategory]))
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let tasks: [Task] = TaskList.sharedInstance.allTasks() // retrieve list of all to-do items
        let overdueItems = tasks.filter() { (task) -> Bool in
            return task.deadline.compare(Date()) != .orderedDescending
        }
        
        UIApplication.shared.applicationIconBadgeNumber = overdueItems.count
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TaskListRefresh"), object: self)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TaskListRefresh"), object: self)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        let task = Task(ID: notification.userInfo!["ID"] as! String, title: "", deadline: notification.fireDate!)
        switch identifier! {
        case "ACTION_COMPLETE":
            TaskList.sharedInstance.removeTask(task)
        default:
            // Should never get here!
            break
        }
        completionHandler()
    }


}

