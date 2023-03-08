enum SessionId {
  europe,
  america,
  arctic,
  cape,
  africa;

  const SessionId();

  factory SessionId.fromPathPart(String s1, [String? s2]) {
    switch (s1) {
      case 'sunken_treasures':
        return SessionId.cape;
      case 'colony_03_sp':
        return SessionId.arctic;
      case 'land_of_lions':
        return SessionId.africa;
      case 'pool':
        switch (s2) {
          case 'colony01':
            return SessionId.america;
          case 'moderate':
            return SessionId.europe;
        }
    }

    throw Exception('$s1 $s2');
  }

  static bool isNeedSecondPart(String s1) => s1 == 'pool';
}
