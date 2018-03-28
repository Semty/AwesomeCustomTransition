//
//  HeaderButton.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import UIKit

public final class HeaderButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
        layer.cornerRadius = 2
    }
}
