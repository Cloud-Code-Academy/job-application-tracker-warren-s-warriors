@IsTest
private with sharing class JoobleJSONCalloutTest {
    @IsTest
    private static void make_POST_callout_creates_three_jobs() {
        // GIVEN
        Test.setMock(HttpCalloutMock.class, new JoobleJSONCalloutMockGenerator());

        // WHEN
        Test.startTest();

        JoobleJSONCallout.makePOSTCallout(
            'Junior Salesforce Developer', 
            'Remote', 
            '25', 
            50000, 
            '2024-04-15', 
            '1', 
            '100'
        );

        Test.stopTest();

        // THEN
        List<Job__c> retrievedJobs = [
            SELECT Id 
            FROM Job__c 
            WHERE Title__c LIKE '%Salesforce Developer%' 
                AND Location__c LIKE '%FL%' 
                AND Salary__c IN (
                    '$1,234 per week', 
                    '$90.1 - $95.9 per hour', 
                    '$90.25k - $100.75k'
                )
                AND Source__c IN (
                    'nowhere.com', 
                    'somewhere.com', 
                    'drjobs.ae'
                )
                AND Type__c IN (
                    'Full-time', 
                    'Temporary'
                )
                AND Company__c IN (
                    'CodeEveryDay', 
                    'Salesforce', 
                    'Hirekeyz Inc'
                )
                AND Id__c IN (
                    '-1234567890123456789', 
                    '-2885668755075351000', 
                    '6407669124240903000'
                )
        ];

        System.assertEquals(3, retrievedJobs.size(), 'Expect 3 retrieved jobs');
    }

    @IsTest
    private static void make_POST_callout_fails() {
        // GIVEN
        Test.setMock(HttpCalloutMock.class, new JoobleJSONCalloutMockGeneratorFailure());

        // WHEN
        Test.startTest();

        try {
            JoobleJSONCallout.makePOSTCallout(
                null, 
                null, 
                null, 
                null, 
                null, 
                null, 
                null
            );

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'HTTP request failed | Status Code: 500', 
                e.getMessage(), 
                'Exception message does not match: ' + e.getMessage()
            );
        }

        List<Job__c> retrievedJobs = [
            SELECT Id 
            FROM Job__c
        ];

        System.assertEquals(0, retrievedJobs.size(), 'Expect 0 retrieved job');
    }
}