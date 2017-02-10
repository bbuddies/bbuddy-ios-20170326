//
//  AccountsTableViewController.swift
//  bbuddy
//
//  Created by Jackson Zhang on 08/02/2017.
//  Copyright © 2017 odd-e. All rights reserved.
//

import UIKit
import Moya
import Argo

class AccountsTableViewController: UITableViewController {
    
    private var accounts = [Account]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    private func mapArray<T:Decodable>(response: Response) throws -> [T] where T == T.DecodedType {
        
        do {
            //map to JSON
            let JSON = try response.mapJSON()
            
            //decode with Argo
            let decodedArray:Decoded<[T]>
            //no root key, it's an array
            guard let array = JSON as? [AnyObject] else {
                throw DecodeError.typeMismatch(expected: "\(T.DecodedType.self)", actual: "\(type(of: JSON))")
            }
            decodedArray = decode(array)
            
            //return array of decoded objects, or throw decoding error
            return try decodedValue(decoded: decodedArray)
            
        } catch {
            
            throw error
        }
    }
    
    private func decodedValue<T>(decoded: Decoded<T>) throws -> T {
        
        switch decoded {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    private func fetchAccounts(){
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
        provider.request(.showAccounts) { result in
            switch result {
            case .success(let response):
                guard (200...299).contains(response.statusCode) else{
                    print("error: \(response.statusCode)")
                    return
                }
                DispatchQueue.main.async { [unowned me = self] in
                    do {
                        me.accounts = try me.mapArray(response: response)
                    } catch {
                        
                    }
                }
            case .failure(let error):
                print("failure: \(error)")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAccounts()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accounts.count
    }
    
    private struct Storyboard{
        static let AccountCellIdentifier = "Account"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.AccountCellIdentifier, for: indexPath)

        let account = accounts[indexPath.row]
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = "\(account.balance)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let accountDetailViewController = destinationViewController as? AccountDetailViewController,
            let accountIndex = tableView.indexPathForSelectedRow?.row {
            accountDetailViewController.account = accounts[accountIndex]
        }
    }

}
