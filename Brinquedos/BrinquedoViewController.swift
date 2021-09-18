//
//  BrinquedoViewController.swift
//  Brinquedos
//
//  Created by user203358
//

import SwiftUI

class BrinquedoViewController : UIViewController {
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var sgmEstado: UISegmentedControl!
    @IBOutlet weak var txtDoador: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    @IBOutlet weak var btnSalvar: UIButton!
    
    var brinquedo : BrinquedoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareScreen()
    }
    
    func prepareScreen(){
        if let brinquedo = brinquedo {
            lblTitulo.text = "Cadastrar brinquedo"
            txtNome.text = brinquedo.nome
            sgmEstado.selectedSegmentIndex = brinquedo.estado
            txtDoador.text = brinquedo.doador
            txtEndereco.text = brinquedo.endereco
            txtTelefone.text = brinquedo.telefone
        }
        
    }
}
