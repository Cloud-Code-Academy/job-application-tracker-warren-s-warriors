@IsTest
private with sharing class EventReminderTest {
    // @TestSetup
    // private static void setup() {}

    @IsTest
    private static void emailUserDayBeforeInterview_ExpectOneEventAndOneEmailMessage() {
        // GIVEN
        Datetime tomorrow = Datetime.now() + 1;
        Datetime dayAftertomorrow = tomorrow + 1;
        Datetime monday = dayAftertomorrow + 1;

        Integer year;
        Integer month;
        Integer day;

        Integer n;

        if (tomorrow.format('E') != 'Sat' && tomorrow.format('E') != 'Sun') {
            year = tomorrow.year();
            month = tomorrow.month();
            day = tomorrow.day();

            n = 1;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') != 'Sat' && dayAftertomorrow.format('E') != 'Sun')
        ) {
            year = dayAftertomorrow.year();
            month = dayAftertomorrow.month();
            day = dayAftertomorrow.day();

            n = 2;
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') == 'Sat' || dayAftertomorrow.format('E') == 'Sun')
        ) {
            year = monday.year();
            month = monday.month();
            day = monday.day();

            n = 3;
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

        new EventReminder().emailUserDayBeforeInterview();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = Database.query(
            'SELECT Id ' 
            + 'FROM Event ' 
            + 'WHERE StartDateTime = NEXT_N_DAYS:' + n
        );

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
    private static void emailUserDayBeforeInterview_ExpectZeroEventAndZeroEmailMessage() {
        // GIVEN

        // WHEN
        Test.startTest();

        new EventReminder().emailUserDayBeforeInterview();

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