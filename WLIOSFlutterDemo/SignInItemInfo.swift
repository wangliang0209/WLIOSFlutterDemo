//
//  SignInItemInfo.swift
//  TutorLiveSwift
//
//  Created by 王亮 on 2021/6/30.
//

enum SignInStatus: String {
    case unknown = ""
    case missed = "missed"
    case signed = "signed"
    case inComing = "inComing"
}

struct SignInItemInfo {
    var bigRewards: Bool
    var coinCount: Int
    var episodeId: Int
    var status: SignInStatus
    var multiple: Int

    init(bigRewards: Bool, coinCount: Int, episodeId: Int, status: SignInStatus, multiple: Int) {
        self.bigRewards = bigRewards
        self.coinCount = coinCount
        self.episodeId = episodeId
        self.status = status
        self.multiple = multiple
    }
}
