import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/entities.dart';

class SchoolPicker extends StatelessWidget {
  const SchoolPicker({
    super.key,
    required this.schools,
    required this.value,
    required this.onChanged,
    this.required = true,
  });

  final List<School> schools;
  final int? value;
  final ValueChanged<int?> onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Établissement',
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.orangeSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.school_outlined,
            color: AppColors.orange,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.navy.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.navy),
      borderRadius: BorderRadius.circular(16),
      dropdownColor: Colors.white,
      items: [
        for (final s in schools)
          DropdownMenuItem(
            value: s.id!,
            child: Text(
              s.name,
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
      validator: (v) =>
          required && v == null ? 'Choisissez un établissement' : null,
      onChanged: onChanged,
    );
  }
}
