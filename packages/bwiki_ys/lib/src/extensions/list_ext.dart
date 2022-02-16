extension ListExt<T> on List<T> {
  T? safeFirst() => isEmpty ? null : first;
}
