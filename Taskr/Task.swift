import Foundation

struct Task {
    var ID: String
    var title: String
    var deadline: Date
    var hostname: String
    var phone: String
    var assignee: String

    var pastDeadline: Bool {
        return Date().compare(self.deadline) == ComparisonResult.orderedDescending
    }
    
    init(ID: String, title: String, deadline: Date, hostname: String, phone: String, assignee: String) {
        self.ID = ID
        self.title = title
        self.deadline = deadline
        self.hostname = hostname
        self.phone = phone
        self.assignee = assignee
    }
    
}
