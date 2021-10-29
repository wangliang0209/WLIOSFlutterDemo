//
//  PigeonCheckinNewCollectionViewCell.swift
//  TutorLiveSwift
//
//  Created by 王亮 on 2021/6/29.
//

import UIKit

class PigeonCheckinNewCollectionViewCell: UICollectionViewCell {
    static let identifier = "PigeonGradeViewOptionCell"

    let oneFrame = 1.0 / 24.0 // 1帧的时间

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUserInterface() {
        self.contentView.addSubview(self.topBgView)
        self.contentView.addSubview(self.coinDescView)
        self.contentView.addSubview(self.signInIconView)
        self.contentView.addSubview(self.descView)
        self.contentView.addSubview(self.signInCompletedView)
        self.contentView.addSubview(self.missedStatusView)

        self.topBgView.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(76)
            make.top.leading.trailing.equalToSuperview()
        }

        self.coinDescView.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }

        self.signInIconView.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.topBgView.snp_bottom)
        }

        self.descView.snp.makeConstraints { make in
            make.top.equalTo(self.topBgView.snp_bottom).offset(6)
            make.centerX.equalToSuperview()
        }

        self.signInCompletedView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(self.topBgView.snp_bottom)
        }

        self.missedStatusView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.topBgView)
        }
    }

    private lazy var topBgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 4
        bgView.clipsToBounds = true
        return bgView
    }()

    private lazy var coinDescView: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.init(red: 0.98, green: 0.42, blue: 0.04, alpha: 1.0)
        return label
    }()

    private lazy var signInIconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var descView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        return label
    }()

    private lazy var signInCompletedView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "tutor_live_signed_icon")
        imageView.isHidden = true
        return imageView
    }()

    private lazy var missedStatusView: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Missed"
        label.backgroundColor = UIColor.init(red: 0.11, green: 0.11, blue: 0.11, alpha: 0.4)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()

    func setItem(item: SignInItemInfo, index: Int, curEpisodeId: Int) {
        self.topBgView.layer.removeAllAnimations()

        var iconImageName = ""

        if item.bigRewards {
            iconImageName = "tutor_live_big_rewards_icon"
        } else {
            if item.multiple == 1 {
                iconImageName = "tutor_live_one_times_icon"
            } else if item.multiple == 2 {
                iconImageName = "tutor_live_two_times_icon"
            } else if item.multiple == 3 {
                iconImageName = "tutor_live_three_times_icon"
            } else if item.multiple >= 4 {
                iconImageName = "tutor_live_four_and_more_times_icon"
            }
        }
        self.signInIconView.image = UIImage.init(named: iconImageName)
        var coinDesc: String = ""
        if(item.status == SignInStatus.signed) {
            coinDesc = "+\(item.coinCount)"
        } else {
            coinDesc = "\(item.multiple)X"
        }
        self.coinDescView.text = coinDesc

        self.signInCompletedView.isHidden = item.status != .signed
        self.missedStatusView.isHidden = item.status != .missed

        if(curEpisodeId != item.episodeId || item.status != .inComing) {
            if(item.status == .signed) {
                self.topBgView.backgroundColor = UIColor.init(red: 1.0, green: 0.94, blue: 0.85, alpha: 1.0)
            } else {
                self.topBgView.backgroundColor = UIColor.init(red: 0.92, green: 0.97, blue: 1.0, alpha: 1.0)
            }
            self.descView.text = "Session \(index + 1)"
            self.descView.textColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
            self.coinDescView.textColor = UIColor.init(red: 0.98, green: 0.42, blue: 0.04, alpha: 1.0)
        } else {
            self.topBgView.backgroundColor = UIColor.init(red: 0.27, green: 0.72, blue: 1.0, alpha: 1.0)
            self.topBgView.alpha = 0.7
            self.descView.text = "Check-in"
            self.descView.textColor = UIColor.init(red: 0.27, green: 0.72, blue: 1.0, alpha: 1.0)
            self.coinDescView.textColor = UIColor.white

            // BG动画
            self.startHeartBeatAnim()
        }
    }

    private func startHeartBeatAnim() {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeLinear, .repeat, .allowUserInteraction]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.oneFrame * 8) {
                self.topBgView.layer.opacity = 0.7
            }
            UIView.addKeyframe(withRelativeStartTime: self.oneFrame * 8, relativeDuration: self.oneFrame * 4) {
                self.topBgView.layer.opacity = 1.0
            }
            UIView.addKeyframe(withRelativeStartTime: self.oneFrame * 12, relativeDuration: self.oneFrame * 4) {
                self.topBgView.layer.opacity = 1.0
            }
            UIView.addKeyframe(withRelativeStartTime: self.oneFrame * 16, relativeDuration: self.oneFrame * 4) {
                self.topBgView.layer.opacity = 0.7
            }
            UIView.addKeyframe(withRelativeStartTime: self.oneFrame * 20, relativeDuration: self.oneFrame * 8) {
                self.topBgView.layer.opacity = 0.7
            }
            UIView.addKeyframe(withRelativeStartTime: self.oneFrame * 28, relativeDuration: self.oneFrame * 4) {
                self.topBgView.layer.opacity = 1.0
            }
            UIView.addKeyframe(withRelativeStartTime: self.oneFrame * 32, relativeDuration: self.oneFrame * 4) {
                self.topBgView.layer.opacity = 1.0
            }
            UIView.addKeyframe(withRelativeStartTime: self.oneFrame * 36, relativeDuration: self.oneFrame * 4) {
                self.topBgView.layer.opacity = 0.7
            }
        } completion: { _ in
        }
    }
}
