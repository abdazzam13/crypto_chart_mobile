abstract class CryptoChartRepository {
  Future<Stream?> submitRequest(
      {String? action, String? symbols});
}
