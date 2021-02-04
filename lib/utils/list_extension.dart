extension ExtendedList on List {
  T firstOrNull<T>() => this.isEmpty ? null : this.first;
}
