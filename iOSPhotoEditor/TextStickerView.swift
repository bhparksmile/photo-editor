//
//  TextStickerView.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/10.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit

protocol TextStickerDelegate {
    func textViewDidChange(_ textStickerView: TextStickerView)
    func textViewDidBeginEditing(_ textStickerView: TextStickerView)
    func textViewDidEndEditing(_ textStickerView: TextStickerView)
}

class TextStickerView: UIView {
    
    var isSelected = false {
        didSet {
            if isSelected {
                self.isHiddenControl(false)
            } else {
                self.isHiddenControl(true)
            }
            setNeedsLayout()
        }
    }
    
    private var leadingLine = UIView()
    private var trailingLine = UIView()
    private var topLine = UIView()
    private var bottomLine = UIView()
    var textView = UITextView()
    var textStickerDelegate: TextStickerDelegate?
    
    lazy var btnDelete: UIButton = {
        let button = UIButton()
        button.setImage(R.image.btnDeleteSticker(), for: .normal)
        button.addTarget(self, action: #selector(self.tapDelete), for: .touchUpInside)
        return button
    } ()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubView()
    }
    
    
    private func setupSubView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        leadingLine.translatesAutoresizingMaskIntoConstraints = false
        trailingLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        textView.backgroundColor = .clear
        textView.delegate = self
        leadingLine.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        trailingLine.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        topLine.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        bottomLine.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        addSubview(textView)
        addSubview(leadingLine)
        addSubview(trailingLine)
        addSubview(topLine)
        addSubview(bottomLine)
        addSubview(btnDelete)
        
        var constraints = [NSLayoutConstraint]()

        constraints.append(leadingLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12))
        constraints.append(leadingLine.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(leadingLine.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -24))
        constraints.append(leadingLine.widthAnchor.constraint(equalToConstant: 0.5))

        constraints.append(trailingLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12))
        constraints.append(trailingLine.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(trailingLine.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -24))
        constraints.append(trailingLine.widthAnchor.constraint(equalToConstant: 0.5))
        
        constraints.append(topLine.topAnchor.constraint(equalTo: self.topAnchor, constant: 12))
        constraints.append(topLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24))
        constraints.append(topLine.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(topLine.heightAnchor.constraint(equalToConstant: 0.5))
        
        constraints.append(bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12))
        constraints.append(bottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24))
        constraints.append(bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(bottomLine.heightAnchor.constraint(equalToConstant: 0.5))
        
        constraints.append(btnDelete.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 12))
        constraints.append(btnDelete.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -12))
        constraints.append(btnDelete.heightAnchor.constraint(equalToConstant: 24))
        constraints.append(btnDelete.widthAnchor.constraint(equalToConstant: 24))
        
        constraints.append(textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12))
        constraints.append(textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12))
        constraints.append(textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12))
        constraints.append(textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12))

        NSLayoutConstraint.activate(constraints)
    }
    
    private func isHiddenControl(_ isHidden: Bool) {
        self.leadingLine.isHidden = isHidden
        self.trailingLine.isHidden = isHidden
        self.topLine.isHidden = isHidden
        self.bottomLine.isHidden = isHidden
        self.btnDelete.isHidden = isHidden
    }
    
    @objc func tapDelete() {
        self.removeFromSuperview()
    }
}

extension TextStickerView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textStickerDelegate?.textViewDidChange(self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textStickerDelegate?.textViewDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textStickerDelegate?.textViewDidEndEditing(self)
    }
}
