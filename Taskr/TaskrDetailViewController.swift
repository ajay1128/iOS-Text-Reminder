import UIKit
import Alamofire
import ContactsUI
import Contacts

class TaskrDetailViewController: UIViewController,CNContactPickerDelegate {
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

    //saves tasks
    @IBAction func save(_ sender: AnyObject) {
        let task = Task(ID: UUID().uuidString, title: titleTextField.text!,deadline: deadlineDatePicker.date, hostname: hostName?.text ?? " ", phone: phoneNumber?.text ?? " ", assignee: assignedTo?.text ?? " ")
        TaskList.sharedInstance.addTask(task)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //sendData - sends text messages to assignee
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
    
    //accesses contacts app
    @IBAction func AccessContacts(_ sender: Any) {
        let entityType = CNEntityType.contacts
        let authStat = CNContactStore.authorizationStatus(for: entityType)
        if authStat == CNAuthorizationStatus.notDetermined{
            let store = CNContactStore.init()
            store.requestAccess(for: entityType, completionHandler: { (success,nil) in
                
                if success {
                    self.openContacts()
                }
                else{
                    print("access denied")
                }
            })
            
        }
        else if authStat == CNAuthorizationStatus.authorized {
            self.openContacts()
        }
    }
    
    //opens contacts
    func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    //did not pick contact
    func contactPickerDidCancel(_ picker: CNContactPickerViewController){
        picker.dismiss(animated: true){
        }
    }
    
    //picks a contact
    //assigns contact name to assignee field
    //assigns phone number to phone number field
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact){
        let fullName = "\(contact.givenName)\(contact.familyName)"
        var phoneNo = "not available"
        let phoneString = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
        phoneNo = phoneString! as! String
        self.assignedTo?.text = "\(fullName)"
        self.phoneNumber?.text = "\(phoneNo)"
    }
}
    
    



