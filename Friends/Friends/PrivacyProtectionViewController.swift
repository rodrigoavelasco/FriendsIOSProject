//
//  PrivacyProtectionViewController.swift
//  Friends
//
//  Created by Rodrigo Velasco on 7/7/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class PrivacyProtectionViewController: UITableViewController {
    
    init() {
        super.init(style: .grouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let labelHeight = view.bounds.height * 0.66
        (privacyLabel.frame, _) = view.bounds.divided(atDistance: labelHeight, from: .minYEdge)
    }

    private lazy var privacyLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true

        label.textAlignment = .center
        label.textColor = .gray

        label.numberOfLines = 0
        label.text = "Content hidden\nto protect\nyour privacy\nsuper secret\ninformation\nover here"

        self.view.addSubview(label)

        return label
    }()
}
