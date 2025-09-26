
import 'package:flutter/material.dart';
// Imports required after pubspec.yaml update:
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

// Use the shared AppText widget from widgets folder
import '../../widgets/app_text.dart';

// Mock data model for an alarm
class Alarm {
  final String id;
  // Stores the full scheduled DateTime for accurate scheduling and display
  DateTime scheduledDateTime; 
  String detail;
  bool isActive;

  Alarm({
    required this.id,
    required this.scheduledDateTime,
    required this.detail,
    this.isActive = true,
  });
}

class HomeAlarmScreen extends StatefulWidget {
  final String initialLocation;
  final bool locationFetched;

  const HomeAlarmScreen({
    Key? key,
    this.initialLocation = 'Unknown Location',
    this.locationFetched = false,
  }) : super(key: key);

  @override
  State<HomeAlarmScreen> createState() => _HomeAlarmScreenState();
}

class _HomeAlarmScreenState extends State<HomeAlarmScreen> {
  // Define colors from the app's palette
  static const Color primaryDark = Color(0xFF0B0024);
  static const Color accentColor = Color(0xFF5200FF);
  static const Color inactiveColor = Colors.white70;
  static const Color _alarmButtonBg = Color(0xFF201A43);
  
  // State variable to hold the location text
  late String _currentLocation;
  late bool _locationFetched;

  // --- LOCAL NOTIFICATION SETUP ---
  // Initialize the plugin instance
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initial mock list of alarms
  List<Alarm> alarms = [];

  // Map of scheduled timers for alarms (in-app fallback scheduling)
  final Map<String, Timer> _scheduledTimers = {};

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _currentLocation = widget.initialLocation;
    _locationFetched = widget.locationFetched;
    
    // Initialize mock data
    DateTime now = DateTime.now();
    alarms = [
      Alarm(
        id: '1',
        scheduledDateTime: now.add(const Duration(hours: 1, minutes: 10)),
        detail: 'Scheduled',
        isActive: true,
      ),
      Alarm(
        id: '2',
        scheduledDateTime: now.add(const Duration(hours: 2, minutes: 55)),
        detail: 'Scheduled',
        isActive: false,
      ),
    ];

