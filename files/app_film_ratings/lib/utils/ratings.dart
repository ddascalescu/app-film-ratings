import 'package:intl/intl.dart';
import 'dart:convert';

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

  String encode(List<Rating> ratings) {
    return jsonEncode(ratings);
  }

  List<Rating> decode(String data) {
    var l = jsonDecode(data);
    assert (l is List);

    List<Rating> ratings = [];
    for (var r in l) {
      assert (r is Rating);
      ratings.add(r);
    }
    return ratings;
  }

  String get yearString => filmYear.toString();
  String get ratingString => rating.toStringAsFixed(1);
  String get ratingDateString => Ratings.dateFormat.format(ratingDate!);
}
