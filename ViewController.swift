//
//  ViewController.swift
//  CreditCardHandlerApp
//
//  Created by Peter Qiu on 3/16/15.
//  Copyright (c) 2015 Peter Qiu. All rights reserved.
//


import UIKit
import CreditCardHandler
//import AppKit

class ViewController: UIViewController {
    @IBOutlet weak var txtLog: UITextView!
    
    @IBOutlet weak var txtFile: UITextField!
    
    let _handler: IJCreditCardHandler = IJCreditCardHandler()
    var _file = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _handler.initializeSDK(LogLevel.Trace.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func EMV_Click(sender: AnyObject) {
        let gi = GeneralInfoVO()
        gi.DepartureTime = NSDate()
        gi.DestinationAirport = "ORD"
        gi.OriginatingAirport = "MCO"
        gi.FlightNum = "101"
        gi.companyId = 1006
        gi.crewId = 104
        gi.deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        _handler.GeneralInfomation = gi
        //if(!_handler.StartEMVTransaction(TransactionTypes.Purchase.rawValue, amt: "18.88", currency: "USD"))
        if(!_handler.StartEMVTransaction(TransactionTypes.Purchase.rawValue, amt:"18.88", currency:"USD", itemId:1002,  seatNum:"21F", fareClass:"First Class",ffStatus:"Platinum"))
        {
            txtLog.text = txtLog.text + "Device is not connect or time out!\n"
        }
        let emv = _handler.EMVInfo
        if(emv.NonEMVConfirmationResponseCode == "A")
        {
            txtLog.text = txtLog.text + "Transaction Approved!\n"
        }
        else if(emv.NonEMVConfirmationResponseCode == "D")
        {
            let reason = _handler.GetDeclineReasons(_handler.EMVInfo.EMVCardTerminalVerificationResults)
            txtLog.text = txtLog.text + reason + "\n"
        }
        if(emv.NonEMVErrorResponseCode.utf16Count > 0)
        {
            txtLog.text = txtLog.text + _handler.GetErrorDescription(_handler.EMVInfo.NonEMVErrorResponseCode) + "\n"
        }
    }
    
    @IBAction func Swiped_Click(sender: AnyObject) {
        let gi = GeneralInfoVO()
        gi.DepartureTime = NSDate()
        gi.DestinationAirport = "ORD"
        gi.OriginatingAirport = "MCO"
        gi.FlightNum = "101"
        gi.companyId = 1006
        gi.crewId = 104
        gi.deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        _handler.GeneralInfomation = gi
        let ok = _handler.StartSwipedTransaction(TransactionTypes.Purchase.rawValue, amt:"18.88", currency:"USD", itemId:1002,  seatNum:"21F", fareClass:"First Class",ffStatus:"Platinum")
        if(ok)
        {
            txtLog.text = txtLog.text + _handler.TrackData3 + "\n"
        }
        else
        {
            txtLog.text = txtLog.text + "Device is not connect or time out!\n"
        }
    }
        
    @IBAction func NFC_Click(sender: AnyObject) {
        let gi = GeneralInfoVO()
        gi.DepartureTime = NSDate()
        gi.DestinationAirport = "ORD"
        gi.OriginatingAirport = "MCO"
        gi.FlightNum = "101"
        gi.companyId = 1006
        gi.crewId = 104
        gi.deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        _handler.GeneralInfomation = gi
        if(_handler.StartNFCTransaction(TransactionTypes.Purchase.rawValue, amt:"18.88", currency:"USD", itemId:1002,  seatNum:"21F", fareClass:"First Class",ffStatus:"Platinum"))
        {
            txtLog.text = txtLog.text + _handler.TrackData3 + "\n"
        }
        else
        {
            txtLog.text = txtLog.text + "Device is not connect or time out!\n"
        }
    }
    
    @IBAction func Browse_Click(sender: AnyObject) {
//        var openPanel = NSOpenPanel()
//        openPanel.allowsMultipleSelection = false
//        openPanel.canChooseDirectories = false
//        openPanel.canCreateDirectories = false
//        openPanel.canChooseFiles = true
//        openPanel.beginWithCompletionHandler { (result) -> Void in
//            if result == NSFileHandlingPanelOKButton
//            {
//                let _file = openPanel.URL
//            }
//        }
    }
    
    @IBAction func Upload_Click(sender: AnyObject) {
        let content = String(contentsOfFile: _file, encoding: NSUTF8StringEncoding, error: nil)
        
        let url = NSURL(string: "http://myrestservice")
        let theRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(theRequest, queue: nil, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data.length > 0 && error == nil
            {
                let response : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: nil)
            }
        })
    }

}

