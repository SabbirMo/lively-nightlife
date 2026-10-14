import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/club_event_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/create_event_models.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/controller/user_event_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/model/user_event_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/model/user_lineup_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/model/user_ticket_model.dart';

class ClubCreateEventController extends GetxController {
  final RxInt currentStep = 1.obs;

  // Step 1 state
  final RxString selectedBannerPath = ImagePath.clubCoverPhoto.obs;
  final List<String> presetBanners = [
    ImagePath.clubCoverPhoto, ImagePath.feedImage, ImagePath.onbImage1, ImagePath.onbImage2, ImagePath.onbImage3,
  ];
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final capacityController = TextEditingController(text: '500');
  final RxString selectedVenue = 'Omnia Nightclub'.obs;
  final customVenueController = TextEditingController();
  final descriptionController = TextEditingController();

  // Step 2 state
  final RxList<String> selectedGenres = <String>[].obs;
  final RxString selectedAge = '21+'.obs;
  final RxString selectedDressCode = 'Upscale Nightclub'.obs;
  final RxList<String> eventTags = <String>[].obs;
  final eventTagController = TextEditingController();

  // Step 3 state
  final RxList<EventTicketTier> ticketTiers = <EventTicketTier>[EventTicketTier()].obs;

  // Step 4 state
  final RxList<EventArtist> lineup = <EventArtist>[
    EventArtist(avatar: 'https://i.pravatar.cc/150?img=33'),
    EventArtist(avatar: 'https://i.pravatar.cc/150?img=34'),
    EventArtist(avatar: 'https://i.pravatar.cc/150?img=35'),
  ].obs;

  final RxBool isEditMode = false.obs;
  String? editingEventId;

  @override
  void onInit() {
    super.onInit();
    _loadEventIfEditing();
  }

