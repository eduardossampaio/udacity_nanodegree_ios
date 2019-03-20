//
//  MemeTableViewController.swift
//  udacity_nanodegree_ios_meme_generator_v1
//
//  Created by Eduardo Soares Sampaio on 11/06/18.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//
//
import Foundation
import UIKit
class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var selectedMemePosition = -1;
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func goToNewMeme(_ sender: Any) {
        print("go to create meme screen")

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "createMemeViewController") as! CreateMemeViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("seledted meme\(indexPath.item)")
        self.selectedMemePosition = indexPath.item;
        performSegue(withIdentifier: "detailMeme", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMeme"{
            print("indo para detalhe")
            if let viewController: DetailMemeViewController = segue.destination as? DetailMemeViewController{
        
                viewController.meme = memes[selectedMemePosition]
            }
        }
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell",for:indexPath) as! MemeListTableCell
        let meme = self.memes[indexPath.item];
        cell.topTextLabel.text = meme.topText ?? ""
        cell.bottoTextLabel.text = meme.bottomText ?? ""
        if let memedImage = meme.memedImage{
            cell.memeImageView.image=memedImage
        }
        return cell
    }

}
