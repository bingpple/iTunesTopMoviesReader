//
//  TopMovieTableViewController.swift
//
//  Copyright (c) 2017 Bing Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import FeedKit

let feedURL = URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topMovies/xml")!

class TopMovieTableViewCell: UITableViewCell{
  
  @IBOutlet weak var movieImageView: UIImageView!
  @IBOutlet weak var movieNameLabel: UILabel!
  @IBOutlet weak var moviePriceLabel: UILabel!
  @IBOutlet weak var movieCategoryLabel: UILabel!
  
}

class TopMovieTableViewController: UIViewController {
    
  var feed: AtomFeed?
  let parser = FeedParser(URL: feedURL)!
  var movieDetailContent: String?
  var movieName: String?
    
  @IBOutlet
  var tableView: UITableView!
   
  lazy var refreshControl: UIRefreshControl = {
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(TopMovieTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    refreshControl.tintColor = .blue
    refreshControl.attributedTitle =  NSAttributedString(string: "Refreshing Top Movies List")
    return refreshControl
    
  }()
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
        
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
        
    // parse the feed in async way
    parseFeed()
    
  }

  func parseFeed(){
    
    parser.parseAsync { [weak self] (result) in
      self?.feed = result.atomFeed
            
    // Then back to the Main thread to update the UI.
    DispatchQueue.main.async {
      self?.title = self?.feed?.title
      self?.tableView.reloadData()
    }
      
    }
    
  }

  @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
    
    // Simply retrive the feed again
    parseFeed()
        
    // Refresh the table view
    tableView.reloadData()
    refreshControl.endRefreshing()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "movieDetailSegue"){
      let topMovieDetailViewController = segue.destination as! TopMovieDetailViewController
      topMovieDetailViewController.movieDetailContent = (feed?.entries?[(tableView.indexPathForSelectedRow?.row)!].content?.value)!
      topMovieDetailViewController.movieName = (feed?.entries?[(tableView.indexPathForSelectedRow?.row)!].title!)!
      
    }
    
  }
  
}

//MARK: - UITableViewDataSource
extension TopMovieTableViewController:UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    
  }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return feed?.entries?.count ?? 0
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! TopMovieTableViewCell
    cell.movieCategoryLabel.text = feed?.entries?[indexPath.row].categories?[0].attributes?.label
    cell.movieNameLabel.text = feed?.entries?[indexPath.row].title
    let htmlContent = feed?.entries?[indexPath.row].content?.value
    let pricePat = "\\$ *(\\d+(\\.\\d+)?)"
    let matchedPrice = matches(for: pricePat, in: htmlContent!)
    //Match movie price
    cell.moviePriceLabel.text = matchedPrice[0]
    let postImgPat = "<img.*?src=\"([^\"]*)\""
    let matchedImgs = matches(for: postImgPat, in: htmlContent!)
    //Match movie image element
    let postImageElement = matchedImgs[0]
    let postPicPat = "(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"
    let postPicUrl = matches(for: postPicPat, in: postImageElement)
    //Match movie image url
    let imageUrl:URL = URL(string: postPicUrl[0])!
    DispatchQueue.global(qos: .userInitiated).async {
      let imageData:NSData = NSData(contentsOf: imageUrl)!
      // When from background thread, UI needs to be updated on main_queue
      DispatchQueue.main.async {
        let image = UIImage(data: imageData as Data)
          cell.movieImageView.image = image
        
      }
      
    }
    
    return cell
    
  }
  
 func matches(for regex: String, in text: String) -> [String] {
    
    do {
      let regex = try NSRegularExpression(pattern: regex)
      let results = regex.matches(in: text,
                                  range: NSRange(text.startIndex..., in: text))
      return results.map {String(text[Range($0.range, in: text)!])}
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
    
  }
  
}
