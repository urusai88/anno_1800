/*
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:anno_shared/anno_shared.dart';
import 'package:computer/computer.dart';
import 'package:http/http.dart';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RpcProvider {
  final Computer computer;
  late final WebSocketChannel _wsChannel;
  late final Peer _peer;
  late final StreamSubscription<String> _subscription;

  RpcProvider({required this.computer}) {
    return;
    final uri = Uri.parse('ws://127.0.0.1:60000/ws');
    _wsChannel = WebSocketChannel.connect(uri);
    final stream =
        _wsChannel.stream.where((e) => e is String).map((e) => e as String);
    final controller = StreamController<String>();
    final channel = StreamChannel.withCloseGuarantee(stream, controller.sink);
    _peer = Peer(channel);
    _subscription = controller.stream.listen(_wsChannel.sink.add);
  }

  void open() {
    unawaited(_peer.listen());
  }

  Future<List<String>> sessionsJson() {
    return _peer
        .sendRequest('sessionsJson')
        .then((v) => List<String>.from(v as List));
  }

  Future<List<SessionDataFile>> sessions() {
    return _peer.sendRequest('sessions').then((v) {
      return (List<JSON>.from(v as List))
          .map((e) => SessionDataFile.fromJson(e))
          .toList();
    });
  }

  Future<List<LandDataFile>> lands() {
    return _peer.sendRequest('lands').then((v) {
      return (List<JSON>.from(v as List))
          .map((e) => LandDataFile.fromJson(e))
          .toList();
    });
  }

  Future<Image> imageHttp(String path) async {
    final b64 = base64Encode(utf8.encode(path));
    final uri = Uri.parse('http://127.0.0.1:60000/image?image=$b64');
    final resp = await get(uri, headers: {
      'content-type': 'image/png',
    });
    final bytes = resp.bodyBytes;
    final completer = Completer<Image>();
    decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }
}
*/
