//
//  PostingViewController.swift
//  IllhaTask
//
//  Created by A1502 on 23/08/21.
//

import UIKit

class PostingViewController: UIViewController {
    
    @IBOutlet weak var pageControlNew: UIPageControl!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var tblData: UITableView!
    var postVMObj = PostViewModel()
    var isSearching:Bool = false
    var isRowHidden:Bool = false
    let localSource = ["img1","img2","img3","img4"]
    
    // MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tblData.separatorColor = UIColor.clear
        prepareViewModelObserver()
        postVMObj.requestPostData = []
        postVMObj.requestPostDataSearch = []
        pageControlNew.numberOfPages = localSource.count
        pageControlNew.currentPage = 0
        pageControlNew.tintColor = UIColor.red
        pageControlNew.pageIndicatorTintColor = UIColor.black
        pageControlNew.currentPageIndicatorTintColor = UIColor.green
        self.imageCollection.isPagingEnabled = true;
        

        fetchPostList()
    }
}
// MARK: Extension
extension PostingViewController :UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.resignFirstResponder()
            isSearching = false
        } else {
            postVMObj.requestPostDataSearch = searchText.isEmpty ? postVMObj.requestPostData : postVMObj.requestPostData!.filter{ $0.title!.range(of: searchText, options: .caseInsensitive) != nil }
            if postVMObj.requestPostDataSearch?.count == 0{
                isSearching = true
                postVMObj.requestPostDataSearch = []
            } else {
                isSearching = true
            }
        }
        self.reloadTableView()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
// MARK: TableView Method
extension PostingViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if postVMObj.requestPostDataSearch?.count == 0{
                return 0
            }else {
                return postVMObj.requestPostDataSearch!.count
            }
        } else{
            return postVMObj.requestPostData!.count
        }
        
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PsotingTableViewCell3 = (tableView.dequeueReusableCell(withIdentifier: "PsotingTableViewCell3") as! PsotingTableViewCell3?)!
        if isSearching{
            if postVMObj.requestPostDataSearch?.count ?? 0>0{
                cell.prepareLayout(objDashboard: postVMObj.requestPostDataSearch?[indexPath.row])
                
            } else {
                cell.lblTitle.text = ""
            }
        } else {
            if postVMObj.requestPostData?.count ?? 0>0{
                cell.prepareLayout(objDashboard: postVMObj.requestPostData?[indexPath.row])
                
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 15, width: tableView.bounds.width, height: 45))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = UIColor.white
        searchBar.delegate = self
        return searchBar
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
// MARK: CollectionView Method
extension PostingViewController:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ImageCollectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCollectionViewCell", for: indexPath) as! ImageCollectionCollectionViewCell
        cell.slideshow.image = UIImage(named: localSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width, height: 200)
        return size
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isPagingEnabled{
            var visibleRect = CGRect()
            visibleRect.origin = imageCollection.contentOffset
            visibleRect.size = imageCollection.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath1 = imageCollection.indexPathForItem(at: visiblePoint) else { return }
            pageControlNew.currentPage = indexPath1.row
            DispatchQueue.main.async {
                self.postVMObj.requestPostData?.shuffle()
                self.reloadTableView()
            }
        }
    }
}
extension PostingViewController {
    func fetchPostList() {
        postVMObj.fetchpostListData()
    }
    func prepareViewModelObserver() {
        self.postVMObj.postDidChanges = { (finished, error) in
            if !error {
                self.reloadTableView()
            }
        }
    }
    func reloadTableView() {
        self.tblData.reloadData()
    }
}
