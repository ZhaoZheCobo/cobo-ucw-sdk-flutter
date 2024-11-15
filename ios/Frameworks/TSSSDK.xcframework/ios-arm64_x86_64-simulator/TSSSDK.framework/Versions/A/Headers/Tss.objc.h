// Objective-C API for talking to code.1cobo.com/cobo-tss-service/sdkv2/mobile Go package.
//   gobind -lang=objc code.1cobo.com/cobo-tss-service/sdkv2/mobile
//
// File is generated by gobind. Do not edit.

#ifndef __Tss_H__
#define __Tss_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class TssResult;
@class TssResultWithData;
@class TssSDKConfig;
@protocol TssCallback;
@class TssCallback;
@protocol TssCallbackWithData;
@class TssCallbackWithData;
@protocol TssLogger;
@class TssLogger;

@protocol TssCallback <NSObject>
- (void)callback:(int32_t)code message:(NSString* _Nullable)message;
@end

@protocol TssCallbackWithData <NSObject>
- (void)callback:(int32_t)code message:(NSString* _Nullable)message data:(NSString* _Nullable)data;
@end

@protocol TssLogger <NSObject>
- (void)log:(NSString* _Nullable)level message:(NSString* _Nullable)message;
@end

/**
 * Result API return result
Code - definitions:

	0: Success
	1000 - 1099: CodeCommon
	1100 - 1199: CodeNode
	1200 - 1299: CodeSDK
	1300 - 1399: CodeNetwork
	1400 - 1499: CodeSession
	1500 - 1599: CodeCallback
	1900 - 1999: CodeAssistance

Message - specific error details.
 */
@interface TssResult : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) int32_t code;
@property (nonatomic) NSString* _Nonnull message;
@end

/**
 * ResultWithData API return result and Data
Code - defined as in Code of Result
Message - specific error details
Data - result data in JSON string format.
 */
@interface TssResultWithData : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) int32_t code;
@property (nonatomic) NSString* _Nonnull message;
@property (nonatomic) NSString* _Nonnull data;
@end

/**
 * SDKConfig SDK Configuration
Env - configures the connection to the TSS environment, with reference values: development; production
TxVerifyURL - configures the TX verify URL
Debug - specifies whether to enable debug mode.
 */
@interface TssSDKConfig : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull env;
@property (nonatomic) NSString* _Nonnull txVerifyURL;
@property (nonatomic) BOOL debug;
@end

/**
 * ApproveKeyShareSignRequests Approve the specified KeyShareSignRequests.
jsonKeyShareSignRequestIDs Format: [KeyShareSignRequestID1, KeyShareSignRequestID2, ...].
 */
FOUNDATION_EXPORT TssResult* _Nullable TssApproveKeyShareSignRequests(NSString* _Nullable handler, NSString* _Nullable jsonKeyShareSignRequestIDs);

/**
 * ApproveTSSRequests Approve the specified TSS requests.
jsonTSSRequestIDs Format: [TSSRequestID1, TSSRequestID2, ...].
 */
FOUNDATION_EXPORT TssResult* _Nullable TssApproveTSSRequests(NSString* _Nullable handler, NSString* _Nullable jsonTSSRequestIDs);

/**
 * ApproveTransactions Approve the specified transactions.
jsonTransactionIDs Format: [TransactionID1, TransactionID2, ...].
 */
FOUNDATION_EXPORT TssResult* _Nullable TssApproveTransactions(NSString* _Nullable handler, NSString* _Nullable jsonTransactionIDs);

/**
 * CleanRecoveryKeyShares clean up all imported TSS key share data.
 */
FOUNDATION_EXPORT void TssCleanRecoveryKeyShares(void);

/**
 * Close Close the opened secrets and connection.
 */
FOUNDATION_EXPORT TssResult* _Nullable TssClose(NSString* _Nullable handler);

