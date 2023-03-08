import 'package:flutter/foundation.dart';

class PictureProvider extends ChangeNotifier {
  PictureProvider(/*{required this.rpc}*/);

/*
  // final RpcProvider rpc;
  final images = <String, Image?>{};

  Image? getImage(String key) {
    if (images.containsKey(key)) {
      return images[key];
    }
    images[key] = null;
    rpc.imageHttp(key).then((image) {
      images[key] = image;
      notifyListeners();
    });
    return images[key];
  }
  */
}
