//
//  ResultVCViewController.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 20/09/23.
//

import UIKit

class ResultVC: UIViewController {
    var loaderView = UIActivityIndicatorView()
//    var finalData = NSDictionary
    let mainTextView = UILabel()
    let subTextView = UILabel()
    let mainView = UIView()
    var timeTaken  = 0
    let dismissButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.fetchResults(isRefreshing: false)
        })
        setupView()
    }
    func setupView(){
        
        view.backgroundColor = .clear
        let blurView = UIVisualEffectView(frame: self.view.bounds)
        blurView.effect = UIBlurEffect(style: .extraLight)
        blurView.alpha = 0.8
        self.view.addSubview(blurView)
        mainView.frame = CGRect(x: 0, y: view.bounds.height / 4 , width: view.bounds.width, height: view.bounds.height / 4)
        mainView.backgroundColor = .orange.withAlphaComponent(0.8)
        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = true
        loaderView.frame = mainView.bounds
        loaderView.color = .black
        loaderView.style = .large
       
        var yPos = 0.0
        
        mainTextView.frame =  CGRect(x: 0, y: yPos + 20 , width: mainView.bounds.width, height: 50)
        mainTextView.textAlignment = .center
        mainTextView.font = UIFont.boldSystemFont(ofSize: 30)
        mainTextView.text = "Searching for Falcone"
        mainTextView.backgroundColor = .clear
        
        yPos += 70
        
        subTextView.frame = CGRect(x: 0, y: yPos + 20, width: mainView.bounds.width, height: 50)
        subTextView.textAlignment = .center
        subTextView.font = UIFont.boldSystemFont(ofSize: 20)
        subTextView.text = ""
        subTextView.backgroundColor = .clear
        subTextView.numberOfLines = 2
        subTextView.minimumScaleFactor = 0.5
        
        yPos += 70
        
        dismissButton.frame = CGRect(x: 0, y: mainView.bounds.maxY - 50, width: mainView.bounds.width, height: 50)
        
        yPos += 70
        
        dismissButton.addTarget(self, action: #selector(dismissBtn), for: .touchUpInside)
        dismissButton.isHidden = true
        dismissButton.backgroundColor = .orange
        
        mainView.addSubview(mainTextView)
        mainView.addSubview(subTextView)
        mainView.addSubview(loaderView)
        mainView.addSubview(dismissButton)
        view.addSubview(blurView)
        view.addSubview(mainView)
        
    }
    @objc func dismissBtn(){
        self.dismiss(animated: true)
    }
    func fetchResults(isRefreshing:Bool){
        DataManager.shared.fetchResult{dict in
            self.loaderView.stopAnimating()
            if dict["status"] == "success"  {
                print("\(String(describing: dict["status"]))")
                self.mainTextView.text = "Falcone Found :)"
                self.mainView.backgroundColor = UIColor.green.withAlphaComponent(0.6)
                self.dismissButton.isHidden = false
                self.dismissButton.setTitle("Okay!!", for: .normal)
                self.subTextView.text = "Planet name: " + dict["planet_name"]! + "\n In Time: \(self.timeTaken)"
                print("\(String(describing: dict["planet_name"]))")
            }
            else if dict["status"] == "false"  {
                self.mainView.backgroundColor = UIColor.red.withAlphaComponent(0.6)
                self.mainTextView.text = "Falcone not found :("
                self.subTextView.text = "Try other planets!"
                self.dismissButton.isHidden = false
                self.dismissButton.setTitle("Try other planets", for: .normal)
            }
            else {
                
                print("\(String(describing: dict["status"]))")
                if let error = dict["error"]  ,error.contains("Token not initialized") , !isRefreshing{
                    DataManager.shared.fetchToken(forceRefresh: true,completion: {
                        self.fetchResults(isRefreshing: true)
                    })
                }
                else {
                    let alert = UIAlertController(title: "Error", message: (String(describing: dict["error"])), preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
            
        }
    }
    

}
