//
//  MoreInfoViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/10/23.
//
//this is something i'm changing
import Foundation
import UIKit

class MoreInfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _: CGFloat = 40.0 //
        let buttonWidth: CGFloat = 320.0 
        
        let naspghanButton = UIButton(type: .system)
        naspghanButton.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        naspghanButton.setTitle("NASPGHAN", for: .normal)
        naspghanButton.setTitleColor(UIColor.white, for: .normal)
        naspghanButton.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        naspghanButton.layer.cornerRadius = 10
        naspghanButton.addTarget(self, action: #selector(openNASPGHANWebsite), for: .touchUpInside)
        
        let aaaaiButton = UIButton(type: .system)
        aaaaiButton.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        aaaaiButton.setTitle("AAAI", for: .normal)
        aaaaiButton.setTitleColor(UIColor.white, for: .normal)
        aaaaiButton.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        aaaaiButton.layer.cornerRadius = 10
        aaaaiButton.addTarget(self, action: #selector(openAAAIIWebsite), for: .touchUpInside)
        
        let apfedButton = UIButton(type: .system)
        apfedButton.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        apfedButton.setTitle("APFED", for: .normal)
        apfedButton.setTitleColor(UIColor.white, for: .normal)
        apfedButton.titleLabel?.font = UIFont(name: "Lato", size: 15.0)
        apfedButton.layer.cornerRadius = 10
        apfedButton.addTarget(self, action: #selector(openAPFEDWebsite), for: .touchUpInside)
        
        let naspghanLabel = UILabel()
        naspghanLabel.text = "North American Society For Pediatric Gastroenterology, Hepatology & Nutrition"
        naspghanLabel.textColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        naspghanLabel.font = UIFont(name: "Lato", size: 17.0)
        naspghanLabel.textAlignment = .center
        naspghanLabel.numberOfLines = 2 // Allow multiple lines
        
        let aaaaiLabel = UILabel()
        aaaaiLabel.text = "American Academy for Allergy, Asthma, and Immunology"
        aaaaiLabel.textColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        aaaaiLabel.font = UIFont(name: "Lato", size: 17.0)
        aaaaiLabel.textAlignment = .center
        aaaaiLabel.numberOfLines = 2 // Allow multiple lines
        
        let apfedLabel = UILabel()
        apfedLabel.text = "American Partnership for Eosinophilic Disorders"
        apfedLabel.textColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        apfedLabel.font = UIFont(name: "Lato", size: 17.0)
        apfedLabel.textAlignment = .center
        apfedLabel.numberOfLines = 2 // Allow multiple lines
        
        // Create vertical stack views for each button-label pair
        let naspghanStackView = UIStackView(arrangedSubviews: [naspghanButton, naspghanLabel])
        naspghanStackView.axis = .vertical
        naspghanStackView.spacing = 15.0
        
        let aaaaiStackView = UIStackView(arrangedSubviews: [aaaaiButton, aaaaiLabel])
        aaaaiStackView.axis = .vertical
        aaaaiStackView.spacing = 15.0
        
        let apfedStackView = UIStackView(arrangedSubviews: [apfedButton, apfedLabel])
        apfedStackView.axis = .vertical
        apfedStackView.spacing = 15.0
        
        // Set constraints for button widths
        naspghanButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        aaaaiButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        apfedButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        // Create a main stack view for all button-label pairs
        let mainStackView = UIStackView(arrangedSubviews: [naspghanStackView, aaaaiStackView, apfedStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 50.0
        
        self.view.addSubview(mainStackView)
        
        // Set Constraints for the main stack view
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            naspghanLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            aaaaiLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            apfedLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
        ])
    }
    
    // Links functions
    @objc func openNASPGHANWebsite() {
        if let url = URL(string: "https://naspghan.org") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openAAAIIWebsite() {
        if let url = URL(string: "http://www.aaaai.org") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openAPFEDWebsite() {
        if let url = URL(string: "http://www.apfed.org") {
            UIApplication.shared.open(url)
        }
    }
}
