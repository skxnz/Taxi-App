import UIKit
import Firebase
import FirebaseFirestore

class ShopingDetailViewController: UIViewController {
    @IBOutlet var timeInfoButton: UIButton!
    @IBOutlet var requestRideButton: UIButton!
    @IBOutlet var driverCommentTextField: UITextField!
    @IBOutlet var tippingSlider: UISlider!
    @IBOutlet var tarifChoseButton: UIButton!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    private var taxiTarif = 52
    public var distance: Int = 0
    private var totalPrice: Int?
    private var additionPrice: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.systemPink
        //setPopupButton()
        calculateDistance()
        calculatePrice()
        setUpTippingSlider()
        calculateAdditionalPrice()
    }
    
    func setPopupButton() {
        let optionClosure = {(action: UIAction) in
            print(action.title)
            if action.title == "economy" {
                self.taxiTarif = 52
            } else if action.title == "standart" {
                self.taxiTarif = 74
            } else if action.title == "business" {
                self.taxiTarif = 105
            }
        }
        
        tarifChoseButton.menu = UIMenu(children: [
            UIAction(title: "economy", state: .on, handler: optionClosure),
            UIAction(title: "standart", handler: optionClosure),
            UIAction(title: "business", handler: optionClosure),
        ])
        
        tarifChoseButton.showsMenuAsPrimaryAction = true
        tarifChoseButton.changesSelectionAsPrimaryAction = true
    }
    
    func calculateDistance() {
        distance = distance/1000
        distanceLabel.text = "\(distance)km"
    }
    
    func calculatePrice() {
        totalPrice = (distance * taxiTarif)
    }
    
    func setUpTippingSlider() {
        tippingSlider.value = Float(totalPrice!) * 0.4
        tippingSlider.minimumValue = Float(totalPrice!) * 0.2
        tippingSlider.maximumValue = Float(totalPrice!) * 2.0
    }
    
    func calculateAdditionalPrice() {
        additionPrice = Int(tippingSlider.value) + totalPrice!
        totalPriceLabel.text = "\(additionPrice!)₴"
    }
    
    @IBAction func tippingSliderHasChanged(_ sender: UISlider) {
        calculateAdditionalPrice()
    }
    @IBAction func requestRideButtonClicked(_ sender: UIButton) {
        let db = Firestore.firestore()
        db.collection("drive-requests").addDocument(data: [
            "Comment-for-a-driver": driverCommentTextField.text!,
            "Distance-journey": distance,
            "Money-paid": Int(tippingSlider.value)
        ]) { (error) in
            if error != nil {
                print(String(describing: error))
            } else {
                let ac = UIAlertController(title: "Success", message: "Your ride was successfuly requested. We will let drivers see your request", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
                    self.navigationController?.pushViewController(firstViewController!, animated: true)
                })
                self.present(ac, animated: true)
            }
        }
        func timeInfoButtonClicked(_ sender: UIButton) {
        }
    }
}
