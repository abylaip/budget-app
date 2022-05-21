//
//  ReportViewController.swift
//  budget-app
//
//  Created by gumball on 5/9/22.
//

import UIKit
import Charts
import FirebaseAuth
import FirebaseFirestore

class ReportViewController: UIViewController {

    @IBOutlet weak var reportScrollView: UIScrollView!
    @IBOutlet weak var reportChart: PieChartView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    var chartLabels = ["Income", "Expense"]
    var incomeValue: Int = 0
    var expenseValue: Int = 0
    var chartValues: [Int] = []
    var parsed: Bool = false
    
    let database = Firestore.firestore()
    
    let refreshControl = UIRefreshControl()
    
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }
        
        parseHistory()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        reportScrollView.addSubview(refreshControl)
        reportScrollView.refreshControl = refreshControl
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        parseHistory()
        refreshControl.endRefreshing()
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
      // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
      pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
      format.numberStyle = .none
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      // 4. Assign it to the chart’s data
      reportChart.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      let color1 = UIColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
      let color2 = UIColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
      colors.append(color1)
      colors.append(color2)
      return colors
    }
    
    func parseHistory() {
        incomeValue = 0
        expenseValue = 0
        chartValues.removeAll()
        let expensesDoc = database.collection("history")
        expensesDoc.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.parsed = true
                for document in querySnapshot!.documents {
                    if document.data()["uuid"] as! String == self.uid {
                        if document.data()["operation"] as! String == "Income" {
                            self.incomeValue += Int(document.data()["money"]! as! String) ?? 0
                        }
                        if document.data()["operation"] as! String == "Expense" {
                            self.expenseValue += Int(document.data()["money"]! as! String) ?? 0
                        }
                    }
                }
                self.chartValues.append(self.incomeValue)
                self.chartValues.append(self.expenseValue)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if self.parsed == true {
                        self.customizeChart(dataPoints: self.chartLabels, values: self.chartValues.map{ Double($0) })
                    }
                }
                self.incomeLabel.text = "+ $" + String(self.incomeValue)
                self.expenseLabel.text = "- $" + String(self.expenseValue)
                self.totalLabel.text = "$" + String(self.incomeValue - self.expenseValue)
            }
        }
    }
    
}
