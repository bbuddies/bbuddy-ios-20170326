//
//  AccountDetailViewController.swift
//  bbuddy
//
//  Created by Jackson Zhang on 10/02/2017.
//  Copyright © 2017 odd-e. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    
    private let api = Api()
    
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
        if let name = nameField.text, let balance = Int(balanceField.text ?? ""){
            var accountToUpdate = account!
            accountToUpdate.name = name
            accountToUpdate.balance = balance
            account.id > 0 ? updateAccount(accountToUpdate) : addAccount(accountToUpdate)
        }
    }
    
    private func addAccount(_ account: Account) {
        api.addAccount(account) {
            DispatchQueue.main.async { [unowned me = self] in
                _ = me.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateAccount(_ account: Account) {
        api.updateAccount(account) {
            DispatchQueue.main.async { [unowned me = self] in
                _ = me.navigationController?.popViewController(animated: true)
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
