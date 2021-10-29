//
//  MyTableViewController.swift
//  wltest
//
//  Created by 王亮 on 2021/6/28.
//

import UIKit
import SnapKit

class MyTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.title = "Table View"
    }

//MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "testCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if(cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }

        cell?.textLabel?.text = "这是个标题~"
        cell?.detailTextLabel?.text = "这里是内容"
        return cell!
    }

//MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
