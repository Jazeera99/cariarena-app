import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/app_export.dart';

class VenueImageGalleryWidget extends StatefulWidget {
  final List<String> images;
  final String venueName;

  const VenueImageGalleryWidget({
    super.key,
    required this.images,
    required this.venueName,
  });

  @override
  State<VenueImageGalleryWidget> createState() =>
      _VenueImageGalleryWidgetState();
}

class _VenueImageGalleryWidgetState extends State<VenueImageGalleryWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logika fallback: jika daftar gambar kosong, gunakan satu gambar placeholder
    final List<String> imageUrls =
        widget.images.isNotEmpty
            ? widget.images
            : ['assets/images/no-image.jpg'];

    return SizedBox(
      height: 35.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = imageUrls[index];

              if (imageUrl == 'assets/images/no-image.jpg') {
                return Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 35.h,
                );
              }

              // Gunakan CachedNetworkImage untuk gambar dari API
              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 35.h,
                placeholder:
                    (context, url) =>
                        Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  // Jika gambar gagal dimuat, tampilkan ikon "gambar dicoret"
                  return Center(
                    child: CustomIconWidget(
                      iconName: 'image_not_supported',
                      size: 20.w,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageUrls.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  width: _currentIndex == index ? 3.w : 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color:
                        _currentIndex == index
                            ? AppTheme.lightTheme.colorScheme.surface
                            : AppTheme.lightTheme.colorScheme.surface
                                .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 4.w,
            left: 4.w,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(
                    0.5,
                  ),
                  shape: BoxShape.circle,
                ),
                // child: CustomIconWidget(
                //   iconName: 'arrow_back_ios_new',
                //   color: AppTheme.lightTheme.colorScheme.surface,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => _FullScreenImageViewer(
              images: widget.images,
              initialIndex: initialIndex,
              venueName: widget.venueName,
            ),
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String venueName;

  const _FullScreenImageViewer({
    required this.images,
    required this.initialIndex,
    required this.venueName,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.surface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.surface,
              size: 24,
            ),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Hero(
                  tag: 'venue_image_${widget.venueName}_$index',
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) =>
                            Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) => Center(
                          child: CustomIconWidget(
                            iconName: 'image_not_supported',
                            size: 20.w,
                            color: AppTheme.lightTheme.colorScheme.surface,
                          ),
                        ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 5.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berbagi gambar ${widget.venueName}'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
