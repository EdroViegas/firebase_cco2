class Address {
  final String city;
  final String county;
  final String street;
  final String reference;

  Address({this.city, this.county, this.street, this.reference});

  Address.fromData(Map<String, dynamic> data)
      : city = data['city'],
        county = data['county'],
        street = data['street'],
        reference = data['reference'];

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'county': county,
      'street': street,
      'reference': reference,
    };
  }
}
