// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'barcode_scanner_view.dart';
// import '/firebase/controller/main/general/dto.dart';
// import '/firebase/controller/main/item_add.dart';
// import 'package:get/get.dart';

// class Barcodescanner extends StatefulWidget {
//   @override
//   _BarcodescannerState createState() => _BarcodescannerState();
// }

// class _BarcodescannerState extends State<Barcodescanner> {
//   String? _scanBarcode = '';
//   ItemAddController controller = Get.arguments;
//   ItemAddDTO? item;
//   @override
//   void initState() {
//     super.initState();
//   }
// // Future<void> startBarcodeScanStream() async {
// // FlutterBarcodeScanner.getBarcodeStreamReceiver(
// // '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
// // .listen((barcode) => print(barcode));
// // }
// // Future<void> scanQR() async {
// // String barcodeScanRes;
// // // Platform messages may fail, so we use a try/catch PlatformException.
// // try {
// // barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
// // '#ff6666', 'Cancel', true, ScanMode.QR);
// // print(barcodeScanRes);
// // } on PlatformException {
// // barcodeScanRes = 'Failed to get platform version.';
// // }
// // if (!mounted) return;

// // setState(() {
// // _scanBarcode = barcodeScanRes;
// // });
// // }

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (BuildContext context) {
//       return Container(
//           alignment: Alignment.center,
//           child: Flex(
//               direction: Axis.vertical,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     var list = await availableCameras();
//                     _scanBarcode = await Get.to(() => BarcodeScannerView(),
//                         arguments: list);
//                     if (_scanBarcode != null) {
//                       setState(() {
//                         item = controller.getByBarcode(_scanBarcode!.trim());
//                       });
//                     }
//                   },
//                   child: Text('바코드 스캔'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Color(0xff2C7B0C),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(item == null ? "스캔해주세요" : item!.itemName,
//                     style: TextStyle(fontSize: 20)),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (item != null) {
//                       await controller.add(item!);
//                     }
//                   },
//                   child: Text('아이템 추가'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Color(0xff2C7B0C),
//                   ),
//                 ),
//               ]));
//     });
//   }
// }
