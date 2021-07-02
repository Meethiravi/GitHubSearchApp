//
//  ViewController.swift
//  SearchGitHub
//
//  Created by Mahalakshmi Raveenthiran on 01/07/21.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "Search Results for \(self.searchBar.text ?? "your query")"
            }
        }
    }
    
    //activity indicator
    let spinner = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        let navColour = UIColor(red: 241/255, green: 241/255, blue: 232/255, alpha: 1)
        let bar = UINavigationBarAppearance()
        bar.backgroundColor = navColour
        navBar.scrollEdgeAppearance = bar
        searchBar.barTintColor = navColour
    }
    
    
    //MARK: - TableView data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RepositoryTableViewCell
        
        let repo = searchResults[indexPath.row]
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        
        //user avatar
        if let url = URL(string: (repo.owner?.avatar_url)!) {
            if let image = try? Data(contentsOf: url) {
                cell.repoAvatar.image = UIImage(data: image)
            }
        }
        
        //repo full name
        cell.repoFullName.text = repo.full_name
        
        //login name
        if let ownerLogin = repo.owner?.login {
            cell.repoOwnerLogin.addLeading(image: UIImage(systemName: "person.circle.fill", withConfiguration: symbolConfiguration)!, text: ownerLogin)
        }
        
        //repo description
        if let description = repo.description {
            cell.repoDescription.addLeading(image: UIImage(systemName: "book")!, text: description)
        }
        
        //cell style
        cell.repoView.layer.shadowColor = UIColor.gray.cgColor
        cell.repoView.layer.shadowOpacity = 1
        cell.repoView.layer.shadowOffset = .zero
        cell.repoView.layer.shadowRadius = 10
        cell.repoView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 232/255, alpha: 1)
        cell.repoView.layer.cornerRadius = 10
        cell.repoAvatar.layer.cornerRadius = cell.repoAvatar.frame.height / 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: searchResults[indexPath.row].html_url!) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}


//MARK: - SearchBar delegate methods


extension TableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        spinner.startAnimating()
        tableView.backgroundView = spinner
        guard let searchBarText = searchBar.text else {
            return
        }
        let repoRequest = RepositoryManager(searchRepo: searchBarText)
        repoRequest.getRepos { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let items):
                self?.searchResults = items
            }
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            searchResults = []
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.navigationItem.title = "GitHub Repositories"
                self.spinner.isHidden = true
            }
        }
    }
}


//MARK: - Appending SF symbols in UILabel


extension UILabel {
    
    func addLeading(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        
        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
}
