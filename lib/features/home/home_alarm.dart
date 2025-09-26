import 'package:flutter/material.dart';
import '../../widgets/app_text.dart';

// Mock data model for an alarm
class Alarm {
  final String id;
  TimeOfDay time;
  String detail;
  bool isActive;

  Alarm({
    required this.id,
    required this.time,
    required this.detail,
    this.isActive = true,
  });
}

class HomeAlarmScreen extends StatefulWidget {
  const HomeAlarmScreen({Key? key}) : super(key: key);

  @override
  State<HomeAlarmScreen> createState() => _HomeAlarmScreenState();
}

class _HomeAlarmScreenState extends State<HomeAlarmScreen> {
  // Define colors from the app's palette
  static const Color primaryDark = Color(0xFF0B0024);
  static const Color accentColor = Color(0xFF5200FF);
  // INCREASED OPACITY for date text to 70%
  static const Color inactiveColor = Colors.white70; 
  // New color constant for the alarm buttons
  static const Color _alarmButtonBg = Color(0xFF201A43); 
  
  // State variable to hold the location text
  String _currentLocation = 'Add your location';

  // Mock list of alarms, adjusted to match the screenshot text structure
  List<Alarm> alarms = [
    Alarm(
      id: '1',
      time: const TimeOfDay(hour: 7, minute: 10),
      // Updated date format: Day Date Year
      detail: 'Fri 21 2025',
      isActive: true,
    ),
    Alarm(
      id: '2',
      time: const TimeOfDay(hour: 6, minute: 55),
      // Updated date format: Day Date Year
      detail: 'Fri 21 2025',
      isActive: false,
    ),
    Alarm(
      id: '3',
      time: const TimeOfDay(hour: 7, minute: 10),
      // Updated date format: Day Date Year
      detail: 'Fri 21 2025',
      isActive: true,
    ),
  ];

  // Toggles the isActive state of an alarm
  void _toggleAlarm(int index, bool newValue) {
    setState(() {
      alarms[index].isActive = newValue;
    });
  }

