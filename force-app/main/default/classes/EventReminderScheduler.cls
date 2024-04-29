public with sharing class EventReminderScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.debug('sc.getTriggerId() = ' + sc.getTriggerId());

        new EventReminder().emailReminderBeforeInterviewOnNextWeekDay();
    }
}