class Post {
  final String uid;
  final String userUID;
  final String icon;
  final String name;
  final String imageSRC;
  final String legend;
  final DateTime date;
  final List curtidas;

  Post({
    this.uid,
    this.userUID,
    this.icon,
    this.name,
    this.imageSRC,
    this.legend,
    this.date,
    this.curtidas,
  });
}
