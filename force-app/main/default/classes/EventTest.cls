@IsTest
private with sharing class EventTest {
    @TestSetup
    private static void setup() {
        List<Event> eventsToInsert = new List<Event>();

        Event codeEveryDay = new Event(
            Subject = 'codeEveryDay', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 05, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00)
        );

        eventsToInsert.add(codeEveryDay);

        Event dangerousCommute = new Event(
            Subject = 'dangerousCommute', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 10, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 13, 00, 00)
        );

        eventsToInsert.add(dangerousCommute);

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 20, 00, 00)
        );

        eventsToInsert.add(informationalInterview);

        insert eventsToInsert;
    }

    @IsTest
    private static void startDT_cannot_be_after_endDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 16, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 15, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            insert phoneScreen;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_INTEGRITY_EXCEPTION, Event duration cannot be negative', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void startDT_cannot_be_after_endDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN (
                    'codeEveryDay', 
                    'informationalInterview'
                )
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 16, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 15, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            update eventsToUpdate;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_INTEGRITY_EXCEPTION, Event duration cannot be negative', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_schedule_event_on_weekend_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 07, 09, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 07, 10, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            insert phoneScreen;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot schedule event on the weekend', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_schedule_event_on_weekend_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN (
                    'codeEveryDay', 
                    'informationalInterview'
                )
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 07, 09, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 07, 10, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            update eventsToUpdate;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot schedule event on the weekend', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_existingEndDT_newEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            insert phoneScreen;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_existingEndDT_newEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN (
                    'codeEveryDay', 
                    'informationalInterview'
                )
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            update eventsToUpdate;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_newEndDT_existingEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            insert phoneScreen;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_newEndDT_existingEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN (
                    'codeEveryDay', 
                    'informationalInterview'
                )
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            update eventsToUpdate;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_existingEndDT_newEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            insert phoneScreen;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_existingEndDT_newEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN (
                    'codeEveryDay', 
                    'informationalInterview'
                )
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            update eventsToUpdate;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_newEndDT_existingEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 12, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            insert phoneScreen;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_newEndDT_existingEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN (
                    'codeEveryDay', 
                    'informationalInterview'
                )
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 12, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            update eventsToUpdate;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }
}