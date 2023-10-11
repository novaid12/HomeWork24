//
//  DetailVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import UIKit

class DetailVC: UIViewController {
    var user: User?

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var webSiteLbl: UILabel!
    @IBOutlet var adressLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func allPostsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postsVC = storyboard.instantiateViewController(withIdentifier: "PostsVC") as! PostsVC
        postsVC.userId = user?.id
        navigationController?.pushViewController(postsVC, animated: true)
    }

    private func setupUI() {
        guard let user = user else { return }
        nameLbl.text = user.name
        userNameLbl.text = user.username
        emailLbl.text = user.email
        phoneLbl.text = user.phone
        webSiteLbl.text = user.website
        adressLbl.text = (user.address?.city)! + ", " + (user.address?.street)!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapVC = segue.destination as? MapVC else { return }
        mapVC.geo = user?.address?.geo
    }
}
