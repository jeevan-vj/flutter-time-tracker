class TimeEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TimeEntryBloc>(),
      child: BlocBuilder<TimeEntryBloc, TimeEntryState>(
        builder: (context, state) {
          return Scaffold(
            // UI implementation using state
          );
        },
      ),
    );
  }
} 