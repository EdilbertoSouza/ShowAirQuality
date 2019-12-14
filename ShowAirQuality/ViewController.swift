//
//  ViewController.swift
//  ShowAirQuality
//
//  Created by Edilberto on 07/12/19.
//  Copyright © 2019 Edilberto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //let urlbase: String = "https://api.airvisual.com/v2"
    //let apikey: String = "api_key=045f8466-d157-4520-b54f-4b70662f7a63"
    let urlbase: String = "https://e42ea33c-9d9f-4f70-ab7d-65f2353c772d.mock.pstmn.io"
    var estados: [String] = ["Alabama", "California","Texas"]
    var estado: String = "Alabama"
    var cidades: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var pvState: UIPickerView!
    
    @IBAction func btList(_ sender: UIButton) {
        getCidades()
    }
    
    @IBOutlet weak var table: UITableView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.estados.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.estados[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.estado = self.estados[row]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cidades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celReuso", for: indexPath) as! CityCell
        let cidade = cidades[indexPath.row]
        //cell.textLabel?.text = cidade
        cell.lbCidade?.text = cidade
        cell.lbDescricao?.text = "Uma boa cidade para se morar..."
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    fileprivate func getEstados() {
        if let url = URL(string: urlbase+"/estados") {
            let task = URLSession.shared.dataTask(with: url) { (result, response, error) in
                if error != nil {
                    print("Erro ao tentar carregar dados da web")
                }
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: result!, options:.mutableContainers)
                    let dictResult = jsonResult as! NSDictionary
                    if let status = dictResult["status"] as? String {
                        if status != "success" {
                            print("Erro na resposta do servidor")
                        }
                        if let data = dictResult["data"] as? NSArray {
                            for i in 0...data.count-1 {
                                if let elemento = data[i] as? [String: String] {
                                    if let dado = elemento["state"] {
                                        self.estados.append(dado)
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.pvState.reloadAllComponents()
                            }
                        }
                    }
                } catch {
                    print("Erro ao formatar retorno")
                }
            }
            task.resume()
        }
    }

    private func getCidades() {
        self.cidades = []
        if let url = URL(string: urlbase+"/cidades?estado="+self.estado) {
        //if let url = URL(string: urlbase+"/cities?state="+self.estado+"&country=USA&"+apikey) {
            let task = URLSession.shared.dataTask(with: url) { (result, response, error) in
                if error != nil {
                    self.msgInfo("Erro ao tentar carregar dados da web", "Atencao")
                }
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: result!, options:.mutableContainers)
                    let dictResult = jsonResult as! NSDictionary
                    if let status = dictResult["status"] as? String {
                        if let data = dictResult["data"] as? NSArray {
                            for i in 0...data.count-1 {
                                if let elemento = data[i] as? [String: String] {
                                    if status == "success" {
                                        if let dado = elemento["city"] {
                                            self.cidades.append(dado)
                                        }
                                    } else {
                                        if let dado = elemento["message"] {
                                            self.msgInfo(dado, "Atencao")
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    self.msgInfo("Erro ao formatar retorno", "Atencao")
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegue" {
            if let indexPath = table.indexPathForSelectedRow {
                let cidadeSelecionada = self.cidades[indexPath.row]
                let vcDestino = segue.destination as! DetailViewController
                vcDestino.cidade = cidadeSelecionada
                vcDestino.estado = self.estado
            }
        }
    }
    
    private func msgInfo(_ message: String, _ title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}

