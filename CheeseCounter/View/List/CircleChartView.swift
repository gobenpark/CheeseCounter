//
//  CircleChartView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 6. 5..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import Charts
import Eureka

//class CircleChartView: UICollectionViewCell{
//
//  var didTap: ((String) -> Void)?
//  var didNotTap:(() -> Void)?
//
//  let titleLabel: UILabel = {
//    let label = UILabel()
//    label.text = "지역"
//    label.font = UIFont.CheeseFontMedium(size: 14)
//    label.sizeToFit()
//    return label
//  }()
//
//  var dataEntries: [PieChartDataEntry] = []
//
//  let pieChartView: PieChartView = {
//    let chart = PieChartView()
//
//    chart.drawHoleEnabled = false
//    chart.rotationEnabled = false
//
//    chart.backgroundColor = .white
//    chart.noDataText = "데이터가 없습니다."
//    chart.noDataTextColor = .black
//    chart.noDataFont = UIFont.CheeseFontMedium(size: 15)
//    chart.chartDescription?.enabled = false
//    chart.usePercentValuesEnabled = true
//    chart.drawCenterTextEnabled = true
//
//    chart.extraTopOffset = 20
//    chart.extraBottomOffset = 20
//
//    chart.drawEntryLabelsEnabled = true
//    chart.legend.enabled = false
//
//    return chart
//  }()
//
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//
//    self.pieChartView.delegate = self
//    self.contentView.addSubview(pieChartView)
//    self.contentView.addSubview(titleLabel)
//
//    titleLabel.snp.makeConstraints { (make) in
//      make.top.equalToSuperview().inset(10)
//      make.left.equalToSuperview().inset(22)
//    }
//
//    pieChartView.snp.makeConstraints { (make) in
//      make.edges.equalToSuperview()
//    }
//  }
//
//  func dataFetch(datas:DetailResult.Data?){
//    guard let datas = datas?.addr else {return}
//
//    var dictionary:[String:Double] = [:]
//
//    for data in datas {
//      dictionary[data.category] = Double(data.count)
//    }
//
//    setChart(datas: dictionary)
//  }
//
//  func setChart(datas:[String:Double]){
//
//    let pFormatter = NumberFormatter()
//    pFormatter.numberStyle = .percent
//    pFormatter.maximumFractionDigits = 1
//    pFormatter.multiplier = 1
//    pFormatter.percentSymbol = "%"
//
//    self.dataEntries.removeAll()
//
//    for (category,count) in datas{
//      let dataEntry = PieChartDataEntry(value: count, label: category)
//      dataEntries.append(dataEntry)
//    }
//
//    let colors: [UIColor] = [#colorLiteral(red: 0.9176470588, green: 0.231372549, blue: 0.1411764706, alpha: 1),#colorLiteral(red: 0.9294117647, green: 0.4823529412, blue: 0.1607843137, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.6901960784, blue: 0.1921568627, alpha: 1),#colorLiteral(red: 0.9843137255, green: 0.9058823529, blue: 0.2235294118, alpha: 1),#colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.2235294118, alpha: 1),
//                             #colorLiteral(red: 0.462745098, green: 0.8078431373, blue: 0.2196078431, alpha: 1),#colorLiteral(red: 0.3098039216, green: 0.6352941176, blue: 0.2235294118, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.7647058824, blue: 0.4666666667, alpha: 1),#colorLiteral(red: 0.3960784314, green: 0.8196078431, blue: 0.6823529412, alpha: 1),#colorLiteral(red: 0.5725490196, green: 0.8549019608, blue: 0.862745098, alpha: 1),
//                             #colorLiteral(red: 0.462745098, green: 0.7137254902, blue: 0.8235294118, alpha: 1),#colorLiteral(red: 0.5333333333, green: 0.6156862745, blue: 0.9098039216, alpha: 1),#colorLiteral(red: 0.5764705882, green: 0.5333333333, blue: 0.9098039216, alpha: 1),#colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1)]
//
//
//    let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
//    pieChartDataSet.colors = colors
//    pieChartDataSet.valueFormatter =  DefaultValueFormatter(formatter: pFormatter)
//    pieChartDataSet.selectionShift = 5
//    pieChartDataSet.valueLineColor = .black
//    pieChartDataSet.valueLinePart1Length = 0.7
//    pieChartDataSet.valueLinePart2Length = 0.2
//    pieChartDataSet.valueLinePart1OffsetPercentage = 1
//    pieChartDataSet.xValuePosition = .outsideSlice
//    pieChartDataSet.entryLabelColor = .black
//    pieChartDataSet.entryLabelFont = UIFont.CheeseFontMedium(size: 9)
//
//
//    let pieChartData = PieChartData(dataSet: pieChartDataSet)
//
//    if datas.isEmpty{
//      self.pieChartView.data = nil
//    }else {
//      self.pieChartView.data = pieChartData
//    }
//    self.pieChartView.setNeedsDisplay()
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//}
//
//extension CircleChartView: ChartViewDelegate{
//  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//    guard let tap = didTap, let country = dataEntries[Int(highlight.x)].label else {return}
//    tap(country)
//  }
//
//  func chartValueNothingSelected(_ chartView: ChartViewBase) {
//    guard let tap = didNotTap else {return}
//    tap()
//  }
//}

