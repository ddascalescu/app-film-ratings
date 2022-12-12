import 'package:intl/intl.dart';

class Ratings {
  static final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
}

class Rating {
  // TODO: if started caching films, change this to a corresponding filmID
  String filmTitle;
  int filmYear;

  double rating;
  DateTime? ratingDate;

  Rating(this.filmTitle, this.filmYear, this.rating, DateTime ratingDate) {
    this.ratingDate = DateTime(ratingDate.year, ratingDate.month, ratingDate.day);
  }

  @override
  String toString() {
    return
      'Rating {\n'
        '\tFilm: $filmTitle ($filmYear)\n'
        '\tRating: $rating\n'
        '\tRating date: ${Ratings.dateFormat.format(ratingDate!)}\n'
      '}';
  }
}
