import Foundation
import Flutter
import TSSSDK

enum SDKErrorCode: Int32 {
    case success = 0

    var description: String {
        switch self {
        case .success:
            return "Success"
        }
    }
}

class TssCallback: NSObject, TssCallbackProtocol {
    private let flutterResult: FlutterResult

    init(flutterResult: @escaping FlutterResult) {
        self.flutterResult = flutterResult
    }

    func callback(_ code: Int32, message: String?) {
        if code != SDKErrorCode.success.rawValue {
            flutterResult(FlutterError(code: "\(code)", message: message, details: nil))
            return
        }

        flutterResult(nil)
    }
}

class TssCallbackWithData: NSObject, TssCallbackWithDataProtocol {
    private let flutterResult: FlutterResult

    init(flutterResult: @escaping FlutterResult) {
        self.flutterResult = flutterResult
    }

    func callback(_ code: Int32, message: String?, data: String?) {
        if code != SDKErrorCode.success.rawValue {
            flutterResult(FlutterError(code: "\(code)", message: message, details: nil))
            return
        }

        guard let data = data else {
            flutterResult(FlutterError(code: "TSSSDK error", message: "No data in result", details: nil))
            return
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

class TssLogger: NSObject, TssLoggerProtocol, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func log(_ level: String?, message: String?) {
        print("[iOS] TSS SDK log: [level]: \(level ?? "Unknown") [message]:\(message ?? "No message")")        
        let logData: [String: String] = [
            "level": level ?? "Unknown",
            "message": message ?? "No message"
        ]
        DispatchQueue.main.async {
            if let sink = self.eventSink {
                sink(logData)
            } else {
                print("[iOS] eventSink is nil, cannot send log")
            }
        }
    }
}


class TssConnection: NSObject, TssCallbackProtocol, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func callback(_ code: Int32, message: String?) {
        print("[iOS] TSS SDK connect status: [code]: \(code) [message]:\(message ?? "No message")")

        let logData: [String: Any] = [
            "code": code,
            "message": message ?? "No message"
        ]

        DispatchQueue.main.async {
            if let sink = self.eventSink {
                sink(logData)
            } else {
                print("[iOS] eventSink is nil, cannot send connect status")
            }
        }
    }
}
