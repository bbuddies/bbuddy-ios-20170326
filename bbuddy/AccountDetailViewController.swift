//
//  AccountDetailViewController.swift
//  bbuddy
//
//  Created by Jackson Zhang on 10/02/2017.
//  Copyright © 2017 odd-e. All rights reserved.
//

import UIKit
import Moya
import Cely

class AccountDetailViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    
    var account: Account! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI(){
        if nameField != nil {
            nameField.text = account.name
            balanceField.text = "\(account.balance)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    @IBAction func saveAccount(_ sender: UIButton) {
        if let name = nameField.text,
            let balance = Int(balanceField.text ?? ""){
            var accountToUpdate = account!
            accountToUpdate.name = name
            accountToUpdate.balance = balance
            updateAccount(accountToUpdate)
        }
    }
    
    private func updateAccount(_ account: Account) {
        let provider  = MoyaProvider<Api>(
            plugins: [
                AuthPlugin(tokenClosure: {
                    if
                        let uid = User.get(.email) as? String,
                        let client = User.get(.client) as? String,
                        let accessToken = User.get(.token) as? String,
                        let type = User.get(.type) as? String {
                        return AuthorizedToken(
                            uid: uid,
                            client: client,
                            accessToken: accessToken,
                            type: type
                        )
                    }
                    return nil
                })
            ]
        )
        provider.request(.updateAccount(account: account)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200...299:
                    DispatchQueue.main.async { [unowned me = self] in
                        _ = me.navigationController?.popViewController(animated: true)
                    }
                case 401:
                    Cely.logout()
                default:
                    print("error: \(response.statusCode)")
                }
            case .failure(let error):
                print("failure: \(error)")
            }
        }
 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
