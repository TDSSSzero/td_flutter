import 'dart:io';

class FilePath{

  static const waterVideo = "assets/video/water.mp4";
  static const cityVideo = "assets/video/video_coastalcity.mp4";
  static const galaxyVideo = "assets/video/video_milkywaygalaxy.mp4";
  static const sparklerVideo = "assets/video/video_sparkler.mp4";


  //themes
  static const themeBg1 = "assets/theme_img/bg1.png";
  static const themeBg2 = "assets/theme_img/bg2.png";
  static const themeBg3 = "assets/theme_img/bg3.png";
  static const themeBg4 = "assets/theme_img/bg4.png";
  static const themeBg5 = "assets/theme_img/bg5.png";
  static const themeVideo1 = "assets/theme_img/city.webp";
  static const themeVideo2 = "assets/theme_img/galaxy.webp";
  static const themeVideo3 = "assets/theme_img/sparkler.webp";

  static late String audioTempPath;

  static Future<List<String>> getFilesInFolder(String folderPath) async {
    Directory directory = Directory(folderPath);
    if (!await directory.exists()) {
      directory.create(recursive: true);
      // 文件夹不存在
      return [];
    }
    List<String> fileNames = [];
    List<FileSystemEntity> entities = directory.listSync(recursive: false);
    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        fileNames.add(entity.path.split('/').last); // 获取文件名
      }
    }
    return fileNames;
  }
}