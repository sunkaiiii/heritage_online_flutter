import 'package:dio/dio.dart';
import 'package:heritage_online_flutter/network/api_client.dart';
import 'package:heritage_online_flutter/network/response/banner_response.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';

class Repository {
  final ApiClient _apiClient = ApiClient(Dio());

  Repository();

  static final Repository _instance = Repository();

  factory Repository.getInstance() => _instance;

  Future<List<NewsListResponse>> getNewsList(int page) {
    return _apiClient.getNewsList(page);
  }

  Future<List<BannerResponse>> getBanner() {
    return _apiClient.getBanner();
  }
}
