import 'package:flutter/material.dart';

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
      decoration: const InputDecoration(
        labelText: 'Établissement',
        prefixIcon: Icon(Icons.school_outlined),
      ),
      items: [
        for (final s in schools)
          DropdownMenuItem(value: s.id!, child: Text(s.name)),
      ],
      validator: (v) =>
          required && v == null ? 'Choisissez un établissement' : null,
      onChanged: onChanged,
    );
  }
}
