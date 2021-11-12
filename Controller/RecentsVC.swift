//
//  RecentsVC.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 30/09/2021.
//

import UIKit
import Firebase

class RecentsVC: UITableViewController {

    //MARK:- IBOutlets
    
    
    //MARK:- Variables
    let searchController = UISearchController(searchResultsController: nil)

    var users = [FUser]()
    var userdMsg = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupSearchbar()
        setupNavigationUI()
       // getUsersMsg()
    }
    
    //MARK:- IBActions


    //MARK:- Helper Functions
    

    func setupUI(){
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white
        tableView.refreshControl = refreshControl
    }
    func setupNavigationUI(){
        self.navigationItem.title = "Recent"
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    func setupSearchbar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = .white
    }
    
 
    
//    func getUsersMsg(){
//        DBref.child(reference(.Message)).child(FUser.currentId()).observe(.value) { snapshot in
//            let snap = snapshot.value as! [String:Any]
//            for (_,value) in snap{
//                let Message = Messages(_dictionary: value as! NSDictionary, chatRoomId: nil)
//                //if Message.senderId == FUser.currentId(){
//                    self.userdMsg.append(Message)
//                //}
//
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
}
//MARK:- Table View

extension RecentsVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userdMsg.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentsChatRoomCell") as! RecentsChatRoomCell
        cell.dateLbl.text = timeElapsed(date: userdMsg[indexPath.row].date)
        cell.userNameLbl.text = userdMsg[indexPath.row].senderName
        cell.userMsgLbl.text = userdMsg[indexPath.row].message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREENHEIGHT / 8
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if  self.refreshControl!.isRefreshing {
            self.refreshControl?.endRefreshing()
        }
    }
}

extension RecentsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        filteredUserArr = users.filter({ user in
//            return (user.fullname.lowercased().contains(searchController.searchBar.text!.lowercased()))
//        })
        tableView.reloadData()
    }
}
