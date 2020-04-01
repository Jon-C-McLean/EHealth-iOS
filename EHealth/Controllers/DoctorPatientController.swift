//
//  DoctorPatientController.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorPatientController: UIViewController {
    
    var doctor: Doctor
    var patient: Patient
    
    var backButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.tintColor = UIColor.black
        
        return button
    }()
    
    var patientLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    var birthLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    
    var medicareLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        label.textAlignment = .right
        
        return label
    }()
    
    var emailInfoView = InfoView()
    var phoneInfoView = InfoView()
    var addressInfoView = InfoView()
    var concessionTypeInfoView = InfoView()
    var concessionNumberInfoView = InfoView()
    
    init(doctor: Doctor, patient: Patient) {
        self.doctor = doctor
        self.patient = patient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        patientLabel.text = self.patient.name
        birthLabel.text = "DOB \(self.patient.dateOfBirth)"
        medicareLabel.text = self.patient.medicareNumber
        emailInfoView.title = "Email"
        emailInfoView.content = self.patient.email
        phoneInfoView.title = "Phone Number"
        phoneInfoView.content = self.patient.phoneNumber
        addressInfoView.title = "Address"
        addressInfoView.content = self.patient.address
        concessionTypeInfoView.title = "Concession Type"
        concessionTypeInfoView.content = self.patient.concessionType.displayName()
        
        concessionNumberInfoView.title = "Concession Card Number"
        concessionNumberInfoView.content = self.patient.concessionCardNumber
        concessionNumberInfoView.isHidden = self.patient.concessionType == .none
        
        
        self.view.addSubview(backButton)
        self.view.addSubview(patientLabel)
        self.view.addSubview(birthLabel)
        self.view.addSubview(medicareLabel)
        self.view.addSubview(emailInfoView)
        self.view.addSubview(phoneInfoView)
        self.view.addSubview(addressInfoView)
        self.view.addSubview(concessionTypeInfoView)
        self.view.addSubview(concessionNumberInfoView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge)
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 3)
        }
        
        patientLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.backButton)
            make.top.equalTo(self.backButton.snp.bottom).offset(Dimensions.Padding.extraLarge)
        }
        
        birthLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.patientLabel)
            make.top.equalTo(self.patientLabel.snp.bottom)
        }
        
        medicareLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.birthLabel.snp.right).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge)
            make.top.equalTo(self.birthLabel)
        }
        
        emailInfoView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge)
            make.top.equalTo(self.medicareLabel.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        phoneInfoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.emailInfoView)
            make.top.equalTo(self.emailInfoView.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        addressInfoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.phoneInfoView)
            make.top.equalTo(self.phoneInfoView.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        concessionTypeInfoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.addressInfoView)
            make.top.equalTo(self.addressInfoView.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        if self.patient.concessionType != .none {
            concessionNumberInfoView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.concessionTypeInfoView)
                make.top.equalTo(self.concessionTypeInfoView.snp.bottom).offset(Dimensions.Padding.large)
            }
            
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
