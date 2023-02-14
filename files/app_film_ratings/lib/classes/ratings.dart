import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:logger/logger.dart';

class Ratings {
  static final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateFormatShort = DateFormat('dd-MMM');
  static final DateFormat _dateFormatOnlyYear = DateFormat('yyyy');

  static final DateFormat dateFormatTimestamp = DateFormat('yyyyMMddhhmmss');

  static final types = {
    1: "First viewing",
    2: "Repeat viewing",
    3: "Retroactive change",
    4: "External import"
  }; // TODO: make final list combination of this plus any custom-made descriptions

  static String encode(List<Rating> ratings, String version) {
    Map<String, dynamic> map = {
      "version": version,
      "list": ratings
    };
    JsonEncoder e = const JsonEncoder.withIndent(' ');
    return e.convert(map);
  }

  static List<Rating> decode(String data) {
    var m = jsonDecode(data);
    assert (m is Map);

    var l = m['list'];
    assert (l is List);

    return decodeList(l);
  }

  static List<Rating> decodeList(List l) {
    List<Rating> ratings = [];
    for (var r in l) {
      try {
        Rating rating = Rating.fromJson(r);
        ratings.add(rating);
      } catch (e) {
        try{
          Rating rating = Rating.fromJson020(r);
          ratings.add(rating);
        } catch (e) {
          Logger().w("Error decoding rating from JSON:"
              "\n\t$r"
              "\n\t$e");
        }
      }
    }
    return ratings;
  }
}

class Rating {
  // TODO: if started caching films, change this to a corresponding filmID
  late String uuid;
  late String timestamp;

  String filmTitle;
  int filmYear;

  double rating;
  late DateTime ratingDate;
  int typeId;

  Rating(this.filmTitle, this.filmYear, this.rating, DateTime ratingDate, this.typeId) {
    uuid = const Uuid().v4();
    timestamp = Ratings.dateFormatTimestamp.format(DateTime.now());
    this.ratingDate = DateTime(ratingDate.year, ratingDate.month, ratingDate.day);
  }

  String get filmYearString => filmYear.toString();
  String get ratingString => rating.toStringAsFixed(1);
  String get ratingDateString => Ratings.dateFormat.format(ratingDate);

  String get ratingDateStringShort => (ratingDate.isAfter(DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day))) ? Ratings._dateFormatShort.format(ratingDate) : Ratings._dateFormatOnlyYear.format(ratingDate);
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
    'uuid': uuid,
    'ts': timestamp,
    'title': filmTitle,
    'year': filmYear,
    'rating': rating,
    'date': ratingDateString,
    'type': typeId
  };

  Rating.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        timestamp = json['ts'],
        filmTitle = json['title'],
        filmYear = json['year'],
        rating = json['rating'],
        ratingDate = Ratings.dateFormat.parse(json['date']),
        typeId = json['type'];

  Rating.fromJson020(Map<String, dynamic> json)
      : uuid = json['uuid'],
        timestamp = json['ts'],
        filmTitle = json['title'],
        filmYear = json['year'],
        rating = json['rating'],
        ratingDate = Ratings.dateFormat.parse(json['date']),
        typeId = json['descr'];
}
