@IsTest
private with sharing class EventReminderTest {
    @IsTest
    private static void send_one_email_reminder_on_Sunday_for_one_event_on_Monday() {
        // GIVEN
        EventReminder eventReminder = new EventReminder();

        Date sunday = Date.valueOf(eventReminder.now).toStartOfWeek();

        eventReminder.now = Datetime.valueOf(sunday + ' 00:00:00');

        Datetime tomorrow = eventReminder.now + 1;
        Datetime dayAftertomorrow = tomorrow + 1;
        Datetime monday = dayAftertomorrow + 1;

        Integer year;
        Integer month;
        Integer day;

        Datetime nextWeekDayBegin;
        Datetime nextWeekDayEnd;

        if (tomorrow.format('E') != 'Sat' && tomorrow.format('E') != 'Sun') {
            year = tomorrow.year();
            month = tomorrow.month();
            day = tomorrow.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') != 'Sat' && dayAftertomorrow.format('E') != 'Sun')
        ) {
            year = dayAftertomorrow.year();
            month = dayAftertomorrow.month();
            day = dayAftertomorrow.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') == 'Sat' || dayAftertomorrow.format('E') == 'Sun')
        ) {
            year = monday.year();
            month = monday.month();
            day = monday.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        }

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        insert accBlackthorn;

        Contact contactThornie = new Contact(LastName = 'Thornie', AccountId = accBlackthorn.Id);

        insert contactThornie;

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(year, month, day, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(year, month, day, 20, 00, 00), 
            Location = 'no where', 
            WhoId = contactThornie.Id, 
            Type = 'Informational Interview', 
            Interview_Format__c = '1-on-1', 
            Description = 'Description'

        );

        insert informationalInterview;

        // WHEN
        Test.startTest();

        eventReminder.emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event 
            WHERE StartDateTime >= :nextWeekDayBegin 
                AND StartDateTime < :nextWeekDayEnd
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                TextBody, 
                Subject, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage
        ];

        for (EmailMessage retrievedEmailMessage : retrievedEmailMessages) {
            System.debug('retrievedEmailMessage = ' + retrievedEmailMessage);
        }

        System.assertEquals(1, retrievedEmailMessages.size(), 'Expect 1 email message');
    }

    @IsTest
    private static void send_one_email_reminder_on_Saturday_for_one_event_on_Monday() {
        // GIVEN
        EventReminder eventReminder = new EventReminder();

        Date saturday = Date.valueOf(eventReminder.now).toStartOfWeek() - 1;

        eventReminder.now = Datetime.valueOf(saturday + ' 00:00:00');

        Datetime tomorrow = eventReminder.now + 1;
        Datetime dayAftertomorrow = tomorrow + 1;
        Datetime monday = dayAftertomorrow + 1;

        Integer year;
        Integer month;
        Integer day;

        Datetime nextWeekDayBegin;
        Datetime nextWeekDayEnd;

        if (tomorrow.format('E') != 'Sat' && tomorrow.format('E') != 'Sun') {
            year = tomorrow.year();
            month = tomorrow.month();
            day = tomorrow.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') != 'Sat' && dayAftertomorrow.format('E') != 'Sun')
        ) {
            year = dayAftertomorrow.year();
            month = dayAftertomorrow.month();
            day = dayAftertomorrow.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') == 'Sat' || dayAftertomorrow.format('E') == 'Sun')
        ) {
            year = monday.year();
            month = monday.month();
            day = monday.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        }

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        insert accBlackthorn;

        Contact contactThornie = new Contact(LastName = 'Thornie', AccountId = accBlackthorn.Id);

        insert contactThornie;

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(year, month, day, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(year, month, day, 20, 00, 00), 
            Location = 'no where', 
            WhoId = contactThornie.Id, 
            Type = 'Informational Interview', 
            Interview_Format__c = '1-on-1', 
            Description = 'Description'

        );

        insert informationalInterview;

        // WHEN
        Test.startTest();

        eventReminder.emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event 
            WHERE StartDateTime >= :nextWeekDayBegin 
                AND StartDateTime < :nextWeekDayEnd
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                TextBody, 
                Subject, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage
        ];

        for (EmailMessage retrievedEmailMessage : retrievedEmailMessages) {
            System.debug('retrievedEmailMessage = ' + retrievedEmailMessage);
        }

        System.assertEquals(1, retrievedEmailMessages.size(), 'Expect 1 email message');
    }

    @IsTest
    private static void send_one_email_reminder_on_Friday_for_one_event_on_Monday() {
        // GIVEN
        EventReminder eventReminder = new EventReminder();

        Date friday = Date.valueOf(eventReminder.now).toStartOfWeek() - 2;

        eventReminder.now = Datetime.valueOf(friday + ' 00:00:00');

        Datetime tomorrow = eventReminder.now + 1;
        Datetime dayAftertomorrow = tomorrow + 1;
        Datetime monday = dayAftertomorrow + 1;

        Integer year;
        Integer month;
        Integer day;

        Datetime nextWeekDayBegin;
        Datetime nextWeekDayEnd;

        if (tomorrow.format('E') != 'Sat' && tomorrow.format('E') != 'Sun') {
            year = tomorrow.year();
            month = tomorrow.month();
            day = tomorrow.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') != 'Sat' && dayAftertomorrow.format('E') != 'Sun')
        ) {
            year = dayAftertomorrow.year();
            month = dayAftertomorrow.month();
            day = dayAftertomorrow.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') == 'Sat' || dayAftertomorrow.format('E') == 'Sun')
        ) {
            year = monday.year();
            month = monday.month();
            day = monday.day();

            nextWeekDayBegin = Datetime.newInstance(year, month, day, 00, 00, 00);
            nextWeekDayEnd = nextWeekDayBegin + 1;
        }

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        insert accBlackthorn;

        Contact contactThornie = new Contact(LastName = 'Thornie', AccountId = accBlackthorn.Id);

        insert contactThornie;

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(year, month, day, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(year, month, day, 20, 00, 00), 
            Location = 'no where', 
            WhoId = contactThornie.Id, 
            Type = 'Informational Interview', 
            Interview_Format__c = '1-on-1', 
            Description = 'Description'

        );

        insert informationalInterview;

        // WHEN
        Test.startTest();

        eventReminder.emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event 
            WHERE StartDateTime >= :nextWeekDayBegin 
                AND StartDateTime < :nextWeekDayEnd
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                TextBody, 
                Subject, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage
        ];

        for (EmailMessage retrievedEmailMessage : retrievedEmailMessages) {
            System.debug('retrievedEmailMessage = ' + retrievedEmailMessage);
        }

        System.assertEquals(1, retrievedEmailMessages.size(), 'Expect 1 email message');
    }

    @IsTest
    private static void send_zero_email_reminder() {
        // GIVEN

        // WHEN
        Test.startTest();

        new EventReminder().emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event
        ];

        System.assertEquals(0, retrievedEvents.size(), 'Expect 0 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                Id, 
                TextBody, 
                Subject, 
                FromAddress, 
                ToAddress, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage
        ];

        for (EmailMessage retrievedEmailMessage : retrievedEmailMessages) {
            System.debug('retrievedEmailMessage = ' + retrievedEmailMessage);
        }

        System.assertEquals(0, retrievedEmailMessages.size(), 'Expect 0 email message');
    }
}