class Rating {
  // TODO: if started caching films, change this to a corresponding filmID
  String filmTitle;
  int filmYear;

  double rating;
  DateTime ratingDate;

  Rating(this.filmTitle, this.filmYear, this.rating, this.ratingDate);

  @override
  String toString() {
    return
      'Rating {\n'
        '\tFilm: ${filmTitle} (${filmYear})\n'
        '\tRating: ${rating}\n'
        '\tRating date: ${ratingDate}\n'
      '}';
  }
}
