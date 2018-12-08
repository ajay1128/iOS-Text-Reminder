import UIKit
import Alamofire

class TaskrDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    
    @IBOutlet weak var hostName: UITextField?
    
    
    @IBOutlet weak var phoneNumber: UITextField?
    
    @IBOutlet weak var assignedTo: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: AnyObject) {
        let task = Task(ID: UUID().uuidString, title: titleTextField.text!,deadline: deadlineDatePicker.date, hostname: hostName?.text ?? " ", phone: phoneNumber?.text ?? " ", assignee: assignedTo?.text ?? " ")
        TaskList.sharedInstance.addTask(task)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func sendData(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a"
        //let dat = dateFormatter.string(from: deadlineDatePicker.date)
       
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = [
            "To":  phoneNumber!.text! ,
            "Body":  hostName!.text! + " has assigned: " + titleTextField.text! + "\n" + dateFormatter.string(from: deadlineDatePicker.date)
        ]
        
        Alamofire.request("https://black-locust-4228.twil.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
            
        }
    }
    
    
}


