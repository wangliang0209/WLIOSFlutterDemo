//
//  FlutterAgent.swift
//  wltest
//
//  Created by 王亮 on 2021/10/27.
//

import UIKit
import Flutter

public class FlutterAgent: NSObject {

    private static let engineIdPrefix = "oda_class_engine_"
    static let methodChannel = "pigeon_oda_class"

    static let routePage1 = "page_1"
    static let routePage2 = "page_2"

    private let routeList = [routePage1, routePage2]

    public static let shared = FlutterAgent()

    private var flutterEngineDict = Dictionary<String, FlutterEngine>()

    private override init() {
        super.init()
    }

    private func flutterEngineId(route: String) -> String {
        return "\(FlutterAgent.engineIdPrefix)\(route)"
    }

    public func initEngine() {
        routeList.forEach { route in
            let engineId: String = flutterEngineId(route: route)
            let flutterEngine = FlutterEngine(name: engineId)
            flutterEngine.run(withEntrypoint: nil, initialRoute: route)
            flutterEngineDict[engineId] = flutterEngine
        }
    }

    public func getFlutterEngine(route: String) -> FlutterEngine? {
        return flutterEngineDict[flutterEngineId(route: route)]
    }

}
