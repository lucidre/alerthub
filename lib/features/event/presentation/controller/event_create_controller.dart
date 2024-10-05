import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';

class EventCreateController extends GetxController {
  final EventService eventService;
  EventCreateController(this.eventService);
  final RxnDouble _selectedLat = RxnDouble(-1);
  final RxnDouble _selectedLng = RxnDouble(-1);

  final RxBool _isHidden = true.obs;
  final RxBool _isLoading = false.obs;

  final Rxn<EventPriority> _selectedPriority = Rxn();

  final Rxn<DateTime> _startDate = Rxn();
  final Rxn<DateTime> _endDate = Rxn();

  final RxBool _userDoesNotKnowStartDate = false.obs;
  final RxBool _userDoesNotKnowEndDate = false.obs;

  final RxList<dynamic> _images = <dynamic>[].obs;

  // Reactive variables
  final Rx<TextEditingController> _nameController = TextEditingController().obs;
  final Rx<TextEditingController> _descriptionController =
      TextEditingController().obs;
  final Rx<TextEditingController> _locationController =
      TextEditingController().obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final ImagePicker _imagePicker = ImagePicker();

  // Getters
  TextEditingController get nameController => _nameController.value;
  TextEditingController get descriptionController =>
      _descriptionController.value;
  TextEditingController get locationController => _locationController.value;
  GlobalKey<FormState> get formKey => _formKey.value;
  ImagePicker get imagePicker => _imagePicker;

  double? get selectedLat => _selectedLat.value;
  double? get selectedLng => _selectedLng.value;

  bool get isHidden => _isHidden.value;
  bool get isLoading => _isLoading.value;

  EventPriority? get selectedPriority => _selectedPriority.value;

  DateTime? get startDate => _startDate.value;
  DateTime? get endDate => _endDate.value;

  bool get userDoesNotKnowStartDate => _userDoesNotKnowStartDate.value;
  bool get userDoesNotKnowEndDate => _userDoesNotKnowEndDate.value;

  List get images => _images;

  // Setters
  set selectedLat(double? value) => _selectedLat.value = value;
  set selectedLng(double? value) => _selectedLng.value = value;

  set isHidden(bool value) => _isHidden.value = value;
  set isLoading(bool value) => _isLoading.value = value;

  set selectedPriority(EventPriority? value) => _selectedPriority.value = value;

  set startDate(DateTime? value) => _startDate.value = value;
  set endDate(DateTime? value) => _endDate.value = value;

  set userDoesNotKnowStartDate(bool value) =>
      _userDoesNotKnowStartDate.value = value;
  set userDoesNotKnowEndDate(bool value) =>
      _userDoesNotKnowEndDate.value = value;

  set images(List value) => _images.value = value;

  set nameController(TextEditingController value) =>
      _nameController.value = value;
  set descriptionController(TextEditingController value) =>
      _descriptionController.value = value;
  set locationController(TextEditingController value) =>
      _locationController.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  void removeImage(int index) {
    _images.removeAt(index);
    _images.refresh();
  }

  setUpData(Event? event) {
    selectedLat = event?.lat ?? -1;
    selectedLng = event?.lng ?? -1;
    selectedPriority = event?.priority;
    startDate = event?.startDate == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(event?.startDate ?? 0);
    endDate = event?.endDate == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(event?.endDate ?? 0);

    // if event is null then this is a create event setup and the value should be a default fo false else check if the previously uploaded data have dates.
    userDoesNotKnowStartDate = event == null ? false : event.startDate == null;
    userDoesNotKnowEndDate = event == null ? false : event.endDate == null;

    nameController.text = event?.name ?? '';
    descriptionController.text = event?.description ?? '';
    locationController.text = event?.location ?? '';

    _images.clear();
    _images.addAll(event?.images ?? []);
    _images.refresh();
  }

  Future<void> uploadEventToServer(String? eventId) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return Future.error('Kindly fill all fields');
    }
    if (isLoading) {
      return Future.error('Kindly wait till the current operation is complete');
    }

    if (selectedPriority == null) {
      return Future.error('Kindly select the event priority.');
    }

    if (startDate == null && !userDoesNotKnowStartDate) {
      return Future.error('Kindly select the start date of the event.');
    }
    if (endDate == null && !userDoesNotKnowEndDate) {
      return Future.error('Kindly select the end date of the event.');
    }
    if (images.isEmpty) {
      return Future.error('Kindly select an image.');
    }

    if (startDate != null &&
        endDate != null &&
        !userDoesNotKnowStartDate &&
        !userDoesNotKnowEndDate &&
        startDate!.millisecondsSinceEpoch > endDate!.millisecondsSinceEpoch) {
      return Future.error(
          'The start date can not be greater than the end date.');
    }

    formKey.currentState?.save();

    isLoading = true;

    try {
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final location = locationController.text.trim();

      List<String> imageUrls = await getImageUrls();

      if (eventId != null) {
        await eventService.editEvent(
          eventId: eventId,
          name: name,
          description: description,
          location: location,
          priority: selectedPriority?.name ?? '',
          lat: selectedLat,
          lng: selectedLng,
          startDate: userDoesNotKnowStartDate
              ? null
              : startDate!.millisecondsSinceEpoch,
          endDate:
              userDoesNotKnowEndDate ? null : endDate!.millisecondsSinceEpoch,
          images: imageUrls,
        );
      } else {
        await eventService.createEvent(
          name: name,
          description: description,
          location: location,
          priority: selectedPriority?.name ?? '',
          lat: selectedLat,
          lng: selectedLng,
          startDate: userDoesNotKnowStartDate
              ? null
              : startDate!.millisecondsSinceEpoch,
          endDate:
              userDoesNotKnowEndDate ? null : endDate!.millisecondsSinceEpoch,
          images: imageUrls,
        );
      }
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception.toString());
    }
  }

  Future<List<String>> getImageUrls() async {
    final randomId = FirebaseFirestore.instance.collection('id').doc().id;

    //exisiting image urls.
    List<String> imageUrls = images
        .whereType<String>()
        .map(
          (e) => e.toString(),
        )
        .toList();

    final newImages = images.whereType<File>().map((e) => e.path).toList();
    if (newImages.isNotEmpty) {
      final list = await eventService.uploadEventImages(
        randomId,
        newImages,
      );
      imageUrls.addAll(list);
    }
    return imageUrls;
  }

  selectImages() async {
    try {
      final files = await _imagePicker.pickMultiImage();

      if (files.isNotEmpty) {
        for (final file in files) {
          final f = File(file.path);
          _images.add(f);
        }
        _images.refresh();
      }
    } catch (exception) {
      return Future.error(exception);
    }
  }

  decodeAddress() async {
    try {
      final address = locationController.text.trim();
      final geocoding = GoogleMapsGeocoding(apiKey: dotenv.env['mapKey'] ?? '');
      final response = await geocoding.searchByAddress(address);
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        return;
      }

      final location = response.results.firstOrNull?.geometry.location;

      if (location != null) {
        selectedLat = location.lat;
        selectedLng = location.lng;
      }
    } catch (_) {}
  }
}
