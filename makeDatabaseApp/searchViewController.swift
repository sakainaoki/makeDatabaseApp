//
//  searchViewController.swift
//  makeDatabaseApp
//
//  Created by 酒井直輝 on 2021/06/21.
//

import UIKit
import Firebase
import FirebaseFirestore
class searchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
    @IBOutlet weak var tableView: UITableView!
    var foodsArray:[FoodModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadFireStore()
        // Do any additional setup after loading the view.
    }
    func loadFireStore(){
        let db = Firestore.firestore()
       
        db.collection("foods").getDocuments { SnapshotMetadata, Error in
            if Error != nil{
                print("error")
                return
            }
            if let snapShotDoc = SnapshotMetadata?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let foodName = data["foodName"] as? String,let carb = data["carb"] as? String,let protein = data["protein"] as? String,let fat = data["fat"] as? String,let kcal = data["kcal"] as? String{
                        let foodModel = FoodModel(foodName: foodName, carb: carb, protein: protein, fat: fat,kcal: kcal)
                        self.foodsArray.append(foodModel)
                        
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = foodsArray[indexPath.row].foodName
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
