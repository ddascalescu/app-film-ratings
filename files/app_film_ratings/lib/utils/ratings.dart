import 'package:intl/intl.dart';
import 'dart:convert';

class Ratings {
  static final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateFormatShort = DateFormat('dd-MMM');
  static final DateFormat _dateFormatOnlyYear = DateFormat('yyyy');

  static String encode(List<Rating> ratings) {
    JsonEncoder e = const JsonEncoder.withIndent(' ');
    return e.convert(ratings);
  }

  static List<Rating> decode(String data) {
    var l = jsonDecode(data);
    assert (l is List);

    List<Rating> ratings = [];
    for (var r in l) {
      ratings.add(Rating.fromJson(r));
    }
    return ratings;
  }
}

class Rating {
  // TODO: if started caching films, change this to a corresponding filmID
  // TODO: when added sorting, add ratingID and use as a default sort
  String filmTitle;
  int filmYear;

  double rating;
  DateTime? ratingDate;

  Rating(this.filmTitle, this.filmYear, this.rating, DateTime ratingDate) {
    this.ratingDate = DateTime(ratingDate.year, ratingDate.month, ratingDate.day);
  }

  String get filmYearString => filmYear.toString();
  String get ratingString => rating.toStringAsFixed(1);
  String get ratingDateString => Ratings.dateFormat.format(ratingDate!);

  String get ratingDateStringShort => (ratingDate!.isAfter(DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day))) ? Ratings._dateFormatShort.format(ratingDate!) : Ratings._dateFormatOnlyYear.format(ratingDate!);
  /* ratingDateStringShort displays e.g. 04-Nov if date is within 1 year of
  * current date, otherwise displays just the year */

  @override
  String toString() {
    return
      'Rating {\n'
        '\tFilm: $filmTitle ($filmYear)\n'
        '\tRating: $rating\n'
        '\tRating date: $ratingDateString\n'
      '}';
  }

  Map<String, dynamic> toJson() => {
    'title': filmTitle,
    'year': filmYear,
    'rating': rating,
    'date': ratingDateString
  };

  Rating.fromJson(Map<String, dynamic> json)
      : filmTitle = json['title'],
        filmYear = json['year'],
        rating = json['rating'],
        ratingDate = Ratings.dateFormat.parse(json['date']);
}
