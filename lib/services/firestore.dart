import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/dashboard_models.dart';
import '../models/user_auth_model.dart';

final ref = FirebaseFirestore.instance.collection('Build_With_Innovation');
const todaySpecialId = "today_special_123";
const featuredServicesId = "featured_services";
final uid = FirebaseAuth.instance.currentUser!.uid;

class FirestoreService {
  Future<TodaySpecial?> getTodaySpecial() async {
    late TodaySpecial? todaySpecial;
    final doc = await ref.doc(todaySpecialId).get();
    if (doc.exists) {
      todaySpecial = TodaySpecial.fromMap(doc.data()!);
    }
    return todaySpecial;
  }

  Future<UserModel?> getUser() async {
    UserModel? user;
    final doc =
        await ref.doc('users').collection("users_collection").doc(uid).get();
    if (doc.exists) {
      user = UserModel.fromMap(doc.data()!);
    }
    return user;
  }

  Future<List<FeaturedService>?> getFeaturedServices() async {
    List<FeaturedService>? featuredServices;
    final doc = await ref
        .doc(featuredServicesId)
        .collection('featured_services_collection')
        .get();
    if (doc.docs.isNotEmpty) {
      featuredServices = [];
      try {
        for (var element in doc.docs) {
          featuredServices.add(FeaturedService.fromMap(element.data()));
        }
        //adding twice for testing purpose
        for (var element in doc.docs) {
          featuredServices.add(FeaturedService.fromMap(element.data()));
        }
        //adding twice for testing purpose
        for (var element in doc.docs) {
          featuredServices.add(FeaturedService.fromMap(element.data()));
        }
      } catch (e) {
        log('error is here $e');
      }
    }
    return featuredServices;
  }

  Future<List<CategoryModel>?> getCategories() async {
    List<CategoryModel>? categories;
    final doc =
        await ref.doc('categories').collection('categories_collection').get();

    if (doc.docs.isNotEmpty) {
      categories = [];
      try {
        for (var element in doc.docs) {
          categories.add(CategoryModel.fromMap(element.data()));
        }
      } catch (e) {
        log('error is here in getcategories $e');
      }
    }
    return categories;
  }

  Future<List<HairSalon>?> getHairSalons() async {
    List<HairSalon>? hairSalons;
    final doc = await ref
        .doc('hair_salons')
        .collection('hair_salons_collection')
        .orderBy('total_reviews')
        .get();

    if (doc.docs.isNotEmpty) {
      hairSalons = [];
      try {
        for (var element in doc.docs.reversed) {
          hairSalons.add(HairSalon.fromMap(element.data()));
        }
      } catch (e) {
        log('error is here in gethair salons $e');
      }
    }
    return hairSalons;
  }

  Future<void> addUserToFirestore(UserModel user) async {
    await ref.doc('users').collection("users_collection").doc(user.id).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }
}
