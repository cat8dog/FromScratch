
import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    let api = APIController()
    var tableData = []
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
        self.tableData = results
        self.appsTableView!.reloadData()
        })
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        api.delegate = self
        
        // Calling the method from an instance of an APIController, as opposed to from this View Controller. 
        api.searchItunesFor("Tetris")
    }
    
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableData.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
            
            if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            // Gragb the artworkUrl60 key to get an image URL for the app's thumbnail
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Download an NSData representation of the image at the URL
            imgData = NSData(contentsOfURL: imgURL),
            // Get the track name
                trackName = rowData["trackName"] as? String {
                    // Get the formatted price string for display in the subtitle
                    cell.detailTextLabel?.text = formattedPrice
                    // Update the imageView cell to use the downloaded image data
                    cell.imageView?.image = UIImage(data: imgData)
                    // Update the textLabel text to use the trackName from the API
                    cell.textLabel?.text = trackName
            }
            
            
            return cell
        }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        if let rowData = self.tableData[indexPath.row] as? NSDictionary,
        // Get the name of the track for this row
        name = rowData["trackName"] as? String,
        // Get the price of the track on this row
            formattedPrice = rowData["formattedPrice"] as? String {
                let alert = UIAlertController(title: name, message: formattedPrice, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

