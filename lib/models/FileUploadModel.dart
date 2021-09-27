import 'dart:io';

class FileUploadModel {
  File file;
  String fileUrl;
  bool isUploaded;
  bool isUploadError;

  FileUploadModel(this.file,this.fileUrl, this.isUploaded, this.isUploadError);
}