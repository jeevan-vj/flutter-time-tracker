abstract class TimeEntryRepository {
  Future<List<TimeEntry>> getEntries();
  Future<void> saveEntry(TimeEntry entry);
  Future<void> deleteEntry(String id);
}

class TimeEntryRepositoryImpl implements TimeEntryRepository {
  final LocalStorage _storage;
  
  TimeEntryRepositoryImpl(this._storage);
  
  @override
  Future<List<TimeEntry>> getEntries() async {
    // Implementation
  }
} 