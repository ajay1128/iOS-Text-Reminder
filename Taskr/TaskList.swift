import Foundation
import UIKit

class TaskList {
    static let sharedInstance = TaskList()
    private init() { }
    
    private let TASKS_KEY = "tasks"

    func addTask(_ task: Task) {
        var taskDictionary = UserDefaults.standard.dictionary(forKey: TASKS_KEY) ?? [:]
        
        taskDictionary[task.ID] = ["ID" : task.ID, "title" : task.title, "deadline" : task.deadline]
        UserDefaults.standard.set(taskDictionary, forKey: TASKS_KEY)
        
        let notification = UILocalNotification()
        notification.alertBody = "Task \"\(task.title)\" Is Overdue"
        notification.alertAction = "open"
        notification.fireDate = task.deadline as Date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["ID": task.ID]
        notification.category = "TASK_CATEGORY"
        UIApplication.shared.scheduleLocalNotification(notification)
        resetBadgeNumbers()
    }
    
    func allTasks() -> [Task] {
        let taskDictionary = UserDefaults.standard.dictionary(forKey: TASKS_KEY) as? [String : [String: Any]] ?? [:]
        let items = Array(taskDictionary.values)
        let taskArray = items.map({Task(ID: $0["ID"] as! String!,
            title: $0["title"] as! String,
            deadline: $0["deadline"] as! Date)})
        
        return taskArray.sorted(by: {(left: Task, right:Task) -> Bool in
            left.deadline.compare(right.deadline) == .orderedAscending})
    }
    
    func removeTask(_ task: Task) {
        if var taskItems = UserDefaults.standard.dictionary(forKey: TASKS_KEY) {
            taskItems.removeValue(forKey: task.ID)
            UserDefaults.standard.set(taskItems, forKey: TASKS_KEY)
        }
        
        for notification in UIApplication.shared.scheduledLocalNotifications! {
            if notification.userInfo!["ID"] as! String == task.ID {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
        resetBadgeNumbers()
    }
    
    func resetBadgeNumbers() {
        let notifications = UIApplication.shared.scheduledLocalNotifications!
        let tasks: [Task] = allTasks()
        for notification in notifications {
            let overdueItems = tasks.filter({ (task) -> Bool in
                return (task.deadline.compare(notification.fireDate!) != .orderedDescending)
            })
            UIApplication.shared.cancelLocalNotification(notification)
            notification.applicationIconBadgeNumber = overdueItems.count
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
}
