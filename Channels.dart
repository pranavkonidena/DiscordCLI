class category_channels {
  String channel = "";
  String category = "";
  Map<String, String> channels_students = {};

  category_channels(String channel_c, String category_c, String username) {
    channel = channel_c;
    category = category_c;
    String key = channel + "_" + category;
    

  }
}
