//
//  ViewController.swift
//  cotacaoBitcoin
//
//  Created by Fellipe Ricciardi Chiarello on 06/09/19.
//  Copyright © 2019 Fellipe Ricciardi Chiarello. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var precoBitcoin: UILabel!
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    //MARK: - Actions
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperarPrecoBitcoin()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.recuperarPrecoBitcoin()
    }
    
    func formatarPreco(preco: NSNumber) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_br")
        
        if let precoFinal = nf.string(from: preco){
            return precoFinal
        }
        return "0,00"
        
    }
    
    func recuperarPrecoBitcoin() {
        self.botaoAtualizar.setTitle("Atualizando", for: .normal)
        
        if let url = URL(string: "https://blockchain.info/ticker"){
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil{
                    if let dadosRetorno = dados {
                        do{
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]{
                                if let brl = objetoJson["BRL"] as? [String: Any]{
                                    if let preco = brl["buy"]as? Double{
                                        let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                        DispatchQueue.main.async(execute: {
                                            self.precoBitcoin.text =    "R$ " + precoFormatado
                                            self.botaoAtualizar.setTitle("Atualizar", for: .normal)
                                        })
                                    }
                                }
                            }
                        }catch{
                            print("Erro")
                        }
                    }
                }else{ print("Erro!")}
            }
            tarefa.resume()
        }
    }


}

