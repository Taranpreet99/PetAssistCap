//
//  InformationViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-10-06.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class InformationViewController: UITableViewController{
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func onClickDogToys(sender : Any){
        mainDelegate.selectedURL = "https://barkpost.com/answers/best-dog-toys-2019/"
    }
    
    @IBAction func onClickPetWorries(sender : Any){
        
        mainDelegate.tableName = "Pet Behavioural Issues"
        
        mainDelegate.listData = ["Aggression","Barking","Destructive Chewing","Food Guarding", "Howling", "Mounting and Masturbation","Mouthing, Nipping and Play Biting in Adult Dogs","Mouthing, Nipping and Biting in Puppies", "Separation Anxiety", "Whining"]
        
        mainDelegate.siteData = ["https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/aggression","https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/barking","https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/destructive-chewing","https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/food-guarding", "https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/howling", "https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/mounting-and-masturbation","https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/mouthing-nipping-and-play-biting-adult-dogs", "https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/mouthing-nipping-and-biting-puppies","https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/separation-anxiety", "https://www.aspca.org/pet-care/dog-care/common-dog-behavior-issues/whining"]
        print(mainDelegate.siteData[0])
        
        //performSegue(withIdentifier: "InfoToOneTable", sender: nil)
    }
    
    @IBAction func onClickHelathIssues(sender: Any){
        
        mainDelegate.tableName = "Common Health Issues"
        
        mainDelegate.listData = ["Arthritis","Bloat & Gastric Torsion","Cancer in Animals", "Canine Parvovirus(CPV)"]
        mainDelegate.siteData = ["https://www.ardmoreah.com/pet-care/common-pet-health-issues/arthritis/","https://www.ardmoreah.com/pet-care/common-pet-health-issues/bloat-gastric-torsion/", "https://www.ardmoreah.com/pet-care/common-pet-health-issues/cancer-in-animals/", "https://www.ardmoreah.com/pet-care/common-pet-health-issues/canine-parvovirus/"]
    }
    
    @IBAction func onClickDiseaseSpread(sender: Any){
        
        mainDelegate.tableName = "Diseases"
        
        mainDelegate.listData = ["Aeromonas hydrophila","Zoonotic hookworms","Avian influenza","Bartonella henselae", "Baylisascaris","B virus infection"]
        
        mainDelegate.siteData = ["https://www.canada.ca/en/public-health/services/laboratory-biosafety-biosecurity/pathogen-safety-data-sheets-risk-assessment/aeromonas-hydrophila.html","https://www.cdc.gov/parasites/zoonotichookworm/","https://www.cdc.gov/flu/avianflu/","https://www.cdc.gov/healthypets/diseases/cat-scratch.html","https://www.cdc.gov/parasites/baylisascaris/index.html","https://www.cdc.gov/herpesbvirus/index.html" ]
    }
    
    @IBAction func unwindToInformation(sender : UIStoryboardSegue){
        
    }
    
    @IBAction func onClickNewPet(){
        mainDelegate.tableName = "Getting a new pet?"
        
        mainDelegate.listData = ["Things to Consider before getting a pet", "Items to Put on Your Shopping List", "Preparing your pet for new Home", "Pet Health Insurance", "Dog Grooming Tips", "Travelling with a Pet"]
        mainDelegate.siteData = ["https://www.petmd.com/dog/care/evr_multi_10_things_consider_before_pet_adoption","http://www.vetstreet.com/our-pet-experts/new-dog-owner-guide-21-items-to-put-on-your-shopping-list", "https://www.petcoach.co/article/8-tips-to-prepare-your-home-for-a-new-pet/","https://www.petinsurance.com/healthzone/ownership-adoption/pet-ownership/pet-owner-topics/8-tips-for-choosing-pet-health-insurance/", "https://www.dogviously.com/basic-dog-grooming-tips/", "https://www.mentalfloss.com/article/586073/pet-travel-safety-tips"]
        
    }
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
