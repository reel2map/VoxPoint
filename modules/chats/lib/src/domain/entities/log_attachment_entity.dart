import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_attachment_entity.freezed.dart';
part 'log_attachment_entity.g.dart';

@freezed
class LogAttachmentEntity with _$LogAttachmentEntity {
  const factory LogAttachmentEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'ocr') String? ocr,
  }) = _LogAttachmentEntity;

  factory LogAttachmentEntity.fromJson(Map<String, dynamic> json) =>
      _$LogAttachmentEntityFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
