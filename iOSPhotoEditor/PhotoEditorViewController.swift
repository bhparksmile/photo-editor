//
//  PhotoEditorViewController.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/07.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit

class PhotoEditorViewController: UIViewController {
    var canvasView: UIView = UIView()
    var imageView: UIImageView = UIImageView()
    lazy var imageViewHeightConstraint: NSLayoutConstraint = {
        return self.imageView.heightAnchor.constraint(equalToConstant: 0)
    } ()
    var canvasImageView: UIImageView = UIImageView()
    
    var bottomControlToolbar: UIView = UIView()
    lazy var bottomControlToolbarStackView: UIStackView = {
        return UIStackView(arrangedSubviews: [self.stickerButton, self.textButton])
//                                              , self.btnFilter])
    } ()
    
    var stickerButton: UIButton = UIButton()
    var textButton: UIButton = UIButton()
    var btnFilter: UIButton = UIButton()
    
    var topGradient: UIView = UIView()
    var topToolbar: UIView = UIView()
    lazy var topToolbarStackView: UIStackView = {
        return UIStackView(arrangedSubviews: [self.cropButton, self.stickerButton, self.drawButton, self.textButton])
    } ()
    
    var cropButton: UIButton = UIButton()
    var drawButton: UIButton = UIButton()
    
    var btnBack: UIButton = UIButton()
    
    var saveButton: UIButton = UIButton()
    var shareButton: UIButton = UIButton()
    var clearButton: UIButton = UIButton()
    var btnFinish: UIButton = UIButton()
    
    var bottomGradient: UIView = UIView()
    var bottomToolbar: UIView = UIView()
    lazy var bottomToolbarStackView: UIStackView = {
        return UIStackView(arrangedSubviews: [self.saveButton, self.shareButton, self.clearButton])
    } ()
    
    var doneButton: UIButton = UIButton()
    var deleteView: UIView = UIView()
    
    var colorPickerView: UIView = UIView()
    lazy var colorPickerViewBottomConstraint: NSLayoutConstraint = {
        return self.colorPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
    } ()
    lazy var colorsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    } ()
    
    var dummyTextView = UITextView()

    
    public var image: UIImage?
    /**
     Array of Stickers -UIImage- that the user will choose from
     */
    public var stickers : [UIImage] = []
    /**
     Array of Colors that will show while drawing or typing
     */
    public var colors  : [UIColor] = []
    
    public var photoEditorDelegate: PhotoEditorDelegate?
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate!
    
    // list of controls to be hidden
    public var hiddenControls : [control] = []
    
    var stickersVCIsVisible = false
    var drawColor: UIColor = UIColor.black
    var textColor: UIColor = UIColor.white
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var swiped = false
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var imageViewToPan: StickerView?
    var isTyping: Bool = false
    
    var textFont: UIFont? = UIFont.systemFont(ofSize: 30)
    
    var stickersViewController: StickersViewController!
    
//    //Register Custom font before we load XIB
//    public override func loadView() {
//        registerFont()
//        super.loadView()
//    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupLayout()
        self.setupControl()
        
        self.setImageView(image: image!)
        
//        deleteView.layer.cornerRadius = deleteView.bounds.height / 2
//        deleteView.layer.borderWidth = 2.0
//        deleteView.layer.borderColor = UIColor.white.cgColor
//        deleteView.clipsToBounds = true
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureCollectionView()
        stickersViewController = StickersViewController()
        hideControls()
    }
    
    
    private func setupView() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.canvasView)
        self.canvasView.addSubview(self.imageView)
        self.canvasView.addSubview(self.canvasImageView)
        
        self.view.addSubview(self.topGradient)
        
        self.view.addSubview(self.topToolbar)
//        self.topToolbar.addSubview(self.cancelbutton)
        self.topToolbar.addSubview(self.topToolbarStackView)
        self.topToolbarStackView.axis = .horizontal
        self.topToolbarStackView.spacing = 15
        self.topToolbarStackView.alignment = .fill
        self.topToolbarStackView.distribution = .fillEqually
        
        self.view.addSubview(btnFinish)
        self.view.addSubview(btnBack)
        self.view.addSubview(self.bottomGradient)
        
        self.view.addSubview(self.bottomToolbar)
        self.bottomToolbar.addSubview(self.bottomToolbarStackView)
