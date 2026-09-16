/// Every country signup accepts, with the dial code its phone numbers carry and
/// the currency a business registered there keeps its books in.
///
/// Signup used to offer a handful of hardcoded countries (web listed five, the
/// mobile form three) and defaulted anything it did not recognize to Rwanda's
/// `+250`. Flipper takes signups worldwide now, so both forms read this one
/// table instead of keeping their own.
///
/// Deliberately a plain `const` list with no imports: the web signup form, the
/// mobile form bloc and their pure-Dart unit tests all share it.
library;

class SignupCountry {
  const SignupCountry(this.name, this.iso2, this.dialCode, this.currency);

  /// Display name, as it is stored on the business record.
  final String name;

  /// ISO 3166-1 alpha-2 code.
  final String iso2;

  /// E.164 country calling code, `+` included.
  final String dialCode;

  /// ISO 4217 code of the country's currency.
  final String currency;
}

/// The country a form starts on, and the fallback for a name this table does
/// not know (a business row written before the list went worldwide).
const String kDefaultSignupCountry = 'Rwanda';
const String kDefaultSignupDialCode = '+250';
const String kDefaultSignupCurrency = 'RWF';

/// Alphabetical, so a picker can show it as-is.
const List<SignupCountry> kSignupCountries = [
  SignupCountry('Afghanistan', 'AF', '+93', 'AFN'),
  SignupCountry('Albania', 'AL', '+355', 'ALL'),
  SignupCountry('Algeria', 'DZ', '+213', 'DZD'),
  SignupCountry('American Samoa', 'AS', '+1684', 'USD'),
  SignupCountry('Andorra', 'AD', '+376', 'EUR'),
  SignupCountry('Angola', 'AO', '+244', 'AOA'),
  SignupCountry('Anguilla', 'AI', '+1264', 'XCD'),
  SignupCountry('Antigua and Barbuda', 'AG', '+1268', 'XCD'),
  SignupCountry('Argentina', 'AR', '+54', 'ARS'),
  SignupCountry('Armenia', 'AM', '+374', 'AMD'),
  SignupCountry('Aruba', 'AW', '+297', 'AWG'),
  SignupCountry('Australia', 'AU', '+61', 'AUD'),
  SignupCountry('Austria', 'AT', '+43', 'EUR'),
  SignupCountry('Azerbaijan', 'AZ', '+994', 'AZN'),
  SignupCountry('Bahamas', 'BS', '+1242', 'BSD'),
  SignupCountry('Bahrain', 'BH', '+973', 'BHD'),
  SignupCountry('Bangladesh', 'BD', '+880', 'BDT'),
  SignupCountry('Barbados', 'BB', '+1246', 'BBD'),
  SignupCountry('Belarus', 'BY', '+375', 'BYN'),
  SignupCountry('Belgium', 'BE', '+32', 'EUR'),
  SignupCountry('Belize', 'BZ', '+501', 'BZD'),
  SignupCountry('Benin', 'BJ', '+229', 'XOF'),
  SignupCountry('Bermuda', 'BM', '+1441', 'BMD'),
  SignupCountry('Bhutan', 'BT', '+975', 'BTN'),
  SignupCountry('Bolivia', 'BO', '+591', 'BOB'),
  SignupCountry('Bosnia and Herzegovina', 'BA', '+387', 'BAM'),
  SignupCountry('Botswana', 'BW', '+267', 'BWP'),
  SignupCountry('Brazil', 'BR', '+55', 'BRL'),
  SignupCountry('British Virgin Islands', 'VG', '+1284', 'USD'),
  SignupCountry('Brunei', 'BN', '+673', 'BND'),
  SignupCountry('Bulgaria', 'BG', '+359', 'BGN'),
  SignupCountry('Burkina Faso', 'BF', '+226', 'XOF'),
  SignupCountry('Burundi', 'BI', '+257', 'BIF'),
  SignupCountry('Cambodia', 'KH', '+855', 'KHR'),
  SignupCountry('Cameroon', 'CM', '+237', 'XAF'),
  SignupCountry('Canada', 'CA', '+1', 'CAD'),
  SignupCountry('Cape Verde', 'CV', '+238', 'CVE'),
  SignupCountry('Cayman Islands', 'KY', '+1345', 'KYD'),
  SignupCountry('Central African Republic', 'CF', '+236', 'XAF'),
  SignupCountry('Chad', 'TD', '+235', 'XAF'),
  SignupCountry('Chile', 'CL', '+56', 'CLP'),
  SignupCountry('China', 'CN', '+86', 'CNY'),
  SignupCountry('Colombia', 'CO', '+57', 'COP'),
  SignupCountry('Comoros', 'KM', '+269', 'KMF'),
  SignupCountry('Congo - Brazzaville', 'CG', '+242', 'XAF'),
  SignupCountry('Congo - Kinshasa', 'CD', '+243', 'CDF'),
  SignupCountry('Cook Islands', 'CK', '+682', 'NZD'),
  SignupCountry('Costa Rica', 'CR', '+506', 'CRC'),
  SignupCountry("Côte d'Ivoire", 'CI', '+225', 'XOF'),
  SignupCountry('Croatia', 'HR', '+385', 'EUR'),
  SignupCountry('Cuba', 'CU', '+53', 'CUP'),
  SignupCountry('Curaçao', 'CW', '+599', 'ANG'),
  SignupCountry('Cyprus', 'CY', '+357', 'EUR'),
  SignupCountry('Czechia', 'CZ', '+420', 'CZK'),
  SignupCountry('Denmark', 'DK', '+45', 'DKK'),
  SignupCountry('Djibouti', 'DJ', '+253', 'DJF'),
  SignupCountry('Dominica', 'DM', '+1767', 'XCD'),
  SignupCountry('Dominican Republic', 'DO', '+1809', 'DOP'),
  SignupCountry('Ecuador', 'EC', '+593', 'USD'),
  SignupCountry('Egypt', 'EG', '+20', 'EGP'),
  SignupCountry('El Salvador', 'SV', '+503', 'USD'),
  SignupCountry('Equatorial Guinea', 'GQ', '+240', 'XAF'),
  SignupCountry('Eritrea', 'ER', '+291', 'ERN'),
  SignupCountry('Estonia', 'EE', '+372', 'EUR'),
  SignupCountry('Eswatini', 'SZ', '+268', 'SZL'),
  SignupCountry('Ethiopia', 'ET', '+251', 'ETB'),
  SignupCountry('Falkland Islands', 'FK', '+500', 'FKP'),
  SignupCountry('Faroe Islands', 'FO', '+298', 'DKK'),
  SignupCountry('Fiji', 'FJ', '+679', 'FJD'),
  SignupCountry('Finland', 'FI', '+358', 'EUR'),
  SignupCountry('France', 'FR', '+33', 'EUR'),
  SignupCountry('French Guiana', 'GF', '+594', 'EUR'),
  SignupCountry('French Polynesia', 'PF', '+689', 'XPF'),
  SignupCountry('Gabon', 'GA', '+241', 'XAF'),
  SignupCountry('Gambia', 'GM', '+220', 'GMD'),
  SignupCountry('Georgia', 'GE', '+995', 'GEL'),
  SignupCountry('Germany', 'DE', '+49', 'EUR'),
  SignupCountry('Ghana', 'GH', '+233', 'GHS'),
  SignupCountry('Gibraltar', 'GI', '+350', 'GIP'),
  SignupCountry('Greece', 'GR', '+30', 'EUR'),
  SignupCountry('Greenland', 'GL', '+299', 'DKK'),
  SignupCountry('Grenada', 'GD', '+1473', 'XCD'),
  SignupCountry('Guadeloupe', 'GP', '+590', 'EUR'),
  SignupCountry('Guam', 'GU', '+1671', 'USD'),
  SignupCountry('Guatemala', 'GT', '+502', 'GTQ'),
  SignupCountry('Guernsey', 'GG', '+44', 'GBP'),
  SignupCountry('Guinea', 'GN', '+224', 'GNF'),
  SignupCountry('Guinea-Bissau', 'GW', '+245', 'XOF'),
  SignupCountry('Guyana', 'GY', '+592', 'GYD'),
  SignupCountry('Haiti', 'HT', '+509', 'HTG'),
  SignupCountry('Honduras', 'HN', '+504', 'HNL'),
  SignupCountry('Hong Kong SAR China', 'HK', '+852', 'HKD'),
  SignupCountry('Hungary', 'HU', '+36', 'HUF'),
  SignupCountry('Iceland', 'IS', '+354', 'ISK'),
  SignupCountry('India', 'IN', '+91', 'INR'),
  SignupCountry('Indonesia', 'ID', '+62', 'IDR'),
  SignupCountry('Iran', 'IR', '+98', 'IRR'),
  SignupCountry('Iraq', 'IQ', '+964', 'IQD'),
  SignupCountry('Ireland', 'IE', '+353', 'EUR'),
  SignupCountry('Isle of Man', 'IM', '+44', 'GBP'),
  SignupCountry('Israel', 'IL', '+972', 'ILS'),
  SignupCountry('Italy', 'IT', '+39', 'EUR'),
  SignupCountry('Jamaica', 'JM', '+1876', 'JMD'),
  SignupCountry('Japan', 'JP', '+81', 'JPY'),
  SignupCountry('Jersey', 'JE', '+44', 'GBP'),
  SignupCountry('Jordan', 'JO', '+962', 'JOD'),
  SignupCountry('Kazakhstan', 'KZ', '+7', 'KZT'),
  SignupCountry('Kenya', 'KE', '+254', 'KES'),
  SignupCountry('Kiribati', 'KI', '+686', 'AUD'),
  SignupCountry('Kosovo', 'XK', '+383', 'EUR'),
  SignupCountry('Kuwait', 'KW', '+965', 'KWD'),
  SignupCountry('Kyrgyzstan', 'KG', '+996', 'KGS'),
  SignupCountry('Laos', 'LA', '+856', 'LAK'),
  SignupCountry('Latvia', 'LV', '+371', 'EUR'),
  SignupCountry('Lebanon', 'LB', '+961', 'LBP'),
  SignupCountry('Lesotho', 'LS', '+266', 'LSL'),
  SignupCountry('Liberia', 'LR', '+231', 'LRD'),
  SignupCountry('Libya', 'LY', '+218', 'LYD'),
  SignupCountry('Liechtenstein', 'LI', '+423', 'CHF'),
  SignupCountry('Lithuania', 'LT', '+370', 'EUR'),
  SignupCountry('Luxembourg', 'LU', '+352', 'EUR'),
  SignupCountry('Macao SAR China', 'MO', '+853', 'MOP'),
  SignupCountry('Madagascar', 'MG', '+261', 'MGA'),
  SignupCountry('Malawi', 'MW', '+265', 'MWK'),
  SignupCountry('Malaysia', 'MY', '+60', 'MYR'),
  SignupCountry('Maldives', 'MV', '+960', 'MVR'),
  SignupCountry('Mali', 'ML', '+223', 'XOF'),
  SignupCountry('Malta', 'MT', '+356', 'EUR'),
  SignupCountry('Marshall Islands', 'MH', '+692', 'USD'),
  SignupCountry('Martinique', 'MQ', '+596', 'EUR'),
  SignupCountry('Mauritania', 'MR', '+222', 'MRU'),
  SignupCountry('Mauritius', 'MU', '+230', 'MUR'),
  SignupCountry('Mayotte', 'YT', '+262', 'EUR'),
  SignupCountry('Mexico', 'MX', '+52', 'MXN'),
  SignupCountry('Micronesia', 'FM', '+691', 'USD'),
  SignupCountry('Moldova', 'MD', '+373', 'MDL'),
  SignupCountry('Monaco', 'MC', '+377', 'EUR'),
  SignupCountry('Mongolia', 'MN', '+976', 'MNT'),
  SignupCountry('Montenegro', 'ME', '+382', 'EUR'),
  SignupCountry('Montserrat', 'MS', '+1664', 'XCD'),
  SignupCountry('Morocco', 'MA', '+212', 'MAD'),
  SignupCountry('Mozambique', 'MZ', '+258', 'MZN'),
  SignupCountry('Myanmar (Burma)', 'MM', '+95', 'MMK'),
  SignupCountry('Namibia', 'NA', '+264', 'NAD'),
  SignupCountry('Nauru', 'NR', '+674', 'AUD'),
  SignupCountry('Nepal', 'NP', '+977', 'NPR'),
  SignupCountry('Netherlands', 'NL', '+31', 'EUR'),
  SignupCountry('New Caledonia', 'NC', '+687', 'XPF'),
  SignupCountry('New Zealand', 'NZ', '+64', 'NZD'),
  SignupCountry('Nicaragua', 'NI', '+505', 'NIO'),
  SignupCountry('Niger', 'NE', '+227', 'XOF'),
  SignupCountry('Nigeria', 'NG', '+234', 'NGN'),
  SignupCountry('North Korea', 'KP', '+850', 'KPW'),
  SignupCountry('North Macedonia', 'MK', '+389', 'MKD'),
  SignupCountry('Northern Mariana Islands', 'MP', '+1670', 'USD'),
  SignupCountry('Norway', 'NO', '+47', 'NOK'),
  SignupCountry('Oman', 'OM', '+968', 'OMR'),
  SignupCountry('Pakistan', 'PK', '+92', 'PKR'),
  SignupCountry('Palau', 'PW', '+680', 'USD'),
  SignupCountry('Palestinian Territories', 'PS', '+970', 'ILS'),
  SignupCountry('Panama', 'PA', '+507', 'PAB'),
  SignupCountry('Papua New Guinea', 'PG', '+675', 'PGK'),
  SignupCountry('Paraguay', 'PY', '+595', 'PYG'),
  SignupCountry('Peru', 'PE', '+51', 'PEN'),
  SignupCountry('Philippines', 'PH', '+63', 'PHP'),
  SignupCountry('Poland', 'PL', '+48', 'PLN'),
  SignupCountry('Portugal', 'PT', '+351', 'EUR'),
  SignupCountry('Puerto Rico', 'PR', '+1787', 'USD'),
  SignupCountry('Qatar', 'QA', '+974', 'QAR'),
  SignupCountry('Réunion', 'RE', '+262', 'EUR'),
  SignupCountry('Romania', 'RO', '+40', 'RON'),
  SignupCountry('Russia', 'RU', '+7', 'RUB'),
  SignupCountry('Rwanda', 'RW', '+250', 'RWF'),
  SignupCountry('Samoa', 'WS', '+685', 'WST'),
  SignupCountry('San Marino', 'SM', '+378', 'EUR'),
  SignupCountry('São Tomé and Príncipe', 'ST', '+239', 'STN'),
  SignupCountry('Saudi Arabia', 'SA', '+966', 'SAR'),
  SignupCountry('Senegal', 'SN', '+221', 'XOF'),
  SignupCountry('Serbia', 'RS', '+381', 'RSD'),
  SignupCountry('Seychelles', 'SC', '+248', 'SCR'),
  SignupCountry('Sierra Leone', 'SL', '+232', 'SLE'),
  SignupCountry('Singapore', 'SG', '+65', 'SGD'),
  SignupCountry('Sint Maarten', 'SX', '+1721', 'ANG'),
  SignupCountry('Slovakia', 'SK', '+421', 'EUR'),
  SignupCountry('Slovenia', 'SI', '+386', 'EUR'),
  SignupCountry('Solomon Islands', 'SB', '+677', 'SBD'),
  SignupCountry('Somalia', 'SO', '+252', 'SOS'),
  SignupCountry('South Africa', 'ZA', '+27', 'ZAR'),
  SignupCountry('South Korea', 'KR', '+82', 'KRW'),
  SignupCountry('South Sudan', 'SS', '+211', 'SSP'),
  SignupCountry('Spain', 'ES', '+34', 'EUR'),
  SignupCountry('Sri Lanka', 'LK', '+94', 'LKR'),
  SignupCountry('St. Kitts and Nevis', 'KN', '+1869', 'XCD'),
  SignupCountry('St. Lucia', 'LC', '+1758', 'XCD'),
  SignupCountry('St. Vincent and Grenadines', 'VC', '+1784', 'XCD'),
  SignupCountry('Sudan', 'SD', '+249', 'SDG'),
  SignupCountry('Suriname', 'SR', '+597', 'SRD'),
  SignupCountry('Sweden', 'SE', '+46', 'SEK'),
  SignupCountry('Switzerland', 'CH', '+41', 'CHF'),
  SignupCountry('Syria', 'SY', '+963', 'SYP'),
  SignupCountry('Taiwan', 'TW', '+886', 'TWD'),
  SignupCountry('Tajikistan', 'TJ', '+992', 'TJS'),
  SignupCountry('Tanzania', 'TZ', '+255', 'TZS'),
  SignupCountry('Thailand', 'TH', '+66', 'THB'),
  SignupCountry('Timor-Leste', 'TL', '+670', 'USD'),
  SignupCountry('Togo', 'TG', '+228', 'XOF'),
  SignupCountry('Tonga', 'TO', '+676', 'TOP'),
  SignupCountry('Trinidad and Tobago', 'TT', '+1868', 'TTD'),
  SignupCountry('Tunisia', 'TN', '+216', 'TND'),
  SignupCountry('Türkiye', 'TR', '+90', 'TRY'),
  SignupCountry('Turkmenistan', 'TM', '+993', 'TMT'),
  SignupCountry('Turks and Caicos Islands', 'TC', '+1649', 'USD'),
  SignupCountry('Tuvalu', 'TV', '+688', 'AUD'),
  SignupCountry('U.S. Virgin Islands', 'VI', '+1340', 'USD'),
  SignupCountry('Uganda', 'UG', '+256', 'UGX'),
  SignupCountry('Ukraine', 'UA', '+380', 'UAH'),
  SignupCountry('United Arab Emirates', 'AE', '+971', 'AED'),
  SignupCountry('United Kingdom', 'GB', '+44', 'GBP'),
  SignupCountry('United States', 'US', '+1', 'USD'),
  SignupCountry('Uruguay', 'UY', '+598', 'UYU'),
  SignupCountry('Uzbekistan', 'UZ', '+998', 'UZS'),
  SignupCountry('Vanuatu', 'VU', '+678', 'VUV'),
  SignupCountry('Vatican City', 'VA', '+379', 'EUR'),
  SignupCountry('Venezuela', 'VE', '+58', 'VES'),
  SignupCountry('Vietnam', 'VN', '+84', 'VND'),
  SignupCountry('Yemen', 'YE', '+967', 'YER'),
  SignupCountry('Zambia', 'ZM', '+260', 'ZMW'),
  SignupCountry('Zimbabwe', 'ZW', '+263', 'ZWG'),
];