/**
 * ExportRecoveryKeyShares Export TSS key share data that can be used for recovery, encrypted with exportPassphrase.
jsonTSSKeyShareGroupIDs Format: [TSSKeyShareGroupID1, TSSKeyShareGroupID2, ...]
ResultWithData Returns the jsonRecoverySecrets in exported JSON format string.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssExportRecoveryKeyShares(NSString* _Nullable handler, NSString* _Nullable jsonTSSKeyShareGroupIDs, NSString* _Nullable exportPassphrase);

/**
 * ExportSecrets Export the secrets to JSON format string, and encrypts it using exportPassphrase.
ResultWithData Returns the jsonRecoverySecrets in exported JSON format string.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssExportSecrets(NSString* _Nullable handler, NSString* _Nullable exportPassphrase);

/**
 * GetKeyShareSignRequests Get the status and information of specific KeyShareSignRequests.
jsonKeyShareSignRequestIDs Format: [KeyShareSignRequestID1, KeyShareSignRequestID2, ...].
 */
FOUNDATION_EXPORT void TssGetKeyShareSignRequests(NSString* _Nullable handler, NSString* _Nullable jsonKeyShareSignRequestIDs, int32_t timeout, id<TssCallbackWithData> _Nullable cb);

/**
 * GetSDKInfo Get SDK information.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssGetSDKInfo(void);

/**
 * GetTSSKeyShareGroups Get the public information of specific TSS key share groups.
jsonTSSKeyShareGroupIDs Format: [TSSKeyShareGroupID1, TSSKeyShareGroupID2, ...].
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssGetTSSKeyShareGroups(NSString* _Nullable handler, NSString* _Nullable jsonTSSKeyShareGroupIDs);

/**
 * GetTSSNodeID Get TSS Node ID.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssGetTSSNodeID(NSString* _Nullable handler);

/**
 * GetTSSRequests Get the status and information of specific TSS requests.
jsonTSSRequestIDs Format: [TSSRequestID1, TSSRequestID2, ...].
 */
FOUNDATION_EXPORT void TssGetTSSRequests(NSString* _Nullable handler, NSString* _Nullable jsonTSSRequestIDs, int32_t timeout, id<TssCallbackWithData> _Nullable cb);

/**
 * GetTransactions Get the status and information of specific transactions.
jsonTransactionIDs Format: [TransactionID1, TransactionID2, ...].
 */
FOUNDATION_EXPORT void TssGetTransactions(NSString* _Nullable handler, NSString* _Nullable jsonTransactionIDs, int32_t timeout, id<TssCallbackWithData> _Nullable cb);

/**
 * ImportRecoveryKeyShare import multiple TSS key share data JSON format string (jsonRecoverySecrets)
(use ExportRecoveryKeyShare or ExportSecrets)
for recover the private key via RecoverPrivateKeys.
 */
FOUNDATION_EXPORT TssResult* _Nullable TssImportRecoveryKeyShare(NSString* _Nullable tssKeyShareGroupID, NSString* _Nullable jsonRecoverySecrets, NSString* _Nullable exportPassphrase);

/**
 * ImportSecrets Import and create new secrets from JSON format string (jsonRecoverySecrets), and decrypts it using the exportPassphrase.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssImportSecrets(NSString* _Nullable jsonRecoverySecrets, NSString* _Nullable exportPassphrase, NSString* _Nullable newSecretsFile, NSString* _Nullable newPassphrase);

/**
 * InitializeSecrets Initialize secrets file once, generate and return TSS node ID.
If already initialized, not raise an error; instead, return TSS node ID.
 */
FOUNDATION_EXPORT void TssInitializeSecrets(NSString* _Nullable secretsFile, NSString* _Nullable passphrase, id<TssCallbackWithData> _Nullable cb);

/**
 * ListPendingKeyShareSignRequests List all KeyShareSignRequest that are currently being processed.
 */
FOUNDATION_EXPORT void TssListPendingKeyShareSignRequests(NSString* _Nullable handler, int32_t timeout, id<TssCallbackWithData> _Nullable cb);

/**
 * ListPendingTSSRequests List all TSS requests that are currently being processed.
 */
FOUNDATION_EXPORT void TssListPendingTSSRequests(NSString* _Nullable handler, int32_t timeout, id<TssCallbackWithData> _Nullable cb);

/**
 * ListPendingTransactions List all transactions that are currently being processed.
 */
FOUNDATION_EXPORT void TssListPendingTransactions(NSString* _Nullable handler, int32_t timeout, id<TssCallbackWithData> _Nullable cb);

