//    Rankify is an Open Source AI app made to help brawl stars players reach higher ranks.
//    Copyright (C) 2026 WoLKaR-dev
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Affero General Public License as
//    published by the Free Software Foundation, either version 3 of the
//    License, or (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Affero General Public License for more details.
//
//    You should have received a copy of the GNU Affero General Public License
//    along with this program.  If not, see https://www.gnu.org/licenses/

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
