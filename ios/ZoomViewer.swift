//
//  ZoomAuth.swift
//  ZoomSdkExample
//
//  Created by Willian Angelo on 25/01/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit
import ZoomAuthentication

var APP_TOKEN = "dAfngXBjmeVVyARrhfqebEhD35Wpt0Tf"
var APP_SECRET = "store"
var APP_USER = "current_user"
var APP_CRIPTO = "CRIPTO"

class ZoomViewer: UIViewController, ZoomEnrollmentDelegate, ZoomAuthenticationDelegate {
  
  func onZoomEnrollmentResult(result: ZoomEnrollmentResult) {
    print("\(result.status)")
    
    //
    // retrieve the enrollment audit trail image
    // note: this is enabled on a per-application basis
    // please contact support@zoomlogin.com to request access
    //
    if let auditTrail = result.faceMetrics?.auditTrail {
      print("Audit trail image count: \(auditTrail.count)")
    }
  }
  
  func onZoomAuthenticationResult(result: ZoomAuthenticationResult) {
    print("\(result.status)")
    
    if let secret = result.secret {
      print("Secret data returned from successful authentication: \(secret)")
    }
    
    //
    // retrieve the enrollment audit trail image
    // note: this is enabled on a per-application basis
    // please contact support@zoomlogin.com to request access
    //
    if let auditTrail = result.faceMetrics?.auditTrail {
      print("Audit trail image count: \(auditTrail.count)")
    }
  }
    
    
    // React Method
    @objc func getVersion(_ resolve: RCTPromiseResolveBlock,
                          rejecter reject: RCTPromiseRejectBlock) -> Void {
        
        let result: String = ZoomSDK.version
        
        if ( !result.isEmpty ) {
            resolve(result)
        } else {
            let errorMsg = "SDK Errror"
            let err: NSError = NSError(domain: errorMsg, code: 0, userInfo: nil)
            reject("getVersion", errorMsg, err)
        }
    }
    
    // React Method
    @objc func startSdk(_ appToken: String,
                        secret: String,
                        userId: String,
                        encrypt: String,
                        resolver resolve: RCTPromiseResolveBlock,
                        rejecter reject: RCTPromiseRejectBlock) -> Void {
        
        APP_TOKEN = appToken
        APP_STORE = secret
        APP_USER = userId
        APP_CRIPTO = encrypt
        
        
        //
        // We want to disable enroll and auth until App Token has been validated
        //
        
        
        // initialize ZoomSDK
        //
        // create the customization object
        var customization: ZoomCustomization = ZoomCustomization()
        
        // dark mode theme
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor,
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor,
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor,
            UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9).cgColor
        ]
        
        customization.mainBackgroundColors = [ UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9), UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9) ]
        customization.tabBackgroundColor         = UIColor(red:0.14, green:0.13, blue:0.14, alpha:1.0)
        customization.tabBackgroundSelectedColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        customization.tabTextColor               = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        customization.tabTextSelectedColor       = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        customization.tabBackgroundSuccessColor  = UIColor(red:0.00, green:0.61, blue:0.27, alpha:1.0)
        customization.tabTextSuccessColor        = UIColor(red:1.0,  green:1.0,  blue:1.0,  alpha:1.0)
        customization.resultsScreenBackgroundColor = [ UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9), UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9) ]
        customization.progressSpinnerColor1 = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9)
        customization.progressSpinnerColor2 = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.9)
        customization.progressBarColor = gradientLayer
        
        // logo intro before enrollment and authentication
        customization.showEnrollmentIntro = false
        customization.showAuthenticationIntroLogo = false
        
        
        ZoomSDK.initialize(
            appToken: APP_TOKEN,
            enrollmentStrategy: .ZoomOnly,
            interfaceCustomization: customization,
            completion: { (appTokenValidated: Bool) -> Void in
                //
                // We want to ensure that App Token is valid before enabling Enroll and Auth button
                //
                if appTokenValidated {
                    let message = "AppToken validated successfully"
                    print(message)
                    resolve(message)
                }
                else {
                    let errorMsg = "AppToken did not validate.  If Zoom ViewController's are launched, user will see an app token error state"
                    print(errorMsg)
                    let err: NSError = NSError(domain: errorMsg, code: 0, userInfo: nil)
                    reject("ZoomSDK.initialize", errorMsg, err)
                }
        })
    }
  
    
    func checkAuth() -> Bool {
        return ZoomSDK.isUserEnrolled(userID: APP_USER)
    }
  
    // React Method
  @objc func onEnrollPressed(_ resolve: RCTPromiseResolveBlock,
                             rejecter reject: RCTPromiseRejectBlock) -> Void {
    
    let enrollVC = ZoomSDK.createEnrollmentVC()
    
    enrollVC.prepareForEnrollment(
      delegate: self,
      userID: APP_USER,
      applicationPerUserEncryptionSecret: APP_CRIPTO,
      secret: APP_SECRET
    )
    
    self.present(enrollVC, animated: true, completion: nil)
    
   
    if ( let result = self.checkAuth() ) {
      resolve(result)
    } else {
      let errorMsg = "Authenticate"
      let err: NSError = NSError(domain: errorMsg, code: 0, userInfo: nil)
      reject("isUserEnrolled", errorMsg, err)
    }
    
  }
    
    // React Method
    @objc func onAuthenticateButtonClicked(_ sender: Any) {
        let authVC = ZoomSDK.createAuthenticationVC()
        authVC.prepareForAuthentication(
            delegate: self,
            userID: APP_USER,
            applicationPerUserEncryptionSecret: APP_CRIPTO
        )
        
        authVC.modalTransitionStyle = .coverVertical
        authVC.modalPresentationStyle = .overFullScreen
        self.present(authVC, animated: true, completion: nil)
        
        if ( let result = self.checkAuth() ) {
            resolve(result)
        } else {
            let errorMsg = "Authenticate"
            let err: NSError = NSError(domain: errorMsg, code: 0, userInfo: nil)
            reject("isUserEnrolled", errorMsg, err)
        }
    }
  
  
}