    // Schedule any active mock alarms upon starting the screen
    for (var alarm in alarms) {
      if (alarm.isActive) {
        // Schedule is only safe if the time is in the future
        if (alarm.scheduledDateTime.isAfter(DateTime.now())) {
           _scheduleAlarmNotification(alarm);
        }
      }
    }
  }

  @override
  void dispose() {
    // Cancel all in-app timers
    for (final timer in _scheduledTimers.values) {
      timer.cancel();
    }
    _scheduledTimers.clear();
    super.dispose();
  }

  // Configuration for local notifications
  void _initializeNotifications() async {
    // Note: For a real app, you need to ensure an appropriate icon exists
  final AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    
    // Robust initialization of the plugin
    try {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
    } catch (e) {
      print('Notification initialization failed: $e');
    }
  }

  // Schedules a single alarm notification
  Future<void> _scheduleAlarmNotification(Alarm alarm) async {
    final now = DateTime.now();
    
    // Only schedule if the alarm time is in the future
    if (!alarm.isActive || alarm.scheduledDateTime.isBefore(now)) {
      await _cancelAlarmNotification(alarm.id); 
      return;
    }
    
    // FIX: Added try-catch for robust scheduling
    try {
      // Define notification details (non-const)
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'alarm_channel_id',
        'Travel Alarm Channel',
        channelDescription: 'Channel for scheduled travel alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      // Fallback scheduling using in-app Timer (works while app is running)
      final Duration untilAlarm = alarm.scheduledDateTime.difference(DateTime.now());
      // Cancel any existing timers for this alarm id
      _scheduledTimers[alarm.id]?.cancel();
      _scheduledTimers[alarm.id] = Timer(untilAlarm, () async {
        // Show the notification when timer fires
        try {
          await flutterLocalNotificationsPlugin.show(
            alarm.id.hashCode,
            'Smart Travel Alarm: Time to Go!',
            'Your alarm is set for ${DateFormat('jm').format(alarm.scheduledDateTime)}.',
            notificationDetails,
          );
        } catch (e) {
          print('Error showing notification via Timer fallback: $e');
        }
      });

      print('Alarm scheduled for: ${alarm.scheduledDateTime}');
    } catch (e) {
      // Catch errors related to missing timezone setup or other platform configuration issues
      print('Error scheduling alarm notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            text: "Warning: Notification scheduling failed. Check console for error details.",
            color: Colors.redAccent,
            type: AppTextType.paragraph,
            customSize: 14.0,
          ),
          backgroundColor: primaryDark,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Cancels a scheduled alarm notification
  Future<void> _cancelAlarmNotification(String alarmId) async {
    // FIX: Added try-catch for robust cancellation
    try {
      await flutterLocalNotificationsPlugin.cancel(alarmId.hashCode);
      print('Alarm cancelled for ID: $alarmId');
    } catch (e) {
      print('Error cancelling alarm notification: $e');
    }
  }

  // --- ALARM DATA & LOGIC ---

  // Toggles the isActive state of an alarm and schedules/cancels notifications
  void _toggleAlarm(int index, bool newValue) {
    setState(() {
      alarms[index].isActive = newValue;
    });
    
    final alarm = alarms[index];
    if (newValue) {
      if (alarm.scheduledDateTime.isAfter(DateTime.now())) {
        _scheduleAlarmNotification(alarm);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Alarm Activated and Scheduled!"),
            duration: Duration(milliseconds: 800),
          ),
        );
      } else {
        // FIX: If the alarm is in the past, set isActive back to false and warn the user.
        setState(() {
          alarms[index].isActive = false; 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Alarm time is in the past, please set a new one."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      _cancelAlarmNotification(alarm.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alarm Deactivated and Cancelled."),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  // Simulates fetching the current location and updates the state
  void _fetchLocation() {
    setState(() {
      _currentLocation = 'Tokyo, Japan (Updated)';
      _locationFetched = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Location updated to '$_currentLocation'"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 1. Show Date Picker, 2. Show Time Picker, 3. Combine, 4. Add Alarm
  void _selectDateTime() async {
    // 1. Show Date Picker
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(minutes: 1)),
      firstDate: DateTime.now(), // Alarms must be set from now onward
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: accentColor, 
              onPrimary: Colors.white, 
              surface: primaryDark,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: primaryDark,
          ),
          child: child!,
        );
      },
    );

    if (datePicked == null) return; 

    // 2. Show Time Picker
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: primaryDark,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: primaryDark,
          ),
          child: child!,
        );
      },
    );

    if (timePicked == null) return; 

    // 3. Combine Date and Time
    DateTime scheduledTime = DateTime(
      datePicked.year,
      datePicked.month,
      datePicked.day,
      timePicked.hour,
      timePicked.minute,
      0, // Set seconds to 0
    );

    // Ensure the scheduled time is actually in the future
    if (scheduledTime.isBefore(DateTime.now())) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cannot set alarm in the past. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // 4. Add Alarm
    _addNewAlarm(scheduledTime);
  }

  // Final step of adding a new alarm to the list and scheduling it
  void _addNewAlarm(DateTime scheduledTime) {
    setState(() {
      final newAlarm = Alarm(
        id: UniqueKey().toString(),
        scheduledDateTime: scheduledTime,
        // Use DateFormat for clean display
        detail: DateFormat('EEE dd yyyy').format(scheduledTime),
        isActive: true,
      );

      alarms.add(newAlarm);

      // Schedule the real notification
      _scheduleAlarmNotification(newAlarm);

      // Sort alarms by time
      alarms.sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          text: "Alarm set for ${DateFormat('MMM dd, yyyy at hh:mm a').format(scheduledTime)}",
          color: Colors.white,
          type: AppTextType.paragraph,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- Widget for a single alarm row ---
  Widget _buildAlarmRow(Alarm alarm, int index) {
    // Text color depends on whether the alarm is active
    final Color textColor = alarm.isActive ? Colors.white : inactiveColor;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        // FIX: Tapping the whole row now toggles the alarm
        onTap: () {
          _toggleAlarm(index, !alarm.isActive);
        },
        child: Container(
          height: 64.0, 
          decoration: BoxDecoration(
            color: _alarmButtonBg,
            borderRadius: BorderRadius.circular(61.0), 
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Time (Formatted using DateFormat)
              AppText(
                text: DateFormat('hh:mm a').format(alarm.scheduledDateTime),
                type: AppTextType.heading,
                customSize: 20.0,
                color: textColor,
              ),
              
              const Spacer(),

              // 2. Date/Detail and Toggle Switch
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    // Date text (Formatted using DateFormat: EEE dd yyyy)
                    text: DateFormat('EEE dd yyyy').format(alarm.scheduledDateTime),
                    type: AppTextType.paragraph,
                    customSize: 16.0,
                    color: inactiveColor,
                  ),

                  const SizedBox(width: 10),

                  // 3. Toggle Switch
                  Transform.scale(
                    scale: 0.85,
                    child: Switch.adaptive(
                      value: alarm.isActive,
                      // The switch itself still calls the toggle function
                      onChanged: (newValue) => _toggleAlarm(index, newValue),
                      
                      activeTrackColor: accentColor, 
                      activeColor: Colors.white,
                      inactiveTrackColor: _alarmButtonBg,
                      inactiveThumbColor: Colors.white,
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

            // Header (Selected Location)
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
                  // Location Widget
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: _alarmButtonBg,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white70, size: 22),
                        const SizedBox(width: 10),
                        AppText(
                          text: _currentLocation,
                          type: AppTextType.paragraph,
                          customSize: 18.0,
                          color: Colors.white,
                        ),
                        const Spacer(),
                        // Fetch Location Button
                        IconButton(
                          icon: const Icon(Icons.gps_fixed, color: accentColor, size: 28),
                          onPressed: _fetchLocation,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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


            // Alarm List
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

      // Floating Action Button (FAB) to set a new alarm
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: _locationFetched
              ? _selectDateTime
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fetch your location before setting alarms.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
          backgroundColor: _locationFetched ? accentColor : Colors.grey,
          shape: const CircleBorder(),
          elevation: 8,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 36.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
