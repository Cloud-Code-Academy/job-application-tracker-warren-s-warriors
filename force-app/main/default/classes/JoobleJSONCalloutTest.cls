@IsTest
private with sharing class JoobleJSONCalloutTest {
    @IsTest
    private static void makePOSTCallout_ExpectTwoRetrievedAccountsAndTwoJobApplicationsWithSavedStatusCreated() {
        // GIVEN
        Test.setMock(HttpCalloutMock.class, new JoobleJSONCalloutMockGenerator());

        insert new Account(Name = 'Salesforce');

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
                URL__c, 
                Job_Id__c 
            FROM Job_Application__c 
            WHERE Status__c = 'Saved' 
        ];

        for (Job_Application__c retrievedJobApplication : retrievedJobApplications) {
            if (retrievedJobApplication.Job_Id__c == '-2885668755075350954') {
                System.assertEquals('Salesforce Developer', retrievedJobApplication.Position_Title__c);
                System.assertEquals('Jacksonville, FL', retrievedJobApplication.Location__c);
                System.assertEquals('This is the greatest entry level job!', retrievedJobApplication.Notes__c);
                System.assertEquals(125000, retrievedJobApplication.Salary__c);
                System.assertEquals('https://careers.salesforce.com/en/jobs', retrievedJobApplication.URL__c);
            }
        }

        for (Job_Application__c retrievedJobApplication : retrievedJobApplications) {
            if (retrievedJobApplication.Job_Id__c == '-6407669124240902847') {
                System.assertEquals('Sr Salesforce Developer', retrievedJobApplication.Position_Title__c);
                System.assertEquals('Tampa, FL', retrievedJobApplication.Location__c);
                System.assertEquals(
                    '&nbsp;...POSITION  \r\n  Sr <b>Salesforce Developer </b> \r\n\r\n     LOCATION  \r\n  Tampa FL Hybrid  \r\n\r\n     DURATION  \r\n 6 months  \r\n\r\n     INTERVIEW TYPE  \r\n  Video  \r\n\r\n     REQUIRED SKILLS  \r\n  \r\n Financial Services experience highly preferred   \r\n Needs a background in other programming...&nbsp;', 
                    retrievedJobApplication.Notes__c
                );
                System.assertEquals(null, retrievedJobApplication.Salary__c);
                System.assertEquals(
                    'https://jooble.org/desc/6407669124240902847?ckey=Salesforce+Developer&rgn=10&pos=20&groupId=40906&elckey=6560772729242811828&p=1&aq=426136413298815402&cid=3389&jobAge=133&relb=100&brelb=100&bscr=7124.704&scr=7124.704000000001', 
                    retrievedJobApplication.URL__c
                );
            }
        }
    }
}