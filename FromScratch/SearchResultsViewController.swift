
import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController!
    var albums = [Album]()
    let kCellIdentifier: String = "SearchResultCell"
    // add a lookup dictionary 
    // will be presented like this: imageCache["Bob"] = UIImage(named: "BobsPicture.jpg")
    // to get it back out: 
        // let imageOfBob = imageCache["Bob"] - the [] is for calling the constructor method to init the empty dictionary.
    var imageCache = [String:UIImage]()
    
    //test git

    @IBOutlet var appsTableView : UITableView!
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
        self.albums = Album.albumsWithJSON(results)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // Calling the method from an instance of an APIController, as opposed to from this View Controller. 
        api.searchItunesFor("Beatles")
    }
    
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return albums.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
            
            let album = self.albums[indexPath.row]
            
            cell.detailTextLabel?.text = album.price
            cell.textLabel?.text = album.title
            cell.imageView?.image = UIImage(named: "Blank52")
            
            let thumbnailURLString = album.thumbnailImageURL
            let thumbnailURL = NSURL(string: thumbnailURLString)!
            
            if let img = imageCache[thumbnailURLString]{
                cell.imageView?.image = img
            }
            
            // old code
//            if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
//            // Gragb the artworkUrl60 key to get an image URL for the app's thumbnail
//            urlString = rowData["artworkUrl60"] as? String,
//            // Create an NSURL instance from the String URL we get from the API
//            imgURL = NSURL(string: urlString),
//            // Get the formatted price string for display in the subtitle
//            formattedPrice = rowData["formattedPrice"] as? String,
//            // Download an NSData representation of the image at the URL
//            imgData = NSData(contentsOfURL: imgURL),
//            // Get the track name
//                trackName = rowData["trackName"] as? String {
//                    // Get the formatted price string for display in the subtitle
//                    cell.detailTextLabel?.text = formattedPrice
//                    // Update the imageView cell to use the downloaded image data
//                    cell.imageView?.image = UIImage(data: imgData)
//                    // Update the textLabel text to use the trackName from the API
//                    cell.textLabel?.text = trackName
//                    
//                    // Set cell's image to a static file (otherwise won't have an image view)
//                    cell.imageView?.image = UIImage(named: "Blank52")
//                    
//                    // If image is already chached, don't re-download
//                    if let img = imageCache[urlString] {
//                        cell.imageView?.image = img
                
                    else {
                        // The image isn't chached, download the img data
                        // We should perform this request in a background thread
                        let request: NSURLRequest = NSURLRequest(URL: thumbnailURL)
                        let mainQueue = NSOperationQueue.mainQueue()
                        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                // Convert the donloaded data into a UIImage object
                                let image = UIImage(data: data)
                                // Store the image to our cache
                                self.imageCache[thumbnailURLString] = image                                // Update the cell
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                                        cellToUpdate.imageView?.image = image
                                    }
                                })
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                        })
                    }
            
            
            return cell
        }
    
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        // Get the row data for the selected row
//        if let rowData = self.tableData[indexPath.row] as? NSDictionary,
//        // Get the name of the track for this row
//        name = rowData["trackName"] as? String,
//        // Get the price of the track on this row
//            formattedPrice = rowData["formattedPrice"] as? String {
//                let alert = UIAlertController(title: name, message: formattedPrice, preferredStyle: .Alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

