

import 'package:calendy_x_project/common/animations/error_animation.dart';
import 'package:calendy_x_project/common/animations/loading_animation.dart';
import 'package:calendy_x_project/common/theme/app_colors.dart';
import 'package:calendy_x_project/common/theme/providers/theme_provider.dart';
import 'package:calendy_x_project/tabs/calendar/backend/google_calendar_client.dart';
import 'package:calendy_x_project/tabs/calendar/providers/google_calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileCalendarViewState();
}

class _MobileCalendarViewState extends ConsumerState<CalendarScreen> {
  static late CalendarController _calendarController;

  @override
  void initState() {
    _calendarController = CalendarController();
    _calendarController.selectedDate = DateTime.now();
    _calendarController.displayDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final googleCalendarData = ref.watch(googleCalendarDataProvider);

    return googleCalendarData.when(
      // TODO: need to fix because the state is not updated
      data: (data) {
        return FutureBuilder(
          future: getGoogleEventsData(),
          builder: (context, snapshot) {
            return SfCalendar(
              view: CalendarView.month,
              initialDisplayDate: _calendarController.displayDate,
              initialSelectedDate: _calendarController.selectedDate,
              dataSource: GoogleCalendarClient(events: snapshot.data),
              viewHeaderStyle: ViewHeaderStyle(
                dayTextStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isDarkMode ? AppColors.perano : AppColors.blackPanther,
                ),
              ),
              selectionDecoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode ? AppColors.perano : AppColors.blackPanther,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
              ),
              todayTextStyle: TextStyle(
                color: isDarkMode ? AppColors.perano : AppColors.blackPanther,
              ),
              todayHighlightColor:
                  isDarkMode ? AppColors.blackPanther : AppColors.perano,
              monthCellBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.blackPanther
                          : AppColors.perano,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3, top: 2),
                      child: Text(
                        details.date.day.toString(),
                      ),
                    ),
                  ),
                );
              },
              monthViewSettings: MonthViewSettings(
                showAgenda: true,
                agendaStyle: AgendaStyle(
                  appointmentTextStyle: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color:
                        isDarkMode ? AppColors.blackPanther : AppColors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) => const ErrorAnimation(),
      loading: () => Center(
        child: LoadingAnimation(isDarkMode: isDarkMode),
      ),
    );
  }
}