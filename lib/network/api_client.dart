import 'package:dio/dio.dart';
import 'package:heritage_online_flutter/network/apis.dart';
import 'package:heritage_online_flutter/network/response/banner_response.dart';
import 'package:heritage_online_flutter/network/response/news_detail_response.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';

const String baseUrl = "https://sunkai.xyz:5001";

@RestApi(baseUrl: baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.newsListUrl)
  Future<List<NewsListResponse>> getNewsList(@Path("page") int page);

  @GET(Apis.forumsList)
  Future<List<NewsListResponse>> getForumsList(@Path("page") int page);

  @GET(Apis.specialTopic)
  Future<List<NewsListResponse>> getSpecialTopicList(@Path("page") int page);

  @GET(Apis.newsDetail)
  Future<NewsDetailResponse> getNewsDetail(@Query("link") String link);

  @GET(Apis.forumsDetail)
  Future<NewsDetailResponse> getForumsDetail(@Query("link") String link);

  @GET(Apis.specialTopicDetail)
  Future<NewsDetailResponse> getSpecialTopicDetail(@Query("link") String link);

  @GET(Apis.banner)
  Future<List<BannerResponse>> getBanner();
}
