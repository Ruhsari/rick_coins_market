import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/ui/show_cartoon_page.dart';

import '../components/character_info_card.dart';
import '../components/top_bar_widget.dart';
import '../models/btn_cartoon_model.dart';
import '../services/char_api_service.dart';
import '../states/local_user_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;

  int _selectedIndex = 0; // 0 - Home, 1 - Market, 2 - Cabinet и т.д.

  final FirebaseFirestore _firesstor_user_collection = FirebaseFirestore
      .instance
      .collection('user_persons')
      .firestore;

  final List<BtnCartoonModel> cartoonList =
  BtnCartoonModel.getListCartoonModels();

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";
  List<dynamic> _allCharacters = [];
  List<dynamic> _filteredCharacters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await CharApiService().getAllCharacters();
      setState(() {
        _allCharacters = data;
        _filteredCharacters = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error :$e");
    }
  }

  void _filterCharacters(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCharacters = _allCharacters
          .where(
            (char) => char['name'].toString().toLowerCase().contains(
          query.toLowerCase(),
        ),
      )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopBarWidget(showLogoutButton: true),
              _buildSearchBar(userProvider),
              _buildListViewCharacters(),
              showListCartoon(),
              _buildEarnCard(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildSearchBar(UserProvider userProvider) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
  //     child: TextField(
  //       controller: _searchController,
  //       onChanged: _filterCharacters,
  //       decoration: InputDecoration(
  //         hintText: "Search character...",
  //         prefixIcon: const Icon(Icons.search),
  //         filled: true,
  //         fillColor: Colors.white,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(30),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildSearchBar(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _searchController,
        onChanged: _filterCharacters,
        decoration: InputDecoration(
          hintText: "Search character...",
          prefixIcon: const Icon(Icons.search, color: Color(0xFF0077B6)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),

        ),
      ),
    );
  }

  Widget _buildListViewCharacters() {
    return SizedBox(
      height: 280,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filteredCharacters.length,
        itemBuilder: (context, index) {
          return CharacterInfoCard(char: _filteredCharacters[index]);
        },
      ),
    );
  }

  Widget showListCartoon() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cartoonList.length,
        itemBuilder: (context, index) {
          final cartoonModel = cartoonList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ShowCartoonPage(btnCartoonModel: cartoonModel),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  cartoonModel.image,
                  width: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildEarnCard() {
  //   return Container(
  //     margin: const EdgeInsets.all(16),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(24),
  //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
  //     ),
  //     child: Row(
  //       children: [
  //         SizedBox(
  //           width: 100,
  //           height: 100,
  //           child: Lottie.asset('assets/lottie/turn_coin.json'),
  //         ),
  //         const SizedBox(width: 16),
  //         const Expanded(
  //           child: Text(
  //             "If you have not account \nfor earning rickkoins, \nyou can do it now!\nRead Uses Condition",
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             if (currentUser == null) {
  //               Navigator.pushNamed(context, '/offerta');
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text("You already \nhave an account!"),
  //                 ),
  //               );
  //             }
  //           },
  //           child: const Icon(Icons.arrow_forward_ios, size: 16),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEarnCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF56CCF2), Color(0xFF0077B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0077B6).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Lottie.asset('assets/lottie/turn_coin.json'),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Earn Rick Coins now!\nRead user conditions.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white, height: 1.3),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentUser == null) {
                Navigator.pushNamed(context, '/offerta');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You already have an account!")),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF0077B6)),
            ),
          ),
        ],
      ),
    );
  }
}

