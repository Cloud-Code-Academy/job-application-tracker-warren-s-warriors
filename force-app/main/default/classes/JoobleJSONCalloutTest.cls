@IsTest
private with sharing class JoobleJSONCalloutTest {
    @IsTest
    private static void makePOSTCallout_ExpectTwoRetrievedAccountsAndTwoJobApplicationsWithSavedStatusCreated() {
        // GIVEN
        Test.setMock(HttpCalloutMock.class, new JoobleJSONCalloutMockGenerator());

        Account accSalesforce = new Account(Name = 'Salesforce');

        insert accSalesforce;

        insert new Job_Application__c(
            Position_Title__c = 'Salesforce Developer', 
            Company__c = accSalesforce.Id, 
            Job_Id__c = '-2885668755075351000'
        );

        // WHEN
        Test.startTest();

        JoobleJSONCallout.makePOSTCallout(
            'Junior Salesforce Developer', 
            'Florida', 
            '30', 
            70000, 
            '2024-04-15', 
            '1', 
            '50'
        );

        Test.stopTest();

        // THEN
        List<Account> retrievedAccts = [
            SELECT 
                Id, 
                Name 
            FROM Account 
            WHERE Name IN (
                    'Salesforce', 
                    'Hirekeyz Inc'
                )
        ];

        System.assertEquals(2, retrievedAccts.size(), 'Expect 2 retrieved accounts');

        List<Job_Application__c> retrievedJobApplications = [
            SELECT 
                Status__c, 
                Position_Title__c, 
                Location__c, 
                Salary__c, 
                Job_Description__c, 
                URL__c, 
                Job_Id__c 
            FROM Job_Application__c 
            WHERE Status__c = 'Saved' 
                AND Position_Title__c LIKE '%Salesforce Developer%' 
                AND Location__c LIKE '%FL%' 
                AND Job_Id__c IN (
                    '-2885668755075351000', 
                    '6407669124240903000'
                )
        ];

        System.assertEquals(2, retrievedJobApplications.size(), 'Expect 2 job applications with saved status created');
    }
}