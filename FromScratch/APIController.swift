
import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class APIController {
    
    var delegate: APIControllerProtocol?
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            
            // Grabs the default NSURLSession object.  Used for all networking calls.
            let session = NSURLSession.sharedSession()
            
            // Creates the connection task which is going to be used to actually send the request.  Has a closure as its last parameter, which gets run upon the completion of the request.  This is where we check for errors in the response, then parse the JSON, and call the delegate method didReceiveAPIResults.
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if (error != nil) {
                
                // If there is an error, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                // Converts JSON to Foundation objects.
                //                Parameters:
                //                1) data: a data object containing JSON data.
                //                2) Options for reading the JSON data and creating the JSON objects.
                //                3) error: If an error occurs, upon return contains an NSError object that *** describes the problem.
                // Returns: A Foundation object from the JSON data in data, or nil if an error occurs.
                
                // NSJSONSerialization class converts our raw data into useful Dictionary objects by deserializing the results from iTunes
                
                if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                    if(err != nil) {
                        
                        // localizedDescription: A string containing the localized description of the error.
                        println("JSON Error \(err!.localizedDescription)")
                    }
                    if let results: NSArray = jsonResult["results"] as? NSArray {
                        
                        self.delegate?.didReceiveAPIResults(results)
                       
                        // Below is the former method of retrieving results, before moving the API call off the original ViewController.
                        /* dispatch_async(dispatch_get_main_queue(), {
                            self.tableData = results
                            self.appsTableView!.reloadData()
                        }) */
                    }
                }
            })
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
    

    
    
}
