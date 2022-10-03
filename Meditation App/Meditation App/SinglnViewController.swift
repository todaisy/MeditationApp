//
//  ViewController.swift
//  Meditation App
//
//  Created by user on 12.09.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class SinglnViewController: UIViewController {
    @IBOutlet weak var inputLogin: UITextField! //ввод логина
    @IBOutlet weak var inputPassword: UITextField! //ввод пароля
    
    let userDef = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    } //метод скрытия клавиатуры
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    } //скрыть клавиатуру
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        guard inputPassword.text?.isEmpty == false && inputPassword.text?.isEmpty == false else {
            return showAlert(message: "Поля пустые")//добавлено условие, если поля пустые - выводится сообщение
        }
        guard isValidEmail(emailID: inputLogin.text!) else {
            return showAlert(message: "Проверьте правильность почты") //добавлено условие, если почта не корректна - выводится сообщение
        }
        let url = "http://mskko2021.mad.hakta.pro/api/user/login" //ссылка на апи
        
        let param: [String: String] = [
            "email": inputLogin.text!,
            "password": inputPassword.text!
        ] //создание константы для хранения параметров
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default).validate().responseJSON { response in switch responce.result {
            case .success(let value):
                let jsin = JSON(value)
                let token = json["token"].stringValue
                self.userDef.setValue(token, forKey: "userToken")
            case .failure(let error):
                let errorJSON = JSON(response.data)
                let errorDesciption = errorJSON["error"].stringValue
                self.showAlert(message: errorDesciption)
            }
        }
        
    } //функция нажатия кнопки вход и сбора данных логина + пароля
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert) //создание константы алерт
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil)) //кнопка закрытия окна
        present(alert, animated: true, completion: nil) //метод отображения
    } //функция вывода ошибки, если ничего небыло введено
    func isValidEmail(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z{2,}]"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    } //условие для ввода почты, обязателен знак @
}

