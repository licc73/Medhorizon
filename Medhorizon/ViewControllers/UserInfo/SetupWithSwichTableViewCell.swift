//
//  SetupWithSwichTableViewCell.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

protocol SetupWithSwichTableViewCellDelegate: class {
    func setupWithSwitchTableViewCell(cell: UITableViewCell, change value: Bool)
}

class SetupWithSwichTableViewCell: UITableViewCell {
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var sw: UISwitch!
    weak var delegate: SetupWithSwichTableViewCellDelegate?

    func setTitle(title: String, isOn value: Bool) {
        self.labTitle.text = title
        self.sw.on = value
    }

    @IBAction func switchValueChange(control: UISwitch) {
        self.delegate?.setupWithSwitchTableViewCell(self, change: control.on)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labTitle.text = nil
        self.sw.on = false
    }

}
