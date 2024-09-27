import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/app_utils.dart';

class ApiService {

  Future<Stream> post({
    required String apiPath,
    String? request,
  }) async {
    appPrint('SUBMIT REQUEST TO WEBSOCKET');
    appPrint('URL : $apiPath');
    appPrint("Request : $request");
    final wsUri = Uri.parse(apiPath);
    final channel = WebSocketChannel.connect(wsUri);

    await channel.ready;
    channel.sink.add(request);
    return channel.stream;

  }
}
