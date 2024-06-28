//
//  ConfigUpdate.swift
//  StarSpeedBrowser
//
//  Created by 李白 on 2022/1/5.
//

import Foundation

//let TEST_HOST = "ss.work"
//let PRE_HOST = "asdf987"
//let RELEASE_HOST = "csd01.com"

let CHANNEL_LIST = ["O52FEG", "D2LJU5"]

let CONFIG_KEY = MDAppinfoHelper.getConfigKey()

let CONFIG_HOST = MDAppinfoHelper.getConfigHost()

var HOST_REQUEST_SUCCESS = false

//let CONFIG_URL = "https://sz1.\(CONFIG_HOST):50100/api/strategy/client/v1/chrome/chrome_url"

let API_VERSION = "1.4.0"
var PRODUCT_CHANNEL = "N56FQ8"
let PRODUCT_UUID = "c6447788-6a83-42f6-878c-61eea6bd53d6"
let PLATFORM = "iOS"
var kEtagValue = "656624bd4-6d28"
var kBaseHost = "https://sz1.01msxs.com:50100"  //需要按照实际环境修改对应的域名 https://b58915981ddb.mdmraydmz.xyz
var divice_token: String = ""

var isStoreVersion = true
var hasShowAnounce: Bool = false

let showErrorPage = true

var showNoticeView = true
var showFeedbackView = false
var showUpdateView = false
var needShowNoticeCache = true
var needUpdate = true
var isFirstLauch = true
var updateToken = 1

var isShowExceptionView = false
var isShowJailBreakView = false
var netConnectionState:MKNetState = .connect

//var netConnectionState: MDNetState = .connect

let termsUrl = "https://jl.cshstywwh273.xyz/terms.html"

let privacyUrl = "https://jl.cshstywwh273.xyz/privacy.html"

let purchasUrl = "https://91kbvpn.com/subscription"

let itunesUrl = "https://apps.apple.com/app/%E7%8B%82%E9%A3%99%E5%8A%A0%E9%80%9F%E5%99%A8-%E6%B5%B7%E5%A4%96%E7%BD%91%E7%BB%9Cvpn%E4%B8%93%E5%AE%B6/id1658728870"

var mobileDownloadUrl = "https://91kbvpn.com"

let documentsDirectory = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
