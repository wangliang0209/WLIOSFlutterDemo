//
//  PigeonCheckInNewView.swift
//  TutorLiveSwift
//
//  Created by 王亮 on 2021/7/1.
//

import UIKit

class PigeonCheckInNewView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    fileprivate let collectionViewMaxWidth: Int = 5 * 48 + 5 * 12 + 24
    fileprivate let cardMinWidth: Int = 353
    private var array: NSMutableArray = []
    private var curEpisodeId: Int = -1
    private var currentEpisodeSignInItem: SignInItemInfo? = nil
    private var nextEpisodeSignInItem: SignInItemInfo? = nil
    private var preEpisodeSignInItem: SignInItemInfo? = nil
    private var bigRewardMultiplier: Int = -1

    @objc
    public init() {
        super.init(frame: .zero)
        self.setupUserInterface()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUserInterface() {
        self.isHidden = true
        self.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)

        self.addSubview(self.cardBgView)
        self.cardBgView.addSubview(self.topTitleView)
        self.cardBgView.addSubview(self.checkInCollectionView)
        self.cardBgView.addSubview(self.leftArrowBtn)
        self.cardBgView.addSubview(self.rightArrowBtn)
        self.cardBgView.addSubview(self.tipsView)

        self.cardBgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.cardMinWidth)
            make.height.equalTo(227)
        }

        self.topTitleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.centerX.equalToSuperview()
        }

        self.checkInCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.topTitleView.snp_bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(94)
            make.width.equalTo(0)
        }

        self.leftArrowBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.checkInCollectionView)
            make.leading.equalTo(self.checkInCollectionView).offset(-20)
            make.height.equalTo(20)
            make.width.equalTo(13)
        }

        self.rightArrowBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.checkInCollectionView)
            make.trailing.equalTo(self.checkInCollectionView).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(13)
        }

        self.tipsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.checkInCollectionView.snp_bottom).offset(20)
        }

        let leftTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(doScrollLeft))
        self.leftArrowBtn.addGestureRecognizer(leftTapGesture)
        self.leftArrowBtn.isUserInteractionEnabled = true

        let rightTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(doScrollRight))
        self.rightArrowBtn.addGestureRecognizer(rightTapGesture)
        self.rightArrowBtn.isUserInteractionEnabled = true
    }

    private lazy var cardBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()

    private lazy var topTitleView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.init(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "More Check-in More Coins"
        return label
    }()

    private lazy var checkInCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 48, height: 94)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(PigeonCheckinNewCollectionViewCell.self,
                      forCellWithReuseIdentifier: PigeonCheckinNewCollectionViewCell.identifier)
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    lazy var leftArrowBtn: UIImageView = {
        let btn = UIImageView()
        btn.isHidden = true
        btn.image = UIImage.init(named: "tutor_live_signin_left_arrow")
        return btn
    }()

    lazy var rightArrowBtn: UIImageView = {
        let btn = UIImageView()
        btn.isHidden = true
        btn.image = UIImage.init(named: "tutor_live_signin_right_arrow")
        return btn
    }()

    lazy var tipsView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor =  UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        return label
    }()

    private func layoutCollectionView() {
        let actWidth = self.array.count * 48 + (self.array.count - 1) * 12
        let width: CGFloat = CGFloat(min(collectionViewMaxWidth, actWidth))
        let bgWidth: CGFloat = CGFloat(max(cardMinWidth, Int(width) + 32 * 2))
        self.checkInCollectionView.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
        self.cardBgView.snp.updateConstraints { make in
            make.width.equalTo(bgWidth)
        }
    }

    private func getDstPos(toLeft: Bool) -> Int {
        var visibleCellIndex = self.checkInCollectionView.indexPathsForVisibleItems
        visibleCellIndex.sort(by: { pre, nxt in
            pre.row < nxt.row
        })
        let firstIndex = visibleCellIndex.first?.row ?? 0
        let lastIndex = visibleCellIndex.last?.row ?? 0
        let visibleCount = lastIndex - firstIndex
        if(toLeft) {
            return max(0, firstIndex - visibleCount/2 + 1)
        } else {
            return min(self.array.count - 1, lastIndex + visibleCount/2 - 1)
        }
    }

    @objc func doScrollLeft() {
        let dstPos = self.getDstPos(toLeft: true)
        let indexPath = IndexPath.init(row: dstPos, section: 0)
        self.checkInCollectionView.scrollToItem(at: indexPath,
                                                at: UICollectionView.ScrollPosition.centeredHorizontally,
                                                animated: true)
    }

    @objc func doScrollRight() {
        let dstPos = self.getDstPos(toLeft: false)
        let indexPath = IndexPath.init(row: dstPos, section: 0)
        self.checkInCollectionView.scrollToItem(at: indexPath,
                                                at: UICollectionView.ScrollPosition.centeredHorizontally,
                                                animated: true)
    }

    func autoScrollCenter() {
        let indexPath = IndexPath.init(row: self.array.count/2, section: 0)
        self.checkInCollectionView.scrollToItem(at: indexPath,
                                                at: UICollectionView.ScrollPosition.centeredHorizontally,
                                                animated: true)
    }

    func updateData(array: NSArray, curEpisodeId: Int) {
        self.array.removeAllObjects()
        self.curEpisodeId = curEpisodeId
        for item in array {
            self.array.add(item)
        }

        // 初始化所需的数据
        let curEpisodeIndex = self.getCurEpisodeIndex()
        if curEpisodeIndex >= 0 && curEpisodeIndex < self.array.count {
            currentEpisodeSignInItem = self.array[curEpisodeIndex] as? SignInItemInfo
        }
        if curEpisodeIndex >= 0 && curEpisodeIndex < self.array.count - 1 {
            nextEpisodeSignInItem = self.array[curEpisodeIndex + 1] as? SignInItemInfo
        }

        if(curEpisodeIndex > 0) {
            preEpisodeSignInItem = self.array[curEpisodeIndex - 1] as? SignInItemInfo
        }

        bigRewardMultiplier = getFirstBigRewards()

        self.layoutCollectionView()
        self.checkInCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.autoScrollCenter()
        }

        handleTips()
    }

    private func handleTips() {
        let missed = currentEpisodeSignInItem?.status == .missed || preEpisodeSignInItem?.status == .missed
        if missed {
            self.tipsView.text = "Attend LIVE before the session starts to win Oda Coin!"
        } else if preEpisodeSignInItem?.bigRewards != false {
            if bigRewardMultiplier <= 0 {
                self.tipsView.text = "Attend LIVE before the session starts to win Oda Coin!"
            } else {
                self.tipsView.text = "Congrats! Continuous check-in wins 5 times of Oda Coin!"
            }
        } else {
            self.tipsView.text = "You'll get n times of Oda Coin in the next session!"
        }
    }

    private func getFirstBigRewards() -> Int {
        let arrayCount = self.array.count
        for index in 0..<arrayCount {
            let item : SignInItemInfo = self.array[index] as! SignInItemInfo
            if item.bigRewards {
                return item.multiple
            }
        }

        return -1
    }


    private func getCurEpisodeIndex() -> Int {
        let arrayCount = self.array.count
        for index in 0..<arrayCount {
            let item : SignInItemInfo = self.array[index] as! SignInItemInfo
            if item.episodeId == curEpisodeId {
                return index
            }
        }
        return -1
    }

///MARK UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PigeonCheckinNewCollectionViewCell.identifier,
                                                            for: indexPath) as? PigeonCheckinNewCollectionViewCell else {
            return PigeonCheckinNewCollectionViewCell()
        }

        let item = self.array[indexPath.row] as! SignInItemInfo
        cell.setItem(item: item, index: indexPath.row, curEpisodeId: 3)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }

///MARK UIScrollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.size.width
        let scrollContentSizeWidth = scrollView.contentSize.width
        let scrollOffset = scrollView.contentOffset.x
        if scrollOffset == 0 {
            self.leftArrowBtn.isHidden = true
        } else {
            self.leftArrowBtn.isHidden = false
        }

        if scrollOffset + scrollViewWidth >= scrollContentSizeWidth {
            self.rightArrowBtn.isHidden = true
        } else {
            self.rightArrowBtn.isHidden = false
        }
    }
}
