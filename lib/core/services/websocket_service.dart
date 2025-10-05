import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../exceptions/app_exceptions.dart';
import 'base_websocket_service.dart';

class WebSocketServices implements BaseWebSocketServices {
  const WebSocketServices();

  // static const String baseWebSocketUrl = "ws://10.0.2.2:5678/";
  static const String baseWebSocketUrl =
      "wss://safe-drop-backend-3nwm.onrender.com/";

  @override
  WebSocketChannel connectWebSocket({
    required String token,
    required String path,
  }) {
    try {
      return IOWebSocketChannel.connect(
        baseWebSocketUrl + path,
        headers: {"Authorization": token},
      );
    } on Exception catch (e) {
      throw WebSocketConnectionException('Failed to connect to WebSocket: $e');
    }
  }

  @override
  Stream<dynamic> listenWebSocketChannel(WebSocketChannel channel) {
    try {
      return channel.stream;
    } on Exception catch (e) {
      throw WebSocketListeningException('Failed to listen to WebSocket: $e');
    }
  }

  @override
  void send(WebSocketChannel channel, dynamic data) {
    try {
      channel.sink.add(jsonEncode(data));
    } on Exception catch (e) {
      throw WebSocketSendingException('Failed to send data to WebSocket: $e');
    }
  }

  @override
  void dispose(WebSocketChannel channel) {
    try {
      channel.sink.close();
    } on Exception catch (e) {
      throw WebSocketClosingException(
        'Failed to close WebSocket connection: $e',
      );
    }
  }
}
