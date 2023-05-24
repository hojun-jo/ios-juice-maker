//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class JuiceMakerViewController: UIViewController, FruitStockDelegate {

    @IBOutlet private weak var strawberryStockLabel: UILabel!
    @IBOutlet private weak var bananaStockLabel: UILabel!
    @IBOutlet private weak var pineappleStockLabel: UILabel!
    @IBOutlet private weak var kiwiStockLabel: UILabel!
    @IBOutlet private weak var mangoStockLabel: UILabel!
    
    private let juiceMaker = JuiceMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFruitStockLabel()
    }
    
    @IBAction private func tapStockChangeButton(_ sender: UIBarButtonItem) {
        showFruitStockViewController()
    }
    
    @IBAction private func tapJuiceOrderButton(_ sender: UIButton) {
        do {
            let menu = try matchJuiceMenu(by: sender.tag)
            
            try juiceMaker.make(juice: menu)
            setFruitStockLabel()

            let message = "\(menu.name) 나왔습니다! 맛있게 드세요!"
            let actions = [UIAlertAction(title: "Yes!", style: .default)]
            
            Alert.default.showAlert(self, title: "제조 완료", message: message, actions: actions)
        } catch {
            var title: String? = nil
            var message = "쥬스를 만들 수 없습니다."
            var actions = [UIAlertAction(title: "Yes!", style: .default)]
            
            switch error {
            case JuiceError.nonexistentFruit:
                print("FruitStore에 해당 Fruit이 없습니다.")
            case JuiceError.shortageFruitStock:
                print("Fruit의 수량이 부족합니다.")
                
                title = "재고 부족"
                message = "재료가 모자라요. 재고를 수정할까요?"
                actions = [
                    UIAlertAction(title: "예", style: .destructive, handler: { _ in self.showFruitStockViewController() }),
                    UIAlertAction(title: "아니오", style: .cancel)
                ]
            case JuiceError.nonexistentJuiceMenu:
                print("JuiceMenu에 해당 메뉴가 없습니다.")
            default:
                print("알 수 없는 에러")
            }
            
            Alert.default.showAlert(self, title: title, message: message, actions: actions)
        }
    }
    
    private func setFruitStockLabel() {
        strawberryStockLabel.text = String(juiceMaker.fruitStore.fruitStock[.strawberry] ?? 0)
        bananaStockLabel.text = String(juiceMaker.fruitStore.fruitStock[.banana] ?? 0)
        pineappleStockLabel.text = String(juiceMaker.fruitStore.fruitStock[.pineapple] ?? 0)
        kiwiStockLabel.text = String(juiceMaker.fruitStore.fruitStock[.kiwi] ?? 0)
        mangoStockLabel.text = String(juiceMaker.fruitStore.fruitStock[.mango] ?? 0)
    }
    
    private func showFruitStockViewController() {
        guard let fruitStockViewController = self.storyboard?.instantiateViewController(withIdentifier: "FruitStockViewController") as? FruitStockViewController else {
            return
        }
        
        fruitStockViewController.modalTransitionStyle = .coverVertical
        fruitStockViewController.delegate = self
        fruitStockViewController.fruitStock = juiceMaker.fruitStore.fruitStock
        
        self.present(fruitStockViewController, animated: true)
    }
    
    private func matchJuiceMenu(by tag: Int) throws -> JuiceMenu {
        switch tag {
        case 0:
            return .strawberryJuice
        case 1:
            return .bananaJuice
        case 2:
            return .kiwiJuice
        case 3:
            return .pineappleJuice
        case 4:
            return .strawberryBananaJuice
        case 5:
            return .mangoJuice
        case 6:
            return .mangoKiwiJuice
        default:
            throw JuiceError.nonexistentJuiceMenu
        }
    }
    
    func chage(_ fruitStock: [Fruit : Int]) {
        juiceMaker.fruitStore.changeStock(fruitStock)
        setFruitStockLabel()
    }
}