  // Simulates fetching the current location and updates the state
  void _fetchLocation() {
    // In a real app, this would involve async calls to a location service.
    // We simulate the update here.
    setState(() {
      _currentLocation = 'London, UK (Current)';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Location updated to '$_currentLocation'"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Adds a mock alarm and shows a snackbar confirmation
  void _addAlarm() {
    setState(() {
      final now = DateTime.now();
      final newTime = TimeOfDay.fromDateTime(now.add(const Duration(minutes: 5)));
      
      // Simple format for the mock detail text
      // Updated date format for new mock alarms: Day Date Year
      String mockDate = 'Sat ${now.day} ${now.year}';
      
      alarms.add(Alarm(
        id: UniqueKey().toString(),
        time: newTime,
        detail: mockDate,
        isActive: true,
      ));
      
      // Sort alarms by time after adding a new one
      alarms.sort((a, b) {
        final aMinutes = a.time.hour * 60 + a.time.minute;
        final bMinutes = b.time.hour * 60 + b.time.minute;
        return aMinutes.compareTo(bMinutes);
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("New mock alarm added!"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // --- Widget for a single alarm row (Transparent Button Style) ---
  Widget _buildAlarmRow(Alarm alarm, int index) {
    // Text color depends on whether the alarm is active
    final Color textColor = alarm.isActive ? Colors.white : inactiveColor;
    
    // Border is removed
    const double borderWidth = 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          // Placeholder for tapping the alarm to open edit settings
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Tapped to edit Alarm ${alarm.id}"),
              duration: const Duration(milliseconds: 500),
            ),
          );
        },
        child: Container(
          // --- BEGIN SIZE AND SHAPE SPECIFICATIONS ---
          // Increased Height from 56.0 to 64.0
          height: 64.0, 
          // Border-radius: 61px (We use 61.0 for the high pill shape)
          decoration: BoxDecoration(
            // Applied background color #201A43
            color: _alarmButtonBg,
            borderRadius: BorderRadius.circular(61.0), 
            // Border is now removed by setting width to 0.0
            border: Border.all(
              color: Colors.transparent, 
              width: borderWidth, 
            ),
          ),
          // Padding: Adjusted to keep content centered vertically in the new 64px height
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          // --- END SIZE AND SHAPE SPECIFICATIONS ---

          child: Row(
            // Time and Date/Toggle are separated by a Spacer
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Time (Most Left)
              AppText(
                text: alarm.time.format(context),
                type: AppTextType.heading,
                customSize: 20.0, // Adjusted font size for larger button
                color: textColor,
              ),
              
              // Spacer to push the time to the left and the date/toggle group to the right
              const Spacer(),

              // 2. Date/Detail and Toggle Switch (Grouped on Right)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    // Date text
                    text: alarm.detail,
                    type: AppTextType.paragraph,
                    customSize: 16.0, // Adjusted font size for larger button
                    color: inactiveColor, // Now using 70% opacity white
                  ),

                  // Small gap between date and switch
                  const SizedBox(width: 10),

                  // 3. Toggle Switch (Right)
                  // >>> Making the toggle button smaller by scaling it down <<<
                  Transform.scale(
                    scale: 0.85, // Scale factor to make it slightly smaller
                    child: Switch.adaptive(
                      value: alarm.isActive,
                      onChanged: (newValue) => _toggleAlarm(index, newValue),
                      
                      // ON State: Track #5200FF, Thumb white
                      activeTrackColor: accentColor, 
                      activeColor: Colors.white, // Active thumb is white
                      
                      // OFF State: To maintain visual size consistency, the thumb is white (same color as active).
                      // The track is set to the button background color for contrast.
                      inactiveTrackColor: _alarmButtonBg, // Dark background for contrast
                      inactiveThumbColor: Colors.white,    // Inactive thumb is white
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF082257),
              primaryDark,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safe Area padding for content below the status bar
            const SizedBox(height: 50), 

            // Header (Selected Location) - Based on screenshot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Selected Location',
                    type: AppTextType.heading,
                    customSize: 22.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  // >>> Location Widget - Increased Height from 56.0 to 64.0 <<<
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: _alarmButtonBg, // Set background to #201A43
                      borderRadius: BorderRadius.circular(32.0), // Adjusted for new height
                      // Border removed
                      border: Border.all(color: Colors.transparent, width: 0.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white70, size: 22), // Increased icon size
                        const SizedBox(width: 10), // Increased spacing
                        // Use the state variable _currentLocation
                        AppText(
                          text: _currentLocation,
                          type: AppTextType.paragraph,
                          customSize: 18.0, // Adjusted font size
                          // Change color based on whether location is the placeholder or actual data
                          color: _currentLocation == 'Add your location' ? Colors.white70 : Colors.white,
                        ),
                        const Spacer(), // Pushes the button to the right

                        // New Fetch Location Button
                        IconButton(
                          icon: const Icon(Icons.gps_fixed, color: accentColor, size: 28), // Increased icon size
                          // Call the new _fetchLocation function to update the state
                          onPressed: _fetchLocation,
                          padding: EdgeInsets.zero, // Minimal padding
                          constraints: const BoxConstraints(), // Minimal constraints
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const AppText(
                    text: 'Alarms',
                    type: AppTextType.heading,
                    customSize: 22.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),


            // Alarm List (Now using a standard ListView inside an Expanded widget)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  return _buildAlarmRow(alarms[index], index);
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button (FAB)
      floatingActionButton: SizedBox(
        width: 64, // Enforced width
        height: 64, // Enforced height
        child: FloatingActionButton(
          onPressed: _addAlarm,
          backgroundColor: accentColor,
          shape: const CircleBorder(),
          elevation: 8,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 36.0, // Bigger icon size
          ),
        ),
      ),
      // Reverting to endFloat will place the FAB floating above the content
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
