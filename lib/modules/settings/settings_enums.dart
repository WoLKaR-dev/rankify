enum SpeechMode {
  pro("Pro"),
  aggro("Aggro");

  final String value;
  const SpeechMode(this.value);
}

enum Model {
  v1("V1"),
  v2("V2"),
  v3("V3");

  final String value;
  const Model(this.value);
}

enum Optimization {
  few("Fast"),
  regular("Regular"),
  personalized("Personalized");

  final String value;
  const Optimization(this.value);
}