/// Country names in the order a picker should show them.
final List<String> kSignupCountryNames = List.unmodifiable(
  kSignupCountries.map((c) => c.name),
);

final Map<String, SignupCountry> _byName = Map.unmodifiable({
  for (final country in kSignupCountries) country.name: country,
});

final Map<String, SignupCountry> _byLowerName = Map.unmodifiable({
  for (final country in kSignupCountries) country.name.toLowerCase(): country,
});

final Map<String, SignupCountry> _byIso2 = Map.unmodifiable({
  for (final country in kSignupCountries) country.iso2: country,
});

/// Names that were already stored on customer and business rows before this
/// table existed, mapped to the spelling it uses. `DRC` came off a hand-written
/// dial-code map in the checkout path, so dropping it would have started
/// dialling those customers as Rwandan.
const Map<String, String> _nameAliases = {
  'congo': 'Congo - Kinshasa',
  'drc': 'Congo - Kinshasa',
  'democratic republic of congo': 'Congo - Kinshasa',
  'democratic republic of the congo': 'Congo - Kinshasa',
  'republic of the congo': 'Congo - Brazzaville',
  'ivory coast': "Côte d'Ivoire",
  'cote d ivoire': "Côte d'Ivoire",
  "cote d'ivoire": "Côte d'Ivoire",
  'burma': 'Myanmar (Burma)',
  'myanmar': 'Myanmar (Burma)',
  'turkey': 'Türkiye',
  'turkiye': 'Türkiye',
  'czech republic': 'Czechia',
  'cabo verde': 'Cape Verde',
  'swaziland': 'Eswatini',
  'macedonia': 'North Macedonia',
  'holy see': 'Vatican City',
  'east timor': 'Timor-Leste',
  'hong kong': 'Hong Kong SAR China',
  'macao': 'Macao SAR China',
  'macau': 'Macao SAR China',
  'palestine': 'Palestinian Territories',
  'south africa (rsa)': 'South Africa',
  'korea': 'South Korea',
  'republic of korea': 'South Korea',
  'usa': 'United States',
  'u.s.a.': 'United States',
  'united states of america': 'United States',
  'uk': 'United Kingdom',
  'great britain': 'United Kingdom',
  'uae': 'United Arab Emirates',
  'russia federation': 'Russia',
  'russian federation': 'Russia',
  'saint kitts and nevis': 'St. Kitts and Nevis',
  'saint lucia': 'St. Lucia',
  'saint vincent and the grenadines': 'St. Vincent and Grenadines',
  'sao tome and principe': 'São Tomé and Príncipe',
  'reunion': 'Réunion',
  'curacao': 'Curaçao',
  'laos pdr': 'Laos',
  'vietnam (viet nam)': 'Vietnam',
};

