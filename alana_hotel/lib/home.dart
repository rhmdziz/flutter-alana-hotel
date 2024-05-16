// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Hotel {
  final String url;
  final String title;
  final String desc;
  final String review;
  final String location;
  final String rating;
  final String image;
  final String price;

  Hotel({
    required this.url,
    required this.title,
    required this.desc,
    required this.review,
    required this.location,
    required this.rating,
    required this.image,
    required this.price,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      url: json['url'],
      title: json['title'],
      desc: json['desc'],
      review: json['review'],
      location: json['location'],
      rating: json['rating'],
      image: json['image'],
      price: json['price'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Hotel>> futureHotel;

  @override
  void initState() {
    super.initState();
    futureHotel = fetchHotel();
  }

  Future<List<Hotel>> fetchHotel() async {
    final response =
        await http.get(Uri.parse('http://192.168.50.210:8000/hotels'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Hotel> hotelList = data.map((json) => Hotel.fromJson(json)).toList();
      return hotelList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  final List<String> categories = ["Popular", "4+ Star", "3- Star"];
  String selectedCategory = "Popular";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
        title: const Center(
          child: Text(
            "Places to stay",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.blueAccent,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Specifics hotel in mind?..",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Logika pencarian saat teks berubah
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Category'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  children: categories.map((category) {
                    return ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.blue,
                        ),
                      ),
                      selected: selectedCategory == category,
                      selectedColor: Colors.lightBlue,
                      backgroundColor: Colors.white,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                        // Logika untuk memfilter item berdasarkan kategori yang dipilih
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Hotel>>(
                future: futureHotel,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final hotel = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            _showHotelDetail(context, hotel);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        hotel.image,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              hotel.rating,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hotel.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              hotel.location,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                        height: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Start From',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                hotel.price,
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              // Aksi ketika tombol favorit ditekan
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0, // Menghilangkan bayangan
        color: Colors.blue, // Atur warna background
        child: Padding(
          padding: EdgeInsets.zero, // Menghilangkan padding
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Alana Hotel Sentul',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1 room - Master bed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4 - 5 April',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      '1 Night',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: null,
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)))),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Check in',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'Rp1200.000',
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showHotelDetail(BuildContext context, Hotel hotel) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                hotel.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              hotel.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 4.0),
                Text(
                  hotel.rating,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 4.0),
                Text(
                  '(${hotel.review} Reviews)',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 8.0),
            Text(
              hotel.title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              hotel.desc,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Amenities',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text('WiFi'),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text('Free Parking'),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text('Pool'),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text('Restaurant'),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text('Lift'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 8.0),
            const Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.grey,
                ),
                SizedBox(width: 4.0),
                Text(
                  'Self Check IN',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              'Location: ${hotel.location}',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Row(
              children: [
                Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                SizedBox(width: 4.0),
                Text(
                  'Great check in experience',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              '90% of recent guess gave 5 star rating!',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4-5 Apr | 1 Night(s)',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        hotel.price,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed:
                        () {}, // onPressed harus diisi dengan fungsi yang akan dijalankan saat tombol ditekan
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // ubah nilai sesuai keinginan
                      ),
                    ),
                    child: const Text(
                      'Book Now!',
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
