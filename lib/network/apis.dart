class Apis {
  static const String banner = "/api/banner";
  static const String newsListUrl = "/api/NewsList/{page}";
  static const String newsDetail = "/api/NewsDetail";
  static const String forumsList = "/api/Forums/ForumsList/{page}";
  static const String forumsDetail = "/api/Forums/GetForumsDetail";
  static const String specialTopic =
      "/api/SpecialTopic/GetSpecialTopicList/{page}";
  static const String specialTopicDetail =
      "/api/SpecialTopic/GetSpecialTopicDetail";
  static const String peopleMainPage = "/api/People/GetPeopleMainPage";
  static const String peopleList = "/api/People/PeopleList/{page}";
  static const String peopleDetail = "/api/People/GetPeopleDetail";
  static const String projectList =
      "/api/HeritageProject/GetHeritageProjectList/{page}";
  static const String projectBasicInformation =
      "/api/HeritageProject/GetMainPage";
  static const String projectDetail = "/api/HeritageProject/GetHeritageDetail";
  static const String inheritanceDetail =
      "/api/HeritageProject/GetInheritatePeople";
  static const String searchCategory =
      "/api/HeritageProject/GetSearchCategories";
  static const String searchProject =
      "/api/HeritageProject/SearchHeritageProject";
  static const String projectStatistics =
      "/api/HeritageProject/GetProjectStatisticInformation";
  static const String searchNews = "/api/NewsList/SearchNews/{pages}";
  static const String getAllProjectType =
      "/api/HeritageProject/GetAllProjectType";
}
