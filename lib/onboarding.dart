import 'package:flutter/material.dart';
import 'package:web3dart_explore/services/wallet_address.dart';
import 'package:web3dart_explore/transfer_local_ganache.dart';
import 'package:web3dart_explore/transfer_rinkeby.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String mnemonic = '';
  var privateKey;
  var publicKey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SelectableText(
              mnemonic,
              textAlign: TextAlign.center,
            ),
            SelectableText(
              privateKey.toString(),
              textAlign: TextAlign.center,
            ),
            SelectableText(
              publicKey.toString(),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () async {
                WalletAddress service = WalletAddress();
                mnemonic = service.generateMnemonic();
                privateKey = await service.getPrivateKey(mnemonic);
                publicKey = await service.getPublicKey(privateKey);
                print(mnemonic);
                print(privateKey);
                print(publicKey);
                setState(() {});
              },
              child: Text('Generate'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransferLocalGanache()));
              },
              child: Text('Transfer Ganache'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferRinkeby(
                      privateKey: privateKey.toString(),
                      publicKey: publicKey.toString(),
                    ),
                  ),
                );
              },
              child: Text('Transfer Rinkeby'),
            ),
          ],
        ),
      ),
    );
  }
}
