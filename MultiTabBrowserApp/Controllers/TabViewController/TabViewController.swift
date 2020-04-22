//
//  TabViewController.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 09/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAuth
import FirebaseDatabase
import AVFoundation

class TabViewController: UIViewController {
    
    var viewModel = TabViewModel()
    let cellReuseID = "WebViewCollectionViewCell"
    
    @IBOutlet weak var noTasksStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    var titleTimer: Timer?
    
    var timer: Timer?
    var waitingRooms: [String] = []
    var audioPlayer: AVAudioPlayer?
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForLogInSessions()
        setupCollectionView()
        self.setupNavigationBar()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        titleTimer?.invalidate()
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        titleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.updateTitle()
        })
        RunLoop.main.add(titleTimer!, forMode: .common)
    }
    
    @objc func updateTitle() {
        navigationItem.setTwoLineTitle(lineOne: "Browser Tasks", lineTwo: getCurrentTime())
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "WebViewCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellReuseID)
    }
    
    func addTab() {
        if !viewModel.createTab() {
            self.prsentError(message: "Maximum amount of tabs open")
        }
        collectionView.reloadData()
        toggleStackViewVisibility()
    }
    
    func toggleStackViewVisibility() {
        collectionView.isHidden = viewModel.tabs.isEmpty
    }
    
    func loadDetailWebView(webView: WKWebView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            webViewController.delegate = self
            webViewController.webView = webView
            webViewController.modalPresentationStyle = .fullScreen
            present(webViewController, animated: true, completion: nil)
        }
    }
    
    func forceLogOut() {
        let alert = UIAlertController(title: "Oops!", message: "This device has been logged out because our system recently identified a second device logged in under the same email. Please log back in.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel) { (ation) in
            do {
                try Auth.auth().signOut()
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
                UIApplication.shared.keyWindow?.rootViewController = loginViewController
            } catch {
                print("Unable to log out")
            }
        }
      
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func checkForLogInSessions() {
        let identifier = UIDevice.current.identifierForVendor!.uuidString
        Database.database().reference().child("logged_in_devices").child(identifier).observe(DataEventType.value) { (dataSnapshot) in
            if !dataSnapshot.exists() {
                self.forceLogOut()
            }
        }
    }
    
    @IBAction func settingsBtn(_ sender: Any) {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func presentLinkChangeAlert() {
        let alert = UIAlertController(title: "Mass Link Change", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter link here"
            textField.keyboardType = .URL
        }
        let okAction = UIAlertAction(title: "Go", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if
                let linkField = alert.textFields?.first,
                let linkText = linkField.text {
                if !self.viewModel.changeAll(urlString: linkText) {
                    self.prsentError(message: "Link Invalid")
                }
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension TabViewController {
    @IBAction func addTabButtonPressed(_ sender: Any) {
        addTab()
    }
    
    @IBAction func refresh(_ sender: Any) {
        viewModel.refreshAll()
    }
    
    @IBAction func closeAll(_ sender: Any) {
        self.alert(title: "Close All Tabs", message: "Warning: You are about to close all active tabs") { [weak self] in
            self?.viewModel.closeAll()
            self?.collectionView.reloadData()
            self?.toggleStackViewVisibility()
        }
    }
    
    @IBAction func changeLinks(_ sender: Any) {
        presentLinkChangeAlert()
    }
    
    @IBAction func onClickProfile(_ sender: Any) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}


extension TabViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tabCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 2) - 20, height: collectionView.frame.size.height * 0.6)
    }
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! WebViewCollectionViewCell
        let webView = viewModel.tabs[indexPath.row]
        webView.navigationDelegate = self
        cell.addWebview(webView: webView)
        cell.updateIndex(indexPath.row + 1)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webView = viewModel.tabs[indexPath.row]
        webView.removeFromSuperview()
        loadDetailWebView(webView: webView)
    }
}

extension TabViewController: WebViewCollectionViewCellDelegate {
    func closeTab(_ tab: WebViewCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: tab) {
            viewModel.deleteTab(at: indexPath.row)
            collectionView.reloadData()
            toggleStackViewVisibility()
        }
    }
}

extension TabViewController: WebViewControllerDelegate {
    func webViewDidClose(webView: WKWebView?) {
        webView?.isUserInteractionEnabled = false
        if
            let webView = webView,
            let index = self.viewModel.tabs.firstIndex(of: webView) {
            webView.removeFromSuperview()
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        collectionView.reloadData()
    }
}

extension TabViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // webView.addLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //webView.removeLoading()
        checkWaitingRoom(webView)
        checkGoogleLogin(webView)
    }
}

fileprivate extension TabViewController {
    
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        
        let time = dateFormatter.string(from: Date())
        return time
    }
    
    func checkWaitingRoom(_ webView: WKWebView) {
        
        if let url = webView.url?.absoluteString, url.starts(with: "https://www.yeezysupply.com/product/") {
            print("It is in YS")
            let injectString = """
                javascript:(function() {
                    var dom = document.getElementsByClassName('src-components-___container__container___Grvi1');
                    var result = dom.length > 0 ? 'true' : 'false';
                    return result;
                })();
            """
            webView.evaluateJavaScript(injectString) { (result, error) in
                var inWaiting = false
                if error == nil {
                    if let res = result as? String, res == "true" {
                        if !self.waitingRooms.contains(url) {
                            self.waitingRooms.append(url)
                            inWaiting = true
                            print("\(url) User is in the waiting room")
                        }
                        return
                    }
                }
                
                if self.waitingRooms.contains(url) && !inWaiting {
                    // User has passed or is no longer in the waiting room
                    print("\(url) User has passed or is no longer in the waiting room")
                    if let index = self.waitingRooms.firstIndex(of: url) {
                        self.waitingRooms.remove(at: index)
                    }
                    self.loadSettings()
                    self.discordWebhook()
                    Global.sendWebhookMessage(
                        url: Global.myWebhookUrl,
                    message: DummyData.discordMessagePassedSplash) {
                        print(">>> Completed")
                    }
                    print("User has passed or is no longer in the waiting room")
                    
                }
            }
        }
    }

    func loadSettings() {
        if (Settings.vibrateSwitchFlag) {
            vibrateMyPhone()
        }
        
        if (Settings.soundSwitchFlag) {
            playSound()
        }
        
        if (Settings.discordSwitchFlag) {
            discordWebhook()
        }
    }
    
    func playSound() {
        let path = Bundle.main.path(forResource: "waitingroom", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }

    func discordWebhook() {
        if let userUrl = UserDefaults.getUserUrl() { // This is a part checking user url is nil or not.
            Global.sendWebhookMessage(
                url: userUrl, // user's url. You are sending a message to a user.
            message: DummyData.discordMessagePassedSplash) {
                print(">>> Completed")
            }
        }
    }
    func vibrateMyPhone() {
        counter = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vibratePhone()
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.vibratePhone), userInfo: nil, repeats: true)
        }
    }
    func playSoundAndVibrate() {
        playSound()
        vibrateMyPhone();
    }
    
    @objc func vibratePhone() {
        counter += 1
        switch counter {
        case 1:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            break
        default:
            timer?.invalidate()
            break
        }
    }
}
