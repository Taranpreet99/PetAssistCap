//
//  TrainingPickerViewController.swift
//  PetAssist
//
//  Created by Taranpreet Singh on 2020-03-28.
//  Copyright © 2020 Taranpreet Singh. All rights reserved.
//  Developed by Taranpreet Singh



import UIKit


class TrainingPickerViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    //Unwind segue to this page when back button is clicked on another
    @IBAction func unwindToPickerView(sender: UIStoryboardSegue){
        
    }
    
    //Four different types of training - Different link for each
    var trainingLinks: [String] = ["https://www.youtube.com/results?search_query=pet+Behavioral+training","https://www.youtube.com/results?search_query=pet+Obedience+training", "https://www.youtube.com/results?search_query=pets+Agility+training", "https://www.youtube.com/results?search_query=Vocational+training+for+pets" ]
   
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Number of rows in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainDelegate.trainingOptions.count
        
    }
    
    
    //Number of components in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Text to be displayed
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mainDelegate.trainingOptions[row]
        
    }
    
    //Function to be performed when a value is selected from the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let alertController = UIAlertController(title: mainDelegate.trainingOptions[row] , message: "You have selected" + mainDelegate.trainingOptions[row] + ". Do you want to continue?", preferredStyle: .alert)
        
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        let yes = UIAlertAction(title: "Yes", style: .default){
            (UIAlertAction) in
            
            self.mainDelegate.selectedURL = self.trainingLinks[row]
            self.performSegue(withIdentifier: "SegueToTutorialsWeb", sender: nil)
        }
        
        alertController.addAction(yes)
        alertController.addAction(no)
        present(alertController, animated: true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}
