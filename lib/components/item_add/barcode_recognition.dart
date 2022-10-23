import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '/firebase/controller/main/general/dto.dart';
import '/firebase/controller/main/item_add.dart';
import 'package:get/get.dart';

class Barcodescanner extends StatefulWidget {
  @override
  _BarcodescannerState createState() => _BarcodescannerState();
}

class _BarcodescannerState extends State<Barcodescanner> {
  String _scanBarcode = 'Unknown';
  late ItemAddDTO _scanItem;
  ItemAddController controller = Get.arguments;
  @override
  void initState() {
    super.initState();
  }

  // Future<void> startBarcodeScanStream() async {
  //   FlutterBarcodeScanner.getBarcodeStreamReceiver(
  //           '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
  //       .listen((barcode) => print(barcode));
  // }

  // Future<void> scanQR() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      ItemAddDTO? item = controller.getByBarcode(_scanBarcode);
      if (item != null) {
        _scanItem = item;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Container(
          alignment: Alignment.center,
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: Text('바코드 스캔'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff2C7B0C),
                  ),
                ),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () => scanQR(),
                //   child: Text('Start QR scan'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Color(0xff2C7B0C),
                //   ),
                // ),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () => startBarcodeScanStream(),
                //   child: Text('Start barcode scan stream'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Color(0xff2C7B0C),
                //   ),
                // ),
                SizedBox(height: 20),
                Text(_scanItem.itemName,
                    style: TextStyle(fontSize: 20)),
                ElevatedButton(
                  onPressed: () => controller.add(_scanItem),
                  child: Text('아이템 추가'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff2C7B0C),
                  ),
                ),
              ]));
    });
  }
}
