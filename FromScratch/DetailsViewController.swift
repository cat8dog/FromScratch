import UIKit

class DetailsViewController: UIViewController {
    var album: Album?
    @IBOutlet var albumCover: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.album?.title
        var url = NSURL(string: self.album!.largeImageURL!)
        var imageData = NSData(contentsOfURL: url!)
        var loadImageData = UIImage(data:imageData!)
      //  albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)

        albumCover.image = loadImageData!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
