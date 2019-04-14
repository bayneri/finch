//
//  ProfileViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

@objc(BarChartFormatter)
class MonthFormatter:NSObject,IAxisValueFormatter {
  
  var months: [String]! = ["Kas", "Ara", "Oca", "Şub", "Mar", "Nis", "May"]
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return months[Int(value) - 1]
  }
}

@objc(LineChartFormatter)
class WeekFormatter:NSObject,IAxisValueFormatter {
  
  var months: [String]! = ["Kas", "Ara", "Oca", "Şub", "Mar", "Nis", "May"]
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return "\(months![Int(ceil(value/4) - 1)]) - \(Int(value) % 4 == 0 ? 4 : Int(value) % 4)"
  }
}

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var monthlyChart: BarChartView!
  @IBOutlet weak var weeklyChart: LineChartView!
  @IBOutlet weak var categoryChart: PieChartView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchChartData()
    
    // Left button
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchChartData))
  }
  
  @objc func fetchChartData() {
    self.showHUD("Grafikler yükleniyor")
    UserAPI.getProfile({ monthly, weekly, category in
      self.hideHUD()
      self.setup(barChartView: self.monthlyChart, data:monthly)
      self.setup(lineChartView: self.weeklyChart, data:weekly)
      self.setup(pieChartView: self.categoryChart, data:category)
    }, failure: {error in
      self.hideHUD()
    })
    
  }
  
  func setup(barChartView chartView: BarChartView, data:JSON) {
    // SET DATA
    var dataEntries:[BarChartDataEntry] = []
    var colors:[UIColor] = []
    colors += ChartColorTemplates.vordiplom()
    colors += ChartColorTemplates.joyful()
    colors += ChartColorTemplates.colorful()
    colors += ChartColorTemplates.liberty()
    colors += ChartColorTemplates.pastel()
    colors += [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
    
    dataEntries.append(BarChartDataEntry(x: 6, y: data["4"].doubleValue))
    dataEntries.append(BarChartDataEntry(x: 5, y: data["3"].doubleValue))
    dataEntries.append(BarChartDataEntry(x: 4, y: data["2"].doubleValue))
    dataEntries.append(BarChartDataEntry(x: 3, y: data["1"].doubleValue))
    dataEntries.append(BarChartDataEntry(x: 2, y: data["12"].doubleValue))
    dataEntries.append(BarChartDataEntry(x: 1, y: data["11"].doubleValue))
    
    //    for (month, value):(String, JSON) in data {
    //      dataEntries.append(BarChartDataEntry(x: Double(month)!, y: value.doubleValue))
    //    }
    
    let dataSet = BarChartDataSet(values: dataEntries, label: "Aylar")
    dataSet.colors = colors
    dataSet.drawValuesEnabled = false
    
    let data = BarChartData(dataSet: dataSet)
    chartView.data = data
    chartView.fitBars = true
    chartView.dragEnabled = false
    chartView.setScaleEnabled(false)
    chartView.pinchZoomEnabled = false
    chartView.leftAxis.drawGridLinesEnabled = false
    chartView.xAxis.drawGridLinesEnabled = false
    chartView.rightAxis.enabled = false
    chartView.setNeedsDisplay()
    
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.minimumFractionDigits = 0
    leftAxisFormatter.maximumFractionDigits = 1
    leftAxisFormatter.negativeSuffix = "₺"
    leftAxisFormatter.positiveSuffix = "₺"
    chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    
    
    // SET VIEW
    chartView.chartDescription?.enabled = false
    chartView.maxVisibleCount = 60
    chartView.pinchZoomEnabled = false
    chartView.drawBarShadowEnabled = false
    
    let xAxis = chartView.xAxis
    xAxis.labelPosition = .bottom
    
    let chartFormmater = MonthFormatter()
    chartView.xAxis.valueFormatter = chartFormmater
    
    chartView.legend.enabled = false
    
    chartView.data = data
  }
  
  func setup(lineChartView chartView: LineChartView, data:JSON) {
    // SET DATA
    var dataEntries:[ChartDataEntry] = []
    
    for i in 45...52 {
      dataEntries.append(ChartDataEntry(x: Double(i - 44), y: data[String(i)].doubleValue))
    }
    
    for i in 1...12 {
      dataEntries.append(ChartDataEntry(x: Double(i + 8), y: data[String(i)].doubleValue))
    }
    
    
    let dataSet = LineChartDataSet(values: dataEntries, label: "Haftalar")
    dataSet.drawValuesEnabled = false
    
    let color = ChartColorTemplates.vordiplom()[0]
    dataSet.setColor(color)
    dataSet.circleRadius = 2
    dataSet.setCircleColor(color)
    dataSet.lineWidth = 1
    dataSet.drawCircleHoleEnabled = false
    
    dataSet.fillAlpha = 0.8
    dataSet.fill = Fill(color: color)
    dataSet.drawFilledEnabled = true
    
    let data = LineChartData(dataSet: dataSet)
    chartView.data = data
    chartView.dragEnabled = false
    chartView.setScaleEnabled(false)
    chartView.pinchZoomEnabled = false
    chartView.leftAxis.drawGridLinesEnabled = false
    chartView.xAxis.drawGridLinesEnabled = false
    chartView.rightAxis.enabled = false
    chartView.setNeedsDisplay()
    
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.minimumFractionDigits = 0
    leftAxisFormatter.maximumFractionDigits = 1
    leftAxisFormatter.negativeSuffix = "₺"
    leftAxisFormatter.positiveSuffix = "₺"
    chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    
    
    // SET VIEW
    chartView.chartDescription?.enabled = false
    chartView.maxVisibleCount = 60
    chartView.pinchZoomEnabled = false
    
    let xAxis = chartView.xAxis
    xAxis.labelPosition = .bottom
    
    let chartFormmater = WeekFormatter()
    chartView.xAxis.valueFormatter = chartFormmater
    
    chartView.legend.enabled = false
    
    chartView.data = data
  }
  
  func setup(pieChartView chartView: PieChartView, data:JSON) {
    // SET DATA
    var dataEntries:[PieChartDataEntry] = []
    var colors:[UIColor] = []
    colors += ChartColorTemplates.vordiplom()
    colors += ChartColorTemplates.joyful()
    colors += ChartColorTemplates.colorful()
    colors += ChartColorTemplates.liberty()
    colors += ChartColorTemplates.pastel()
    colors += [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
    
    
    for (category, value):(String, JSON) in data {
      dataEntries.append(PieChartDataEntry(value: value.doubleValue, label: category))
    }
    let pieDataSet = PieChartDataSet(values: dataEntries, label: "Kategoriler")
    pieDataSet.colors = colors
    pieDataSet.drawValuesEnabled = true
    pieDataSet.yValuePosition = .outsideSlice
    pieDataSet.xValuePosition = .outsideSlice
    
    let pieData = PieChartData()
    pieData.addDataSet(pieDataSet)
    
    let pFormatter = NumberFormatter()
    pFormatter.numberStyle = .percent
    pFormatter.maximumFractionDigits = 1
    pFormatter.multiplier = 1
    pFormatter.percentSymbol = " %"
    pieData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
    pieData.setValueFont(.systemFont(ofSize: 11, weight: .light))
    pieData.setValueTextColor(.black)
    
    
    // SET VIEW
    chartView.usePercentValuesEnabled = true
    chartView.drawSlicesUnderHoleEnabled = false
    chartView.holeRadiusPercent = 0.58
    chartView.transparentCircleRadiusPercent = 0.61
    chartView.chartDescription?.enabled = false
    //    chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
    chartView.drawEntryLabelsEnabled = true
    
    chartView.drawCenterTextEnabled = false
    
    
    chartView.drawHoleEnabled = true
    chartView.rotationAngle = 0
    chartView.rotationEnabled = false
    chartView.highlightPerTapEnabled = false
    chartView.legend.enabled = false
    
    // entry label styling
    chartView.entryLabelColor = .white
    chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
    chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    
    chartView.data = pieData
  }
  
  // MARK: - Actions
  
  @IBAction func logout(_ sender: Any) {
    self.showHUD("Çıkış Yapılıyor")
    UserDataManager.deleteUser()
    SessionManager.deleteSession()
    self.hideHUD()
    UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
  }
}
