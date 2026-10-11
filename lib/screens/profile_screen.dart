import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../controllers/profile_controller.dart';
import '../models/student_profile.dart';
import '../services/auth_service.dart';
import '../services/pdf_generator_service.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';
import '../widgets/rainbow_border_container.dart';
import '../services/remote_config_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBioExpanded = false;
  bool _isDownloading = false;
  bool _isFetchingLocation = false;

  bool _isEditingBio = false;
  bool _isEditingLocation = false;
  bool _isEditingUniversity = false;

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    _locationController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation(ProfileController profileProvider) async {
    setState(() => _isFetchingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions permanently denied');
      } 

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty) addressParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) addressParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) addressParts.add(place.locality!);
        if (place.country != null && place.country!.isNotEmpty) addressParts.add(place.country!);
        
        final uniqueParts = addressParts.toSet().toList();
        String locStr = uniqueParts.join(', ');

        final profile = profileProvider.profile!;
        profileProvider.updateProfile(profile.copyWith(location: locStr));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Location fetched successfully!'),
              backgroundColor: Theme.of(context).primaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating,),
        );
      }
    } finally {
      if (mounted) setState(() => _isFetchingLocation = false);
    }
  }

  Future<void> _generateAndDownloadResume(
    ProfileController profileProvider, 
    AuthService auth, {
    bool isDarkMode = false,
    bool includeSkills = true,
    bool includeProjects = true,
  }) async {
    setState(() => _isDownloading = true);
    try {
      final profile = profileProvider.profile!;
      final user = auth.currentUser;
      
      final path = await PdfGeneratorService.generateCustomResume(
        profile: profile,
        isDarkTheme: isDarkMode,
        includeSkills: includeSkills,
        includeProjects: includeProjects,
        userName: user?.name,
        userEmail: user?.email,
        userUniversity: user?.university,
        userDegree: user?.degree,
      );

      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ATS Resume saved to $path'),
            backgroundColor: Theme.of(context).primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating,),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileController>(context);
    final theme = Theme.of(context);

    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final profile = profileProvider.profile;
    if (profile == null) return const SizedBox.shrink();

    final auth = Provider.of<AuthService>(context);

    const String defaultCoverUrl =
        'https://images.unsplash.com/photo-1555066931-4365d14bab8c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80';

    return SingleChildScrollView(
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: _buildHeader(context, defaultCoverUrl, profile.profileImage, auth),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsivePadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                
                // Name (Fitted Box)
                FadeInDown(
                  child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    auth.currentUser?.name ?? profile.fullName,
                    style: theme.textTheme.displayMedium?.copyWith(
                      shadows: [
                        Shadow(
                          color: theme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                  ),
                ),
                ),
                const SizedBox(height: 4),
                
                // Email
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    auth.currentUser?.email ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                ),
                const SizedBox(height: 12),
                
                // Title
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    profile.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: theme.primaryColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 2))
                      ]
                    ),
                  ),
                ),
                ),
                const SizedBox(height: 20),
                
                // Location & University Row
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // LOCATION
                      Icon(Icons.location_on, color: theme.primaryColor, size: 22),
                      const SizedBox(width: 4),
                      if (_isEditingLocation)
                        SizedBox(
                          width: 150,
                          child: TextField(
                            controller: _locationController,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8)),
                            onSubmitted: (val) {
                              profileProvider.updateProfile(profile.copyWith(location: val));
                              setState(() => _isEditingLocation = false);
                            },
                          ),
                        )
                      else
                        Text(profile.location, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(_isEditingLocation ? Icons.check_circle : Icons.edit_note, size: 20, color: theme.primaryColor),
                        onPressed: () {
                          if (_isEditingLocation) {
                            profileProvider.updateProfile(profile.copyWith(location: _locationController.text));
                          } else {
                            _locationController.text = profile.location;
                          }
                          setState(() => _isEditingLocation = !_isEditingLocation);
                        },
                      ),
                      
                      if (!_isEditingLocation) ...[
                        const SizedBox(width: 4),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: _isFetchingLocation 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : Icon(Icons.my_location, size: 20, color: theme.primaryColor.withValues(alpha: 0.8)),
                          onPressed: _isFetchingLocation ? null : () => _fetchCurrentLocation(profileProvider),
                        ),
                      ],

                      const SizedBox(width: 16),
                      Container(height: 24, width: 2, color: theme.dividerColor),
                      const SizedBox(width: 16),

                      // UNIVERSITY
                      Icon(Icons.school, color: theme.primaryColor, size: 22),
                      const SizedBox(width: 4),
                      if (_isEditingUniversity)
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _universityController,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8)),
                            onSubmitted: (val) {
                              profileProvider.updateProfile(profile.copyWith(university: val));
                              setState(() => _isEditingUniversity = false);
                            },
                          ),
                        )
                      else
                        Text(
                          auth.currentUser?.university ?? profile.university,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(_isEditingUniversity ? Icons.check_circle : Icons.edit_note, size: 20, color: theme.primaryColor),
                        onPressed: () {
                          if (_isEditingUniversity) {
                            profileProvider.updateProfile(profile.copyWith(university: _universityController.text));
                          } else {
                            _universityController.text = auth.currentUser?.university ?? profile.university;
                          }
                          setState(() => _isEditingUniversity = !_isEditingUniversity);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 350),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, color: theme.primaryColor, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        auth.currentUser?.degree ?? profile.degreeProgram,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Container(height: 24, width: 2, color: theme.dividerColor),
                      const SizedBox(width: 16),
                      Icon(Icons.timeline, color: theme.primaryColor, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        'Semester ${profile.semester}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildActionButtons(theme, profileProvider, auth),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: _buildBioSection(theme, profile.shortBio, profileProvider, profile),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: _buildAnalyticsSection(theme),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: _buildRemoteConfigToggles(theme),
                ),
                const SizedBox(height: 120), // Extra space for scrolling
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String coverUrl, String avatarUrl, AuthService auth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final coverHeight = ResponsiveUtils.isMobile(context) ? 150.0 : 250.0;
    final user = auth.currentUser;
    final hasBase64 = user?.profilePicBase64 != null && user!.profilePicBase64.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: screenWidth,
          height: coverHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(coverUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
            alignment: Alignment.topRight,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  auth.signOut();
                  context.go('/auth');
                },
                tooltip: 'Logout',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          child: GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
              if (image != null) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Updating profile picture...'), backgroundColor: Theme.of(context).primaryColor, behavior: SnackBarBehavior.floating));
                final bytes = await image.readAsBytes();
                auth.updateProfilePicture(base64Encode(bytes));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: hasBase64
                        ? MemoryImage(base64Decode(user.profilePicBase64))
                        : NetworkImage(
                            avatarUrl.isNotEmpty
                                ? avatarUrl
                                : 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                          ) as ImageProvider,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, ProfileController provider, AuthService auth) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        AnimatedBounceButton(
          enableGlow: true,
          onPressed: _isDownloading ? () {} : () => _showResumeCustomizer(context, provider, auth),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: theme.primaryColor.withValues(alpha: 0.6), blurRadius: 15, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isDownloading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.download_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(_isDownloading ? '...' : 'Download', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        AnimatedBounceButton(
          enableGlow: false,
          onPressed: () {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('ATS Resume Template Opened for Editing.'), backgroundColor: theme.primaryColor, behavior: SnackBarBehavior.floating));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: theme.primaryColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_document, color: theme.primaryColor, size: 22),
                const SizedBox(width: 8),
                Text('Edit Resume', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        AnimatedBounceButton(
          enableGlow: false,
          onPressed: () {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resume Deleted.'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.redAccent),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection(ThemeData theme, String bio, ProfileController profileProvider, StudentProfile profile) {
    return RainbowBorderContainer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.15),
              blurRadius: 25,
              spreadRadius: 5,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('About Me', style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: theme.primaryColor.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))]
                  )),
                  IconButton(
                    icon: Icon(_isEditingBio ? Icons.check_circle : Icons.edit_note, color: theme.primaryColor, size: 28),
                    onPressed: () {
                      if (_isEditingBio) {
                        profileProvider.updateProfile(profile.copyWith(shortBio: _bioController.text));
                      } else {
                        _bioController.text = bio;
                        _isBioExpanded = true;
                      }
                      setState(() => _isEditingBio = !_isEditingBio);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (_isEditingBio)
                TextField(
                  controller: _bioController,
                  maxLines: 5,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintText: 'Write about your background, skills, and aspirations...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              else
                AnimatedCrossFade(
                  firstChild: Text(
                    bio,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondChild: Text(
                    bio,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  crossFadeState: _isBioExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
                
              if (!_isEditingBio) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() => _isBioExpanded = !_isBioExpanded),
                  child: Text(
                    _isBioExpanded ? 'Read Less' : 'Read More',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(ThemeData theme) {
    return Consumer<RemoteConfigService>(
      builder: (context, config, child) {
        if (!config.showAnalytics) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Analytics',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Views over the last 7 days',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value >= 0 && value < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 35),
                      FlSpot(2, 28),
                      FlSpot(3, 55),
                      FlSpot(4, 40),
                      FlSpot(5, 75),
                      FlSpot(6, 92),
                    ],
                    isCurved: true,
                    color: theme.primaryColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.primaryColor.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  void _showResumeCustomizer(BuildContext context, ProfileController provider, AuthService auth) {
    bool includeBio = true;
    bool includeProjects = true;
    bool isDarkMode = false;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        final theme = Theme.of(sheetContext);
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customize Resume',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Include Bio Section'),
                    value: includeBio,
                    activeThumbColor: theme.primaryColor,
                    onChanged: (val) => setState(() => includeBio = val),
                  ),
                  SwitchListTile(
                    title: const Text('Include Projects Section'),
                    value: includeProjects,
                    activeThumbColor: theme.primaryColor,
                    onChanged: (val) => setState(() => includeProjects = val),
                  ),
                  SwitchListTile(
                    title: const Text('Dark Mode Template'),
                    value: isDarkMode,
                    activeThumbColor: theme.primaryColor,
                    onChanged: (val) => setState(() => isDarkMode = val),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _generateAndDownloadResume(
                          provider, 
                          auth,
                          isDarkMode: isDarkMode,
                          includeSkills: includeBio,
                          includeProjects: includeProjects,
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Generate & Download PDF'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRemoteConfigToggles(ThemeData theme) {
    return Consumer<RemoteConfigService>(
      builder: (context, config, child) {
        return RainbowBorderContainer(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.settings_suggest, color: theme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Feature Toggles (Simulated RC)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Show Education Tab'),
                  value: config.showEducationTab,
                  onChanged: (value) => config.toggleFeature('showEducationTab', value),
                  activeThumbColor: theme.primaryColor,
                ),
                SwitchListTile(
                  title: const Text('Show Analytics'),
                  value: config.showAnalytics,
                  onChanged: (value) => config.toggleFeature('showAnalytics', value),
                  activeThumbColor: theme.primaryColor,
                ),
                SwitchListTile(
                  title: const Text('Enable 3D Effects'),
                  value: config.enable3DEffects,
                  onChanged: (value) => config.toggleFeature('enable3DEffects', value),
                  activeThumbColor: theme.primaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
