import 'package:flipper_models/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCountryProvider = StateProvider<String?>((ref) => null);

class CountryOfOriginSelector extends ConsumerWidget {
  final void Function(Country)? onCountrySelected;
  final TextEditingController controller;

  const CountryOfOriginSelector({
    Key? key,
    this.onCountrySelected,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsyncValue = ref.watch(countriesProvider);
    final selectedCountryCode = ref.watch(selectedCountryProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: countriesAsyncValue.when(
          data: (countries) {
            // Remove duplicates by country code
            final uniqueCountries = <String, Country>{};
            for (var country in countries) {
              if (!uniqueCountries.containsKey(country.code)) {
                uniqueCountries[country.code] = country;
              }
            }
            final uniqueCountriesList = uniqueCountries.values.toList();

            // Select first item if nothing is selected
            if (selectedCountryCode == null && uniqueCountriesList.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final firstCountry = uniqueCountriesList.first;
                if (onCountrySelected != null) {
                  onCountrySelected!(firstCountry);
                }
                controller.text = firstCountry.code;
                ref.read(selectedCountryProvider.notifier).state =
                    firstCountry.code;
              });
            }

            return DropdownButton<String>(
              value:
                  selectedCountryCode ??
                  (uniqueCountriesList.isNotEmpty
                      ? uniqueCountriesList.first.code
                      : null),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  final selectedCountry = uniqueCountriesList.firstWhere(
                    (country) => country.code == newValue,
                  );
                  if (onCountrySelected != null) {
                    onCountrySelected!(selectedCountry);
                  }
                  controller.text = newValue;
                  ref.read(selectedCountryProvider.notifier).state = newValue;
                }
              },
              items: uniqueCountriesList.map((country) {
                return DropdownMenuItem<String>(
                  value: country.code,
                  child: Text(
                    '${country.name} (${country.code})',
                  ), // Show both name and code
                );
              }).toList(),
              isExpanded: true,
              underline: const SizedBox(),
              hint: const Text("Select Country of Origin"),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => const Text("Failed to load countries"),
        ),
      ),
    );
  }
}
