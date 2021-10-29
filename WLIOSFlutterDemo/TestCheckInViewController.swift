//
//  TestCollectionViewController.swift
//  wltest
//
//  Created by 王亮 on 2021/6/29.
//

import UIKit

class TestCheckInViewController: UIViewController {

    private var array: NSMutableArray = []

    private lazy var checkInView: PigeonCheckInNewView = {
        let view = PigeonCheckInNewView.init()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.green

        self.view.addSubview(self.checkInView)

        self.checkInView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(100)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottom)
        }

        self.checkInView.isHidden = false
        self.checkInView.alpha = 0
        self.checkInView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5, animations: {
            self.checkInView.transform = CGAffineTransform.identity
            self.checkInView.alpha = 1
        })



        self.testLoadData()
    }

    private func testLoadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 1, status: .missed, multiple: 2))
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 2, status: .signed, multiple: 1))
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 3, status: .inComing, multiple: 2))
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 4, status: .unknown, multiple: 3))
            self.array.add(SignInItemInfo.init(bigRewards: true, coinCount: 10, episodeId: 5, status: .unknown, multiple: 5))
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 6, status: .unknown, multiple: 1))
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 7, status: .unknown, multiple: 2))
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 8, status: .unknown, multiple: 3))
            self.array.add(SignInItemInfo.init(bigRewards: true, coinCount: 10, episodeId: 9, status: .unknown, multiple: 5))
            self.array.add(SignInItemInfo.init(bigRewards: false, coinCount: 10, episodeId: 9, status: .unknown, multiple: 4))
            self.checkInView.updateData(array: self.array, curEpisodeId: 3)
        }

    }
}
