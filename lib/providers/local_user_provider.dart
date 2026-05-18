import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rick_coins_market_ruhsari/models/user_model.dart';
import 'dart:async';

class UserProvider with ChangeNotifier {
  UserModel? _userData;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<DocumentSnapshot>? _userSubscription;

  UserModel? get userData => _userData;

  UserProvider() {
    _listenToUser();
  }

  void _listenToUser() {
    _auth.authStateChanges().listen((User? user) {

      _userSubscription?.cancel();

      if (user != null) {

        _userSubscription = _db
            .collection('user_persons')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            _userData = UserModel.fromMap(snapshot.data()!);
            notifyListeners();
          }
        });
      } else {
        // Если пользователь вышел, очищаем данные
        _userData = null;
        notifyListeners();
      }
    });
  }

  Future<void> updateMarketMessage(String newMessage) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('user_persons').doc(uid).update({
      'message': newMessage,
    });
  }

  Future<void> updateBuyIntent(int toBuy) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('user_persons').doc(uid).update({'buying': toBuy});
  }

  Future<void> updateSaleIntent(int toSell) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('user_persons').doc(uid).update({'sales': toSell});
  }

  Future<void> giveRickCoins(String ownerId, int amount) async {
    final ownerRef = _db.collection('user_persons').doc(ownerId);
    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot ownerSnapshot = await transaction.get(ownerRef);

        if (!ownerSnapshot.exists) {
          throw Exception("This user does not found in the database!");
        } else {
          transaction.update(ownerRef, {'coins': ownerSnapshot['coins'] + amount});
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateIndividualOffer(int buyAmount, int sellAmount, String partnerUid) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('user_persons').doc(user.uid).update({
      'individualBuy': buyAmount,
      'individualSell': sellAmount,
      'targetPartnerId': partnerUid,
    });
  }

  Future<void> acceptIndividualBuy(String partnerUid, int amount) async {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null) return;

    final currentUserRef = _db.collection('user_persons').doc(currentUid);
    final partnerRef = _db.collection('user_persons').doc(partnerUid);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot currentSnap = await transaction.get(currentUserRef);
      DocumentSnapshot partnerSnap = await transaction.get(partnerRef);

      int myCoins = currentSnap['coins'] ?? 0;
      int partnerCoins = partnerSnap['coins'] ?? 0;

      if (myCoins >= amount) {
        transaction.update(currentUserRef, {'coins': myCoins - amount});
        transaction.update(partnerRef, {'coins': partnerCoins + amount});

        // ИСПРАВЛЕНО: убрана лишняя 'u'
        transaction.update(partnerRef, {'individualBuy': 0});
      } else {
        throw Exception("You don't have enought Rickkoins!");
      }
    });
  }
  Future<void> acceptIndividualSell(String partnerUid, int amount) async {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null) return;

    final currentUserRef = _db.collection('user_persons').doc(currentUid);
    final partnerRef = _db.collection('user_persons').doc(partnerUid);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot currentSnap = await transaction.get(currentUserRef);
      DocumentSnapshot partnerSnap = await transaction.get(partnerRef);

      int myCoins = currentSnap['coins'] ?? 0;
      int partnerCoins = partnerSnap['coins'] ?? 0;

      transaction.update(currentUserRef, {'coins': myCoins + amount});
      transaction.update(partnerRef, {'coins': partnerCoins - amount});

      transaction.update(partnerRef, {'individualSell': 0});
    });
  }

  Future<void> currentUserBuys(String partnerId, int amount) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    final currentUserRef = _db.collection('user_persons').doc(currentUserId);
    final partnerRef = _db.collection('user_persons').doc(partnerId);

    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot currentUserSnap = await transaction.get(
          currentUserRef,
        );
        DocumentSnapshot partnerSnap = await transaction.get(partnerRef);

        if (!currentUserSnap.exists || !partnerSnap.exists) {
          throw Exception("One of the users does not exist in the database!");
        }

        int currentCoins = currentUserSnap['coins'] ?? 0;
        int partnerCoins = partnerSnap['coins'] ?? 0;

        if (partnerCoins >= amount) {
          transaction.update(partnerRef, {'coins': partnerCoins - amount});
          transaction.update(currentUserRef, {'coins': currentCoins + amount});
        } else {
          throw Exception("Partner does not have enough Rickkoins!");
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> currentUserSells(String partnerId, int amount) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    final currentUserRef = _db.collection('user_persons').doc(currentUserId);
    final partnerRef = _db.collection('user_persons').doc(partnerId);

    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot currentUserSnap = await transaction.get(
          currentUserRef,
        );
        DocumentSnapshot partnerSnap = await transaction.get(partnerRef);

        if (!currentUserSnap.exists || !partnerSnap.exists) {
          throw Exception("One of the users does not exist in the database!");
        }

        int currentCoins = currentUserSnap['coins'] ?? 0;
        int partnerCoins = partnerSnap['coins'] ?? 0;

        if (currentCoins >= amount) {
          transaction.update(currentUserRef, {'coins': currentCoins - amount});
          transaction.update(partnerRef, {'coins': partnerCoins + amount});
        } else {
          throw Exception("Not enough Rickkoins!");
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
