//
//  MoreInfoViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/10/23.
//

import Foundation
import UIKit

struct CustomResource {
    var name: String
    var link: String
}

class MoreInfoViewController: UIViewController {
    
    var customResources: [CustomResource] = []
    let buttonWidth: CGFloat = 320.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCustomResources() // Load saved resources on launch
        
        setupResourceButtons()
        setupCustomResourceButton()
    }
    
    private func setupResourceButtons() {
        
        // NASPGHAN Button and Label
        let naspghanButton = createResourceButton(title: "NASPGHAN", action: #selector(openNASPGHANWebsite))
        let naspghanLabel = createResourceLabel(text: "North American Society For Pediatric Gastroenterology, Hepatology & Nutrition")
        
        // AAAAI Button and Label
        let aaaaiButton = createResourceButton(title: "AAAAI", action: #selector(openAAAIIWebsite))
        let aaaaiLabel = createResourceLabel(text: "American Academy for Allergy, Asthma, and Immunology")
        
        // APFED Button and Label
        let apfedButton = createResourceButton(title: "APFED", action: #selector(openAPFEDWebsite))
        let apfedLabel = createResourceLabel(text: "American Partnership for Eosinophilic Disorders")
        
        // CHRichmond Button and Label
        let chrichmondButton = createResourceButton(title: "Children's Hospital of Richmond", action: #selector(openCHRichmondWebsite))
        let chrichmondLabel = createResourceLabel(text: "Children's Hospital of Richmond")
        
        // Stack views for each button-label pair
        let naspghanStackView = UIStackView(arrangedSubviews: [naspghanButton, naspghanLabel])
        naspghanStackView.axis = .vertical
        naspghanStackView.spacing = 15.0
        
        let aaaaiStackView = UIStackView(arrangedSubviews: [aaaaiButton, aaaaiLabel])
        aaaaiStackView.axis = .vertical
        aaaaiStackView.spacing = 15.0
        
        let apfedStackView = UIStackView(arrangedSubviews: [apfedButton, apfedLabel])
        apfedStackView.axis = .vertical
        apfedStackView.spacing = 15.0
        
        let chrichmondStackView = UIStackView(arrangedSubviews: [chrichmondButton, chrichmondLabel])
        chrichmondStackView.axis = .vertical
        chrichmondStackView.spacing = 15.0
        
        // Main stack view for predefined buttons
        let mainStackView = UIStackView(arrangedSubviews: [naspghanStackView, aaaaiStackView, apfedStackView, chrichmondStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 50.0
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // Set button widths
            naspghanButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            aaaaiButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            apfedButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            chrichmondButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
    }
    
    private func setupCustomResourceButton() {
        let customResourceButton = UIButton(type: .system)
        customResourceButton.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        customResourceButton.setTitle("Custom Resources", for: .normal)
        customResourceButton.setTitleColor(UIColor.white, for: .normal)
        customResourceButton.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        customResourceButton.layer.cornerRadius = 10
        customResourceButton.addTarget(self, action: #selector(showCustomResources), for: .touchUpInside)
        
        customResourceButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customResourceButton)
        
        NSLayoutConstraint.activate([
            customResourceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customResourceButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            customResourceButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
    }
    
    @objc private func showCustomResources() {
        let alert = UIAlertController(title: "Custom Resources", message: nil, preferredStyle: .actionSheet)
        
        // Add a new resource
        alert.addAction(UIAlertAction(title: "Add New Resource", style: .default, handler: { _ in
            self.addCustomResource()
        }))
        
        // Display saved resources with options to edit or delete
        for (index, resource) in customResources.enumerated() {
            alert.addAction(UIAlertAction(title: resource.name, style: .default, handler: { _ in
                self.presentResourceOptions(for: index)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func presentResourceOptions(for index: Int) {
        let resource = customResources[index]
        let alert = UIAlertController(title: resource.name, message: "Choose an action", preferredStyle: .actionSheet)
        
        // Open the link
        alert.addAction(UIAlertAction(title: "Open Link", style: .default, handler: { _ in
            self.openURL(self.validateURL(resource.link))
        }))
        
        // Edit option
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            self.editCustomResource(at: index)
        }))
        
        // Delete option
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteCustomResource(at: index)
        }))
        
        // Cancel option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func addCustomResource() {
        let alert = UIAlertController(title: "Add Resource", message: "Enter the name and URL", preferredStyle: .alert)
        
        alert.addTextField { $0.placeholder = "Resource Name" }
        alert.addTextField { $0.placeholder = "URL (e.g., vcu.edu)" }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let name = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty,
                  let linkInput = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines), !linkInput.isEmpty else { return }
            let validatedLink = self?.validateURL(linkInput) ?? linkInput
            let newResource = CustomResource(name: name, link: validatedLink)
            self?.customResources.append(newResource)
            self?.saveCustomResources()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func editCustomResource(at index: Int) {
        let resource = customResources[index]
        let alert = UIAlertController(title: "Edit Resource", message: "Update the name and URL", preferredStyle: .alert)
        
        alert.addTextField { $0.text = resource.name }
        alert.addTextField { $0.text = resource.link }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let name = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty,
                  let linkInput = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines), !linkInput.isEmpty else { return }
            let validatedLink = self?.validateURL(linkInput) ?? linkInput
            self?.customResources[index] = CustomResource(name: name, link: validatedLink)
            self?.saveCustomResources()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func deleteCustomResource(at index: Int) {
        customResources.remove(at: index)
        saveCustomResources()
    }
    
    private func saveCustomResources() {
        let encodedResources = customResources.map { ["name": $0.name, "link": $0.link] }
        UserDefaults.standard.set(encodedResources, forKey: "customResources")
    }
    
    private func loadCustomResources() {
        if let savedResources = UserDefaults.standard.array(forKey: "customResources") as? [[String: String]] {
            customResources = savedResources.compactMap { dict in
                guard let name = dict["name"], let link = dict["link"] else { return nil }
                return CustomResource(name: name, link: link)
            }
        }
    }
    
    private func validateURL(_ urlString: String) -> String {
        if urlString.lowercased().hasPrefix("http://") || urlString.lowercased().hasPrefix("https://") {
            return urlString
        } else {
            return "https://\(urlString)"
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            let errorAlert = UIAlertController(title: "Invalid URL", message: "The URL provided is invalid.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(errorAlert, animated: true)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // Button actions for predefined resource websites
    @objc private func openNASPGHANWebsite() {
        openURL("https://naspghan.org")
    }
    
    @objc private func openAAAIIWebsite() {
        openURL("https://www.aaaai.org")
    }
    
    @objc private func openAPFEDWebsite() {
        openURL("https://apfed.org")
    }
    
    @objc private func openCHRichmondWebsite() {
        openURL("https://www.chrichmond.org")
    }
    
    private func createResourceButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: action, for: .touchUpInside)
        // Note: Do not set width constraint here; it will be set outside
        return button
    }
    
    private func createResourceLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        label.font = UIFont(name: "Lato", size: 11.0)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }
}
