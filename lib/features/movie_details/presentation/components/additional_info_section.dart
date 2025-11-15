import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/movie_details.dart';
import 'details_info_row.dart';

class AdditionalInfoSection extends StatelessWidget {
  final MovieDetailsModel movie;

  const AdditionalInfoSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: TextStyles.font18Primary600.copyWith(
            color: ColorsManager.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorsManager.cardBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              DetailsInfoRow(
                label: 'Original Title',
                value: movie.originalTitle,
              ),
              if (movie.budget != null && movie.budget! > 0) ...[
                Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
                DetailsInfoRow(
                  label: 'Budget',
                  value: '\$${_formatCurrency(movie.budget!)}',
                ),
              ],
              if (movie.revenue != null && movie.revenue! > 0) ...[
                Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
                DetailsInfoRow(
                  label: 'Revenue',
                  value: '\$${_formatCurrency(movie.revenue!)}',
                ),
              ],
              if (movie.productionCompaniesText.isNotEmpty) ...[
                Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
                DetailsInfoRow(
                  label: 'Production Companies',
                  value: movie.productionCompaniesText,
                ),
              ],
              if (movie.productionCountriesText.isNotEmpty) ...[
                Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
                DetailsInfoRow(
                  label: 'Production Countries',
                  value: movie.productionCountriesText,
                ),
              ],
              if (movie.spokenLanguagesText.isNotEmpty) ...[
                Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
                DetailsInfoRow(
                  label: 'Spoken Languages',
                  value: movie.spokenLanguagesText,
                ),
              ],
              if (movie.homepage?.isNotEmpty == true) ...[
                Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
                DetailsInfoRow(label: 'Homepage', value: movie.homepage!),
              ],
              if (movie.imdbId?.isNotEmpty == true) ...[
                Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
                DetailsInfoRow(label: 'IMDb ID', value: movie.imdbId!),
              ],
              Divider(color: ColorsManager.textSecondary.withOpacity(0.3)),
              DetailsInfoRow(
                label: 'Popularity',
                value: movie.popularity.toStringAsFixed(1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toString();
  }
}
