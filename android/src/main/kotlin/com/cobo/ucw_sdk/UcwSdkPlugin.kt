package com.cobo.ucw_sdk

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject
import tss.Callback
import tss.CallbackWithData
import tss.SDKConfig
import tss.Tss
import java.util.concurrent.Executors

class UcwSdkPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val mainHandler = Handler(Looper.getMainLooper())
    private val executor = Executors.newCachedThreadPool()

    private var logEventSink: EventChannel.EventSink? = null
    private var connEventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ucw_sdk")
        channel.setMethodCallHandler(this)

        val logChannel = EventChannel(flutterPluginBinding.binaryMessenger, "ucw_sdk/logs")
        logChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                logEventSink = events
            }
            override fun onCancel(arguments: Any?) {
                logEventSink = null
            }
        })

        val connChannel = EventChannel(flutterPluginBinding.binaryMessenger, "ucw_sdk/connection")
        connChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                connEventSink = events
            }
            override fun onCancel(arguments: Any?) {
                connEventSink = null
            }
        })

        Tss.setLogger(object : tss.Logger {
            override fun log(level: String?, message: String?) {
                val logData = mapOf(
                    "level" to (level ?: "Unknown"),
                    "message" to (message ?: "No message")
                )
                mainHandler.post { logEventSink?.success(logData) }
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        @Suppress("UNCHECKED_CAST")
        val args = call.arguments as? Map<String, Any> ?: emptyMap()
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "initializeSecrets" -> initializeSecrets(args, result)
            "open" -> open(args, result)
            "openPublic" -> openPublic(args, result)
            "close" -> close(args, result)
            "getTSSNodeID" -> getTSSNodeID(args, result)
            "listTSSKeyShareGroups" -> listTSSKeyShareGroups(args, result)
            "getTSSKeyShareGroups" -> getTSSKeyShareGroups(args, result)
            "listPendingTSSRequests" -> listPendingTSSRequests(args, result)
            "getTSSRequests" -> getTSSRequests(args, result)
            "approveTSSRequests" -> approveTSSRequests(args, result)
            "rejectTSSRequests" -> rejectTSSRequests(args, result)
            "listPendingTransactions" -> listPendingTransactions(args, result)
            "getTransactions" -> getTransactions(args, result)
            "approveTransactions" -> approveTransactions(args, result)
            "rejectTransactions" -> rejectTransactions(args, result)
            "exportSecrets" -> exportSecrets(args, result)
            "exportRecoveryKeyShares" -> exportRecoveryKeyShares(args, result)
            "importRecoveryKeyShare" -> importRecoveryKeyShare(args, result)
            "recoverPrivateKeys" -> recoverPrivateKeys(args, result)
            "cleanRecoveryKeyShares" -> cleanRecoveryKeyShares(result)
            "importSecrets" -> importSecrets(args, result)
            "getSDKInfo" -> getSDKInfo(result)
            else -> result.notImplemented()
        }
    }

    // ---- Helper functions ----

    private fun handleResult(tssResult: tss.Result?, flutterResult: Result) {
        if (tssResult == null) {
            mainHandler.post { flutterResult.error("TSSSDK error", "No result from TSSSDK", null) }
            return
        }
        if (tssResult.code != 0) {
            mainHandler.post { flutterResult.error("${tssResult.code}", tssResult.message, null) }
            return
        }
        mainHandler.post { flutterResult.success(null) }
    }

    private fun handleResultWithData(tssResult: tss.ResultWithData?, flutterResult: Result) {
        if (tssResult == null) {
            mainHandler.post { flutterResult.error("TSSSDK error", "No result from TSSSDK", null) }
            return
        }
        if (tssResult.code != 0) {
            mainHandler.post { flutterResult.error("${tssResult.code}", tssResult.message, null) }
            return
        }
        val data = tssResult.data
        if (data.isNullOrEmpty()) {
            mainHandler.post { flutterResult.error("TSSSDK error", "No data in result", null) }
            return
        }
        try {
            val json = jsonObjectToMap(JSONObject(data))
            mainHandler.post { flutterResult.success(json) }
        } catch (e: Exception) {
            mainHandler.post { flutterResult.error("TSSSDK error", "Parsing result exception: $e", data) }
        }
    }

    private fun callbackWithDataToResult(flutterResult: Result): CallbackWithData {
        return object : CallbackWithData {
            override fun callback(code: Int, message: String?, data: String?) {
                if (code != 0) {
                    mainHandler.post { flutterResult.error("$code", message, null) }
                    return
                }
                if (data.isNullOrEmpty()) {
                    mainHandler.post { flutterResult.error("TSSSDK error", "No data in result", null) }
                    return
                }
                try {
                    val json = jsonObjectToMap(JSONObject(data))
                    mainHandler.post { flutterResult.success(json) }
                } catch (e: Exception) {
                    mainHandler.post { flutterResult.error("TSSSDK error", "Parsing result exception: $e", data) }
                }
            }
        }
    }

    private fun jsonObjectToMap(obj: JSONObject): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        val keys = obj.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            map[key] = fromJson(obj.get(key))
        }
        return map
    }

    private fun fromJson(value: Any): Any? {
        return when (value) {
            is JSONObject -> jsonObjectToMap(value)
            is JSONArray -> jsonArrayToList(value)
            JSONObject.NULL -> null
            else -> value
        }
    }

    private fun jsonArrayToList(arr: JSONArray): List<Any?> {
        val list = mutableListOf<Any?>()
        for (i in 0 until arr.length()) {
            list.add(fromJson(arr.get(i)))
        }
        return list
    }

    private fun toJsonArray(list: List<String>): String {
        val arr = JSONArray()
        list.forEach { arr.put(it) }
        return arr.toString()
    }

    // ---- TSS API methods ----

    private fun initializeSecrets(args: Map<String, Any>, result: Result) {
        val secretsFile = args["secretsFile"] as? String
        val passphrase = args["passphrase"] as? String
        if (secretsFile == null || passphrase == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        Tss.initializeSecrets(secretsFile, passphrase, callbackWithDataToResult(result))
    }

    private fun open(args: Map<String, Any>, result: Result) {
        val configEnv = args["config.env"] as? String
        val configDebug = args["config.debug"] as? Boolean
        val secretsFile = args["secretsFile"] as? String
        val passphrase = args["passphrase"] as? String
        if (configEnv == null || configDebug == null || secretsFile == null || passphrase == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val config = SDKConfig()
        config.env = configEnv
        config.debug = configDebug

        val connCallback = object : Callback {
            override fun callback(code: Int, message: String?) {
                val data = mapOf<String, Any>(
                    "code" to code,
                    "message" to (message ?: "No message")
                )
                mainHandler.post { connEventSink?.success(data) }
            }
        }

        executor.execute {
            handleResultWithData(Tss.open(config, secretsFile, passphrase, connCallback), result)
        }
    }

    private fun openPublic(args: Map<String, Any>, result: Result) {
        val secretsFile = args["secretsFile"] as? String
        if (secretsFile == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResultWithData(Tss.openPublic(secretsFile), result)
        }
    }

    private fun close(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        if (handler == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResult(Tss.close(handler), result)
        }
    }

    private fun getTSSNodeID(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        if (handler == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResultWithData(Tss.getTSSNodeID(handler), result)
        }
    }

    private fun listTSSKeyShareGroups(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        if (handler == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResultWithData(Tss.listTSSKeyShareGroups(handler), result)
        }
    }

    private fun getTSSKeyShareGroups(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val tssKeyShareGroupIDs = args["tssKeyShareGroupIDs"] as? List<String>
        if (handler == null || tssKeyShareGroupIDs == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonGroupIDs = toJsonArray(tssKeyShareGroupIDs)
        executor.execute {
            handleResultWithData(Tss.getTSSKeyShareGroups(handler, jsonGroupIDs), result)
        }
    }

    private fun listPendingTSSRequests(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        val timeout = (args["timeout"] as? Number)?.toInt()
        if (handler == null || timeout == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        Tss.listPendingTSSRequests(handler, timeout, callbackWithDataToResult(result))
    }

    private fun getTSSRequests(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val tssRequestIDs = args["tssRequestIDs"] as? List<String>
        val timeout = (args["timeout"] as? Number)?.toInt()
        if (handler == null || tssRequestIDs == null || timeout == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonTSSRequestIDs = toJsonArray(tssRequestIDs)
        Tss.getTSSRequests(handler, jsonTSSRequestIDs, timeout, callbackWithDataToResult(result))
    }

    private fun approveTSSRequests(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val tssRequestIDs = args["tssRequestIDs"] as? List<String>
        if (handler == null || tssRequestIDs == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonTSSRequestIDs = toJsonArray(tssRequestIDs)
        executor.execute {
            handleResult(Tss.approveTSSRequests(handler, jsonTSSRequestIDs), result)
        }
    }

    private fun rejectTSSRequests(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val tssRequestIDs = args["tssRequestIDs"] as? List<String>
        val reason = args["reason"] as? String
        if (handler == null || tssRequestIDs == null || reason == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonTSSRequestIDs = toJsonArray(tssRequestIDs)
        executor.execute {
            handleResult(Tss.rejectTSSRequests(handler, jsonTSSRequestIDs, reason), result)
        }
    }

    private fun listPendingTransactions(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        val timeout = (args["timeout"] as? Number)?.toInt()
        if (handler == null || timeout == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        Tss.listPendingTransactions(handler, timeout, callbackWithDataToResult(result))
    }

    private fun getTransactions(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val transactionIDs = args["transactionIDs"] as? List<String>
        val timeout = (args["timeout"] as? Number)?.toInt()
        if (handler == null || transactionIDs == null || timeout == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonTransactionIDs = toJsonArray(transactionIDs)
        Tss.getTransactions(handler, jsonTransactionIDs, timeout, callbackWithDataToResult(result))
    }

    private fun approveTransactions(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val transactionIDs = args["transactionIDs"] as? List<String>
        if (handler == null || transactionIDs == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonTransactionIDs = toJsonArray(transactionIDs)
        executor.execute {
            handleResult(Tss.approveTransactions(handler, jsonTransactionIDs), result)
        }
    }

    private fun rejectTransactions(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val transactionIDs = args["transactionIDs"] as? List<String>
        val reason = args["reason"] as? String
        if (handler == null || transactionIDs == null || reason == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonTransactionIDs = toJsonArray(transactionIDs)
        executor.execute {
            handleResult(Tss.rejectTransactions(handler, jsonTransactionIDs, reason), result)
        }
    }

    private fun exportSecrets(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        val exportPassphrase = args["exportPassphrase"] as? String
        if (handler == null || exportPassphrase == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResultWithData(Tss.exportSecrets(handler, exportPassphrase), result)
        }
    }

    private fun exportRecoveryKeyShares(args: Map<String, Any>, result: Result) {
        val handler = args["handler"] as? String
        @Suppress("UNCHECKED_CAST")
        val tssKeyShareGroupIDs = args["tssKeyShareGroupIDs"] as? List<String>
        val exportPassphrase = args["exportPassphrase"] as? String
        if (handler == null || tssKeyShareGroupIDs == null || exportPassphrase == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        val jsonGroupIDs = toJsonArray(tssKeyShareGroupIDs)
        executor.execute {
            handleResultWithData(Tss.exportRecoveryKeyShares(handler, jsonGroupIDs, exportPassphrase), result)
        }
    }

    private fun importRecoveryKeyShare(args: Map<String, Any>, result: Result) {
        val tssKeyShareGroupID = args["tssKeyShareGroupID"] as? String
        val jsonRecoverySecrets = args["jsonRecoverySecrets"] as? String
        val exportPassphrase = args["exportPassphrase"] as? String
        if (tssKeyShareGroupID == null || jsonRecoverySecrets == null || exportPassphrase == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResult(Tss.importRecoveryKeyShare(tssKeyShareGroupID, jsonRecoverySecrets, exportPassphrase), result)
        }
    }

    private fun recoverPrivateKeys(args: Map<String, Any>, result: Result) {
        val tssKeyShareGroupID = args["tssKeyShareGroupID"] as? String
        val jsonAddressInfos = args["jsonAddressInfos"] as? String
        if (tssKeyShareGroupID == null || jsonAddressInfos == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResultWithData(Tss.recoverPrivateKeys(tssKeyShareGroupID, jsonAddressInfos), result)
        }
    }

    private fun cleanRecoveryKeyShares(result: Result) {
        Tss.cleanRecoveryKeyShares()
        result.success(null)
    }

    private fun importSecrets(args: Map<String, Any>, result: Result) {
        val jsonRecoverySecrets = args["jsonRecoverySecrets"] as? String
        val exportPassphrase = args["exportPassphrase"] as? String
        val newSecretsFile = args["newSecretsFile"] as? String
        val newPassphrase = args["newPassphrase"] as? String
        if (jsonRecoverySecrets == null || exportPassphrase == null || newSecretsFile == null || newPassphrase == null) {
            result.error("Invalid arguments", "Missing arguments", null)
            return
        }
        executor.execute {
            handleResultWithData(Tss.importSecrets(jsonRecoverySecrets, exportPassphrase, newSecretsFile, newPassphrase), result)
        }
    }

    private fun getSDKInfo(result: Result) {
        executor.execute {
            handleResultWithData(Tss.getSDKInfo(), result)
        }
    }
}
