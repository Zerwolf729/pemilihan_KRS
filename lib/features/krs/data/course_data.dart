import '../models/course.dart';

class CourseData {
  CourseData._();

  static final List<Course> allCourses = [
    const Course(
      code: '000800',
      name: 'Penulisan dan Publikasi Ilmiah',
      credits: 2,
      prerequisite: 'Metodologi Penelitian',
      type: CourseType.wajib,
      description:
          'Mempelajari kaidah penulisan ilmiah, etika publikasi, dan teknik penulisan artikel ilmiah yang memenuhi standar jurnal bereputasi.',
      focus: CourseFocus.penulisanIlmiah,
    ),
    const Course(
      code: '110700',
      name: 'Kriptografi',
      credits: 3,
      prerequisite: 'Matematika Diskrit',
      type: CourseType.pilihan,
      description:
          'Mempelajari prinsip keamanan informasi, algoritma enkripsi klasik dan modern, fungsi hash, tanda tangan digital, serta penerapannya untuk melindungi data dan komunikasi.',
      focus: CourseFocus.kriptografi,
    ),
    const Course(
      code: '111100',
      name: 'Penalaran Komputer',
      credits: 3,
      prerequisite: 'Kecerdasan Buatan',
      type: CourseType.pilihan,
      description:
          'Mempelajari prinsip penalaran berbasis logika dan pengetahuan untuk memecahkan masalah kompleks dalam domain komputer.',
      focus: CourseFocus.penalaranKomputer,
    ),
    const Course(
      code: '111300',
      name: 'Robotika',
      credits: 3,
      prerequisite: 'Mikrokontroler',
      type: CourseType.pilihan,
      description:
          'Mempelajari desain, konstruksi, dan kendali sistem robotik, termasuk sensor, aktuator, dan algoritma pergerakan.',
      focus: CourseFocus.robotika,
    ),
    const Course(
      code: '111400',
      name: 'Simulasi dan Game Komputer',
      credits: 3,
      prerequisite: 'Algoritma dan Pemrograman',
      type: CourseType.pilihan,
      description:
          'Mempelajari teknik pembuatan simulasi komputer dan pengembangan permainan, termasuk perancangan sistem, grafika, dan logika permainan.',
      focus: CourseFocus.simulasiGame,
    ),
    const Course(
      code: '110600',
      name: 'Jaringan Nirkabel',
      credits: 3,
      prerequisite: 'Jaringan Komputer',
      type: CourseType.pilihan,
      description:
          'Mempelajari prinsip komunikasi nirkabel, arsitektur jaringan nirkabel, standar IEEE 802.11, serta teknik pengelolaan kualitas layanan (QoS).',
      focus: CourseFocus.jaringanNirkabel,
    ),
    const Course(
      code: '111000',
      name: 'Pemrograman Aplikasi Bergerak',
      credits: 3,
      prerequisite: 'Algoritma dan Pemrograman',
      type: CourseType.pilihan,
      description:
          'Mempelajari teknik pengembangan aplikasi untuk perangkat seluler, termasuk antarmuka pengguna, akses sumber daya perangkat, dan siklus hidup aplikasi.',
      focus: CourseFocus.pemrogramanBergerak,
    ),
    const Course(
      code: '111600',
      name: 'Teknologi Aplikasi Bergerak',
      credits: 3,
      prerequisite: 'Komunikasi Data',
      type: CourseType.pilihan,
      description:
          'Mempelajari arsitektur dan teknologi terkini dalam pengembangan aplikasi seluler, termasuk sinkronisasi data, layanan berbasis lokasi, dan optimasi kinerja.',
      focus: CourseFocus.teknologiBergerak,
    ),
    const Course(
      code: '111500',
      name: 'Sistem Manajemen Basis Data',
      credits: 3,
      prerequisite: 'Sistem Basis Data',
      type: CourseType.pilihan,
      description:
          'Mempelajari teknik lanjut dalam perancangan, implementasi, dan administrasi sistem manajemen basis data untuk skala besar dan kebutuhan enterprise.',
      focus: CourseFocus.sistemBasisData,
    ),
  ];
}