/// The entry for [name], or null when the table does not know it. Matching is
/// case-insensitive so a stored `RWANDA` still resolves.
SignupCountry? signupCountryByName(String? name) {
  if (name == null) return null;
  final trimmed = name.trim();
  if (trimmed.isEmpty) return null;
  final exact = _byName[trimmed];
  if (exact != null) return exact;
  final lower = trimmed.toLowerCase();
  final aliased = _nameAliases[lower];
  if (aliased != null) return _byName[aliased];
  final byName = _byLowerName[lower];
  if (byName != null) return byName;
  // Some rows store the ISO code rather than the name ('RW', not 'Rwanda').
  return trimmed.length == 2 ? _byIso2[trimmed.toUpperCase()] : null;
}

SignupCountry? signupCountryByIso2(String? iso2) =>
    iso2 == null ? null : _byIso2[iso2.trim().toUpperCase()];

/// Dial code for [country], falling back to Rwanda's for an unknown name so an
/// older business row never leaves a phone field without a prefix.
String signupDialCodeFor(String? country) =>
    signupCountryByName(country)?.dialCode ?? kDefaultSignupDialCode;

/// ISO 4217 currency for [country]. Businesses were all booked in RWF before
/// signup went worldwide, which is also the fallback for an unknown name.
String signupCurrencyFor(String? country) =>
    signupCountryByName(country)?.currency ?? kDefaultSignupCurrency;