/**
 * ListTSSKeyShareGroups Get the public information of all TSS key share groups.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssListTSSKeyShareGroups(NSString* _Nullable handler);

/**
 * Open Open the secrets using a passphrase created in InitializeSecrets, establish a connection, and return a handler for other API usage.
If only public information is needed, you can use the OpenPublic function to open the secrets.
connCB - type Callback for connection status.
code in connCB parameter explanation:

	1300: Connection successful
	1301: Disconnected, will attempt to retry
	1302: Connection closed, currently only triggered by close
	1311: Connection URL parsing error
	1320: Connection refused, will attempt to retry
	1321: Connection failed, will attempt to retry
	1350: Connection proxy error
	1351: Connection proxy parsing error
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssOpen(TssSDKConfig* _Nullable config, NSString* _Nullable secretsFile, NSString* _Nullable passphrase, id<TssCallback> _Nullable connCB);

/**
 * OpenPublic Open the public information of the secrets and return a handler for other API usage.
After using OpenPublic to open the secrets, you can use the GetTSSNodeID GetTSSKeyShareGroups and ListTSSKeyShareGroups interfaces.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssOpenPublic(NSString* _Nullable secretsFile);

/**
 * RecoverPrivateKeys Reconstruct private key shares to generate root private key,
and generate child private key based on address info.
jsonAddressInfos Format: [{bip32Path1, publicKey1},{bip32Path2, publicKey2}].
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssRecoverPrivateKeys(NSString* _Nullable tssKeyShareGroupID, NSString* _Nullable jsonAddressInfos);

/**
 * RejectKeyShareSignRequests Reject the specified KeyShareSignRequests.
jsonKeyShareSignRequestIDs Format: [KeyShareSignRequestID1, KeyShareSignRequestID2, ...].
 */
FOUNDATION_EXPORT TssResult* _Nullable TssRejectKeyShareSignRequests(NSString* _Nullable handler, NSString* _Nullable jsonKeyShareSignRequestIDs, NSString* _Nullable reason);

/**
 * RejectTSSRequests Reject the specified TSS requests.
jsonTSSRequestIDs Format: [TSSRequestID1, TSSRequestID2, ...].
 */
FOUNDATION_EXPORT TssResult* _Nullable TssRejectTSSRequests(NSString* _Nullable handler, NSString* _Nullable jsonTSSRequestIDs, NSString* _Nullable reason);

/**
 * RejectTransactions Reject the specified transactions.
jsonTransactionIDs Format: [TransactionID1, TransactionID2, ...].
 */
FOUNDATION_EXPORT TssResult* _Nullable TssRejectTransactions(NSString* _Nullable handler, NSString* _Nullable jsonTransactionIDs, NSString* _Nullable reason);

/**
 * SetLogger Register a callback function for log output.
This interface only needs to be called once and is globally effective.
After registration, subsequent registrations are ineffective.
 */
FOUNDATION_EXPORT void TssSetLogger(id<TssLogger> _Nullable logger);

/**
 * SignWithKeyShare Sign a message with a single MPC private key share for the purpose of verifying the effectiveness.
 */
FOUNDATION_EXPORT TssResultWithData* _Nullable TssSignWithKeyShare(NSString* _Nullable handler, NSString* _Nullable tssKeyShareGroupID, NSString* _Nullable message);

@class TssCallback;

@class TssCallbackWithData;

@class TssLogger;

/**
 * Callback function for API using callback.
Results are returned through the callback function, with parameters and meanings consistent with Result.
code - defined as in Code of Result
message - specific error details.
 */
@interface TssCallback : NSObject <goSeqRefInterface, TssCallback> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (void)callback:(int32_t)code message:(NSString* _Nullable)message;
@end

/**
 * CallbackWithData function for API using callback.
Results are returned through the callback function, with parameters and meanings consistent with ResultWithData.
code - defined as in Code of Result
message - specific error details
data - result data in JSON string format.
 */
@interface TssCallbackWithData : NSObject <goSeqRefInterface, TssCallbackWithData> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (void)callback:(int32_t)code message:(NSString* _Nullable)message data:(NSString* _Nullable)data;
@end

/**
 * Logger SDK log output
level - Log level, from low to high: trace, debug, info, warning, error, fatal, panic
By default, only logs with level info and above are output.
If debug mode is enabled (SDKConfig.Debug set to true), logs with level debug and above are output.
message - log message.
 */
@interface TssLogger : NSObject <goSeqRefInterface, TssLogger> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (void)log:(NSString* _Nullable)level message:(NSString* _Nullable)message;
@end

#endif
