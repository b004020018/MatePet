//
//  DatabaseEnum.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/9/29.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import Foundation


let colorPicker1 = ["白色", "黑色", "棕色", "黃色", "虎斑", "花色", "其他"]


enum Sexual: String {
    
    case male = "M"
    case female = "F"
    case unknown = "U"
    
    var title: String {
        
        switch self {
        case .male: return "公"
        case .female: return "母"
        case .unknown: return "未知"
        }
    }
}

enum Age: String {
    
    case child = "CHILD"
    case adult = "ADULT"
    
    var title: String {
        
        switch self {
        case .child: return "幼年"
        case .adult: return "成年"
        }
    }
}

enum Colour: String {
    case white = "白色"
    case black = "黑色"
    case brown = "棕色"
    case yellow = "黃色"
    case tabby = "虎斑"
    case mix = "花色"
    case other = "其他"

}

enum District: Int {
    case tw_tpe = 2
    case tw_nwt = 3
    case tw_kee = 4
    case tw_ila = 5
    case tw_tao = 6
    case tw_hsq = 7
    case tw_hsz = 8
    case tw_mia = 9
    case tw_txg = 10
    case tw_cha = 11
    case tw_nan = 12
    case tw_yun = 13
    case tw_cyq = 14
    case tw_cyi = 15
    case tw_tnn = 16
    case tw_khh = 17
    case tw_pif = 18
    case tw_hua = 19
    case tw_ttt = 20
    case tw_pen = 21
    case tw_kin = 22
    case tw_lie = 23
    
    var title: String {
        
        switch self {
        case .tw_tpe: return "台北市"
        case .tw_nwt: return "新北市"
        case .tw_kee: return "基隆市"
        case .tw_ila: return "宜蘭縣"
        case .tw_tao: return "桃園市"
        case .tw_hsq: return "新竹縣"
        case .tw_hsz: return "新竹市"
        case .tw_mia: return "苗栗縣"
        case .tw_txg: return "台中市"
        case .tw_cha: return "彰化縣"
        case .tw_nan: return "南投縣"
        case .tw_yun: return "雲林縣"
        case .tw_cyq: return "嘉義縣"
        case .tw_cyi: return "嘉義市"
        case .tw_tnn: return "台南市"
        case .tw_khh: return "高雄市"
        case .tw_pif: return "屏東縣"
        case .tw_hua: return "花蓮縣"
        case .tw_ttt: return "台東縣"
        case .tw_pen: return "澎湖縣"
        case .tw_kin: return "金門縣"
        case .tw_lie: return "連江縣"
        }
    }

}
