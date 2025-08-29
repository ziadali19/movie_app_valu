import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';
import '../../controller/bloc/search_state.dart';

class SearchResultsHeader extends StatelessWidget {
  final SearchState state;

  const SearchResultsHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

      child: Row(
        children: [
          Text(
            '${state.movies.length} results for "${state.query}"',
            style: TextStyle(
              color: ColorsManager.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (state.isSearching)
            SizedBox(
              width: 16.w,
              height: 16.h,
              child: const CupertinoActivityIndicator(
                color: ColorsManager.primary,
              ),
            ),
        ],
      ),
    );
  }
}
