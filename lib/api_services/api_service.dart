class ApiService{
  //==================Product List =======================
  //static fetchAllProductsApi() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   String link = "${baseUrl}api/v1/getAllProducts";
  //   try {
  //     Response response = await Dio().post(link,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var item = jsonDecode(response.data);
  //     return List.from(item).map((e) => AllProductsModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  }