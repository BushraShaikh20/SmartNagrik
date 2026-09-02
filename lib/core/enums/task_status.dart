enum TaskStatus {
  assigned('Assigned'),
  inProgress('In Progress'),
  completed('Completed');

  final String label;
  const TaskStatus(this.label);

  static TaskStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'assigned':
      default:
        return TaskStatus.assigned;
    }
  }
}
