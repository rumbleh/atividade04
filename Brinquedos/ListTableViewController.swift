//
//  ListTableViewController.swift
//  ShoppingList
//
//

import UIKit
import Firebase
import FirebaseFirestore
	
class ListTableViewController: UITableViewController {
    
    let collection = "brinquedos"
    var brinquedoList: [BrinquedoItem] = []
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBrinquedoList()
    }
    
    func loadBrinquedoList(){
        listener = firestore.collection("brinquedos").order(by: "nome", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
            if let error = error {
                print(error)
            } else {
                guard let snapshot = snapshot else { return }
                print ("Total de brinquedos alterados:  \(snapshot.documentChanges.count)")
                //if (snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0)	 {
                    self.showItemsFrom(snapshot)
                    
                /*} else {
                    self.showItemsFrom(snapshot)
                }*/
            }
        })
    }
    
    func showItemsFrom (_ snapshot: QuerySnapshot){
        brinquedoList.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let nome = data["nome"] as? String,
               let estado = data["estado"] as? Int,
               let doador = data["doador"] as? String,
               let endereco = data["endereco"] as? String,
               let telefone = data["telefone"] as? String {
               let brinquedoItem = BrinquedoItem(id: document.documentID, nome: nome, estado: estado, doador: doador, endereco: endereco, telefone: telefone)
              brinquedoList.append(brinquedoItem)
            }
            
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let brinquedoViewController = segue.destination as? BrinquedoViewController,
            let row = tableView.indexPathForSelectedRow?.row {
                brinquedoViewController.brinquedo = brinquedoList[row]
            }
    }
    
    func showAlertForItem(_ item: BrinquedoItem? = nil){
        let alert = UIAlertController(title: "Brinquedo", message: "Informe os dados do brinquedo'", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Nome"
            textField.text = item?.nome
        }
        alert.addTextField { textField in
            textField.placeholder = "Estado (0 - novo, 1 - usado, 2 - precisa reparo)"
            textField.text = item?.estado.description
            textField.keyboardType =  .numberPad
        }
        alert.addTextField { textField in
            textField.placeholder = "Doador"
            textField.text = item?.doador
        }
        alert.addTextField { textField in
            textField.placeholder = "Endereço"
            textField.text = item?.endereco
        }
        alert.addTextField { textField in
            textField.placeholder = "Telefone"
            textField.text = item?.telefone
        }
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
            
            guard let nome = alert.textFields?[0].text,
            let estado = alert.textFields?[1].text,
            let doador = alert.textFields?[2].text,
            let endereco = alert.textFields?[3].text,
            let telefone = alert.textFields?[4].text else {
                return
            }
            
            let data: [String: Any] = [
                "nome": nome,
                "estado": Int(estado),
                "doador": doador,
                "endereco": endereco,
                "telefone": telefone
            ]
            
            if let item = item{
                self.firestore.collection(self.collection).document(item.id).updateData(data)
            } else {
                self.firestore.collection(self.collection).addDocument(data: data)
            }
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present	(alert, animated: true, completion: nil)
    }
    @IBAction func addItem(_ sender: Any) {
        showAlertForItem()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brinquedoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let estados = ["Novo", "Usado", "Precisa de reparo"	]
        let brinquedoItem = brinquedoList[indexPath.row]
        cell.textLabel?.text = brinquedoItem.nome
        cell.detailTextLabel?.text = estados[brinquedoItem.estado]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
