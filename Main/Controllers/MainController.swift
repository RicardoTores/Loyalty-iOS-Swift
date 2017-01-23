import UIKit

class MainController: UIViewController {
    var isLaunching = true
    var currentViewController: UIViewController?
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var tabBarButtons: Array<UIButton>!
    
    @IBOutlet weak var btnStores: UIButton!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var imgBtnCard: UIImageView!
    @IBOutlet weak var imgBtnStores: UIImageView!
    @IBOutlet weak var topMenu: UIView!
    @IBOutlet weak var containerCafes: UIView!
    @IBOutlet weak var containerCard: UIView!
    @IBOutlet weak var containerCafesDetail: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchToCafes(false);
        
        self.scrollView.contentSize.width = self.containerCafes.bounds.width * 3
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector:#selector(MainController.cafesDetailUI(_:)), name:"cafesDetailUI", object: nil)
        nc.addObserver(self, selector:#selector(MainController.cafesUI(_:)), name:"cafesUI", object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // test for sap
    }
 
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isLaunching == true{
            //scrollView.setContentOffset(CGPoint(x: self.containerCafes.bounds.width, y: 0), animated: false)
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            
            isLaunching = false
        }
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    @IBAction func onTabTopMenu(sender: UIButton) {
        let id = sender
        switch (id) {
        case self.btnStores:
            self.switchToCafes(true)
            break
        case self.btnCard:
            self.switchToCafes(false)
            break
        default:
            break
        }

    }
    
    func switchToCafes(isCafes : Bool){
        if isCafes {
            imgBtnStores.hidden = false
            imgBtnCard.hidden = true
            btnCard.setTitleColor(UIColor(red:122/255.0, green:132/255.0, blue:142/255.0, alpha:1.0), forState: .Normal);
            btnStores.setTitleColor(UIColor.whiteColor(), forState: .Normal);
            scrollView.setContentOffset(CGPoint(x: self.containerCafes.bounds.width, y: 0), animated: true)
        }else{
            imgBtnStores.hidden = true
            imgBtnCard.hidden = false
            btnStores.setTitleColor(UIColor(red:122/255.0, green:132/255.0, blue:142/255.0, alpha:1.0), forState: .Normal);
            btnCard.setTitleColor(UIColor.whiteColor(), forState: .Normal);
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func cafesDetailUI(notifi:NSNotification?){
       scrollView.setContentOffset(CGPoint(x: self.containerCafesDetail.bounds.width * 2, y: 0), animated: true)        
    }
    func cafesUI(notifi:NSNotification?){
        self.switchToCafes(true)
    }
}


extension MainController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.x == self.containerCafes.bounds.width{
                switchToCafes(true)
            }else if scrollView.contentOffset.x == 0{
                switchToCafes(false);
            }
        }
    }
    
}