public class CircleChartCell: Cell<Bool>, CellType{
  var didTap: ((String) -> Void)?
  var didNotTap:(() -> Void)?
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "지역"
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.sizeToFit()
    return label
  }()
  
  var dataEntries: [PieChartDataEntry] = []
  
  let pieChartView: PieChartView = {
    let chart = PieChartView()
    
    chart.drawHoleEnabled = false
    chart.rotationEnabled = false
    
    chart.backgroundColor = .white
    chart.noDataText = "데이터가 없습니다."
    chart.noDataTextColor = .black
    chart.noDataFont = UIFont.CheeseFontMedium(size: 15)
    chart.chartDescription?.enabled = false
    chart.usePercentValuesEnabled = true
    chart.drawCenterTextEnabled = true
    
    chart.extraTopOffset = 20
    chart.extraBottomOffset = 20
    
    chart.drawEntryLabelsEnabled = true
    chart.legend.enabled = false
    
    return chart
  }()
  
  
  
  public override func setup() {
    super.setup()
    
//    self.pieChartView.delegate = self
    self.contentView.addSubview(pieChartView)
    self.contentView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(10)
      make.left.equalToSuperview().inset(22)
    }
    
    pieChartView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func dataFetch(datas:DetailResult.Data?){
    guard let datas = datas?.addr else {return}
    
    var dictionary:[String:Double] = [:]
    
    for data in datas {
      dictionary[data.category] = Double(data.count)
    }
    
    setChart(datas: dictionary)
  }
  
  func setChart(datas:[String:Double]){
    
    let pFormatter = NumberFormatter()
    pFormatter.numberStyle = .percent
    pFormatter.maximumFractionDigits = 1
    pFormatter.multiplier = 1
    pFormatter.percentSymbol = "%"
    
    self.dataEntries.removeAll()
    
    for (category,count) in datas{
      let dataEntry = PieChartDataEntry(value: count, label: category)
      dataEntries.append(dataEntry)
    }
    
    let colors: [UIColor] = [#colorLiteral(red: 0.9176470588, green: 0.231372549, blue: 0.1411764706, alpha: 1),#colorLiteral(red: 0.9294117647, green: 0.4823529412, blue: 0.1607843137, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.6901960784, blue: 0.1921568627, alpha: 1),#colorLiteral(red: 0.9843137255, green: 0.9058823529, blue: 0.2235294118, alpha: 1),#colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.2235294118, alpha: 1),
                             #colorLiteral(red: 0.462745098, green: 0.8078431373, blue: 0.2196078431, alpha: 1),#colorLiteral(red: 0.3098039216, green: 0.6352941176, blue: 0.2235294118, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.7647058824, blue: 0.4666666667, alpha: 1),#colorLiteral(red: 0.3960784314, green: 0.8196078431, blue: 0.6823529412, alpha: 1),#colorLiteral(red: 0.5725490196, green: 0.8549019608, blue: 0.862745098, alpha: 1),
                             #colorLiteral(red: 0.462745098, green: 0.7137254902, blue: 0.8235294118, alpha: 1),#colorLiteral(red: 0.5333333333, green: 0.6156862745, blue: 0.9098039216, alpha: 1),#colorLiteral(red: 0.5764705882, green: 0.5333333333, blue: 0.9098039216, alpha: 1),#colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1)]
    
    
    let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
    pieChartDataSet.colors = colors
    pieChartDataSet.valueFormatter =  DefaultValueFormatter(formatter: pFormatter)
    pieChartDataSet.selectionShift = 5
    pieChartDataSet.valueLineColor = .black
    pieChartDataSet.valueLinePart1Length = 0.7
    pieChartDataSet.valueLinePart2Length = 0.2
    pieChartDataSet.valueLinePart1OffsetPercentage = 1
    pieChartDataSet.xValuePosition = .outsideSlice
    pieChartDataSet.entryLabelColor = .black
    pieChartDataSet.entryLabelFont = UIFont.CheeseFontMedium(size: 9)
    
    
    let pieChartData = PieChartData(dataSet: pieChartDataSet)
    
    if datas.isEmpty{
      self.pieChartView.data = nil
    }else {
      self.pieChartView.data = pieChartData
    }
    self.pieChartView.setNeedsDisplay()
  }
}

//extension CircleChartCell: ChartViewDelegate{
//
//  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//    guard let tap = didTap, let country = dataEntries[Int(highlight.x)].label else {return}
//    tap(country)
//  }
//
//  func chartValueNothingSelected(_ chartView: ChartViewBase) {
//    guard let tap = didNotTap else {return}
//    tap()
//  }
//}


public final class CircleChartRow: Row<CircleChartCell>,RowType{
  public required init(tag: String?) {
    super.init(tag: tag)
  }
}
