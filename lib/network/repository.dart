import 'package:dio/dio.dart';
import 'package:heritage_online_flutter/network/api_client.dart';
import 'package:heritage_online_flutter/network/response/banner_response.dart';
import 'package:heritage_online_flutter/network/response/news_detail_response.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';

class Repository {
  final ApiClient _apiClient = ApiClient(Dio());

  Repository();

  static final Repository _instance = Repository();

  factory Repository.getInstance() => _instance;

  Future<List<NewsListResponse>> getNewsList(int page) {
    return _apiClient.getNewsList(page);
  }

  Future<List<NewsListResponse>> getForumsList(int page) {
    return _apiClient.getForumsList(page);
  }

  Future<List<NewsListResponse>> getSpecialTopicList(int page) {
    return _apiClient.getSpecialTopicList(page);
  }

  Future<List<BannerResponse>> getBanner() {
    return _apiClient.getBanner();
  }

  Future<NewsDetailResponse> getNewsDetail(String link) {
    return _apiClient.getNewsDetail(link);
  }

  Future<NewsDetailResponse> getForumsDetail(String link) {
    return _apiClient.getForumsDetail(link);
  }

  Future<NewsDetailResponse> getSpecialTopicDetail(String link) {
    return _apiClient.getSpecialTopicDetail(link);
  }
}
