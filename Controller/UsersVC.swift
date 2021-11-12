//
//  UsersVC.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 12/09/2021.
//

import UIKit
import Firebase

class UsersVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables

    let searchController = UISearchController(searchResultsController: nil)
    var users = [FUser]()

    var filteredUserArr: [FUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupSearchbar()
        setupNavigationUI()
    }
    
    //MARK:- Helper Functions

    func setupSearchbar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = .white
        
//        self.refreshControl = UIRefreshControl()
//        tableView.refreshControl = refreshControl
    }
    func setupNavigationUI(){
        self.navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
       // self.navigationController?.setStatusBar(backgroundColor:UIColor.black)
    }
    func getUsersData(){
        DBref.child(reference(.User)).observe(.value) { snapshot in
            let snap = snapshot.value as! [String:Any]
            for (_,value) in snap{
                let user = FUser(_dictionary: value as! NSDictionary)
                if user.objectId != FUser.currentId(){
                    //for i in self.users.indices{
                     //   if user.objectId != self.users[i].objectId{
                            self.users.append(user)
                   //     }
                 //   }
                }
               
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    //MARK:- IBActions


}


//MARK:- Table View

extension UsersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUserArr.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell") as! UsersCell
        
        if searchController.isActive {
            cell.userFullname.text = filteredUserArr[indexPath.row].fullname
            cell.userEmail.text = filteredUserArr[indexPath.row].email
            
            imageFromStringData(stringImgData: filteredUserArr[indexPath.row].avatar) { img in
                guard let img = img else {return}
                cell.userProfileImg.image = img.circleMasked
            }
        }else{
            cell.userFullname.text = users[indexPath.row].fullname
            cell.userEmail.text = users[indexPath.row].email
            
            imageFromStringData(stringImgData: users[indexPath.row].avatar) { img in
                guard let img = img else {return}
                cell.userProfileImg.image = img.circleMasked
            }
        }
        
//        cell.userFullname.text = users[indexPath.row].fullname
//        cell.userEmail.text = users[indexPath.row].email
//
//        imageFromStringData(stringImgData: users[indexPath.row].avatar) { img in
//            guard let img = img else {return}
//            cell.userProfileImg.image = img.circleMasked
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREENHEIGHT / 11
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(identifier: "MessagesVC") as! MessagesVC
        vc.chatRoomName = users[indexPath.row].fullname
        vc.usersId = [FUser.currentId(),users[indexPath.row].objectId]
        vc.users = [FUser.currentUser()!,users[indexPath.row]]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UsersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredUserArr = users.filter({ user in
            return (user.fullname.lowercased().contains(searchController.searchBar.text!.lowercased()))
        })
        tableView.reloadData()
    }
}






