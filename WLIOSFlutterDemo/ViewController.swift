//
//  ViewController.swift
//  wltest
//
//  Created by 王亮 on 2021/6/11.
//

import UIKit
import SnapKit
import Flutter

class ViewController: UIViewController {

    private lazy var testFlutterBtn: UIButton = {
        let res = UIButton()
        res.setTitle("测试Flutter Page 1", for: .normal)
        res.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        res.addTarget(self, action: #selector(gotoFlutterPage1), for: .touchUpInside)
        return res
    }()

    private lazy var testFlutterBtn2: UIButton = {
        let res = UIButton()
        res.setTitle("测试Flutter Page 2", for: .normal)
        res.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        res.addTarget(self, action: #selector(gotoFlutterPage2), for: .touchUpInside)
        return res
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(testFlutterBtn)
        testFlutterBtn.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(150)
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(self.view).offset(20)
        }

        self.view.addSubview(testFlutterBtn2)
        testFlutterBtn2.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(160)
            make.top.equalTo(testFlutterBtn.snp.bottom).offset(20)
            make.leading.equalTo(self.view).offset(20)
        }

        self.navigationItem.title = "Demo 首页"
    }

    @objc func gotoFlutterPage1() {
        let flutterVC = PigeonFlutterViewController(route: FlutterAgent.routePage1)
        self.navigationController?.pushViewController(flutterVC, animated: true)
    }

    @objc func gotoFlutterPage2() {
        let flutterVC = PigeonFlutterViewController(route: FlutterAgent.routePage2)
        self.navigationController?.pushViewController(flutterVC, animated: true)
    }
    
}
