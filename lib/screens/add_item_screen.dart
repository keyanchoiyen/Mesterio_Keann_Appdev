import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/item.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({
    super.key,
    this.initialType = 'Lost',
    this.item,
    this.onSave,
  });
  final String initialType;
  final Item? item;
  final Future<void> Function(Item)? onSave;
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _location;
  late final TextEditingController _date;
  late String _type;
  String? _imagePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.item?.itemName);
    _description = TextEditingController(text: widget.item?.description);
    _location = TextEditingController(text: widget.item?.location);
    _date = TextEditingController(
      text: widget.item?.date ?? 'November 2, 2026',
    );
    _type = widget.item?.type ?? widget.initialType;
    _imagePath = widget.item?.imagePath;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _location.dispose();
    _date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Report an Item' : 'Edit Item'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              _buildPhotoPicker(),
              const SizedBox(height: 18),
              _Field(
                label: 'Item Name',
                controller: _name,
                hint: 'e.g. Black wallet',
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'Description',
                controller: _description,
                hint: 'Describe the item',
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'Location',
                controller: _location,
                hint: 'e.g. Library, Building A',
              ),
              const SizedBox(height: 14),
              _DateField(controller: _date),
              const SizedBox(height: 14),
              const Text('Type', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Lost',
                    label: Text('Lost'),
                    icon: Icon(Icons.search_off),
                  ),
                  ButtonSegment(
                    value: 'Found',
                    label: Text('Found'),
                    icon: Icon(Icons.check_circle_outline),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (value) =>
                    setState(() => _type = value.first),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Save',
                icon: Icons.save_outlined,
                onPressed: _save,
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  foregroundColor: AppTheme.darkText,
                  side: const BorderSide(color: AppTheme.yellow),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    final hasSelectedFile =
        _imagePath != null && File(_imagePath!).existsSync();

    return InkWell(
      onTap: _pickPhoto,
      child: Container(
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppTheme.lightYellow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.yellow.withValues(alpha: .6)),
        ),
        child: hasSelectedFile
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(_imagePath!), fit: BoxFit.cover),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: IconButton.filledTonal(
                      onPressed: () => setState(() => _imagePath = null),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 42,
                    color: AppTheme.primaryOrange,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add Item Photo',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;

      final documents = await getApplicationDocumentsDirectory();
      final photoDirectory = Directory(p.join(documents.path, 'item_photos'));
      if (!await photoDirectory.exists()) {
        await photoDirectory.create(recursive: true);
      }

      final extension = p.extension(picked.path);
      final fileName =
          'item_${DateTime.now().millisecondsSinceEpoch}$extension';
      final savedPath = p.join(photoDirectory.path, fileName);
      await File(picked.path).copy(savedPath);

      if (!mounted) return;
      setState(() => _imagePath = savedPath);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not select the photo.')),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);
    final item = Item(
      id: widget.item?.id,
      itemName: _name.text.trim(),
      description: _description.text.trim(),
      location: _location.text.trim(),
      date: _date.text.trim(),
      type: _type,
      imagePath: _imagePath,
      status: widget.item?.status ?? 'Pending',
    );

    final oldImagePath = widget.item?.imagePath;
    try {
      await widget.onSave?.call(item);
      if (oldImagePath != null && oldImagePath != _imagePath) {
        final oldFile = File(oldImagePath);
        if (await oldFile.exists()) await oldFile.delete();
      }
      if (!mounted) return;
      Navigator.of(context).maybePop();
    } catch (_) {
      if (!mounted) return;
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Date', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) => value == null || value.trim().isEmpty
            ? 'This field is required'
            : null,
        decoration: const InputDecoration(
          hintText: 'Select date',
          suffixIcon: Icon(Icons.calendar_today_outlined),
        ),
        onTap: () async {
          final selected = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (selected != null) {
            const months = [
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December',
            ];
            controller.text =
                '${months[selected.month - 1]} ${selected.day}, ${selected.year}';
          }
        },
      ),
    ],
  );
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });
  final String label, hint;
  final TextEditingController controller;
  final int maxLines;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) => value == null || value.trim().isEmpty
            ? 'This field is required'
            : null,
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );
}
