//
//  ViewController.swift
//  CustomPullRefresh
//
//  Created by Vinte1 on 2019/8/13.
//  Copyright © 2019 Vinte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mojiTableView: UITableView!
    var dataArray: Array<String> = ["😂", "🤗", "😳", "😌", "😊"]
    
    var refreshController: UIRefreshControl!
    var customView : UIView!
    var labelsArray : Array<UILabel> = []
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var timer: Timer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mojiTableView.delegate = self
        mojiTableView.dataSource = self
        
        refreshController = UIRefreshControl()
        refreshController.backgroundColor = UIColor.clear
        refreshController.tintColor = UIColor.clear
        mojiTableView.addSubview(refreshController)
        
        loadCustomRefreshContents();
        
    }

    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        customView = refreshContents?[0] as? UIView
        customView.center = refreshController.center
        customView.frame = refreshController.bounds
        
        for i in 0..<customView.subviews.count {
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        refreshController.addSubview(customView)
    }

    
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
        }) { _ in
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveLinear, animations: {
                self.labelsArray[self.currentLabelIndex].transform = .identity
                self.labelsArray[self.currentLabelIndex].textColor = UIColor.black
            }, completion: { _ in
                self.currentLabelIndex += 1
                if self.currentLabelIndex < self.labelsArray.count {
                    self.animateRefreshStep1()
                }else {
                    self.animateRefreshStep2()
                }
            })
        }
    }
    
    func animateRefreshStep2() {
        UIView.animate(withDuration: 0.40, delay: 0.0, options: .curveLinear, animations: {
            let scale = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[1].transform = scale
            self.labelsArray[2].transform = scale
            self.labelsArray[3].transform = scale
            self.labelsArray[4].transform = scale
            self.labelsArray[5].transform = scale
            self.labelsArray[6].transform = scale
            self.labelsArray[7].transform = scale
            self.labelsArray[8].transform = scale
            self.labelsArray[9].transform = scale
            self.labelsArray[10].transform = scale
            self.labelsArray[11].transform = scale
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                self.labelsArray[0].transform = .identity
                self.labelsArray[1].transform = .identity
                self.labelsArray[2].transform = .identity
                self.labelsArray[3].transform = .identity
                self.labelsArray[4].transform = .identity
                self.labelsArray[5].transform = .identity
                self.labelsArray[6].transform = .identity
                self.labelsArray[7].transform = .identity
                self.labelsArray[8].transform = .identity
                self.labelsArray[9].transform = .identity
                self.labelsArray[10].transform = .identity
                self.labelsArray[11].transform = .identity
                
            }, completion: { _ in
                if self.refreshController.isRefreshing {
                    self.currentLabelIndex = 0
                    self.animateRefreshStep1()
                } else {
                    self.isAnimating = false
                    self.currentLabelIndex = 0
                    for i in 0 ..< self.labelsArray.count {
                        self.labelsArray[i].textColor = UIColor.black
                        self.labelsArray[i].transform = .identity
                    }
                }
            })
        })
    }
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [.magenta, .brown, .yellow,
                                           .red, .green, .blue, .orange]
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        return returnColor
    }
    
    func doSomething() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.endedOfWork), userInfo: nil, repeats: true)
    }
    
    @objc func endedOfWork() {
        refreshController.endRefreshing()
        timer.invalidate()
        timer = nil
    }
    
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing {
            if !isAnimating {
                doSomething()
                animateRefreshStep1()
            }
        }
    }
}

extension ViewController : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel!.text = dataArray[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Apple Color Emoji", size: 40)
        cell.textLabel!.textAlignment = .center
        
        return cell
    }
    
    
}
