//
//  ProfileViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import Charts

@objc(BarChartFormatter)
class ChartFormatter:NSObject,IAxisValueFormatter {
  
  var months: [String]! = ["Oca", "Şub", "Mar", "Nis", "May", "Haz", "Tem", "Ağu", "Eyl", "Eki", "Kas", "Ara"]
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return months[Int(value) - 1]
  }
}

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var monthlyChart: BarChartView!
  @IBOutlet weak var weeklyChart: LineChartView!
  @IBOutlet weak var categoryChart: PieChartView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup(barChartView: monthlyChart)
    setup(lineChartView: weeklyChart)
    setup(pieChartView: categoryChart)

    // Do any additional setup after loading the view.
  }
  
  func setup(barChartView chartView: BarChartView) {
    // SET DATA
    var dataEntries:[BarChartDataEntry] = []
    var colors:[UIColor] = []
    colors += ChartColorTemplates.vordiplom()
    colors += ChartColorTemplates.joyful()
    colors += ChartColorTemplates.colorful()
    colors += ChartColorTemplates.liberty()
    colors += ChartColorTemplates.pastel()
    colors += [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
    
    
    dataEntries.append(BarChartDataEntry(x: 1, y: 200))
    dataEntries.append(BarChartDataEntry(x: 2, y: 100))
    dataEntries.append(BarChartDataEntry(x: 3, y: 150))
    dataEntries.append(BarChartDataEntry(x: 4, y: 400))
    dataEntries.append(BarChartDataEntry(x: 5, y: 300))
    
    let dataSet = BarChartDataSet(values: dataEntries, label: "Kategoriler")
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
    
    let chartFormmater = ChartFormatter()
    chartView.xAxis.valueFormatter = chartFormmater

    chartView.legend.enabled = false

    chartView.data = data
  }

  func setup(lineChartView chartView: LineChartView) {
    // SET DATA
    var dataEntries:[ChartDataEntry] = []
    
    dataEntries.append(ChartDataEntry(x: 1, y: 200))
    dataEntries.append(ChartDataEntry(x: 2, y: 100))
    dataEntries.append(ChartDataEntry(x: 3, y: 150))
    dataEntries.append(ChartDataEntry(x: 4, y: 400))
    dataEntries.append(ChartDataEntry(x: 5, y: 300))
    
    let dataSet = LineChartDataSet(values: dataEntries, label: "Haftalar")
    dataSet.drawValuesEnabled = false
    
    var color = ChartColorTemplates.vordiplom()[0]
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
    
    let chartFormmater = ChartFormatter()
    chartView.xAxis.valueFormatter = chartFormmater
    
    chartView.legend.enabled = false
    
    chartView.data = data
  }

  func setup(pieChartView chartView: PieChartView) {
    // SET DATA
    var dataEntries:[PieChartDataEntry] = []
    var colors:[UIColor] = []
    colors += ChartColorTemplates.vordiplom()
    colors += ChartColorTemplates.joyful()
    colors += ChartColorTemplates.colorful()
    colors += ChartColorTemplates.liberty()
    colors += ChartColorTemplates.pastel()
    colors += [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
    
    
    dataEntries.append(PieChartDataEntry(value: Double(20), label: "Yemek"))
    dataEntries.append(PieChartDataEntry(value: Double(16), label: "Market"))
    dataEntries.append(PieChartDataEntry(value: Double(54), label: "Akaryakıt"))
    dataEntries.append(PieChartDataEntry(value: Double(12), label: "İçecek"))
    dataEntries.append(PieChartDataEntry(value: Double(43), label: "Oyuncak"))
    
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
