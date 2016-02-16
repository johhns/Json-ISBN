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
    
    @IBOutlet weak var resultadoText: UITextView!
    
    let hay_internet = Internet.conectado()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        resultadoText.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func ejecutarPeticion()  {
 
        if Internet.conectado() == true {
        
        let lecturaISBN = entradaISBN.text
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + lecturaISBN!
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = {
               ( datos : NSData?, resp : NSURLResponse?, error : NSError? ) -> Void in
                 let texto =  NSString(data: datos!, encoding: NSUTF8StringEncoding)
            
                 dispatch_async(dispatch_get_main_queue()) {
                   self.resultadoText.text = String(texto!)
                 }

               }
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
            
        } else {
            self.resultadoText.text = "Verifica tu coneccion de internet"
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        self.resultadoText.text = "Procesando peticion..."
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
        self.resultadoText.text = ""
        self.entradaISBN.text = ""
    }


}

