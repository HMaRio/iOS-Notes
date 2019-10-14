//
//  ViewController.swift
//  ios-todo
//
//  Created by Mario Holper on 12.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    
    var todoList = Todo.load() {
        didSet {
            //bei jeder Änderung sofort speichern
            Todo.save(todoList)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //langer Klick auf Tabellenzellen zum Ändern
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration=1.2 //in Sekunden
        tableView.addGestureRecognizer(lpgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Button 'Bearbeiten / OK'
    @IBAction func editButton(_ sender: UIButton) {
        if tableView.isEditing {
            //Edit abschließen
            tableView.setEditing(false, animated: true)
            newButton.isEnabled = true
            editButton.setTitle("Bearbeiten", for: UIControlState())
        } else {
            //Edit starten
            tableView.setEditing(true, animated: true)
            newButton.isEnabled = false
            editButton.setTitle("OK", for: UIControlState())
        }
    }
    //Button 'To-Do'
    @IBAction func addItem(sender: UIButton) {
        showPopup(sender: sender, mode: "new")
    }
    
    //Long Press -> Edit
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        //nur das Event .began ist hier interessant
        if gesture.state != .began {return}
        
        //wohin hat der Benutzer gedrückt?
        let pt = gesture.location(in: tableView)
        if let path = tableView.indexPathForRow(at: pt), let row = (path as NSIndexPath?)?.row, let cell = tableView.cellForRow(at: path) {
            showPopup(sender: cell, mode: "edit", text: todoList[row], row: row)
        }
    }
    //Popup zur Neueingabe oder zum Ändern anzeigen
    func showPopup(sender: UIView, mode: String, text: String="", row: Int=0) {
        if !(mode=="edit" || mode=="new" ) {return}
        
        let popVC = storyboard?.instantiateViewController(withIdentifier: "NewPopup") as! NewPopupVC
        popVC.mode = mode
        popVC.currentText = text
        popVC.currentRow = row
        popVC.modalPresentationStyle = .popover
        
        //Presentation Controller konfigurieren
        let popPC = popVC.popoverPresentationController!
        popPC.sourceView = sender
        popPC.sourceRect = sender.bounds
        popPC.delegate = self
        popPC.permittedArrowDirections = [.up, .down]
        //Popup anzeigen
        present(popVC, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindToMainVC(_ segue: UIStoryboardSegue) {
        //gegebenenfalls neuen Eintrag am Ende einfügen und dorthin scrollen
        if let src = segue.source as? NewPopupVC, let txt = src.txt.text {
            let trimtxt = txt.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimtxt != "" {
                if src.mode == "new" {
                    //neuen Eintrag hinzufügen
                    todoList.append(trimtxt)
                    let path = IndexPath(row: todoList.count-1, section: 0)
                    tableView.insertRows(at: [path], with: .automatic)
                    tableView.scrollToRow(at: path, at: .top, animated: true)
                } else if src.mode == "edit" {
                    //vorhandenen Eintrag ändern ...
                    todoList[src.currentRow] = trimtxt
                    let path = IndexPath(row: src.currentRow, section: 0)
                    // ... und neu zeichnen
                    tableView.reloadRows(at: [path], with: .automatic)
                }
            } //Ende if timtxt !=""
        }//Endo if-let
    }      //Ende unwind-Methode
}           //Ende class

extension ViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewController : UITableViewDataSource {
    //Anzahl der Abschnitte der Liste
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Anzahl der Listenelemente
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    //Darstellung der Tabellenzellen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProtoCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row]
        return cell
    }
    //alle Einträge sind veränderlich (für Delete on Swipe)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Eintrag löschen
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    //Verschieben für alle Elemente erlauben
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Verschieben durchführen
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = todoList[sourceIndexPath.row]
        todoList.remove(at: sourceIndexPath.row)
        todoList.insert(item, at: destinationIndexPath.row)
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(todoList[(indexPath as NSIndexPath).row])
    }
}

