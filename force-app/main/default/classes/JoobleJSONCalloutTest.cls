@IsTest
private with sharing class JoobleJSONCalloutTest {
    @IsTest
    private static void makePOSTCallout_ExpectThreeRetrievedJobs() {
        // GIVEN
        Test.setMock(HttpCalloutMock.class, new JoobleJSONCalloutMockGenerator());

        // WHEN
        Test.startTest();

        JoobleJSONCallout.makePOSTCallout(
            'Junior Salesforce Developer', 
            'Florida', 
            '25', 
            50000, 
            '2024-04-15', 
            '1', 
            '50'
        );

        Test.stopTest();

        // THEN
        List<Job__c> retrievedJobs = [
            SELECT 
                Title__c, 
                Location__c, 
                Salary__c, 
                Source__c, 
                Type__c, 
                Link__c, 
                Company__c, 
                Id__c 
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
                    'Part-time', 
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
}