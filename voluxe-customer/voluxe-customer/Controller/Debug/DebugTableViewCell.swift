//
//  DebugTableViewCell.swift
//  voluxe-customer
//
//  Created by Christoph on 5/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

struct DebugTableViewCellModel {

    var title: String
    var cellReuseIdentifier: String

    // IMPORTANT!
    // Be sure to use [unowned self] if your closure uses 'self'
    // otherwise a retain cycle will be created.
    var valueClosure: ((_ cell: UITableViewCell) -> ())?
    var actionClosure: ((_ cell: UITableViewCell) -> ())?
}

class DebugValueTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DebugSubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
