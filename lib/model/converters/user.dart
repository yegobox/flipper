class UserConverter {
  String p;

  String name;

  UserConverter(this.p, this.name);

  @override
  String toString() {
    return '{ ${this.name}, ${this.p} }';
  }
}
