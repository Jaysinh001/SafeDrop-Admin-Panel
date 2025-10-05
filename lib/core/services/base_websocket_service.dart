import 'package:web_socket_channel/web_socket_channel.dart';

abstract class BaseWebSocketServices {
  WebSocketChannel connectWebSocket(
      {required String token, required String path});
  Stream<dynamic> listenWebSocketChannel(WebSocketChannel channel);
  void send(WebSocketChannel channel, dynamic data);
  void dispose(WebSocketChannel channel);
}
