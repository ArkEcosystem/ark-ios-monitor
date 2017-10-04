//
//  ExplorerAccountTableViewCell.swift
//  Dark
//
//  Created by Andrew on 2017-09-29.
//  Copyright © 2017 Walzy. All rights reserved.
//

import UIKit
import SwiftyArk

class ExplorerAccountTableViewCell: UITableViewCell {
    
    public let account: Account
    
    init(_ account: Account) {
        self.account = account
        super.init(style: .default, reuseIdentifier: "account")
        
        backgroundColor = ArkPalette.secondaryBackgroundColor
        selectionStyle = .none
        
        let nameLabel = UILabel()
        nameLabel.textColor = ArkPalette.highlightedTextColor
        nameLabel.text = account.address
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 15.0, weight:  .regular)
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(25.0)
            make.right.equalToSuperview().offset(-25.0)
        }
        
        let seperator = UIView()
        seperator.backgroundColor = ArkPalette.backgroundColor
        addSubview(seperator)
        seperator.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
