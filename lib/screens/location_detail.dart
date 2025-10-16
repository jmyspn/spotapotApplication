class LocationDetail {
  final int floor;
  final String side;
  final String gender;
  bool isOpen;
  double rating;
  final String imagePath;
  final List<String> images;

  LocationDetail({
    required this.floor,
    required this.side,
    required this.gender,
    required this.isOpen,
    required this.rating,
    required this.imagePath,
    required this.images,
  });
}

// Initial mock locations
final List<LocationDetail> initialMockLocations = [
  LocationDetail(
    floor: 1,
    side: 'Left',
    gender: 'Female',
    isOpen: true,
    rating: 4.5,
    imagePath: 'assets/icons/1st_left.JPG',
    images: [
      'assets/icons/1st_left_cubicle1.JPG',
      'assets/icons/1st_left_faucet.JPG',
      'assets/icons/1st_left_cubicle2.JPG',
    ],
  ),
  LocationDetail(
    floor: 1,
    side: 'Right',
    gender: 'Male',
    isOpen: false,
    rating: 3.8,
    imagePath: 'assets/icons/1st_right.JPG',
    images: [
      'assets/icons/1st_right_toilet1.JPG',
      'assets/icons/1st_right_faucet.JPG',
      'assets/icons/1st_right_toilet2.JPG',
    ],
  ),
  LocationDetail(
    floor: 2,
    side: 'Left',
    gender: 'Female',
    isOpen: true,
    rating: 4.9,
    imagePath: 'assets/icons/2nd_left.JPG',
    images: [
      'assets/icons/2nd_left_cubicle1.JPG',
      'assets/icons/2nd_left_faucet.JPG',
      'assets/icons/2nd_left_cubicle2.JPG',
    ],
  ),
  LocationDetail(
    floor: 2,
    side: 'Right',
    gender: 'Male',
    isOpen: true,
    rating: 4.2,
    imagePath: 'assets/icons/2nd_right.JPG',
    images: [
      'assets/icons/2nd_right_toilet1.JPG',
      'assets/icons/2nd_right_faucet.JPG',
      'assets/icons/2nd_right_toilet2.JPG',
    ],
  ),
  LocationDetail(
    floor: 3,
    side: 'Left',
    gender: 'Male',
    isOpen: false,
    rating: 3.5,
    imagePath: 'assets/icons/3rd_left.JPG',
    images: [
      'assets/icons/3rd_left_toilet1.JPG',
      'assets/icons/3rd_left_faucet.JPG',
      'assets/icons/3rd_left_toilet2.JPG',
    ],
  ),
  LocationDetail(
    floor: 3,
    side: 'Right',
    gender: 'Female',
    isOpen: true,
    rating: 4.7,
    imagePath: 'assets/icons/3rd_right.JPG',
    images: [
      'assets/icons/3rd_right_cubicle1.JPG',
      'assets/icons/3rd_right_faucet.JPG',
      'assets/icons/3rd_right_cubicle2.JPG',
    ],
  ),
];
