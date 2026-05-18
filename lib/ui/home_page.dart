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
import '../providers/local_user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;

  final FirebaseFirestore _firestore_user_collection = FirebaseFirestore.instance;

  final List<BtnCartoonModel> cartoonList = BtnCartoonModel.getListCartoonModels();

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
      // Единый светлый фон, как в маркете
      backgroundColor: const Color(0xFFF4F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Пружинящий скролл для всей страницы
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarWidget(showLogoutButton: true),

              // Главный заголовок
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    const Text(
                      "Explore Universe",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF03045E), // Темно-синий
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🌌", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),

              _buildSearchBar(),

              _buildSectionTitle("Popular Characters", "👾"),
              _buildListViewCharacters(),

              _buildSectionTitle("Watch Channels", "📺"),
              showListCartoon(),

              const SizedBox(height: 10),
              _buildEarnCard(),
              const SizedBox(height: 30), // Отступ снизу
            ],
          ),
        ),
      ),
    );
  }

  // Вспомогательный виджет для красивых заголовков секций
  Widget _buildSectionTitle(String title, String emoji) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 12.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF03045E),
            ),
          ),
          const SizedBox(width: 8),
          Text(emoji, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // Легкая тень
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterCharacters,
          decoration: InputDecoration(
            hintText: "Search character...",
            hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF9D4EDD)), // Фиолетовый акцент
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16), // Чуть выше
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24), // Скругление 24
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListViewCharacters() {
    return SizedBox(
      height: 280,
      child: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF00F5D4)),
      )
          : ListView.builder(
        physics: const BouncingScrollPhysics(), // Пружинка
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12), // Отступы по краям
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
        physics: const BouncingScrollPhysics(), // Пружинка
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    builder: (context) => ShowCartoonPage(btnCartoonModel: cartoonModel),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    cartoonModel.image,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEarnCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Яркий бирюзово-синий градиент (как на кнопке Trade)
        gradient: const LinearGradient(
          colors: [Color(0xFF00F5D4), Color(0xFF0077B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          // Цветное свечение под карточкой
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
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
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Colors.white,
                height: 1.3,
              ),
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
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF0077B6)),
            ),
          ),
        ],
      ),
    );
  }
}