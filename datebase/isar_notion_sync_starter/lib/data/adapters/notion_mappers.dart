extension JsonPick on Map<String, dynamic> {
  T? pick<T>(List<String> path) {
    dynamic cur = this;
    for (final k in path) {
      if (cur is Map<String, dynamic>) {
        cur = cur[k];
      } else {
        return null;
      }
    }
    return cur as T?;
  }
}
