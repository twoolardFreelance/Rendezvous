//
//  WebViewController.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 09/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

protocol WebViewControllerDelegate: class {
    func webViewDidClose(webView: WKWebView?)
}

enum SiteType {
    case YeezySupply
    case DicksSportingGoods
    case Adidas
    case FootAction
    case OffCenter
    case FinishLine
    case None
}

class WebViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var urlField: UITextField!
    
    weak var delegate: WebViewControllerDelegate?
    var webView: WKWebView?
    var selectedProfile: Profile?
    
    var isInWaitingRoom = false
    var audioPlayer: AVAudioPlayer?
    var counter = 0
    var timer: Timer?
    var autofillUrls: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
        setupTextView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        self.delegate?.webViewDidClose(webView: self.webView)
        webView?.removeObserver(self, forKeyPath: "URL")
    }
    
    func setupTextView() {
        urlField.text = webView?.url?.absoluteString
        urlField.delegate = self
    }
    
    func loadWebView() {
        guard let webView = webView
            else {return}
        
        webViewContainer.addSubview(webView)
        webView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.webViewContainer.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.webViewContainer.trailingAnchor),
            webView.topAnchor.constraint(equalTo: self.webViewContainer.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.webViewContainer.bottomAnchor),
        ])
        webView.navigationDelegate = self
        view.layoutIfNeeded()
        webView.addObserver(self, forKeyPath: "URL", options: [.new, .old], context: nil)
        
        
        if (!webView.isLoading) {
            checkGoogleLogin()
        }
//            checkWaitingRoom()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newUrl = change?[.newKey] as? URL {
            let urlString = newUrl.absoluteString
            urlField.text = urlString
            autofillUrls = autofillUrls.filter { $0 != urlString }
            if urlString.contains("/payment") ||
                urlString.contains("/DSGBillingAddressView") ||
                urlString.contains("/DSGPaymentViewCmd") ||
                urlString.starts(with: "https://www.yeezysupply.com/product/"){
                webView?.load(URLRequest(url: newUrl))
            }
        }
    }
    
    func updateWebPage(_ url: String) {
        checkWaitingRoom()
        autofillWebPage(url)
        checkGoogleLogin()
    }
    
    func autofillWebPage(_ url: String) {
        let siteType = getSiteType(url)
        
        switch siteType {
        case .YeezySupply:
            autofillYeezySupply(webView!)
            break
        case .DicksSportingGoods:
            autofillDicks(webView!)
            break
        case .Adidas:
            autofillAdidas(webView!)
            break
        case .FootAction:
            autofillFootAction(webView!)
            break
        case .OffCenter:
            autofillOffCenterOffical(webView!)
            break
        case .FinishLine:
            autofillFinishLine(webView!)
            break
        default:
            if !autofillUrls.contains(url) {
                autofillShopify(webView!)
            }
            break
        }
    }
    
    func checkWaitingRoom() {
        
        if let url = webView?.url?.absoluteString, url.starts(with: "https://www.yeezysupply.com/confirmation") {
                  Global.sendWebhookMessage(
                                         url: Global.myWebhookPurchaseSuccess,
                                     message: DummyData.discordMessagePurchaseSuccessful) {
                                         print(">>> Completed")
                                     }
              }
              
        if let url = webView?.url?.absoluteString, url.starts(with: "https://www.yeezysupply.com/product/") {
            print("It is in YS")
            let injectString = """
                javascript:(function() {
                    var dom = document.getElementsByClassName('src-components-___container__container___Grvi1');
                    var result = dom.length > 0 ? 'true' : 'false';
                    return result;
                })();
            """
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.webView!.evaluateJavaScript(injectString) { (result, error) in
                    var inWaiting = false
                    if error == nil {
                        if let res = result as? String, res == "true" {
                            inWaiting = true
                            print("User is in the waiting room")
                        }
                    }
                    
                    if self.isInWaitingRoom && !inWaiting {
                        // User has passed or is no longer in the waiting room
                     /*   if let userUrl = UserDefaults.getUserUrl() { // This is a part checking user url is nil or not.
                            Global.sendWebhookMessage(
                                url: userUrl, // user's url. You are sending a message to a user.
                                message: DummyData.discordMessagePassedSplash) {
                                    print(">>> Completed")
                            }
                        }
                        Global.sendWebhookMessage(
                            url: Global.myWebhookUrl, // your url. You are sending the same mesage to you.
                            message: DummyData.discordMessagePassedSplash) {
                                print(">>> Completed")
                        }
                    */    print("User has passed or is no longer in the waiting room")
                        self.playSoundAndVibrate()
                    }
                    self.isInWaitingRoom = inWaiting
                }
            }
        }
    }
    
}

// MARK: - IBActions
extension WebViewController {
    @IBAction func closeTab(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if webView?.canGoBack ?? false {
            webView?.goBack()
        }
    }
    
    @IBAction func forwardButtonPressed(_ sender: Any) {
        if webView?.canGoForward ?? false  {
            webView?.goForward()
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        if let url = webView?.url?.absoluteString {
            autofillUrls = autofillUrls.filter { $0 != url }
        }
        webView?.reload()
    }
    
    @IBAction func miscButtonPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Profiles", message: "Please select a profile to use", preferredStyle: .actionSheet)
        
        let profiles = Global.getProfiles()
        if profiles.count > 0 {
            for profile in profiles {
                let action = UIAlertAction(title: profile.profileName, style: .default) { _ in
                    self.selectedProfile = profile
                    if let url = self.webView?.url?.absoluteString {
                        self.autofillUrls = self.autofillUrls.filter { $0 != url }
                        self.autofillWebPage(url)
                    }
                }
                actionSheet.addAction(action)
            }
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        actionSheet.addAction(dismissAction)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            break
        default:
            break
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UITextField delegate
extension WebViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            let url = URL(string: text.addingProtocol()) {
            if url != webView?.url {
                let request = URLRequest(url: url)
                webView?.load(request)
            }
        } else {
            self.prsentError(message: "Invalid URL")
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(self)
    }
}

// MARK: - WKNavigation delegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            updateWebPage(url)
        }
    }
    
}

// MARK: - private functions
fileprivate extension WebViewController {
    func getSiteType(_ url: String) -> SiteType {
        if url.hasPrefix("https://www.yeezysupply.com") {
            return SiteType.YeezySupply
        } else if url.hasPrefix("https://www.dickssportinggoods.com") {
            return SiteType.DicksSportingGoods
        } else if url.contains(".adidas.co") {
            return SiteType.Adidas
        } else if url.hasPrefix("https://www.footaction.com") || url.hasPrefix("https://www.footlocker.com") || url.hasPrefix("https://www.eastbay.com") {
            return SiteType.FootAction
        } else if url.hasPrefix("https://www.offcenterofficial.com") {
            return SiteType.OffCenter
        } else if url.hasPrefix("https://www.finishline.com") {
            return SiteType.FinishLine
        }
        return SiteType.None
    }
    
    func playSoundAndVibrate() {
        let path = Bundle.main.path(forResource: "waitingroom", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            audioPlayer?.play()
        } catch {
            print(error)
        }
        
        counter = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vibratePhone()
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.vibratePhone), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func vibratePhone() {
        counter += 1
        switch counter {
        case 1, 2, 3, 4:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            break
        default:
            timer?.invalidate()
            counter = 0
            break
        }
    }
}