/// Distinct dial codes, longest first.
///
/// Order matters: `+1` and `+1268` are both in the table, so a shortest-match
/// scan would strip `+1` off an Antiguan number and leave `268…` behind as the
/// local part.
final List<String> kSignupDialCodesLongestFirst = List.unmodifiable(
  kSignupCountries.map((c) => c.dialCode).toSet().toList()
    ..sort((a, b) => b.length.compareTo(a.length)),
);

/// The dial code [value] starts with, or null. [value] is expected to already
/// carry a leading `+` — a bare national number has no code to find.
String? matchLeadingDialCode(String value) {
  for (final code in kSignupDialCodesLongestFirst) {
    if (value.startsWith(code)) return code;
  }
  return null;
}

/// E.164 caps a full international number at 15 digits, and the shortest
/// national numbers still in service are four. Signup used to check a phone
/// number against a per-country length table (`[9]` digits for Rwanda, Zambia
/// and Mozambique); with every country on the list that table cannot be kept
/// up, so numbers are checked against this range instead.
const int kMinNationalNumberDigits = 4;
const int kMaxE164Digits = 15;

/// Whether [raw] can be dialled as a phone number for [country].
///
/// [raw] may be a national number (`078 305 4874`) or already carry a dial code
/// (`+250783054874`); separators are ignored either way. A number written with
/// a `+` has to start with a dial code this table knows.
bool isPlausiblePhoneNumber(String raw, {String? country}) {
  final cleaned = raw.replaceAll(RegExp(r'[^0-9+]'), '');
  if (cleaned.isEmpty) return false;

  final String dialCode;
  final String national;
  if (cleaned.startsWith('+')) {
    final matched = matchLeadingDialCode(cleaned);
    if (matched == null) return false;
    dialCode = matched;
    national = cleaned.substring(matched.length);
  } else {
    dialCode = signupDialCodeFor(country);
    // A national number is commonly written with a trunk `0` the international
    // form drops.
    national = cleaned.startsWith('0') ? cleaned.substring(1) : cleaned;
  }

  if (national.contains('+')) return false;
  if (national.length < kMinNationalNumberDigits) return false;
  return dialCode.length - 1 + national.length <= kMaxE164Digits;
}