  void _loadEventIfEditing() {
    if (Get.arguments is ClubEventModel) {
      isEditMode.value = true;
      final clubEvent = Get.arguments as ClubEventModel;
      editingEventId = clubEvent.id;

      titleController.text = clubEvent.title;
      selectedBannerPath.value = clubEvent.imagePath;

      UserEventModel? userEvent;
      if (Get.isRegistered<UserEventController>()) {
        userEvent = Get.find<UserEventController>()
            .eventsList
            .firstWhereOrNull((e) => e.id == clubEvent.id);
      }

      if (userEvent != null) {
        dateController.text = userEvent.date;
        startTimeController.text = userEvent.time;
        final times = userEvent.duration.split(' - ');
        if (times.length > 1) {
          endTimeController.text = times[1];
        }
        capacityController.text = userEvent.tickets.isNotEmpty
            ? userEvent.tickets.first.total.toString()
            : '500';

        final loc = userEvent.location;
        if (['Omnia Nightclub', 'Marquee Nightclub, Las Vegas, NV', 'Story Nightclub, Miami', 'Empire Polo Club, Indio'].contains(loc)) {
          selectedVenue.value = loc;
          customVenueController.clear();
        } else {
          selectedVenue.value = '';
          customVenueController.text = loc;
        }

        descriptionController.text = userEvent.description;
        selectedGenres.assignAll(userEvent.categories);

        ticketTiers.clear();
        if (userEvent.tickets.isNotEmpty) {
          for (var t in userEvent.tickets) {
            final tier = EventTicketTier();
            tier.nameController.text = t.name;
            tier.priceController.text = t.price.toString();
            tier.qtyController.text = t.total.toString();
            ticketTiers.add(tier);
          }
        } else {
          ticketTiers.add(EventTicketTier());
        }

        lineup.clear();
        for (var a in userEvent.lineup) {
          final artist = EventArtist(avatar: a.image);
          artist.nameController.text = a.name;
          artist.role.value = a.role;
          lineup.add(artist);
        }
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    capacityController.dispose();
    customVenueController.dispose();
    descriptionController.dispose();
    eventTagController.dispose();
    for (var t in ticketTiers) { t.dispose(); }
    for (var a in lineup) { a.dispose(); }
    super.onClose();
  }

  Future<void> pickBannerFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) selectedBannerPath.value = image.path;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick banner: $e');
    }
  }

  void selectPresetBanner(String path) => selectedBannerPath.value = path;
  void selectVenue(String venue) {
    selectedVenue.value = venue;
    customVenueController.clear();
  }
  void onCustomVenueChanged(String value) {
    if (value.isNotEmpty) selectedVenue.value = '';
  }

  Future<void> selectTime(BuildContext context, TextEditingController txtController) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryColor,
            onPrimary: AppColors.whiteColor,
            onSurface: AppColors.blackColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      txtController.text = "${hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} ${picked.period == DayPeriod.am ? 'AM' : 'PM'}";
    }
  }

  void nextStep() {
    if (currentStep.value == 1) {
      if (titleController.text.trim().isEmpty || dateController.text.trim().isEmpty || startTimeController.text.trim().isEmpty) {
        Get.snackbar('Field Required', 'Title, Date, and Start Time are required');
        return;
      }
    }
    if (currentStep.value < 5) {
      currentStep.value++;
    } else {
      publishEvent();
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
      Get.delete<ClubCreateEventController>();
    }
  }

  void addTag() {
    final t = eventTagController.text.trim();
    if (t.isNotEmpty && !eventTags.contains(t)) {
      eventTags.add(t);
      eventTagController.clear();
    }
  }

  void addTicketTier() => ticketTiers.add(EventTicketTier());
  void removeTicketTier(int idx) {
    ticketTiers[idx].dispose();
    ticketTiers.removeAt(idx);
  }

  void addArtist() {
    final nextImg = 10 + lineup.length % 50;
    lineup.add(EventArtist(avatar: 'https://i.pravatar.cc/150?img=$nextImg'));
  }
  void removeArtist(int idx) {
    lineup[idx].dispose();
    lineup.removeAt(idx);
  }

  void publishEvent() {
    final title = titleController.text.trim().isEmpty ? 'New Club Event' : titleController.text.trim();
    final location = selectedVenue.value.isNotEmpty ? selectedVenue.value : customVenueController.text.trim();
    final banner = selectedBannerPath.value;
    final eventId = isEditMode.value
        ? (editingEventId ?? DateTime.now().millisecondsSinceEpoch.toString())
        : DateTime.now().millisecondsSinceEpoch.toString();

    final clubHomeCtrl = Get.find<ClubHomeController>();

    final userTickets = ticketTiers.map((t) => UserTicketModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: t.nameController.text.trim().isEmpty ? 'General Admission' : t.nameController.text.trim(),
      price: int.tryParse(t.priceController.text.trim()) ?? 0,
      available: int.tryParse(t.qtyController.text.trim()) ?? 500,
      total: int.tryParse(t.qtyController.text.trim()) ?? 500,
    )).toList();

    final userLineup = lineup.map((a) => UserLineupModel(
      name: a.nameController.text.trim().isEmpty ? 'DJ Artist' : a.nameController.text.trim(),
      role: a.role.value,
      image: a.avatar,
    )).toList();

    if (isEditMode.value) {
      final idx = clubHomeCtrl.upcomingEvents.indexWhere((e) => e.id == eventId);
      if (idx != -1) {
        final existing = clubHomeCtrl.upcomingEvents[idx];
        clubHomeCtrl.upcomingEvents[idx] = ClubEventModel(
          id: eventId,
          title: title,
          imagePath: banner,
          isOpen: existing.isOpen,
          rating: existing.rating,
          location: location,
          priceTier: existing.priceTier,
          rsvps: existing.rsvps,
          ticketsSold: existing.ticketsSold,
          revenue: existing.revenue,
        );
      }

      if (Get.isRegistered<UserEventController>()) {
        final userCtrl = Get.find<UserEventController>();
        final uIdx = userCtrl.eventsList.indexWhere((e) => e.id == eventId);
        if (uIdx != -1) {
          final existingUser = userCtrl.eventsList[uIdx];
          userCtrl.eventsList[uIdx] = UserEventModel(
            id: eventId,
            name: title,
            location: location,
            date: dateController.text.trim().isEmpty ? '2026-06-25' : dateController.text.trim(),
            time: startTimeController.text.trim().isEmpty ? '10:00 PM' : startTimeController.text.trim(),
            duration: '${startTimeController.text.trim()} - ${endTimeController.text.trim()}',
            image: banner,
            price: userTickets.isNotEmpty ? userTickets.first.price : 0,
            categories: selectedGenres.toList(),
            goingCount: existingUser.goingCount,
            interestedCount: existingUser.interestedCount,
            isHot: existingUser.isHot,
            isRsvped: existingUser.isRsvped.value,
            description: descriptionController.text.trim(),
            tickets: userTickets,
            lineup: userLineup,
          );
          userCtrl.filterEvents();
        }
      }
    } else {
      clubHomeCtrl.upcomingEvents.insert(0, ClubEventModel(
        id: eventId,
        title: title,
        imagePath: banner,
        isOpen: true,
        rating: 4.8,
        location: location,
        priceTier: '\$\$\$',
        rsvps: '0',
        ticketsSold: '0',
        revenue: '\$0.0k',
      ));

      final newUserEvent = UserEventModel(
        id: eventId,
        name: title,
        location: location,
        date: dateController.text.trim().isEmpty ? '2026-06-25' : dateController.text.trim(),
        time: startTimeController.text.trim().isEmpty ? '10:00 PM' : startTimeController.text.trim(),
        duration: '${startTimeController.text.trim()} - ${endTimeController.text.trim()}',
        image: banner,
        price: userTickets.isNotEmpty ? userTickets.first.price : 0,
        categories: selectedGenres.toList(),
        goingCount: '0',
        interestedCount: '0',
        isHot: true,
        isRsvped: false,
        description: descriptionController.text.trim(),
        tickets: userTickets,
        lineup: userLineup,
      );

      if (Get.isRegistered<UserEventController>()) {
        final userCtrl = Get.find<UserEventController>();
        userCtrl.eventsList.insert(0, newUserEvent);
        userCtrl.filterEvents();
      } else {
        final userCtrl = Get.put(UserEventController());
        userCtrl.eventsList.insert(0, newUserEvent);
        userCtrl.filterEvents();
      }
    }

    Get.back();
    Get.delete<ClubCreateEventController>();
    Get.snackbar(
      'Success',
      isEditMode.value ? 'Event updated successfully!' : 'Event published successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.greenColor.withValues(alpha: 0.9),
      colorText: AppColors.whiteColor,
    );
  }
}
