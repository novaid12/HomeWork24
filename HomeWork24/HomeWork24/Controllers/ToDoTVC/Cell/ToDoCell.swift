//
//  ToDoCell.swift
//  HomeWork24
//
//  Created by  NovA on 21.10.23.
//

import Lottie
import UIKit

class ToDoCell: UITableViewCell {
    private var animationView: LottieAnimationView!

    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var chechView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        chechView.clipsToBounds = true
        animationView = LottieAnimationView()
        animationView.frame = chechView.bounds
        animationView.contentMode = .scaleAspectFit
        chechView.addSubview(animationView)
    }

    func configure(isSelected: Bool) {
        if isSelected == true {
            let animation = LottieAnimation.named("system-check")
            animationView.animation = animation
            animationView.play()

        } else if isSelected == false {
            let animation = LottieAnimation.named("system-clock")
            animationView.animation = animation
            animationView.play()
        }
    }
}
