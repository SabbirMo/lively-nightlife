import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventTicketTier {
  final nameController = TextEditingController(text: 'General Admission');
  final priceController = TextEditingController();
  final qtyController = TextEditingController();
  final descController = TextEditingController();

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    qtyController.dispose();
    descController.dispose();
  }
}

class EventArtist {
  final nameController = TextEditingController();
  final RxString role = 'Headliner'.obs; // Headliner, Co-Headliner, Support
  final String avatar;

  EventArtist({required this.avatar});

  void dispose() {
    nameController.dispose();
  }
}
