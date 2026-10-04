import 'package:flutter/foundation.dart';

enum CourseType {
  wajib,
  pilihan;

  String get label => switch (this) {
        CourseType.wajib => 'Wajib',
        CourseType.pilihan => 'Pilihan',
      };
}

enum CourseFocus {
  kriptografi,
  penalaranKomputer,
  robotika,
  simulasiGame,
  jaringanNirkabel,
  pemrogramanBergerak,
  teknologiBergerak,
  sistemBasisData,
  penulisanIlmiah;

  String get focusLabel => switch (this) {
        CourseFocus.kriptografi => 'Fokus: enkripsi, integritas, autentikasi',
        CourseFocus.penalaranKomputer => 'Fokus: penalaran simbolik dan mesin',
        CourseFocus.robotika => 'Fokus: sensor, aktuator, kontrol',
        CourseFocus.simulasiGame => 'Fokus: fisika simulasi dan rendering',
        CourseFocus.jaringanNirkabel => 'Fokus: protokol dan QoS nirkabel',
        CourseFocus.pemrogramanBergerak => 'Fokus: aplikasi lintas platform',
        CourseFocus.teknologiBergerak => 'Fokus: layanan dan data bergerak',
        CourseFocus.sistemBasisData => 'Fokus: perancangan basis data',
        CourseFocus.penulisanIlmiah => 'Fokus: penulisan dan publikasi ilmiah',
      };
}

@immutable
class Course {
  const Course({
    required this.code,
    required this.name,
    required this.credits,
    required this.prerequisite,
    required this.type,
    required this.description,
    required this.focus,
  });

  final String code;
  final String name;
  final int credits;
  final String prerequisite;
  final CourseType type;
  final String description;
  final CourseFocus focus;
}