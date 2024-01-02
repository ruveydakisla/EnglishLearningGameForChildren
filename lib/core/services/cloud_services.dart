import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/avatar_constants.dart';

class CloudServices {
  Future<void> saveDataToFirebase(int selectedAvatarIndex, String text,
      BuildContext context, int score, String mail) async {
    try {
      await Firebase.initializeApp();
      final firestore = FirebaseFirestore.instance;

      if (selectedAvatarIndex != -1) {
        final selectedAvatarUrl =
            AvatarConstantsExtension.getAvatarUrl(selectedAvatarIndex);

        await firestore.collection('users').add({
          'name': text,
          'avatar': selectedAvatarUrl,
          'score': score,
          'mail': mail
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data saved to Firebase.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an avatar.'),
          ),
        );
      }
    } catch (e) {
      print('Error saving data to Firebase: $e');
    }
  }

  Future<void> updateUserNameAndAvatar(
      String mail, String newName, String newAvatarUrl) async {
    try {
      await Firebase.initializeApp();
      final firestore = FirebaseFirestore.instance;

      // E-posta adresine göre belgeyi sorgula
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .where('mail', isEqualTo: mail)
          .get();

      // Eğer belge bulunursa, belgeyi güncelle
      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await firestore.collection('users').doc(docId).update({
          'name': newName,
          'avatar': newAvatarUrl,
        });

        print('User data updated successfully.');
      } else {
        print('User not found with the given email.');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserDataByEmail(String email) async {
    try {
      await Firebase.initializeApp();
      final firestore = FirebaseFirestore.instance;

      // E-posta adresine göre belgeyi sorgula
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .where('mail', isEqualTo: email)
          .get();

      // Eğer belge bulunursa, belgeyi al ve gerekli alanları içeren bir map oluştur
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();

        // Gerekli alanları içeren bir map oluştur
        final userMap = {
          'name': userData['name'],
          'avatar': userData['avatar'],
          'score': userData['score'],
        };

        return userMap;
      } else {
        print('User not found with the given email.');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