//        self.bottomToolbar.addSubview(self.continueButton)
        self.bottomToolbarStackView.axis = .horizontal
        self.bottomToolbarStackView.spacing = 15
        self.bottomToolbarStackView.alignment = .fill
        self.bottomToolbarStackView.distribution = .fillEqually
        
        self.view.addSubview(self.bottomControlToolbar)
        self.bottomControlToolbar.addSubview(self.bottomControlToolbarStackView)
        self.bottomControlToolbarStackView.axis = .horizontal
        self.bottomControlToolbarStackView.alignment = .fill
        self.bottomControlToolbarStackView.distribution = .fillEqually
        
        self.view.addSubview(self.doneButton)
        self.view.addSubview(self.deleteView)
        
        self.view.addSubview(self.colorPickerView)
        self.colorPickerView.isHidden = true
        self.colorPickerView.addSubview(self.colorsCollectionView)
        
        self.stickerButton.setImage(R.image.icnSticker(), for: .normal)
        self.textButton.setImage(R.image.icnText(), for: .normal)
        self.btnFilter.setImage(R.image.icnFilter(), for: .normal)
        
        let spacing: CGFloat = 12
        let imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        let titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        stickerButton.imageEdgeInsets = imageEdgeInsets
        stickerButton.titleEdgeInsets = titleEdgeInsets
        textButton.imageEdgeInsets = imageEdgeInsets
        textButton.titleEdgeInsets = titleEdgeInsets
        btnFilter.imageEdgeInsets = imageEdgeInsets
        btnFilter.titleEdgeInsets = titleEdgeInsets
        
        self.btnBack.setImage(R.image.btnBack(), for: .normal)
        self.doneButton.setImage(R.image.btnDone(), for: .normal)
        self.drawButton.setTitle("draw", for: .normal)
        self.cropButton.setTitle("crop", for: .normal)
        self.saveButton.setTitle("save", for: .normal)
        self.shareButton.setTitle("share", for: .normal)
        self.clearButton.setTitle("clear", for: .normal)
        
        topToolbar.isHidden = true
        topGradient.isHidden = true
        bottomToolbar.isHidden = true
        bottomGradient.isHidden = true
        doneButton.isHidden = true
        deleteView.isHidden = true
    }

    private func setupLayout() {
        self.canvasView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.canvasImageView.translatesAutoresizingMaskIntoConstraints = false
        self.topGradient.translatesAutoresizingMaskIntoConstraints = false
        
        self.topToolbar.translatesAutoresizingMaskIntoConstraints = false
        self.topToolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stickerButton.translatesAutoresizingMaskIntoConstraints = false
        self.drawButton.translatesAutoresizingMaskIntoConstraints = false
        self.textButton.translatesAutoresizingMaskIntoConstraints = false
        self.btnBack.translatesAutoresizingMaskIntoConstraints = false
        
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.btnFinish.translatesAutoresizingMaskIntoConstraints = false
        
        self.bottomGradient.translatesAutoresizingMaskIntoConstraints = false
        self.bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        self.bottomToolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bottomControlToolbar.translatesAutoresizingMaskIntoConstraints = false
        self.bottomControlToolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteView.translatesAutoresizingMaskIntoConstraints = false
        
        self.colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        // canvas
        constraints.append(self.canvasView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.canvasView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(self.canvasView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        constraints.append(self.canvasView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        
        // imageView
        constraints.append(self.imageView.leadingAnchor.constraint(equalTo: self.canvasView.leadingAnchor))
        constraints.append(self.imageView.trailingAnchor.constraint(equalTo: self.canvasView.trailingAnchor))
        constraints.append(self.imageView.centerYAnchor.constraint(equalTo: self.canvasView.centerYAnchor))
        let imageViewTop = self.imageView.topAnchor.constraint(equalTo: self.canvasView.topAnchor)
        let imageViewBottom = self.imageView.bottomAnchor.constraint(equalTo: self.canvasView.bottomAnchor)
        imageViewTop.priority = .defaultLow
        imageViewBottom.priority = .defaultHigh
        self.imageViewHeightConstraint.priority = .required
        constraints.append(imageViewTop)
        constraints.append(imageViewBottom)
        constraints.append(self.imageViewHeightConstraint)
        
        // canvasImageView
        constraints.append(self.canvasImageView.widthAnchor.constraint(equalTo: self.imageView.widthAnchor))
        constraints.append(self.canvasImageView.heightAnchor.constraint(equalTo: self.imageView.heightAnchor))
        constraints.append(self.canvasImageView.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor))
        constraints.append(self.canvasImageView.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor))
        
        // gradientView
        constraints.append(self.topGradient.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.topGradient.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(self.topGradient.heightAnchor.constraint(equalToConstant: 60))
        constraints.append(self.topGradient.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        
        // topToolBar
        constraints.append(self.topToolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.topToolbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(self.topToolbar.heightAnchor.constraint(equalToConstant: 60))
        constraints.append(self.topToolbar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        
        // topToolBar stackView
        constraints.append(self.topToolbarStackView.topAnchor.constraint(equalTo: self.topToolbar.topAnchor))
        constraints.append(self.topToolbarStackView.bottomAnchor.constraint(equalTo: self.topToolbar.bottomAnchor))
        constraints.append(self.topToolbarStackView.trailingAnchor.constraint(equalTo: self.topToolbar.trailingAnchor, constant: -12))
        
        
        
        // gradientView
        constraints.append(self.bottomGradient.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.bottomGradient.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(self.bottomGradient.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(self.bottomGradient.heightAnchor.constraint(equalToConstant: 80))
        
        // bottomToolBar
        constraints.append(self.bottomToolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.bottomToolbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(self.bottomToolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(self.bottomToolbar.heightAnchor.constraint(equalToConstant: 60))
        
        // bottomToolBar stackView
        constraints.append(self.bottomToolbarStackView.topAnchor.constraint(equalTo: self.bottomToolbar.topAnchor))
        constraints.append(self.bottomToolbarStackView.bottomAnchor.constraint(equalTo: self.bottomToolbar.bottomAnchor, constant: -8))
        constraints.append(self.bottomToolbarStackView.leadingAnchor.constraint(equalTo: self.bottomToolbar.leadingAnchor, constant: 12))
        
        // controlBar
        constraints.append(self.bottomControlToolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.bottomControlToolbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(self.bottomControlToolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(self.bottomControlToolbar.heightAnchor.constraint(equalToConstant: 60))
        
        // bottomToolBar stackView
        constraints.append(self.bottomControlToolbarStackView.leadingAnchor.constraint(equalTo: self.bottomControlToolbar.leadingAnchor))
        constraints.append(self.bottomControlToolbarStackView.trailingAnchor.constraint(equalTo: self.bottomControlToolbar.trailingAnchor))
        constraints.append(self.bottomControlToolbarStackView.topAnchor.constraint(equalTo: self.bottomControlToolbar.topAnchor))
        constraints.append(self.bottomControlToolbarStackView.bottomAnchor.constraint(equalTo: self.bottomControlToolbar.bottomAnchor, constant: -8))
        
        // back button
        constraints.append(btnBack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12))
        constraints.append(btnBack.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16))
        constraints.append(btnBack.widthAnchor.constraint(equalToConstant: 30))
        constraints.append(btnBack.heightAnchor.constraint(equalToConstant: 30))
        
        // continue button
        constraints.append(btnFinish.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24))
        constraints.append(btnFinish.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16))
        constraints.append(btnFinish.heightAnchor.constraint(equalToConstant: 30))
        
        // done button
        constraints.append(doneButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12))
        constraints.append(doneButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16))
        
        // delete View
        constraints.append(self.deleteView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(self.deleteView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -12))
        constraints.append(self.deleteView.widthAnchor.constraint(equalToConstant: 50))
        constraints.append(self.deleteView.heightAnchor.constraint(equalToConstant: 50))
        
        // colorPickerView
        constraints.append(self.colorPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(self.colorPickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(self.colorPickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(self.colorPickerView.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(self.colorPickerViewBottomConstraint)
        
        // collectionView
        constraints.append(self.colorsCollectionView.topAnchor.constraint(equalTo: self.colorPickerView.topAnchor))
        constraints.append(self.colorsCollectionView.trailingAnchor.constraint(equalTo: self.colorPickerView.trailingAnchor))
        constraints.append(self.colorsCollectionView.leadingAnchor.constraint(equalTo: self.colorPickerView.leadingAnchor))
        constraints.append(self.colorsCollectionView.heightAnchor.constraint(equalToConstant: 40))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    private func setupControl() {
        self.btnBack.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        self.cropButton.addTarget(self, action: #selector(self.cropButtonTapped), for: .touchUpInside)
        self.stickerButton.addTarget(self, action: #selector(self.stickersButtonTapped), for: .touchUpInside)
        self.drawButton.addTarget(self, action: #selector(self.drawButtonTapped), for: .touchUpInside)
        self.textButton.addTarget(self, action: #selector(self.textButtonTapped), for: .touchUpInside)
        self.doneButton.addTarget(self, action: #selector(self.doneButtonTapped), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped), for: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(self.shareButtonTapped), for: .touchUpInside)
        self.clearButton.addTarget(self, action: #selector(self.clearButtonTapped), for: .touchUpInside)
        self.btnFinish.addTarget(self, action: #selector(self.continueButtonPressed), for: .touchUpInside)
    }
    
    
    func configureCollectionView() {
        
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate()
        colorsCollectionViewDelegate.colorDelegate = self
        if !colors.isEmpty {
            colorsCollectionViewDelegate.colors = colors
        }
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
        
        colorsCollectionView.register(
            UINib(nibName: "ColorCollectionViewCell", bundle: Bundle(for: ColorCollectionViewCell.self)),
            forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    func setImageView(image: UIImage) {
        imageView.image = image
        let size = image.suitableSize(widthLimit: UIScreen.main.bounds.width)
        imageViewHeightConstraint.constant = (size?.height)!
    }
    
    func hideToolbar(hide: Bool) {
//        topToolbar.isHidden = hide
//        topGradient.isHidden = hide
//        bottomToolbar.isHidden = hide
//        bottomGradient.isHidden = hide
        self.bottomControlToolbar.isHidden = hide
    }
}

extension PhotoEditorViewController: ColorDelegate {
    func didSelectColor(color: UIColor) {
        if isDrawing {
            self.drawColor = color
        } else if activeTextView != nil {
            activeTextView?.textColor = color
            textColor = color
        }
    }
}


