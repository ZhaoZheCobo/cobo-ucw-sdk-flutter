import Flutter
import UIKit
import TSSSDK

public class UcwSdkPlugin: NSObject, FlutterPlugin {
  private var connInstance: TssConnection?
  private var logInstance: TssLogger?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ucw_sdk", binaryMessenger: registrar.messenger())
    let instance = UcwSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    instance.logInstance = TssLogger()
    let logChannel = FlutterEventChannel(name: "ucw_sdk/logs", binaryMessenger: registrar.messenger())
    logChannel.setStreamHandler(instance.logInstance)
    TssSetLogger(instance.logInstance)


    instance.connInstance = TssConnection()
    let connChannel = FlutterEventChannel(name: "ucw_sdk/connection", binaryMessenger: registrar.messenger())
    connChannel.setStreamHandler(instance.connInstance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? Dictionary<String, Any> ?? [:]

    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "initializeSecrets":
      initializeSecrets(arguments: arguments, flutterResult: result)
    case "open":
      open(arguments: arguments, flutterResult: result)
    case "openPublic":
      openPublic(arguments: arguments, flutterResult: result)
    case "close":
      close(arguments: arguments, flutterResult: result)
    case "getTSSNodeID":
      getTSSNodeID(arguments: arguments, flutterResult: result) 
    case "listTSSKeyShareGroups":
      listTSSKeyShareGroups(arguments: arguments, flutterResult: result)
    case "getTSSKeyShareGroups":
      getTSSKeyShareGroups(arguments: arguments, flutterResult: result)
    case "listPendingTSSRequests":
      listPendingTSSRequests(arguments: arguments, flutterResult: result)
    case "getTSSRequests":
      getTSSRequests(arguments: arguments, flutterResult: result)
    case "approveTSSRequests":
      approveTSSRequests(arguments: arguments, flutterResult: result)
    case "rejectTSSRequests":
      rejectTSSRequests(arguments: arguments, flutterResult: result)
    case "listPendingTransactions":
      listPendingTransactions(arguments: arguments, flutterResult: result)
    case "getTransactions":
      getTransactions(arguments: arguments, flutterResult: result)
    case "approveTransactions":
      approveTransactions(arguments: arguments, flutterResult: result)
    case "rejectTransactions":
      rejectTransactions(arguments: arguments, flutterResult: result)
    case "exportSecrets":
        exportSecrets(arguments: arguments, flutterResult: result)
    case "exportRecoveryKeyShares":
        exportRecoveryKeyShares(arguments: arguments, flutterResult: result)
    case "importRecoveryKeyShare":
        importRecoveryKeyShare(arguments: arguments, flutterResult: result)
    case "recoverPrivateKeys":
        recoverPrivateKeys(arguments: arguments, flutterResult: result)
    case "cleanRecoveryKeyShares":
        cleanRecoveryKeyShares()
    case "importSecrets":
        importSecrets(arguments: arguments, flutterResult: result)
    case "getSDKInfo":
        getSDKInfo(flutterResult: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func initializeSecrets(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let secretsFile = arguments["secretsFile"] as? String,
      let passphrase = arguments["passphrase"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    TssInitializeSecrets(secretsFile, passphrase, TssCallbackWithData(flutterResult: flutterResult))
  }


  func open(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let configEnv = arguments["config.env"] as? String,
      let configDebug = arguments["config.debug"] as? Bool,
      let secretsFile = arguments["secretsFile"] as? String,
      let passphrase = arguments["passphrase"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }

    let config = TssSDKConfig()
    config.env = configEnv
    config.debug = configDebug

    self._handleTssResultWithData(tssResult: TssOpen(config, secretsFile, passphrase, connInstance), flutterResult: flutterResult)
  }

  func openPublic(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let secretsFile = arguments["secretsFile"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssOpenPublic(secretsFile), flutterResult: flutterResult)
  }

  func close(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResult(tssResult: TssClose(handler), flutterResult: flutterResult)
  }

  // public
  func getTSSNodeID(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssGetTSSNodeID(handler), flutterResult: flutterResult)
  }

  func listTSSKeyShareGroups(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssListTSSKeyShareGroups(handler), flutterResult: flutterResult)
  }

  func getTSSKeyShareGroups(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let tssKeyShareGroupIDs = arguments["tssKeyShareGroupIDs"] as? [String] else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: tssKeyShareGroupIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert groupIDs to JSON string error: \(error)", details: nil))
      return
    }

    guard let jsonGroupIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert groupIDs to JSON string error", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssGetTSSKeyShareGroups(handler, jsonGroupIDs), flutterResult: flutterResult)
  }
  
