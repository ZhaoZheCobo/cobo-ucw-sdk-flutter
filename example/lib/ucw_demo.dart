import 'package:flutter/material.dart';
import 'package:ucw_sdk/ucw_sdk.dart';
import 'package:ucw_sdk/data.dart';

class UCWDemo extends StatefulWidget {
  const UCWDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWDemoState createState() => _UCWDemoState();
}

class _UCWDemoState extends State<UCWDemo> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _executeMethods() async {
        final doUCW = DoUCW();
    String result = await doUCW.doMethods();
    setState(() {
      _displayController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW Demo'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _executeMethods,
              child: const Text('test UCW methods'),
            ),
            const SizedBox(height: 20),
            Container(
              height: 500,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: _displayController,
                readOnly: true,
                maxLines: null,
                decoration: const InputDecoration.collapsed(hintText: ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//String secretsFile = '~/ucw_sdk_flutter_plugin/secrets.db';
String secretsFile = '/Users/zhaozhe/waas2/ucw_flutter/secrets4.db';
String passphrase = '1234567890123456';
UCW? instanceUCW;

class DoUCW {

  Future<String> doMethods() async {
    String resultStr = '';
    //await setLogger();
    print('start setLogger');
    await setLogger((level, message) {
      print('UCW Demo -> Level: $level, Message: $message');
    });
    resultStr += await doInitializeSecrets();
    resultStr += await doInit();
    resultStr += await doGetTSSRequests();
    resultStr += await doListPendingTSSRequests();
    //sleep(const Duration(seconds: 10));
    //await doDispose();
    return resultStr;
  }

  Future<String> doInitializeSecrets() async {
    String resultStr = '';
    try {
      resultStr += 'Do initialize secrets\n';
      final result = await initializeSecrets(secretsFile, passphrase);
      resultStr += 'TSS Node ID: $result\n';
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to initialize secrets: $e\n';
      return resultStr;
    }
  }

  Future<String> doInit() async {
    String resultStr = '';
    try {
      resultStr += 'Do init\n';
      if (instanceUCW != null) {
        resultStr += 'InstanceUCW exists\n';       
        return resultStr;
      } 

      final sdkConfig = SDKConfig(env: Env.local, debug: true, timeout: 30);
      instanceUCW = UCW(secretsFile: secretsFile, config: sdkConfig);   
      await instanceUCW?.init1(passphrase, (connCode, message) {
        print('UCW Demo -> Conn Code: $connCode, Message: $message');
      });
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to init: $e\n';
      return resultStr;
    }
  }

  Future<void> doDispose() async {
    instanceUCW?.dispose();
  }

  Future<String> doListPendingTSSRequests() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      resultStr += 'Do listPendingTSSRequests\n';
      List<TSSRequest> tssRequests = await instanceUCW!.listPendingTSSRequests();
      resultStr += 'Successfully fetched pending TSS requests: ${tssRequests.length} requests\n';
      for (var tssRequest in tssRequests) {
        resultStr += 'tssRequest ID: ${tssRequest.tssRequestID}, Status: ${tssRequest.status}\n';
      }
    } catch (e) {
      resultStr += 'Failed to list pending TSS requests: $e\n';
    }
    return resultStr;
  }

  Future<String> doGetTSSRequests() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      final tssRequestIDs = ['kg145',"kg144"];
      resultStr += 'Starting getTSSRequests with IDs: ${tssRequestIDs.join(", ")}\n';
      List<TSSRequest> tssRequests = await instanceUCW!.getTSSRequests(tssRequestIDs);
      resultStr += 'Successfully fetched TSS requests: ${tssRequests.length} requests\n';
      for (var tssRequest in tssRequests) {
        resultStr += 'tssRequest ID: ${tssRequest.tssRequestID}, Status: ${tssRequest.status}\n';
      }
    } catch (e) {
      resultStr += 'Failed to get TSS requests: $e\n';
    }
    return resultStr;
  }

