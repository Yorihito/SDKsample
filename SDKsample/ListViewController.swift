//
//  ListViewController.swift
//  SDKsample
//
//  Created by Yorihito Tada on 2018/04/11.
//  Copyright © 2018 ytada. All rights reserved.
//


import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cads: NSArray!
    var cloyaltyCards: NSArray!
    var cOffers: NSArray!
    
    @IBOutlet weak var secondTable: UITableView!
    
    var chosenCellinFirst: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        secondTable.register(UINib(nibName: "ListTableViewCell", bundle: nil),forCellReuseIdentifier: "cell_02")
        
        secondTable.delegate = self
        secondTable.dataSource = self
        
        switch chosenCellinFirst {
        case "List Ad":
            listAd()
        case "List LC":
            listLC()
        case "List Offer":
            listOffer()
        default:
            break
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch chosenCellinFirst {
        case "List Ad":
            return cads != nil ? (cads.count) : 0
        case "List LC":
            return cloyaltyCards != nil ? (cloyaltyCards.count) : 0
        case "List Offer":
            return cOffers != nil ? (cOffers.count) : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // UITableViewCell instance
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_02", for: indexPath) as! ListTableViewCell
        
        // cell contents
        switch chosenCellinFirst {
            
        case "List Ad":
            if let ad = cads[indexPath.row] as? VMAdvertisement {
                cell.secondLabel.text = ad.title
                cell.imageView?.image = nil
                if let imageURL = ad.getImageUrl(withWidth: 100, height: 100, imageFormat: VMImageFormatJPEG) {
                    let url = URL(string: imageURL)
                    do  {
                        let image: NSData = try NSData(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
                        cell.imageView?.image = UIImage(data: image as Data)
                    }
                    catch{
                        break
                    }
                    print("ad:imageURL",imageURL)
                }
            }
            
        case "List LC":
            if let LC = cloyaltyCards[indexPath.row] as? VMLoyaltyCard {
                cell.secondLabel.text = LC.title
                print("LC:id",LC.contentId!)
                print("LC:title",LC.title!)
                print("LC:extended data",LC.extendedData)
                for instance in LC.instances {
                    print("LC:redeemedOfferId",instance.redeemedOfferId)
                }
            }
            
        case "List Offer":
            if let offer = cOffers[indexPath.row] as? VMOffer {
                cell.secondLabel.text = offer.title
                print("offer:title",offer.title)
                cell.imageView?.image = nil
                if let imageURL = offer.getImageUrl(withWidth: 100, height: 100, imageFormat: VMImageFormatJPEG) {
                    let url = URL(string: imageURL)
                    do  {
                        let image: NSData = try NSData(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
                        cell.imageView?.image = UIImage(data: image as Data)
                    }
                    catch{
                        break
                    }
                    print("offer:imageURL",imageURL)
                }
                
                for tag in offer.tags {
                    print("offer:content tags",tag)
                }
                print("offer:isReward",offer.isReward)
                print("offer:instance id",offer.instanceId)
            }
            
        default:
            cell.secondLabel.text = "Table" + String(describing: indexPath)
            
        }
        
        return cell
    }
    
    let VMobAdvtChannelCode = "MAN"
    
    func listAd(){
        let sc = VMAdSearchCriteriaBuilder()
            .setChannel(VMobAdvtChannelCode)
            .setLimit(100, offset: 0)
            .setIgnoreDailyTimeFilter(true)
            .build()
        
        VMob.sharedInstance().advertisementsManager().getAdvertisementsWith(sc)
        { (ads, error) in
            if error != nil {
                print(error ?? "error")
            } else {
                if let ads = ads as? NSArray {
                    self.cads = ads
                    print("Load Ad success")
                    self.secondTable.reloadData()
                }
            }
        }
    }
    
    func listLC(){
        VMob.sharedInstance().loyaltyCardsManager().getLoyaltyCards() { (loyaltyCards, error) in
            if let error = error {
                print(error)
                return
            } else {
                if let loyaltyCards = loyaltyCards as? NSArray {
                    self.cloyaltyCards = loyaltyCards
                    print("load LC success")
                    self.secondTable.reloadData()
                }
            }
        }
    }
    
    func listOffer(){
        let fields = [
            "id",
            "title",
            "description",
            "startDate",
            "endDate",
            "image",
            "contentTagReferenceCodes",
            "sortOrder",
            "extendedData",
            "dailyStartTime",
            "dailyEndTime",
            "daysOfWeek",
            "weighting",
            "isReward",
            "redemptionCount",
            "isRespawningOffer",
            "respawnsInDays",
            "offerInstanceUniqueId"
        ]
        
        let sc = VMOfferSearchCriteriaBuilder()
            .setKeyword(nil)
            //            .setCategoryId(categoryId)
            .setMerchantId(nil)
            //            .setSortCriteria(VMOfferSortCriteria_Weight)
            //            .setSortDirection(VMOfferSortOrder_Descending)
            //            .setTagsFilterExpression("") // not Felica Coupon
            //            .setLimit(0, offset: 0)
            .setIgnoreDailyTimeFilter(true)
            .setIgnoreDayFilter(false)
            .setRankedSearch(false)
            .setFields(fields)
            .build()
        
        VMob.sharedInstance().offersManager().getOffersWith(sc) { (offers, error) in
            if let error = error {
                print(error)
                return
            } else {
                if let offers = offers as? NSArray {
                    self.cOffers = offers
                    print("load Offer success")
                    self.secondTable.reloadData()
                }
            }
        }
    }
}