  // TSS Request
  func listPendingTSSRequests(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let timeout = arguments["timeout"] as? Int32 else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    TssListPendingTSSRequests(handler, timeout, TssCallbackWithData(flutterResult: flutterResult))
  }

  func getTSSRequests(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let tssRequestIDs = arguments["tssRequestIDs"] as? [String],
      let timeout = arguments["timeout"] as? Int32 else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: tssRequestIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert tssRequestIDs to JSON string error: \(error)", details: nil))
      return
    }

    guard let jsonTSSRequestIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert tssRequestIDs to JSON string error", details: nil))
      return
    }
    TssGetTSSRequests(handler, jsonTSSRequestIDs, timeout, TssCallbackWithData(flutterResult: flutterResult))
  }

  func approveTSSRequests(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let tssRequestIDs = arguments["tssRequestIDs"] as? [String] else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: tssRequestIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert tssRequestIDs to JSON string error: \(error)", details: nil))
      return
    }

    guard let jsonTSSRequestIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert tssRequestIDs to JSON string error", details: nil))
      return
    }
    self._handleTssResult(tssResult: TssApproveTSSRequests(handler, jsonTSSRequestIDs), flutterResult: flutterResult)
  }

  func rejectTSSRequests(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let tssRequestIDs = arguments["tssRequestIDs"] as? [String],
      let reason = arguments["reason"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: tssRequestIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert tssRequestIDs to JSON string error: \(error)", details: nil))
      return
    }

    guard let jsonTSSRequestIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert tssRequestIDs to JSON string error", details: nil))
      return
    }
    self._handleTssResult(tssResult: TssRejectTSSRequests(handler, jsonTSSRequestIDs, reason), flutterResult: flutterResult)
  }

  // Transaction
  func listPendingTransactions(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let timeout = arguments["timeout"] as? Int32 else {
      flutterResult(FlutterError(code: "IInvalid arguments", message: "Missing arguments", details: nil))
      return
    }
    TssListPendingTransactions(handler, timeout, TssCallbackWithData(flutterResult: flutterResult))
  }

  func getTransactions(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let transactionIDs = arguments["transactionIDs"] as? [String],
      let timeout = arguments["timeout"] as? Int32 else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }

    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: transactionIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert transactionIDs to JSON data error: \(error)", details: nil))
      return
    }

    guard let jsonTransactionIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert transactionIDs to JSON string error", details: nil))
      return
    }
    TssGetTransactions(handler, jsonTransactionIDs, timeout, TssCallbackWithData(flutterResult: flutterResult))
  }


  func approveTransactions(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let transactionIDs = arguments["transactionIDs"] as? [String] else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: transactionIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert transactionIDs to JSON string error: \(error)", details: nil))
      return
    }

    guard let jsonTransactionIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert transactionIDs to JSON string error", details: nil))
      return
    }
    self._handleTssResult(tssResult: TssApproveTransactions(handler, jsonTransactionIDs), flutterResult: flutterResult)
  }

  func rejectTransactions(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let transactionIDs = arguments["transactionIDs"] as? [String],
      let reason = arguments["reason"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: transactionIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert transactionIDs to JSON string error: \(error)", details: nil))
      return
    }

    guard let jsonTransactionIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert transactionIDs to JSON string error", details: nil))
      return
    }
    self._handleTssResult(tssResult: TssRejectTransactions(handler, jsonTransactionIDs, reason), flutterResult: flutterResult)
  }

  // export
  func exportSecrets(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let exportPassphrase = arguments["exportPassphrase"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssExportSecrets(handler, exportPassphrase), flutterResult: flutterResult)
  }

  func exportRecoveryKeyShares(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let handler = arguments["handler"] as? String,
      let tssKeyShareGroupIDs = arguments["tssKeyShareGroupIDs"] as? [String],
      let exportPassphrase = arguments["exportPassphrase"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }

    let jsonData: Data
    do {
      jsonData = try JSONSerialization.data(withJSONObject: tssKeyShareGroupIDs, options: [])
    } catch {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert groupIDs to JSON string error: \(error)", details: nil))
      return
    }

    guard let jsonGroupIDs = String(data: jsonData, encoding: .utf8) else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Convert groupIDs to JSON string error", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssExportRecoveryKeyShares(handler, jsonGroupIDs, exportPassphrase), flutterResult: flutterResult)
  }

  // recovery
  func importRecoveryKeyShare(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let tssKeyShareGroupID = arguments["tssKeyShareGroupID"] as? String,
      let jsonRecoverySecrets = arguments["jsonRecoverySecrets"] as? String,
      let exportPassphrase = arguments["exportPassphrase"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResult(tssResult: TssImportRecoveryKeyShare(tssKeyShareGroupID, jsonRecoverySecrets, exportPassphrase), flutterResult: flutterResult)
  }

  func recoverPrivateKeys(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let tssKeyShareGroupID = arguments["tssKeyShareGroupID"] as? String,
      let jsonAddressInfos = arguments["jsonAddressInfos"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssRecoverPrivateKeys(tssKeyShareGroupID, jsonAddressInfos), flutterResult: flutterResult)
  }

  func cleanRecoveryKeyShares() {
    TssCleanRecoveryKeyShares()
  }

  // import
  func importSecrets(arguments: Dictionary<String, Any>, flutterResult: @escaping FlutterResult) {
    guard let jsonRecoverySecrets = arguments["jsonRecoverySecrets"] as? String,
      let exportPassphrase = arguments["exportPassphrase"] as? String,
      let newSecretsFile = arguments["newSecretsFile"] as? String,
      let newPassphrase = arguments["newPassphrase"] as? String else {
      flutterResult(FlutterError(code: "Invalid arguments", message: "Missing arguments", details: nil))
      return
    }
    self._handleTssResultWithData(tssResult: TssImportSecrets(jsonRecoverySecrets, exportPassphrase, newSecretsFile, newPassphrase), flutterResult: flutterResult)
  }

  // others
  func getSDKInfo(flutterResult: @escaping FlutterResult) {
    self._handleTssResultWithData(tssResult: TssGetSDKInfo(), flutterResult: flutterResult)
  }

  // internal
  func _handleTssResult(tssResult: TssResult?, flutterResult: @escaping FlutterResult) {
    guard let tssResult = tssResult else {
      flutterResult(FlutterError(code: "TSSSDK error", message: "No result from TSSSDK", details: nil))
      return
    }

    if tssResult.code != SDKErrorCode.success.rawValue {
      flutterResult(FlutterError(code: "\(tssResult.code)", message: tssResult.message, details: nil))
      return
    }

    flutterResult(nil)
  }

  func _handleTssResultWithData(tssResult: TssResultWithData?, flutterResult: @escaping FlutterResult) {
    guard let tssResult = tssResult else {
      flutterResult(FlutterError(code: "TSSSDK error", message: "No result from TSSSDK", details: nil))
      return
    }

    if tssResult.code != SDKErrorCode.success.rawValue {
      flutterResult(FlutterError(code: "\(tssResult.code)", message: tssResult.message, details: nil))
      return
    }

    let data = tssResult.data
    if data.isEmpty {
      flutterResult(FlutterError(code: "TSSSDK error", message: "No data in result", details: nil))
    }

    var result: [String: Any]?
    do {
      guard let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!) as? [String: Any] else {
        flutterResult(FlutterError(code: "TSSSDK error", message: "Parsing result error", details: data))
        return
      }
      result = json
    } catch {
      flutterResult(FlutterError(code: "TSSSDK error", message: "Parsing result exception:\(error)", details: data))
      return
    }

    flutterResult(result)
  }

}
