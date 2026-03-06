class Event<T> {
  Event({required this.type, required this.data});

  final String type;

  final T data;
}
