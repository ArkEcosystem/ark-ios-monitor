// Copyright (c) 2016 Ark
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit
import SwiftyArk

class HomeViewController: ArkViewController {
    
    fileprivate var headerView      : HomeHeaderView!
    fileprivate var tableView       : ArkTableView!
    fileprivate var transactions    : [Transaction] = []
    fileprivate var statusBarHidden = false

    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        tableView                 = ArkTableView(CGRect.zero)
        tableView.delegate        = self
        tableView.dataSource      = self
        headerView                = HomeHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: _screenWidth, height: _screenHeight * 0.375))
        headerView.delegate       = self
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountUpdated), name: NSNotification.Name(rawValue: ArkNotifications.accountUpdated.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transactionsUpdated), name: NSNotification.Name(rawValue: ArkNotifications.transactionsUpdated.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tickerUpdated), name: NSNotification.Name(rawValue: ArkNotifications.tickerUpdated.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        if let account = ArkDataManager.currentAccount {
            headerView.update(account)
        }
        
        if let transactions = ArkDataManager.currentTransactions {
            self.transactions = transactions
            tableView.reloadData()
        }
        
        if let tickerStuct = ArkDataManager.tickerInfo {
            headerView.update(tickerStuct)
        }
    }
    
    @objc private func accountUpdated() {
        guard let account = ArkDataManager.currentAccount else {
            return
        }
        headerView.update(account)
    }
    
    @objc private func transactionsUpdated() {
        guard let newTransactions = ArkDataManager.currentTransactions else {
            return
        }
        
        guard newTransactions.containsSameElements(as: self.transactions) == false else {
            return
        }
        self.transactions = newTransactions
        tableView.reloadData()
    }
    
    
    @objc private func tickerUpdated() {
        guard let tickerStruct = ArkDataManager.tickerInfo else {
            return
        }
        headerView.update(tickerStruct)
    }
}

extension HomeViewController : UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 20.0 {
            statusBarHidden = true
        } else {
            statusBarHidden = false
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let aCell = cell as? HomeTransactionsTableViewCell {
            aCell.update(transactions[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0.0, y: 0.0, width: _screenWidth, height: 35.0))
        header.backgroundColor = ArkPalette.secondaryBackgroundColor
        
        let label = UILabel(frame: CGRect(x: 25.0, y: 0.0, width: _screenWidth - 25.0, height: 35.0))
        label.text = "Transaction History"
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = ArkPalette.highlightedTextColor
        
        header.addSubview(label)
        return header
    }
}

extension HomeViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.cellForRow(at: indexPath) as? HomeTransactionsTableViewCell
        
        if cell == nil {
            cell = HomeTransactionsTableViewCell(style: .default, reuseIdentifier: "transaction")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactions[indexPath.row]
        let vc = TransactionDetailViewController(transaction)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController : HomeHeaderViewDelegate {
    
    func headerDidTapQRCodeButton(_ view: HomeViewController.HomeHeaderView) {
        moveToReceiveView()
    }
    
    private func moveToReceiveView() {
        guard let account = ArkDataManager.currentAccount else {
            return
        }
        
        let vc = ReceiveTransferViewController(account)
        navigationController?.pushViewController(vc, animated: true)
    }
}





