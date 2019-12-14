//
//  DetailViewController.swift
//  ShowAirQuality
//
//  Created by Edilberto on 13/12/19.
//  Copyright © 2019 Edilberto. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //let urlbase: String = "https://e42ea33c-9d9f-4f70-ab7d-65f2353c772d.mock.pstmn.io"
    let urlbase: String = "https://api.airvisual.com/v2"
    let apikey: String = "api_key=045f8466-d157-4520-b54f-4b70662f7a63"

    var city: City = City()
    var cidade: String!
    var estado: String = "California"
    
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbAquis: UILabel!
    @IBOutlet weak var lbTp: UILabel!
    @IBOutlet weak var lbHu: UILabel!
    @IBOutlet weak var lbPr: UILabel!
    @IBOutlet weak var lbCig: UILabel!
    @IBOutlet weak var ivSta: UIImageView!
    
    @IBAction func btAtualizar(_ sender: Any) {
        if cidade != nil {
            getCidade()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if cidade != nil {
            if estado == "California" {
                city = City(cidade, estado, "USA", 144, 18, 100)
            } else {
                city = City(cidade, estado, "USA", 6, 9, 100)
            }
            showCidade()
        }
        */
        getCidade()
    }
    
    private func getCidade() {
        //if let url = URL(string: urlbase+"/cidade?nome="+self.cidade) {
        if let url = URL(string: urlbase+"/city?city="+self.cidade+"&state="+self.estado+"&country=USA&"+apikey) {
            let task = URLSession.shared.dataTask(with: url) { (result, response, error) in
                if error != nil {
                    self.msgInfo("Erro ao tentar carregar dados da web", "Atencao")
                }
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: result!, options:.mutableContainers)
                    let dictResult = jsonResult as! NSDictionary
                    if let status = dictResult["status"] as? String {
                        if let data = dictResult["data"] as? NSDictionary {
                            if status == "success" {
                                if let city = data["city"] as? String {
                                    self.city.name = city
                                }
                                if let state = data["state"] as? String {
                                    self.city.state = state
                                }
                                if let country = data["country"] as? String {
                                    self.city.country = country
                                }
                                if let current = data["current"] as? NSDictionary {
                                    if let weather = current["weather"] as? NSDictionary {
                                        if let tp = weather["tp"] as? Int {
                                            self.city.tp = tp
                                        }
                                        if let hu = weather["hu"] as? Int {
                                            self.city.hu = hu
                                        }
                                        if let pr = weather["pr"] as? Int {
                                            self.city.pr = pr
                                        }
                                    }
                                    if let pollution = current["pollution"] as? NSDictionary {
                                        if let aqius = pollution["aqius"] as? Int {
                                            self.city.aqius = aqius
                                        }
                                    }

                                }
                            } else {
                                if let message = data["message"] as? String {
                                    self.msgInfo(message, "Atencao")
                                }
                            }
                        }
                    }
                } catch {
                    self.msgInfo("Erro ao formatar retorno", "Atencao")
                }
                DispatchQueue.main.async {
                    self.showCidade()
                }
            }
            task.resume()
        }
    }

    private func showCidade() {
        lbCity.text = self.city.name
        lbState.text = self.city.state + " / " + self.city.country
        lbAquis.text = String(self.city.aqius)
        lbTp.text = String(self.city.tp) + "oC"
        lbHu.text = String(self.city.hu) + "%"
        lbPr.text = String(self.city.pr)
        lbCig.text = String(self.city.aqius * 15 / 35) + " cigarros por mes"
        ivSta.image = (self.city.aqius > 100) ? UIImage(imageLiteralResourceName: "ar_poluido.jpg") : UIImage(imageLiteralResourceName: "ar_puro.jpg")
    }
    
    private func msgInfo(_ message: String, _ title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
