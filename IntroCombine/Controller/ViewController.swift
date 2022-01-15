//
//  ViewController.swift
//  IntroCombine
//
//  Created by Sagar on 10/01/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var acceptSwitch: UISwitch!
    @IBOutlet weak var tfName: UITextField!  {
        didSet {
            tfName.delegate = self
            tfName.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var btnSubmit: UIButton!
    
    
   
    
    // Publisher
    @Published var acceptBtn = false
    @Published var name = ""
    
    // Subscriber
    var buttonSubscriber : AnyCancellable?
    
    //Combine Publisher
    
    var validated : AnyPublisher<Bool,Never> {
        return Publishers.CombineLatest($acceptBtn, $name)
            .map { accepts , names in
                return accepts && !names.isEmpty
            }.eraseToAnyPublisher()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSubscriber = validated
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: btnSubmit)
    }
    
    
    @IBAction func handleAcceptSwitch(_ sender: UISwitch) {
        acceptBtn = sender.isOn
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    
    @objc func valueChanged(_ textField : UITextField) {
        name = textField.text ?? ""
    }
    
    @IBAction func handleFetchUserBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserVC") as? UserVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleSubmitBtn(_ sender: Any) {
        
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
