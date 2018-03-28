//
//  PinnedBarView.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 27/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import UIKit

public final class PinnedBarView: UIView {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        setupCoverImage()
    }
    
    // MARK: - Helpful Private Functions
    private func setupCoverImage() {
        coverImageView.layer.shadowOpacity = 0.4
        coverImageView.layer.shadowColor = UIColor.black.cgColor
        coverImageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        coverImageView.layer.shadowRadius = 12
        coverImageView.layer.cornerRadius = 4
    }
}
