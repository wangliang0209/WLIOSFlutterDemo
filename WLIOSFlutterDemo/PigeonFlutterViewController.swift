//
//  PigeonFlutterViewController.swift
//  wltest
//
//  Created by 王亮 on 2021/10/27.
//

import UIKit
import Flutter

class PigeonFlutterViewController: FlutterViewController {

    var methodChannel : FlutterMethodChannel?

    private var route: String;

    public init(route: String) {
        self.route = route
        super.init(engine: FlutterAgent.shared.getFlutterEngine(route: route)!, nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        if let flutterEngine = FlutterAgent.shared.getFlutterEngine(route: route) {
            NSLog("WLTest init method channel \(route)")
            methodChannel = FlutterMethodChannel(name: FlutterAgent.methodChannel,
                                                 binaryMessenger: flutterEngine.binaryMessenger)
            methodChannel?.setMethodCallHandler({ [weak self]
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                guard let self = self else { return }
                switch (call.method) {
                case "goBack":
                    let arguments = call.arguments as? String ?? ""
                    NSLog("WLTest argments \(arguments)")
                    self.navigationController?.popViewController(animated: true)
                default:
                        NSLog("the method \(call.method) not implements")
                }
            })
        }

    }

}
