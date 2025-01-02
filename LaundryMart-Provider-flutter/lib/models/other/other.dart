import 'dart:convert';

class OtherModel {
  final Setting setting;
  OtherModel({
    required this.setting,
  });

  OtherModel copyWith({
    Setting? setting,
  }) {
    return OtherModel(
      setting: setting ?? this.setting,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'setting': setting.toMap(),
    };
  }

  factory OtherModel.fromMap(Map<String, dynamic> map) {
    return OtherModel(
      setting: Setting.fromMap(map['setting'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherModel.fromJson(String source) =>
      OtherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OtherModel(setting: $setting)';

  @override
  bool operator ==(covariant OtherModel other) {
    if (identical(this, other)) return true;

    return other.setting == setting;
  }

  @override
  int get hashCode => setting.hashCode;
}

class Setting {
  final String title;
  final String content;
  Setting({
    required this.title,
    required this.content,
  });

  Setting copyWith({
    String? title,
    String? content,
  }) {
    return Setting(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Setting.fromJson(String source) =>
      Setting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Setting(title: $title, content: $content)';

  @override
  bool operator ==(covariant Setting other) {
    if (identical(this, other)) return true;

    return other.title == title && other.content == content;
  }

  @override
  int get hashCode => title.hashCode ^ content.hashCode;
}