  Future<String> doApproveTSSRequests() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      final tssRequestIDs = ['mockID'];
      resultStr += 'Starting approveTSSRequests for IDs: ${tssRequestIDs.join(", ")}\n';
      await instanceUCW!.approveTSSRequests(tssRequestIDs);
      resultStr += 'Successfully approved TSS requests: ${tssRequestIDs.length} requests\n';
    } catch (e) {
      resultStr += 'Failed to approve TSS requests: $e\n';
    }
    return resultStr;
  }

  Future<String> doRejectTSSRequests() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      final tssRequestIDs = ['mockID'];
      const reason = 'flutter sdk test';
      resultStr += 'Starting rejectTSSRequests for IDs: ${tssRequestIDs.join(", ")} with reason: $reason\n';
      await instanceUCW!.rejectTSSRequests(tssRequestIDs, reason);
      resultStr += 'Successfully rejected TSS requests: ${tssRequestIDs.length} requests\n';
    } catch (e) {
      resultStr += 'Failed to reject TSS requests: $e\n';
    }
    return resultStr;
  }

  Future<String> doListPendingTransactions() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      resultStr += 'Starting listPendingTransactions\n';

      List<Transaction> transactions = await instanceUCW!.listPendingTransactions();
      resultStr += 'Successfully fetched pending transactions: ${transactions.length} transactions\n';
      for (var transaction in transactions) {
        resultStr += 'transaction ID: ${transaction.transactionID}, Status: ${transaction.status}\n';
      }
    } catch (e) {
      resultStr += 'Failed to list pending transactions: $e\n';
    }
    return resultStr;
  }

  Future<String> doGetTransactions() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      final transactionIDs = ['mockID'];
      resultStr += 'Starting getTransactions with IDs: ${transactionIDs.join(", ")}\n';
      List<Transaction> transactions = await instanceUCW!.getTransactions(transactionIDs);
      resultStr += 'Successfully fetched transactions: ${transactions.length} transactions\n';
      for (var transaction in transactions) {
        resultStr += 'transaction ID: ${transaction.transactionID}, Status: ${transaction.status}\n';
      }
    } catch (e) {
      resultStr += 'Failed to get transactions: $e\n';
    }
    return resultStr;
  }

  Future<String> doApproveTransactions() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      final transactionIDs = ['mockID'];
      resultStr += 'Starting approveTransactions for IDs: ${transactionIDs.join(", ")}\n';
      await instanceUCW!.approveTransactions(transactionIDs);
      resultStr += 'Successfully approved transactions: ${transactionIDs.length} transactions\n';
    } catch (e) {
      resultStr += 'Failed to approve transactions: $e\n';
    }
    return resultStr;
  }

  Future<String> doRejectTransactions() async {
    String resultStr = '';
    try {
      if (instanceUCW == null) {
        resultStr += 'InstanceUCW not exists\n';
        return resultStr;
      } 
      final transactionIDs = ['mockID'];
      const reason = 'flutter sdk test';
      resultStr += 'Starting rejectTransactions for IDs: ${transactionIDs.join(", ")} with reason: $reason\n';
      await instanceUCW!.rejectTransactions(transactionIDs, reason);
      resultStr += 'Successfully rejected transactions: ${transactionIDs.length} transactions\n';
    } catch (e) {
      resultStr += 'Failed to reject transactions: $e\n';
    }
    return resultStr;
  }

  Future<String> doGetTSSNodeID() async {
    String resultStr = '';
    try {
      resultStr += 'Do getTSSNodeID\n';
      final tssNodeID = await instanceUCW!.getTSSNodeID();
      resultStr += 'TSS Node ID: $tssNodeID\n';
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to getTSSNodeID: $e\n';
      return resultStr;
    }
  }

  Future<String> doGetTSSKeyShareGroups() async {
    String resultStr = '';
    try {
      resultStr += 'Do getTSSKeyShareGroups\n';
      final groups = await instanceUCW!.getTSSKeyShareGroups(['gjRIvhmnDfpcGrzjOABE']);
      resultStr += 'TSS Key Share Groups: ${groups.length}\n';
      for (var group in groups) {
        resultStr += 'Group ID: ${group.tssKeyShareGroupID}, rootPubKey: ${group.rootPubKey}, type: ${group.type}, \n';
      }
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to getTSSKeyShareGroups: $e\n';
      return resultStr;
    }
  }

  Future<String> doListTSSKeyShareGroups() async {
    String resultStr = '';
    try {
      resultStr += 'Do listTSSKeyShareGroups\n';
      final groups = await instanceUCW!.listTSSKeyShareGroups();
      resultStr += 'TSS Key Share Groups (list): ${groups.length}\n';
      for (var group in groups) {
        resultStr += 'Group ID: ${group.tssKeyShareGroupID}, rootPubKey: ${group.rootPubKey}\n';
      }
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to listTSSKeyShareGroups: $e\n';
      return resultStr;
    }
  }

}
