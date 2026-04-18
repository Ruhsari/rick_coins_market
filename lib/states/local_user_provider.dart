
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userData;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? get userData => _userData;

  UserProvider() {
    _listenToUser();
  }

  void _listenToUser() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _db.collection('user_persons').doc(user.uid).snapshots().listen((
        snapshot,
        ){
          if (snapshot.exists) {
            _userData = UserModel.fromMap(snapshot.data()!);
            notifyListeners();
          }
        });
      } else {
        _userData = null;
        notifyListeners();
      }
    });
  }

  Future<void> updateMarketMessage(String newMessage) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('user_persons').doc(uid).update({
      'message' : newMessage,
    });
  }

  Future<void> updateBuyIntent(int toBuy) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('user_persons').doc(uid).update({
      'buying' : toBuy,
    });
    }

  Future<void> updateSaleIntent(int toSell) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('user_persons').doc(uid).update({
      'sales' : toSell,
    });
  }

  Future<void> giveRickCoins(String ownerId, int amount) async {
    final buyerId = _auth.currentUser!.uid;
    // if (buyerId == null) return;

    final buyerRef = _db.collection('user_persons').doc(buyerId);
    final ownerRef = _db.collection('user_persons').doc(ownerId);
    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot buyerSnapshot = await transaction.get(buyerRef);
        DocumentSnapshot ownerSnapshot = await transaction.get(ownerRef);
        int currentCoins = buyerSnapshot['coins'] ?? 0;
        if (currentCoins >= amount) {
          transaction.update(ownerRef, {'coins': currentCoins - amount});
          transaction.update(buyerRef, {'coins': ownerSnapshot['coins']??0 + amount});
        } else {
          throw Exception("You don't have enough coins");
        }
      });
    } catch (e) {rethrow;
    }
  }
}