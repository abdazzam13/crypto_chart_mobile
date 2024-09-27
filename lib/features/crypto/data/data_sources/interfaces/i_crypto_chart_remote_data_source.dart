abstract class ICryptoChartRemoteDataSource{
  Future<Stream> submitRequest({
    String? apiPath,
    String? request,
    });
}