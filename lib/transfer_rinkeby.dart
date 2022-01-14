import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';
import 'package:web3dart_explore/services/wallet_address.dart';

class TransferRinkeby extends StatefulWidget {
  final String privateKey;
  final String publicKey;
  const TransferRinkeby(
      {Key? key, required this.privateKey, required this.publicKey})
      : super(key: key);

  @override
  _TransferRinkebyState createState() => _TransferRinkebyState();
}

class _TransferRinkebyState extends State<TransferRinkeby> {
  late Client httpClient;
  late Web3Client ethClient;

  String? balance;
  TextEditingController textPrivateKey = TextEditingController();
  TextEditingController textAddress = TextEditingController();
  TextEditingController textAmount = TextEditingController();

  void details() async {
    textPrivateKey.text = widget.privateKey;
    final credentials = EthPrivateKey.fromHex(widget.privateKey);
    getBalance(credentials.address);
    getData(credentials.address);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    String contractAddress = "0x15f16c624Ca76654668629A8a639989BFeEa0639";
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'eth'),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(EthereumAddress credentialAddress) async {
    List result = await query("balErc", [credentialAddress]);
    var data = result[0];
    print('print balance ' + result.toString());
    setState(() {
      balance = EtherAmount.fromUnitAndValue(EtherUnit.ether, data)
          .getInEther
          .toString();
    });
  }

  Future<void> getData(EthereumAddress credentialAddress) async {
    List result = await query("owner", []);
    var data = result[0];
    print(data);
  }

  Future<void> deposit() async {
    var amount = EtherAmount.fromUnitAndValue(EtherUnit.ether, "10").getInWei;
    print('Nilainya : ' + amount.toString());
    var result = await submit("deposit", [amount]);
    // var data = result[0];

    print(result);

    // print(EtherAmount.fromUnitAndValue(EtherUnit.ether, "1000").getInWei);
  }

  Future<String>? sendCoin() async {
    var bigAmount = BigInt.from(int.parse(textAmount.text));
    var response = await submit("deposit", [textAddress.text, bigAmount]);
    return response;
  }

  Future<String> submit(String functionName, List args) async {
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    EthPrivateKey key = EthPrivateKey.fromHex(widget.privateKey);
    Transaction transaction = await Transaction.callContract(
        contract: contract, function: ethFunction, parameters: args);
    final result =
        await ethClient.sendTransaction(key, transaction, chainId: 4);

    return result;
  }

  @override
  void initState() {
    httpClient = Client();
    ethClient =
        Web3Client("https://rinkeby-light.eth.linkpool.io/", httpClient);
    details();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ETH Send'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Text('Your Balance'),
            Text(
              (balance == null ? 0 : balance!).toString() + ' ETH',
              style: const TextStyle(fontSize: 30),
            ),
            Text(widget.publicKey.toString()),
            const SizedBox(
              height: 50,
            ),
            const Text('Your Private Key'),
            TextField(
              controller: textPrivateKey,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Send to'),
            TextField(
              controller: textAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Amount (ETH)'),
            TextField(
              controller: textAmount,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: sendCoin, child: const Text('Send')),
            ElevatedButton(
                onPressed: () {
                  deposit();
                },
                child: const Text('Deposit'))
          ],
        ),
      ),
    );
  }
}
