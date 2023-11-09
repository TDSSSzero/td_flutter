import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:td_flutter/common/file_path.dart';


class EncryptUtils{

  static final Encrypter _encrypter = Encrypter(AES(Key.fromUtf8('metajoy.bettermindset-motivation'),mode: AESMode.cbc));
  static final IV _iv = IV.fromUtf8("1234567890123456");

  static String encryptString(String? data){
    return data != null ? _encrypter.encrypt(data,iv: _iv).base64 : "";
  }

  static String decryptString(String? data){
    return  data != null ? _encrypter.decrypt64(data,iv: _iv) : "";
  }

  static String encryptAudio(String savePath){
    final bytes = _encrypter.encryptBytes(File(FilePath.audioTempPath).readAsBytesSync(),iv: _iv).bytes;
    final file = File(savePath)
        ..writeAsBytesSync(bytes);
    return file.path;
  }

  static int decryptAudio(String savePath){
    final bytes = _encrypter.decryptBytes(Encrypted(File(savePath).readAsBytesSync()),iv: _iv);
    File(FilePath.audioTempPath).writeAsBytesSync(bytes);
    return bytes.length;
  }
}