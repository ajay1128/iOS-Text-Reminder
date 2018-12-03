import Foundation

struct Task {
    var ID: String
    var title: String
    var deadline: Date

    
    var pastDeadline: Bool {
        return Date().compare(self.deadline) == ComparisonResult.orderedDescending
    }
    
    init(ID: String, title: String, deadline: Date) {
        self.ID = ID
        self.title = title
     
        self.deadline = deadline
       
    }
    
}
