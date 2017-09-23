//
//  SelectGenderCell.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//


class SelectEndDateCell: SelectOptionCell{
    static let ID = "SelectEndDateCell"
    override func setLabelText(){
        self.titleLabel.text = "만료기간"
    }
}

class SelectGenderCell: SelectOptionCell{
    static let ID = "SelectGenderCell"
    override func setLabelText() {
        self.titleLabel.text = "성별"
    }
}

class SelectAgeCell: SelectOptionCell{
    static let ID = "SelectAgeCell"
    override func setLabelText() {
        self.titleLabel.text = "연령"
    }
}

class SelectCityCell: SelectOptionCell{
    static let ID = "SelectCityCell"
    override func setLabelText() {
        self.titleLabel.text = "지역"
    }
}

