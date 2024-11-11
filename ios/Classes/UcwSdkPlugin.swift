import Flutter
import UIKit
import TSSSDK

public class UcwSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ucw_sdk", binaryMessenger: registrar.messenger())
    let instance = UcwSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? Dictionary<String, Any> ?? [:]

    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      case "initializeSecrets":
            initializeSecrets(arguments: arguments, flutterResult: result)
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
}
