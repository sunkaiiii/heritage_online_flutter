import 'package:dio/dio.dart';
import 'package:heritage_online_flutter/network/apis.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';

const String baseUrl = "https://sunkai.xyz:5001";

@RestApi(baseUrl: baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.newsListUrl)
  Future<List<NewsListResponse>> getNewsList(@Path("page") int page);
}
