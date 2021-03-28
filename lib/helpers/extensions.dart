extension StringExtensions on String {
  String concatNumber(String number) {
    String str = number.substring(8, number.length);
    String newNumber = "ORD-" + this + str;

    return newNumber;
  }

  String getInitials() {
    List<String> names = this.split(" ");
    String initials = "";
    int numWords = 2;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }

    return initials;
  }

  String capitalize() {
    return this;
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  String numberReducer() {
    return this;
  }

  String dateFormat() {
    if (this != null) {
      final dateTime = DateTime.tryParse(this);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
    return this;
  }

  String dateTimeFormat() {
    if (this != null) {
      final dateTime = DateTime.tryParse(this);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute}";
    }
    return this;
  }

  String dbDateTimeFormat() {
    if (this != null) {
      final dateTime = DateTime.tryParse(this);
      return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    }
    return this;
  }

  String get removeTimeZone {
    var regex = new RegExp(r'[a-zA-Z]');

    if (!this.contains(regex)) {
      return this;
    }

    String replaced = this.replaceAll(regex, '*').replaceAll("*", "");

    String result = "";
    for (int i = 0; i < replaced.length; i++) {
      if (i == 9) {
        result += replaced[i] + " ";
      } else {
        result += replaced[i];
      }
    }

    return result;
  }

  String get formatPublishedDate {
    if (this != null) {
      final dateTime = DateTime.tryParse(this);
      if (dateTime == null) return this;
      var diff = DateTime.now()?.difference(dateTime);
      // For showing date in hours
      if (diff.inHours < 24) {
        // For showing date in minutes
        if (diff.inMinutes < 59) {
          // For showing date in seconds
          if (diff.inSeconds < 59) {
            return "Há alguns segundos";
          }
          return "Há ${diff.inMinutes} minuto${diff.inMinutes > 1 ? 's' : ''}";
        }
        return "Há ${diff.inHours} hora${diff.inHours == 1 ? '' : 's'}";
      }
      // For showing date and time
      return this.dateTimeFormat();
    }

    return this;
  }

  String get formatActiveDate {
    if (this != null) {
      final dateTime = DateTime.tryParse(this);
      if (dateTime == null) return this;
      var diff = DateTime.now()?.difference(dateTime);
      // For showing date in hours
      if (diff.inHours < 24) {
        // For showing date in minutes
        if (diff.inMinutes < 59) {
          // For showing date in seconds
          if (diff.inSeconds < 59) {
            return "Há alguns segundos";
          }
          return "Há ${diff.inMinutes} minuto${diff.inMinutes > 1 ? 's' : ''}";
        }
        return "Há ${diff.inHours} hora${diff.inHours == 1 ? '' : 's'}";
      }
      // For showing date and time
      return "Há ${diff.inDays} dias";
    }

    return this;
  }
}

extension DoubleExtensions on double {
  double numberReducer() {
    return this;
  }
}

extension IntExtensions on int {
  String numberReducer() {
    return this?.toString();
  }
}

extension basename on String {
  String ext() {
    if (this != null) {
      if (this.length > 0) {
        String ext = this.split("/").last.split(".").last;
        if (ext == "jpg") ext = "jpeg";
        return ext;
      }
    }
    return this;
  }

  String name() {
    if (this != null) {
      if (this.length > 0) {
        return this.split("/").last.split(".").first;
      }
    }
    return this;
  }
}
