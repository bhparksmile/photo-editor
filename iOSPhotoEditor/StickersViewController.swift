//
//  StickersViewController.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/11.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit
import SDWebImage


class StickersViewController: UIViewController {
    
    private let TITLE_BOTTOM_VIEW_HEIGHT: Int = 52
    private let TABBAR_HEIGHT: Int = 56
    
    private var contentAdpater: StickerContentAdapter = StickerContentAdapter()
    private var contentCollectionView: UICollectionView! // scrollview 넣을걸 이미 늦었다...
    private var tabbarAdapter: StickerTabbarAdapter = StickerTabbarAdapter()
    private var tabbarCollectionView: UICollectionView!
    private var titleBottomView = UIView()
    private var lbTitle = UILabel()
    private var btnBack = UIButton()
    
    var stickersViewControllerDelegate: StickersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupLayout()
        self.setupTabbarCollectionView()
        self.setupContentCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedImage), name: .selectedStickerImage, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func selectedImage(sender: Notification) {
        guard let selectedImage = sender.object as? UIImage else { return }
        stickersViewControllerDelegate?.didSelectImage(image: selectedImage)
    }
    
    private func setupView() {
        
        let contentLayout = UICollectionViewFlowLayout()
        contentLayout.scrollDirection = .horizontal
        contentLayout.minimumLineSpacing = 0
        contentLayout.minimumInteritemSpacing = 0
        contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: contentLayout)
        
        let tabbarLayout = UICollectionViewFlowLayout()
        tabbarLayout.itemSize = CGSize(width: TABBAR_HEIGHT, height: TABBAR_HEIGHT)
        tabbarLayout.scrollDirection = .horizontal
        tabbarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tabbarLayout)
        
        self.view.addSubview(contentCollectionView)
        self.view.addSubview(tabbarCollectionView)
        self.view.addSubview(titleBottomView)
        titleBottomView.addSubview(lbTitle)
        titleBottomView.addSubview(btnBack)
        
        self.view.backgroundColor = .black
        tabbarCollectionView.backgroundColor = .clear
        contentCollectionView.backgroundColor = .clear
        titleBottomView.backgroundColor = .clear

        contentCollectionView.isPagingEnabled = true
        contentCollectionView.allowsSelection = false
        tabbarCollectionView.allowsSelection = true
        
        btnBack.addTarget(self, action: #selector(tabBack), for: .touchUpInside)
        
        lbTitle.font = R.font.nanumSquareRoundEB(size: 14)
        lbTitle.textColor = .white
        lbTitle.text = R.string.localizable.photoeditor_sticker()
        btnBack.setImage(R.image.btnCancel(), for: .normal)
    }
    
    private func setupLayout() {
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tabbarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        titleBottomView.translatesAutoresizingMaskIntoConstraints = false
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(contentCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(contentCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
        constraints.append(contentCollectionView.bottomAnchor.constraint(equalTo: self.tabbarCollectionView.topAnchor))
        
        constraints.append(tabbarCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(tabbarCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(tabbarCollectionView.bottomAnchor.constraint(equalTo: self.titleBottomView.topAnchor))
        constraints.append(tabbarCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(TABBAR_HEIGHT)))
        
        constraints.append(titleBottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(titleBottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(titleBottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(titleBottomView.heightAnchor.constraint(equalToConstant: CGFloat(TITLE_BOTTOM_VIEW_HEIGHT)))
        
        constraints.append(lbTitle.centerXAnchor.constraint(equalTo: titleBottomView.centerXAnchor))
        constraints.append(lbTitle.centerYAnchor.constraint(equalTo: titleBottomView.centerYAnchor))
        
        constraints.append(btnBack.leadingAnchor.constraint(equalTo: titleBottomView.leadingAnchor))
        constraints.append(btnBack.centerYAnchor.constraint(equalTo: titleBottomView.centerYAnchor))
        constraints.append(btnBack.widthAnchor.constraint(equalToConstant: CGFloat(TITLE_BOTTOM_VIEW_HEIGHT)))
        constraints.append(btnBack.heightAnchor.constraint(equalToConstant: CGFloat(TITLE_BOTTOM_VIEW_HEIGHT)))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    private func setupContentCollectionView() {
        contentCollectionView.register(StickerCategoryPagingCell.self, forCellWithReuseIdentifier: StickerCategoryPagingCell.classNameToString())
        contentCollectionView.dataSource = contentAdpater
        contentCollectionView.delegate = contentAdpater
        contentAdpater.delegate = self
    }
    
    private func setupTabbarCollectionView() {
        tabbarCollectionView.allowsSelection = true
        
        tabbarCollectionView.register(StickerTabberCell.self, forCellWithReuseIdentifier: StickerTabberCell.classNameToString())
        tabbarCollectionView.dataSource = tabbarAdapter
        tabbarCollectionView.delegate = tabbarAdapter
        tabbarCollectionView.showsHorizontalScrollIndicator = false
        tabbarCollectionView.showsVerticalScrollIndicator = false
        tabbarAdapter.delegate = self
    }
    
    
    @objc func tabBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension StickersViewController: StickerTabbarDelegate {
    func didSelectedTab(index: Int) {
        contentCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension StickersViewController: StickerContentDelegate {
    func willDisplay(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = tabbarCollectionView.cellForItem(at: indexPath) else { return }
        
        if !cell.isSelected {
            tabbarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}


protocol StickerContentDelegate {
    func willDisplay(index: Int)
}


class StickerContentAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: StickerContentDelegate?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.willDisplay(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StickerFileProvider.shared.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCategoryPagingCell.classNameToString(), for: indexPath) as! StickerCategoryPagingCell
        cell.adapter.index = indexPath.item
        cell.stickersCollectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    

}




class StickerCategoryPagingCell: UICollectionViewCell {
    var stickersCollectionView: UICollectionView!
    let adapter = StickerCategoryPagingAdapter()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        adapter.index = self.indexPath?.item ?? 0
    }

    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 50, height: 50)
        stickersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stickersCollectionView.register(StickerThumbnailCell.self, forCellWithReuseIdentifier: StickerThumbnailCell.classNameToString())
        stickersCollectionView.dataSource = adapter
        stickersCollectionView.delegate = adapter
        
        stickersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(stickersCollectionView)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(stickersCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(stickersCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(stickersCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(stickersCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    class StickerCategoryPagingAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        var index: Int = 0
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return StickerFileProvider.shared.categories[index].stickers?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerThumbnailCell.classNameToString(), for: indexPath) as! StickerThumbnailCell
            if let url = StickerFileProvider.shared.categories[index].stickers?[indexPath.item].thumbnailURL {
                cell.imageView.sd_setImage(with: url, completed: nil)
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let url = StickerFileProvider.shared.categories[index].stickers?[indexPath.item].imageURL {
                SDWebImageManager.shared.loadImage(with: url, options: .highPriority, context: nil, progress: nil) { uiimage, data, error, cacheType, finished, url in
                    NotificationCenter.default.post(name: .selectedStickerImage, object: uiimage)
                }
            }
        }
    }
    
    class StickerThumbnailCell: UICollectionViewCell {
        var imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setupView()
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }

        private func setupView() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            contentView.addSubview(imageView)
            
            var constraints = [NSLayoutConstraint]()
            constraints.append(imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
            constraints.append(imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
            constraints.append(imageView.topAnchor.constraint(equalTo: contentView.topAnchor))
            constraints.append(imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
            NSLayoutConstraint.activate(constraints)
        }
        
    }
}



protocol StickerTabbarDelegate {
    func didSelectedTab(index: Int)
}

class StickerTabbarAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate: StickerTabbarDelegate?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StickerFileProvider.shared.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerTabberCell.classNameToString(), for: indexPath) as! StickerTabberCell
        cell.imageView.sd_setImage(with: StickerFileProvider.shared.categories[indexPath.item].imageURL, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false }
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = cell.contentView.transform.scaledBy(x: 0.8, y: 0.8)
        cell.contentView.transform = transform
        UIView.commitAnimations()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false }
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        cell.contentView.transform = transform
        UIView.commitAnimations()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! StickerTabberCell
        cell.isSelected = true
        delegate?.didSelectedTab(index: indexPath.item)
    }
}



class StickerTabberCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            self.selectedLineView.isHidden = !isSelected
        }
    }
    var selectedLineView = UIView()
    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        self.setupLayout()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(selectedLineView)
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        selectedLineView.backgroundColor = .white
        selectedLineView.isHidden = true
    }
    
    private func setupLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        selectedLineView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 1))
        constraints.append(self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -1))
        constraints.append(self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 1))
        constraints.append(self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -1))
        
        constraints.append(selectedLineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor))
        constraints.append(selectedLineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor))
        constraints.append(selectedLineView.topAnchor.constraint(equalTo: self.contentView.topAnchor))
        constraints.append(selectedLineView.heightAnchor.constraint(equalToConstant: 2))
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension Notification.Name {
    static let selectedStickerImage: Notification.Name = Notification.Name(rawValue: "selectedImage")
}
