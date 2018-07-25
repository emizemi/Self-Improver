//
//  DisplayReflections.swift
//  CSIA
//
//  Created by Emilio Encarnacion on 23/7/18.
//  Copyright © 2018 Emilio Encarnacion. All rights reserved.
//

import UIKit

//ADDBACK UISearchResultsUpdating
class DisplayReflections: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData = [String]()
    var isSearching = false
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalVariables.selectedReflectionText = UserDefaults.standard.string(forKey: String(indexPath.row) + "reflectionText")!

        globalVariables.selectedReflectionDateAdded = UserDefaults.standard.string(forKey: String(indexPath.row) + "reflectionDateAdded")!
        
        //INSERT AN IF STATEMENT OF SOME SORT IF A GUIDED REFLECTION IS SELECTED
        globalVariables.selectedReflection =  Reflection(text: globalVariables.selectedReflectionText, dateAdded:globalVariables.selectedReflectionDateAdded)
        performSegue(withIdentifier: "reflectionSegue", sender: self)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            //IF STATEMENT HERE
            UserDefaults.standard.removeObject(forKey: String(indexPath.row) + "reflectionText")
            UserDefaults.standard.removeObject(forKey: String(indexPath.row) + "reflectionDateAdded")
            
            if globalVariables.reflectionKey != -1 {
                globalVariables.reflectionKey = globalVariables.reflectionKey - 1
            }
            
            print("---Start---")
            print("This is the globlVariables.reflectionKey")
            print(globalVariables.reflectionKey)
            print("---end---")
            
            var currentRow = indexPath.row
            repeat{
                UserDefaults.standard.set(UserDefaults.standard.object(forKey: String(currentRow + 1) + "reflectionText"), forKey: String(currentRow) + "reflectionText")
                UserDefaults.standard.set(UserDefaults.standard.object(forKey: String(currentRow + 1) + "reflectionDateAdded"), forKey: String(currentRow) + "reflectionDateAdded")
                
                currentRow = currentRow + 1
            } while UserDefaults.standard.object(forKey: String(currentRow) + "reflectionText") != nil
            
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var count = -1
        repeat{
            count = count + 1
        } while UserDefaults.standard.object(forKey: String(count) + "reflectionText") != nil
        globalVariables.reflectionKey = count - 1
        print("---Start---")
        print("This is the globlVariables.reflectionKey")
        print(globalVariables.reflectionKey)
        print("---end---")
    }

    //WE NEED TO DO THIS... GLOBAL VARIALBE?
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var count = -1
        repeat{
            count = count + 1
        } while UserDefaults.standard.object(forKey: String(count) + "reflectionText") != nil
        globalVariables.reflectionKey = count - 1
        
        if isSearching {
            return filteredData.count
        }
        return  globalVariables.reflectionKey + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reflectionCell", for: indexPath)
        
        let text: String!
        if isSearching {
            text = filteredData[indexPath.row]
            cell.textLabel?.text = text
        } else {
        cell.textLabel?.text = UserDefaults.standard.string(forKey: String(indexPath.row) + "reflectionDateAdded")
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                var dateAddedArray = [String]()
                var count = -1
                repeat{
                    count = count + 1
                } while UserDefaults.standard.object(forKey: String(count) + "reflectionDateAdded") != nil
                globalVariables.reflectionKey = count - 1
        
                count = 0
                repeat{
                    dateAddedArray.append(UserDefaults.standard.string(forKey: String(count) + "reflectionDateAdded")!)
                    count = count + 1
                } while count <= globalVariables.reflectionKey
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            myTableView.reloadData()
        }else{
            isSearching = true
            filteredData = dateAddedArray.filter({$0 == searchBar.text})
            
            myTableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
