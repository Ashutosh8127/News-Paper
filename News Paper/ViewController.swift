//
//  ViewController.swift
//  News Paper
//
//  Created by Ashutosh Singh on 01/08/17.
//  Copyright © 2017 Ashutosh Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
   
    @IBOutlet weak var tableView: UITableView!
    
    var articles: [Article]? = []
     
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchArticles()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchArticles(){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=google-news&sortBy=top&apiKey=b5f60edda4504880860517af8b054f4a")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil
            {
                print("error")
                return
            }
            self.articles = [Article]()
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]]
                {
                    for articleFromJson in articlesFromJson
                    {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String
                        {
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                
                    }
                   
                }
                DispatchQueue.main.async
                    {
                        self.tableView.reloadData()
                }
            }
            catch let error
            {
              print(error)
            }
        }
        task.resume()
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        DispatchQueue.main.async {
            cell.title.text = self.articles?[indexPath.item].headline
            cell.desc.text = self.articles?[indexPath.item].desc
            cell.author.text = self.articles?[indexPath.item].author
           cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)

        }
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.articles?.count ?? 0
    }
  }
extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print("error")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

