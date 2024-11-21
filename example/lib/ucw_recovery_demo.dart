import 'package:flutter/material.dart';
import 'package:ucw_sdk/ucw_sdk.dart';
import 'package:ucw_sdk/data.dart';

class UCWRecoveryDemo extends StatefulWidget {
  const UCWRecoveryDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWRecoveryDemoState createState() => _UCWRecoveryDemoState();
}

class _UCWRecoveryDemoState extends State<UCWRecoveryDemo> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _executeMethods() async {
    final doUCWRecovery = DoUCWRecovery();
    String result = await doUCWRecovery.doMethods();
    setState(() {
      _displayController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW Recovery Demo'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _executeMethods,
              child: const Text('test UCW Recovery methods'),
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

String secretsFile = 'secrets.db';
String passphrase = '1234567890123456';
String exportPassphrase = 'ABCDEFGHIJKLMNOP';
UCW? instanceUCW;

String exportPassphrase2 = 'abcdefghijklmnop';
const String recoveryGroupsJson2 = '''
{
  "recovery_groups": [
    {
      "version": 4,
      "group_info": {
        "id": "FgDqmWHqbTSmODraIIHo",
        "canonical_group_id": "111WjXphjiNxxnpN1CouvHRx1urTGHE3yQGSmio6CLXWhhL",
        "protocol_group_id": "111SyFeFMkvph6NZsYm81PVCeGtQMqUut33FSZN7KiB8Za5",
        "protocol_type": "",
        "created_time": "2024-06-14T18:41:54+08:00",
        "type": 2,
        "root_extended_public_key": "cpubGCmTMqXYTnzkbYJ9eVBsoLyAKd2NDFRBeUASqw7zWoSene2SM8uZSQDFoYuf1yyvUeHuv3i6QkiDLjbNfWXmY9RFhV5t3xrKYtCsTpbwRVi",
        "chaincode": "0x609c8b4f3433b33de98955e420d92a118eb2c98f23e1f9d0cf6b6b39d1ebbe31",
        "curve": "ed25519",
        "threshold": 2,
        "participants": [
          {
            "node_id": "coboNj2iqWpTsTzRLHtRsgfRwLUFqqg8QmKmM9wCtzev9mMnw",
            "share_id": "619693302942100684578205955442284626185",
            "share_public_key": "0x217223cdea6b19af34131447763a269d1dbef580bc85272a5bdfc59fa4940cca"
          },
          {
            "node_id": "coboDXQ9uv78yJmp9EQ9EpXLLsdiFBReXgC3UnhKirhZ72ygy",
            "share_id": "1050046039481252240172969605219914426317",
            "share_public_key": "0xe457eef5a3613523c2c8801cfb2e03dba1bba804e2f0ac1a4d5a5d675f6d0179"
          }
        ]
      },
      "share_info": {
        "node_id": "coboDXQ9uv78yJmp9EQ9EpXLLsdiFBReXgC3UnhKirhZ72ygy",
        "share_id": "1050046039481252240172969605219914426317",
        "share_public_key": "0xe457eef5a3613523c2c8801cfb2e03dba1bba804e2f0ac1a4d5a5d675f6d0179",
        "encrypted_share": "OPKOouop2B4GDIHE+R8KGPS0jbKO5buYrzBw5dyZeXjWCcBSgjH9bKk1jCkY1sPE94Y5r5Uh/7AAnG3bNkrOMBIwZOverw00GRvxWVS5XnMyR38ft+kMClzCqqlEmguOQmnD8NrZ+m7ZT4icEle1SJ3ymCQiVGmixFu59Z3dhRRCc6hlk8s0fZddOcTtWIPHpCuQ4xPCfmPniSm0ORLFdcuC/dbJlAEiDDBMWX2mkLZiZYPK4NyA7n2NkEc7kNdzh3F+MOQypUEpnE9BJ6pWziz63z94apytjQ==",
        "kdf": {
          "length": 32,
          "iterations": 600000,
          "salt": "0xf5469ee396cc5db290088cd979b97565d38b4172b2d9e603856a9ee2765ca03f",
          "hash_type": 5,
          "hash_name": "SHA-256"
        }
      }
    }
  ]
}
''';

class DoUCWRecovery {

  Future<String> doMethods() async {
    String resultStr = '';
    resultStr += await doInit();
    resultStr += await doExportRecoveryKeyShares();
    return resultStr;
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
      instanceUCW = await UCW.create(secretsFile: secretsFile, config: sdkConfig, passphrase: passphrase, connCallback:
      (connCode, message) async {
        print('UCW Demo -> Conn Code: $connCode, Message: $message');
      });
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to init: $e\n';
      return resultStr;
    }
  }

  Future<String> doExportRecoveryKeyShares() async {
    String resultStr = '';
    try {
      var tssKeyShareGroupIDs = ['FgDqmWHqbTSmODraIIHo'];
      resultStr += 'Starting export of recovery key shares...\n';
      final exportResult = await instanceUCW?.exportRecoveryKeyShares(
          tssKeyShareGroupIDs, exportPassphrase);

      resultStr += 'Recovery key shares exported successfully:\n';
      resultStr += '$exportResult\n';
      print('$exportResult\n');
      var recoveryKey = UCWRecoverKey(tssKeyShareGroupID: 'FgDqmWHqbTSmODraIIHo');
      recoveryKey.dispose();

      recoveryKey = UCWRecoverKey(tssKeyShareGroupID: 'FgDqmWHqbTSmODraIIHo');
      resultStr += 'Starting importing recovery key share 1...\n';

      await recoveryKey.importRecoveryKeyShare(exportResult!, exportPassphrase);
      resultStr += 'Recovery key share1 imported successfully.';

      resultStr += 'Starting importing recovery key share 2...\n';
    
      await recoveryKey.importRecoveryKeyShare(recoveryGroupsJson2, exportPassphrase2);
      resultStr += 'Recovery key share2 imported successfully.\n';
          
      List<AddressInfo> addressInfos = [
        AddressInfo(bip32Path: 'm', publicKey: null),
        AddressInfo(bip32Path: 'm', publicKey: 'cpubGCmTMqXYTnzkbYJ9eVBsoLyAKd2NDFRBeUASqw7zWoSene2SM8uZSQDFoYuf1yyvUeHuv3i6QkiDLjbNfWXmY9RFhV5t3xrKYtCsTpbwRVi'),
      ];

      resultStr += ('Recovering private keys...\n');
      List<PrivateKeyInfo> rKeys = await recoveryKey.recoverPrivateKeys(addressInfos);
      resultStr += ('Recovered private keys: $resultStr\n');

      rKeys.forEach((keyInfo) {
        resultStr += ('bip32Path: ${keyInfo.bip32Path}\n');
        resultStr += ('public Key: ${keyInfo.publicKey}\n');
        resultStr += ('Private Key: ${keyInfo.privateKey?.extPrivateKey}\n');
        resultStr += ('Private Key: ${keyInfo.privateKey?.hexPrivateKey}\n');
      });
      return resultStr;

    } catch (e) {
      resultStr += 'Failed to export recovery key shares: $e\n';
      return resultStr;
    }
  }

}
