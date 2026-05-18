import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rick_coins_market_ruhsari/app_navigation.dart';
import 'package:rick_coins_market_ruhsari/components/top_bar_widget.dart';

class CabinetPage extends StatefulWidget {
  const CabinetPage({super.key});
  @override
  State<CabinetPage> createState() => _CabinetPageState();
}

class _CabinetPageState extends State<CabinetPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  double uploadProgress = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: type == 'pdf' ? ['pdf'] : ['docx', 'doc']);

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      var ref = FirebaseStorage.instance.ref().child(
        '$type/${DateTime.now().millisecondsSinceEpoch}',
      );
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });
      var snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();

      await _firestore.collection(type == 'pdf' ? 'pdfs' : 'words').add({
        type == 'pdf' ? 'fileTitle' : 'fileWordTitle': fileName,
        type == 'pdf' ? 'downloadUrl' : 'downloadWordUrl': url,
        'idUser': FirebaseAuth.instance.currentUser!.uid,
        'score': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        uploadProgress = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload Successful! 🎉"),
            backgroundColor: Color(0xFF38EF7D),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Единый светлый фон
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Пружинящий скролл
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TopBarWidget(showLogoutButton: false),

              // Современный заголовок
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    const Text(
                      "Scenario Cabinet",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF03045E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("📚", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),

              // Полоса загрузки (плавное появление)
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: uploadProgress > 0
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Uploading... ${(uploadProgress * 100).toInt()}%",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0077B6)),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: uploadProgress,
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          color: const Color(0xFF00F5D4),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 12),

              // Яркие кнопки загрузки
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    _buildUploadCard(
                      label: 'Upload PDF',
                      icon: Icons.picture_as_pdf_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shadowColor: const Color(0xFFFF512F),
                      onPressed: () => uploadFile('pdf'),
                    ),
                    const SizedBox(width: 16),
                    _buildUploadCard(
                      label: 'Upload Word',
                      icon: Icons.description_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shadowColor: const Color(0xFF4FACFE),
                      onPressed: () => uploadFile('word'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Списки файлов
              _buildModernScenarioList(
                path: 'pdfs',
                icon: Icons.picture_as_pdf_rounded,
                iconColor: const Color(0xFFDD2476),
                title: "PDF Scenarios",
              ),
              const SizedBox(height: 20),
              _buildModernScenarioList(
                path: 'words',
                icon: Icons.description_rounded,
                iconColor: const Color(0xFF0077B6),
                title: "Word Scenarios",
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Современная карточка загрузки с градиентом
  Widget _buildUploadCard({
    required String label,
    required IconData icon,
    required LinearGradient gradient,
    required Color shadowColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Современный горизонтальный список
  Widget _buildModernScenarioList({
    required String path,
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF03045E)
            ),
          ),
        ),
        SizedBox(
          height: 130, // Сделали чуть выше для красивых отступов
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection(path).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Padding(padding: const EdgeInsets.only(left: 20), child: Text('Error: ${snapshot.error}'));
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: iconColor));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text("No scenarios uploaded yet.", style: TextStyle(color: Colors.grey[500])),
                );
              }

              final items = snapshot.data!.docs;

              return ListView.builder(
                physics: const BouncingScrollPhysics(), // Пружинящий эффект
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final data = items[index].data() as Map<String, dynamic>;
                  final fileName = (path == 'words')
                      ? (data['fileWordTitle'] ?? 'Unnamed Word')
                      : (data['fileTitle'] ?? 'Unnamed PDF');
                  final url = (path == 'words')
                      ? (data['downloadWordUrl'] ?? '')
                      : (data['downloadUrl'] ?? '');

                  return GestureDetector(
                    onTap: () {
                      if (path == 'pdfs') {
                        Navigator.pushNamed(context, AppNavigation.pdfView, arguments: {'url': url, 'title': fileName, 'authorId': data['idUser']});
                      } else {
                        Navigator.pushNamed(context, AppNavigation.wordView, arguments: {'url': url, 'title': fileName, 'authorId': data['idUser']});
                      }
                    },
                    child: Container(
                      width: 110,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Иконка на мягком фоне
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 28, color: iconColor),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            fileName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF495057),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}