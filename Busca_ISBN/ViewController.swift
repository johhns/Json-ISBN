//
//  ViewController.swift
//  Busca_ISBN
//
//  Created by Juan  Sanchez on 12/2/16.
//  Copyright © 2016 Juan  Sanchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var entradaISBN: UITextField!
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var autor: UILabel!
    
    @IBOutlet weak var portada: UIImageView!
    
    @IBOutlet weak var lblAutor: UILabel!
    
    let portadaVacia =   UIImage(named: "portada")
    
    
    let hay_internet = Internet.conectado()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        
        portada.image = portadaVacia
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
     
    //let texto =  NSString(data: datos!, encoding: NSUTF8StringEncoding)
    func ejecutarPeticion()  {
 
        portada.image =  portadaVacia
        if Internet.conectado() == true {
           let lecturaISBN = entradaISBN.text
           let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + lecturaISBN!
           let url = NSURL(string: urls)
           let datos = NSData(contentsOfURL: url!)
           do {
                let json = try   NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let objeto1 = json as! NSDictionary
                let lecturaSinGuiones = lecturaISBN! //.stringByReplacingOccurrencesOfString("-", withString: "")
                let nombreLlave:String = "ISBN:" + lecturaSinGuiones
                if objeto1.count > 0 {
                   let objeto2 = objeto1[nombreLlave] as! NSDictionary
                   // obtener el titulo
                   let titulo = objeto2["title"] as! NSString as String
                   self.titulo.text = titulo
                   // obtener el o los autores
                   let autores = objeto2["authors"] as! NSArray as Array
                   if autores.count > 1 {
                       lblAutor.text = "Autores : "
                    } else {
                       lblAutor.text = "Autor : "
                    }
                    var autoresTxt = ""
                    for a in 0..<autores.count {
                        let objeto3 = autores[a] as! NSDictionary
                        let nombre = objeto3["name"] as! NSString as String
                        autoresTxt = autoresTxt + nombre + "\n"
                    }
                    autor.text = autoresTxt
                    // obtener la portada
                    if objeto2["cover"] != nil {
                       let objeto4 = objeto2["cover"] as! NSDictionary
                       if objeto4.count > 0 {
                          let imagenMediana = objeto4["medium"] as! NSString as String
                          let urlImagen = NSURL(string: imagenMediana)
                          let imagenData = NSData(contentsOfURL: urlImagen!)
                          if imagenData != nil {
                             portada.image = UIImage(data: imagenData! )
                          } else {
                             portada.image =  portadaVacia
                          }
                        }
                    }
                    
                } else {
                   self.titulo.text = "codigo no encontrado"
                }
           }
           catch _ {
            
           }
            
        } else {
            self.titulo.text = "Verifica tu coneccion de internet"
        }
        
    }
    

    
    
    

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        self.titulo.text = "Procesando peticion..."
        ejecutarPeticion()

        return true
   }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        entradaISBN.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLimpiar(sender: AnyObject) {
        self.titulo.text = ""
        self.autor.text = ""
        self.portada.image = nil
        self.lblAutor.text = "Autor :"
        self.entradaISBN.text = ""
        portada.image =  portadaVacia
    }


}

