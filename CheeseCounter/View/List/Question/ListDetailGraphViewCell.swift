//
//  DetailGraphViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 9..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import CircleProgressView
import Charts

class MyFormatter: DefaultValueFormatter{
  override func stringForValue(_ value: Double,
                               entry: ChartDataEntry,
                               dataSetIndex: Int,
                               viewPortHandler: ViewPortHandler?) -> String
  {
    if block != nil
    {
      return block!(value, entry, dataSetIndex, viewPortHandler)
    }
    else
    {
      if value == 0 {
        return ""
      }else {
        return formatter?.string(from: NSNumber(floatLiteral: value)) ?? ""
      }
    }
  }
}

class ListDetailGraphViewCell: UICollectionViewCell {
  
  private var maleCount: Double = 0{
    didSet{
      self.maleLabel.attributedText = attributeUpdate(gender: "남자", count: maleCount)
    }
  }
  private var femaleCount: Double = 0{
    didSet{
      self.femaleLabel.attributedText = attributeUpdate(gender: "여자", count: femaleCount)
    }
  }
  
  private let maleImageView = UIImageView(image: #imageLiteral(resourceName: "male_nomal@1x"))
  private let femaleImageView = UIImageView(image: #imageLiteral(resourceName: "female_nomal@1x"))

  private let maleLabel = UILabel()
  private let femaleLabel = UILabel()
  
  
  let ageLabel: UILabel = {
    let label = UILabel()
    label.text = "성별 및 연령"
    label.textColor = .black
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.sizeToFit()
    return label
  }()
  
  lazy var barChart: HorizontalBarChartView = {
    let chart = HorizontalBarChartView()
    
    let customFormatter = NumberFormatter()
    customFormatter.negativePrefix = ""
    customFormatter.positiveSuffix = "명"
    customFormatter.negativeSuffix = "명"
    
    chart.fitBars = true
    chart.chartDescription?.enabled = false
    chart.highlightFullBarEnabled = false
    chart.pinchZoomEnabled = false
    chart.drawBarShadowEnabled = false
    chart.leftAxis.enabled = true
    chart.leftAxis.drawGridLinesEnabled = false
    chart.leftAxis.drawZeroLineEnabled = true
    chart.leftAxis.granularity = 1
    chart.leftAxis.gridColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5)
    
    chart.doubleTapToZoomEnabled = false
    
    chart.leftAxis.zeroLineColor = .lightGray
    
    chart.extraBottomOffset = 20
    chart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: customFormatter)
    
    chart.rightAxis.drawZeroLineEnabled = false
    chart.rightAxis.drawGridLinesEnabled = false
    chart.rightAxis.enabled = false
    
    chart.xAxis.drawGridLinesEnabled = false
    chart.xAxis.centerAxisLabelsEnabled = true
    chart.xAxis.drawAxisLineEnabled = false
    chart.xAxis.labelPosition = .bothSided
    chart.xAxis.enabled = false
    
    chart.legend.horizontalAlignment = .center
    chart.legend.verticalAlignment = .bottom
    chart.legend.orientation = .horizontal
    chart.legend.drawInside = false
    chart.legend.enabled = true
    chart.legend.xEntrySpace = 15
    chart.legend.setCustom(entries:   [
      LegendEntry(label: "10대", form: .circle, formSize: 5, formLineWidth: 10, formLineDashPhase: 10, formLineDashLengths: nil, formColor: #colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1)),
      LegendEntry(label: "20대", form: .circle, formSize: 5, formLineWidth: 10, formLineDashPhase: 10, formLineDashLengths: nil, formColor: #colorLiteral(red: 0.5843137255, green: 0.8862745098, blue: 0.3607843137, alpha: 1)),
      LegendEntry(label: "30대", form: .circle, formSize: 5, formLineWidth: 10, formLineDashPhase: 10, formLineDashLengths: nil, formColor: #colorLiteral(red: 0.9333333333, green: 0.3803921569, blue: 0.7450980392, alpha: 1)),
      LegendEntry(label: "40대", form: .circle, formSize: 5, formLineWidth: 10, formLineDashPhase: 10, formLineDashLengths: nil, formColor: #colorLiteral(red: 0.4156862745, green: 0.7568627451, blue: 0.9490196078, alpha: 1)),
      LegendEntry(label: "50대", form: .circle, formSize: 5, formLineWidth: 10, formLineDashPhase: 10, formLineDashLengths: nil, formColor: #colorLiteral(red: 0.6862745098, green: 0.4823529412, blue: 0.9137254902, alpha: 1)),
      LegendEntry(label: "60대", form: .circle, formSize: 5, formLineWidth: 10, formLineDashPhase: 10, formLineDashLengths: nil, formColor: #colorLiteral(red: 1, green: 0.5294117647, blue: 0.2745098039, alpha: 1))
      ]
    )
    
    chart.noDataText = "데이터가 없습니다."
    chart.drawGridBackgroundEnabled = false
    
    chart.drawValueAboveBarEnabled = true
    return chart
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    contentView.addSubview(ageLabel)
    contentView.addSubview(barChart)
    contentView.addSubview(maleImageView)
    contentView.addSubview(femaleImageView)
    contentView.addSubview(maleLabel)
    contentView.addSubview(femaleLabel)
    
    ageLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(22)
      make.top.equalToSuperview().inset(10)
    }
    
    maleImageView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(30)
      make.top.equalTo(ageLabel.snp.bottom).offset(10)
      make.height.equalTo(30)
      make.width.equalTo(30)
    }
    
    maleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(maleImageView.snp.right).offset(10)
      make.bottom.equalTo(maleImageView)
      make.right.equalTo(contentView.snp.centerX)
    }
    
    femaleImageView.snp.makeConstraints { (make) in
      make.left.equalTo(contentView.snp.centerX).offset(30)
      make.top.equalTo(maleImageView)
      make.height.equalTo(maleImageView)
      make.width.equalTo(maleImageView)
    }
    
    femaleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(femaleImageView.snp.right).offset(10)
      make.bottom.equalTo(femaleImageView)
      make.right.equalToSuperview()
    }
    
    barChart.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(22)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview().inset(22)
      make.top.equalTo(maleImageView.snp.bottom).offset(15)
    }
  }
  
  func attributeUpdate(gender:String, count: Double) -> NSMutableAttributedString{
    
    let attribute = NSMutableAttributedString(string: gender, attributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.CheeseFontMedium(size: 15)])
    attribute.append(NSAttributedString(string: "\(Int(count))", attributes: [NSForegroundColorAttributeName:#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),NSFontAttributeName:UIFont.CheeseFontBold(size: 19)]))
    attribute.append(NSAttributedString(string: "명", attributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.CheeseFontMedium(size: 15)]))
    return attribute
  }
  
  func setChart(male:[Int:Double], female:[Int:Double]){
    
    let customFormatter = NumberFormatter()
    customFormatter.negativePrefix = ""
    customFormatter.positiveSuffix = "명"
    customFormatter.negativeSuffix = "명"
    customFormatter.minimumSignificantDigits = 1
    customFormatter.minimumFractionDigits = 1
    
    var dataEntries: [BarChartDataEntry] = []
    
    for i in 1...6{
      
      let dataEntry = BarChartDataEntry(x: Double(i*10), yValues: [-(male[i*10] ?? 0),(female[i*10] ?? 0)])
      dataEntries.append(dataEntry)
    }
    
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
    chartDataSet.axisDependency = .right
    chartDataSet.valueFormatter = MyFormatter(formatter: customFormatter)
    chartDataSet.colors = [#colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1),#colorLiteral(red: 0.5843137255, green: 0.8862745098, blue: 0.3607843137, alpha: 1),#colorLiteral(red: 0.5843137255, green: 0.8862745098, blue: 0.3607843137, alpha: 1),#colorLiteral(red: 0.9333333333, green: 0.3803921569, blue: 0.7450980392, alpha: 1),#colorLiteral(red: 0.9333333333, green: 0.3803921569, blue: 0.7450980392, alpha: 1),#colorLiteral(red: 0.4156862745, green: 0.7568627451, blue: 0.9490196078, alpha: 1),#colorLiteral(red: 0.4156862745, green: 0.7568627451, blue: 0.9490196078, alpha: 1),#colorLiteral(red: 0.6862745098, green: 0.4823529412, blue: 0.9137254902, alpha: 1),#colorLiteral(red: 0.6862745098, green: 0.4823529412, blue: 0.9137254902, alpha: 1),#colorLiteral(red: 1, green: 0.5294117647, blue: 0.2745098039, alpha: 1),#colorLiteral(red: 1, green: 0.5294117647, blue: 0.2745098039, alpha: 1)]
    
    let chartData = BarChartData(dataSet: chartDataSet)
    chartData.barWidth = 6
    
    self.barChart.data = chartData
    barChart.setNeedsDisplay()
  }
  
  func updateData(data: DetailResult.Data){
    
    
    self.maleCount = 0
    self.femaleCount = 0
    var maxCount: Double = 0
    
    var male: [Int:Double] = [:]
    var female: [Int:Double] = [:]
    
    for data in data.gender_age{
      log.info(data)
      let dataCount = Double(data.count) ?? 0
      maxCount = (maxCount > dataCount) ? maxCount : dataCount
      
      
      switch data.category {
      case "male_10":
        male[10] = Double(data.count)
        maleCount += Double(data.count) ?? 0
      case "male_20":
        male[20] = Double(data.count)
        maleCount += Double(data.count) ?? 0
      case "male_30":
        male[30] = Double(data.count)
        maleCount += Double(data.count) ?? 0
      case "male_40":
        male[40] = Double(data.count)
        maleCount += Double(data.count) ?? 0
      case "male_50":
        male[50] = Double(data.count)
        maleCount += Double(data.count) ?? 0
      case "male_60","male_70","male_80","male_90":
        male[60] = Double(data.count)
        maleCount += Double(data.count) ?? 0
      case "female_10":
        female[10] = Double(data.count)
        femaleCount += Double(data.count) ?? 0
      case "female_20":
        female[20] = Double(data.count)
        femaleCount += Double(data.count) ?? 0
      case "female_30":
        female[30] = Double(data.count)
        femaleCount += Double(data.count) ?? 0
      case "female_40":
        female[40] = Double(data.count)
        femaleCount += Double(data.count) ?? 0
      case "female_50":
        female[50] = Double(data.count)
        femaleCount += Double(data.count) ?? 0
      case "female_60","female_70","female_80","female_90":
        female[60] = Double(data.count)
        femaleCount += Double(data.count) ?? 0
      default:
        break
      }
    }
    maxCount += 1
    self.barChart.leftAxis.axisMaximum = maxCount
    self.barChart.leftAxis.axisMinimum = -maxCount
    self.barChart.rightAxis.axisMinimum = -maxCount
    self.barChart.rightAxis.axisMaximum = maxCount
    
    setChart(male: male, female: female)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


