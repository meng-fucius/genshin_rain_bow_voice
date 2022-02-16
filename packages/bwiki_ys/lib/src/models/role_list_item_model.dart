class RoleListItemModel {
  final String name;
  final String image;
  final String path;

  Uri? get imageUri => Uri.tryParse(image);
  RoleListItemModel({
    required this.name,
    required this.image,
    required this.path,
  });
}
