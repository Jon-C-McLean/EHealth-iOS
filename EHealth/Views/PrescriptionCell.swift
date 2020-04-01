//
//  PrescriptionCell.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PrescriptionCell: UITableViewCell {
    
    private var medicationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 19)
        label.textColor = UIColor.black
        return label
    }()
    
    private var takenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 19)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    var instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildCell()
    }
    
    init(reuseId: String) {
        super.init(style: .default, reuseIdentifier: reuseId)
        self.buildCell()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func buildCell() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(medicationLabel)
        self.contentView.addSubview(takenLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(instructionsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        medicationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(Dimensions.Padding.large)
            make.top.equalTo(self.contentView).offset(Dimensions.Padding.medium)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.medicationLabel.snp.right).offset(Dimensions.Padding.medium)
            make.right.equalTo(self.contentView).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.medicationLabel)
        }
        
        instructionsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.medicationLabel)
            make.top.equalTo(self.medicationLabel.snp.bottom).offset(Dimensions.Padding.medium)
        }
        
        takenLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.instructionsLabel.snp.right).offset(Dimensions.Padding.medium)
            make.right.equalTo(self.dateLabel)
            make.top.equalTo(self.instructionsLabel)
        }
    }
    
    func setPrescription(_ prescription: Prescription) {
        self.medicationLabel.text = "\(prescription.dosage.removeDecimal())mg \(prescription.medication.name)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: Date(timeIntervalSince1970: Double(prescription.prescriptionDate)))
        self.dateLabel.text = date
        self.instructionsLabel.text = "\(prescription.amount) per \(prescription.perUnit)"
        self.takenLabel.text = "Taken \(prescription.medication.consumption.description())"
    }
    
}

extension Double {
    func removeDecimal() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return String(formatter.string(from: number) ?? "")
    }
}
