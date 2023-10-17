//
//  CreateUserVC.swift
//  HomeWork24
//
//  Created by  NovA on 16.10.23.
//

import Alamofire
import SwiftyJSON
import UIKit

final class CreateUserVC: UIViewController {
    var user: User?
    var editType: Bool = false
    var delegate: UpdateUser?

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var websiteTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var cityTF: UITextField!
    @IBOutlet var streetTF: UITextField!
    @IBOutlet var suitTF: UITextField!
    @IBOutlet var zipcodeTF: UITextField!
    @IBOutlet var saveBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if editType == true {
            setupUI()
        }
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        nameTF.text = user?.name
        userNameTF.text = user?.username
        emailTF.text = user?.email
        phoneTF.text = user?.phone
        websiteTF.text = user?.website
        cityTF.text = user?.address?.city
        streetTF.text = user?.address?.street
        suitTF.text = user?.address?.suite
        zipcodeTF.text = user?.address?.zipcode
    }

    @IBAction func saveNewUser(_ sender: Any) {
        var newUser: User?
        if let name = nameTF.text,
           let username = userNameTF.text,
           let email = emailTF.text,
           let phone = emailTF.text,
           let website = websiteTF.text,
           let street = streetTF.text,
           let suite = suitTF.text,
           let city = cityTF.text,
           let zipcode = zipcodeTF.text,
           let url = ApiConstants.usersURL
        {
            let address: Parameters = [
                "street": street,
                "suite": suite,
                "city": city,
                "zipcode": zipcode
            ]

            let parameters: Parameters = [
                "name": name,
                "username": username,
                "email": email,
                "phone": phone,
                "website": website,
                "address": address
            ]
            if editType == false {
                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .response { response in
                        print(url)
                        /// тут мы уже в главном потоке
                        debugPrint(response)
                        print(response.request)
                        print(response.response)
                        debugPrint(response.result)

                        switch response.result {
                        case .success(let data):
                            print(data)
                            print(JSON(data))

                        case .failure(let error):
                            print(error)
                        }
                    }
            } else {
                guard let userId = user?.id else { return }
                let urlEditUser = "\(ApiConstants.usersURL!)/\(userId)"
                AF.request(urlEditUser, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
                    .response { [weak self] response in
                        if let data = response.data {
                            do {
                                self?.user = try JSONDecoder().decode(User.self, from: data)
                                newUser = self?.user
                                guard let user = newUser else { return }
                                self?.delegate?.updateUserData(user: user)
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    }
            }
        }

        navigationController?.popViewController(animated: true)
    }
}
