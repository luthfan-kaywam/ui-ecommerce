import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  bool _isLaunching = false;

  // Pulse animation for the shutter button
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ── Camera / Gallery launchers ─────────────────────────────────────────────

  Future<void> _launchCamera() async {
    if (_isLaunching) return;
    setState(() => _isLaunching = true);
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (!mounted) return;
      if (photo != null) {
        // Return the captured file/path to the calling screen
        Navigator.pop(context, photo);
      }
      // User cancelled — just pop back with null (handled below silently)
    } catch (e) {
      if (!mounted) return;
      _showErrorSnack('Kamera tidak tersedia: $e');
    } finally {
      if (mounted) setState(() => _isLaunching = false);
    }
  }

  Future<void> _launchGallery() async {
    if (_isLaunching) return;
    setState(() => _isLaunching = true);
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (!mounted) return;
      if (image != null) {
        Navigator.pop(context, image);
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnack('Galeri tidak tersedia: $e');
    } finally {
      if (mounted) setState(() => _isLaunching = false);
    }
  }

  void _showErrorSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Dark viewfinder background ───────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
              ),
            ),
          ),

          // ── Rule-of-thirds grid ─────────────────────────────────
          Positioned.fill(
            child: CustomPaint(painter: _SceneGridPainter()),
          ),

          // ── Centre hint ─────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image_search_rounded,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
                const SizedBox(height: 12),
                Text(
                  'Arahkan kamera ke produk',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.13),
                    fontSize: 14,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),

          // ── Corner frame overlay ────────────────────────────────
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 160),
              child: CustomPaint(
                painter: _CornerFramePainter(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),

          // ── Launching overlay ───────────────────────────────────
          if (_isLaunching)
            Container(
              color: Colors.black.withValues(alpha: 0.55),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF4C53A5)),
              ),
            ),

          // ── Top bar ─────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  _TopControlButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                    tooltip: 'Kembali',
                  ),

                  // Branded badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Visual Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Placeholder so Row stays balanced
                  const SizedBox(width: 44),
                ],
              ),
            ),
          ),

          // ── Hint label ─────────────────────────────────────────
          Align(
            alignment: const Alignment(0, 0.25),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Posisikan produk di dalam bingkai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          // ── Bottom controls ─────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Gallery button
                          GestureDetector(
                            onTap: _launchGallery,
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.photo_library_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),

                          const SizedBox(width: 40),

                          // Shutter / Camera button
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: GestureDetector(
                              onTap: _isLaunching ? null : _launchCamera,
                              child: Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF4C53A5),
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4C53A5)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 40),

                          // Spacer mirror for layout symmetry
                          const SizedBox(width: 52, height: 52),
                        ],
                      ),
                    ),

                    // Labels
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ModeTab(label: 'Galeri', isActive: false),
                        SizedBox(width: 32),
                        _ModeTab(label: 'Kamera', isActive: true),
                        SizedBox(width: 32),
                        _ModeTab(label: '', isActive: false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _TopControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _TopControlButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.4),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool isActive;
  const _ModeTab({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 20 : 0,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF4C53A5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

// ── Custom Painters ──────────────────────────────────────────────────────────

class _CornerFramePainter extends CustomPainter {
  final Color color;
  const _CornerFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 28.0;
    final w = size.width;
    final h = size.height;

    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, len), paint);
    canvas.drawLine(Offset(w, 0), Offset(w - len, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, len), paint);
    canvas.drawLine(Offset(0, h), Offset(len, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - len), paint);
    canvas.drawLine(Offset(w, h), Offset(w - len, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - len), paint);
  }

  @override
  bool shouldRepaint(_CornerFramePainter old) => old.color != color;
}

class _SceneGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 2; i++) {
      final x = size.width * i / 3;
      final y = size.height * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final cx = size.width / 2;
    final cy = size.height / 2;
    final cross = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(cx - 12, cy), Offset(cx + 12, cy), cross);
    canvas.drawLine(Offset(cx, cy - 12), Offset(cx, cy + 12), cross);
  }

  @override
  bool shouldRepaint(_SceneGridPainter _) => false;
}
