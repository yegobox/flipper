/// Local + remote shape for a Services hub provider profile.
class ServiceGigProvider {
  final String userId;
  final String? businessId;
  final String? branchId;
  final String displayName;
  final String bio;
  final List<String> services;
  /// Catalog ids (e.g. home_services) for browse filters.
  final List<String> serviceCategories;
  final String? serviceArea;
  final String? phone;
  final String? email;
  final String? profileImageUrl;
  final String? coverImageUrl;
  
  /// Pricing information
  final int? basePriceRwf;
  final String? pricingNotes;
  final List<ServicePricing> servicePricing;
  
  /// Availability
  final String? availabilitySchedule;
  final bool isAvailable;
  final DateTime? nextAvailableDate;
  
  /// Ratings and reviews
  final double averageRating;
  final int totalReviews;
  final List<ProviderReview>? recentReviews;
  
  /// Verification and badges
  final bool isVerified;
  final bool isBackgroundChecked;
  final List<String> badges;
  final String? verificationBadge;
  
  /// Statistics
  final int totalJobs;
  final int completedJobs;
  final double completionRate;
  final String? responseTime;
  final DateTime? lastActiveAt;
  
  /// Portfolio
  final List<PortfolioItem> portfolio;
  
  /// Social links
  final String? websiteUrl;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? twitterUrl;
  
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceGigProvider({
    required this.userId,
    this.businessId,
    this.branchId,
    required this.displayName,
    required this.bio,
    required this.services,
    this.serviceCategories = const [],
    this.serviceArea,
    this.phone,
    this.email,
    this.profileImageUrl,
    this.coverImageUrl,
    this.basePriceRwf,
    this.pricingNotes,
    this.servicePricing = const [],
    this.availabilitySchedule,
    this.isAvailable = true,
    this.nextAvailableDate,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.recentReviews,
    this.isVerified = false,
    this.isBackgroundChecked = false,
    this.badges = const [],
    this.verificationBadge,
    this.totalJobs = 0,
    this.completedJobs = 0,
    this.completionRate = 0.0,
    this.responseTime,
    this.lastActiveAt,
    this.portfolio = const [],
    this.websiteUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'business_id': businessId,
        'branch_id': branchId,
        'display_name': displayName,
        'bio': bio,
        'services': services,
        'service_categories': serviceCategories,
        'service_area': serviceArea,
        'phone': phone,
        'email': email,
        'profile_image_url': profileImageUrl,
        'cover_image_url': coverImageUrl,
        'base_price_rwf': basePriceRwf,
        'pricing_notes': pricingNotes,
        'service_pricing': servicePricing.map((p) => p.toJson()).toList(),
        'availability_schedule': availabilitySchedule,
        'is_available': isAvailable,
        'next_available_date': nextAvailableDate?.toIso8601String(),
        'average_rating': averageRating,
        'total_reviews': totalReviews,
        'recent_reviews': recentReviews?.map((r) => r.toJson()).toList(),
        'is_verified': isVerified,
        'is_background_checked': isBackgroundChecked,
        'badges': badges,
        'verification_badge': verificationBadge,
        'total_jobs': totalJobs,
        'completed_jobs': completedJobs,
        'completion_rate': completionRate,
        'response_time': responseTime,
        'last_active_at': lastActiveAt?.toIso8601String(),
        'portfolio': portfolio.map((p) => p.toJson()).toList(),
        'website_url': websiteUrl,
        'facebook_url': facebookUrl,
        'instagram_url': instagramUrl,
        'twitter_url': twitterUrl,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };

  factory ServiceGigProvider.fromJson(Map<String, dynamic> json) {
    List<String> parseServices(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      }
      return [];
    }

    List<ServicePricing> parsePricing(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v
            .where((e) => e != null)
            .map((e) => ServicePricing.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    }

    List<ProviderReview> parseReviews(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v
            .where((e) => e != null)
            .map((e) => ProviderReview.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    }

    List<PortfolioItem> parsePortfolio(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v
            .where((e) => e != null)
            .map((e) => PortfolioItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    }

    List<String> parseBadges(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      }
      return [];
    }

    List<String> parseServiceCategories(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      }
      return [];
    }

    DateTime? parseTs(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return ServiceGigProvider(
      userId: json['user_id']?.toString() ?? '',
      businessId: json['business_id']?.toString(),
      branchId: json['branch_id']?.toString(),
      displayName: json['display_name']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      services: parseServices(json['services']),
      serviceCategories: parseServiceCategories(json['service_categories']),
      serviceArea: json['service_area']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      coverImageUrl: json['cover_image_url']?.toString(),
      basePriceRwf: json['base_price_rwf'] is int
          ? json['base_price_rwf']
          : int.tryParse(json['base_price_rwf']?.toString() ?? ''),
      pricingNotes: json['pricing_notes']?.toString(),
      servicePricing: parsePricing(json['service_pricing']),
      availabilitySchedule: json['availability_schedule']?.toString(),
      isAvailable: json['is_available'] ?? true,
      nextAvailableDate: parseTs(json['next_available_date']),
      averageRating: (json['average_rating'] is num)
          ? (json['average_rating'] as num).toDouble()
          : double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0.0,
      totalReviews: json['total_reviews'] is int
          ? json['total_reviews']
          : int.tryParse(json['total_reviews']?.toString() ?? '0') ?? 0,
      recentReviews: parseReviews(json['recent_reviews']),
      isVerified: json['is_verified'] ?? false,
      isBackgroundChecked: json['is_background_checked'] ?? false,
      badges: parseBadges(json['badges']),
      verificationBadge: json['verification_badge']?.toString(),
      totalJobs: json['total_jobs'] is int
          ? json['total_jobs']
          : int.tryParse(json['total_jobs']?.toString() ?? '0') ?? 0,
      completedJobs: json['completed_jobs'] is int
          ? json['completed_jobs']
          : int.tryParse(json['completed_jobs']?.toString() ?? '0') ?? 0,
      completionRate: (json['completion_rate'] is num)
          ? (json['completion_rate'] as num).toDouble()
          : double.tryParse(json['completion_rate']?.toString() ?? '0') ?? 0.0,
      responseTime: json['response_time']?.toString(),
      lastActiveAt: parseTs(json['last_active_at']),
      portfolio: parsePortfolio(json['portfolio']),
      websiteUrl: json['website_url']?.toString(),
      facebookUrl: json['facebook_url']?.toString(),
      instagramUrl: json['instagram_url']?.toString(),
      twitterUrl: json['twitter_url']?.toString(),
      createdAt: parseTs(json['created_at']),
      updatedAt: parseTs(json['updated_at']),
    );
  }

  ServiceGigProvider copyWith({
    String? displayName,
    String? bio,
    List<String>? services,
    List<String>? serviceCategories,
    String? serviceArea,
    String? phone,
    String? email,
    String? profileImageUrl,
    String? coverImageUrl,
    int? basePriceRwf,
    String? pricingNotes,
    List<ServicePricing>? servicePricing,
    String? availabilitySchedule,
    bool? isAvailable,
    DateTime? nextAvailableDate,
    double? averageRating,
    int? totalReviews,
    List<ProviderReview>? recentReviews,
    bool? isVerified,
    bool? isBackgroundChecked,
    List<String>? badges,
    String? verificationBadge,
    int? totalJobs,
    int? completedJobs,
    double? completionRate,
    String? responseTime,
    DateTime? lastActiveAt,
    List<PortfolioItem>? portfolio,
    String? websiteUrl,
    String? facebookUrl,
    String? instagramUrl,
    String? twitterUrl,
    DateTime? updatedAt,
  }) {
    return ServiceGigProvider(
      userId: userId,
      businessId: businessId,
      branchId: branchId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      services: services ?? this.services,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      serviceArea: serviceArea ?? this.serviceArea,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      basePriceRwf: basePriceRwf ?? this.basePriceRwf,
      pricingNotes: pricingNotes ?? this.pricingNotes,
      servicePricing: servicePricing ?? this.servicePricing,
      availabilitySchedule: availabilitySchedule ?? this.availabilitySchedule,
      isAvailable: isAvailable ?? this.isAvailable,
      nextAvailableDate: nextAvailableDate ?? this.nextAvailableDate,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      recentReviews: recentReviews ?? this.recentReviews,
      isVerified: isVerified ?? this.isVerified,
      isBackgroundChecked: isBackgroundChecked ?? this.isBackgroundChecked,
      badges: badges ?? this.badges,
      verificationBadge: verificationBadge ?? this.verificationBadge,
      totalJobs: totalJobs ?? this.totalJobs,
      completedJobs: completedJobs ?? this.completedJobs,
      completionRate: completionRate ?? this.completionRate,
      responseTime: responseTime ?? this.responseTime,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      portfolio: portfolio ?? this.portfolio,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get rating distribution (5-star, 4-star, etc.)
  Map<int, int> get ratingDistribution {
    if (recentReviews == null || recentReviews!.isEmpty) {
      return {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    }
    final distribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in recentReviews!) {
      final stars = review.rating.clamp(1, 5).toInt();
      distribution[stars] = (distribution[stars] ?? 0) + 1;
    }
    return distribution;
  }

  /// Check if provider has a specific service
  bool hasService(String serviceName) {
    final normalized = serviceName.toLowerCase().trim();
    return services.any((s) => s.toLowerCase().trim() == normalized);
  }

  /// Get formatted base price
  String get formattedBasePrice {
    if (basePriceRwf == null) return 'Negotiable';
    return '${basePriceRwf!.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} RWF';
  }

  /// Get formatted completion rate
  String get formattedCompletionRate {
    return '${(completionRate * 100).toStringAsFixed(1)}%';
  }
}

/// Pricing for a specific service offered by the provider
class ServicePricing {
  final String serviceName;
  final int priceRwf;
  final String? unit; // e.g., 'hour', 'item', 'visit'
  final String? description;

  const ServicePricing({
    required this.serviceName,
    required this.priceRwf,
    this.unit,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'service_name': serviceName,
        'price_rwf': priceRwf,
        'unit': unit,
        'description': description,
      };

  factory ServicePricing.fromJson(Map<String, dynamic> json) {
    return ServicePricing(
      serviceName: json['service_name']?.toString() ?? '',
      priceRwf: json['price_rwf'] is int
          ? json['price_rwf']
          : int.tryParse(json['price_rwf']?.toString() ?? '0') ?? 0,
      unit: json['unit']?.toString(),
      description: json['description']?.toString(),
    );
  }

  String get formattedPrice {
    return '${priceRwf.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} RWF${unit != null ? '/$unit' : ''}';
  }
}

/// Review left by a customer for a provider
class ProviderReview {
  final String id;
  final String reviewerUserId;
  final String reviewerDisplayName;
  final String? reviewerProfileImageUrl;
  final int rating;
  final String comment;
  final String? serviceProvided;
  final DateTime reviewDate;
  final String? providerResponse;
  final DateTime? providerResponseDate;

  const ProviderReview({
    required this.id,
    required this.reviewerUserId,
    required this.reviewerDisplayName,
    this.reviewerProfileImageUrl,
    required this.rating,
    required this.comment,
    this.serviceProvided,
    required this.reviewDate,
    this.providerResponse,
    this.providerResponseDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'reviewer_user_id': reviewerUserId,
        'reviewer_display_name': reviewerDisplayName,
        'reviewer_profile_image_url': reviewerProfileImageUrl,
        'rating': rating,
        'comment': comment,
        'service_provided': serviceProvided,
        'review_date': reviewDate.toIso8601String(),
        'provider_response': providerResponse,
        'provider_response_date': providerResponseDate?.toIso8601String(),
      };

  factory ProviderReview.fromJson(Map<String, dynamic> json) {
    DateTime parseTs(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    return ProviderReview(
      id: json['id']?.toString() ?? '',
      reviewerUserId: json['reviewer_user_id']?.toString() ?? '',
      reviewerDisplayName: json['reviewer_display_name']?.toString() ?? '',
      reviewerProfileImageUrl: json['reviewer_profile_image_url']?.toString(),
      rating: json['rating'] is int
          ? json['rating']
          : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      comment: json['comment']?.toString() ?? '',
      serviceProvided: json['service_provided']?.toString(),
      reviewDate: parseTs(json['review_date']),
      providerResponse: json['provider_response']?.toString(),
      providerResponseDate: json['provider_response_date'] != null
          ? parseTs(json['provider_response_date'])
          : null,
    );
  }
}

/// Portfolio item showcasing provider's work
class PortfolioItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? thumbnailUrl;
  final String? category;
  final DateTime? completedDate;

  const PortfolioItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.thumbnailUrl,
    this.category,
    this.completedDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'thumbnail_url': thumbnailUrl,
        'category': category,
        'completed_date': completedDate?.toIso8601String(),
      };

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString(),
      category: json['category']?.toString(),
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'].toString())
          : null,
    );
  }
}
