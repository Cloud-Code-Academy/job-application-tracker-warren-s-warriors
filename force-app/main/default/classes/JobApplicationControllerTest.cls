@IsTest
private with sharing class JobApplicationControllerTest {
    @TestSetup
    private static void setup() {
        List<Job__c> jobsToInsert = new List<Job__c>();

        Job__c jobJrSFDev = new Job__c(
            Title__c = 'Junior Salesforce Developer', 
            Location__c = 'Brooklyn, NY', 
            Snippet__c = '...No actual work experience No problem Apply if you got the skills to do the work...', 
            Salary__c = '$3,210 per week', 
            Source__c = 'nowhere.com', 
            Type__c = 'Full-time', 
            Link__c = 'https://careers.codeeveryday.com/en/jobs', 
            Company__c = 'CodeEveryDay', 
            Updated__c = Datetime.now() - 30, 
            Id__c = '-1234567890123456789'
        );

        jobsToInsert.add(jobJrSFDev);

        Job__c jobSFDev = new Job__c(
            Title__c = 'Salesforce Developer', 
            Location__c = 'New York, NY', 
            Snippet__c = '', 
            Salary__c = '$90.1 - $95.9 per hour', 
            Source__c = '', 
            Type__c = 'Temporary', 
            Link__c = 'https://careers.salesforce.com/en/jobs', 
            Company__c = 'Salesforce', 
            Id__c = '-2885668755075351000'
        );

        jobsToInsert.add(jobSFDev);

        Job__c jobTempSFDev = new Job__c(
            Title__c = 'Temporary Salesforce Developer', 
            Location__c = 'Staten Island, NY', 
            Snippet__c = '', 
            Salary__c = '', 
            Source__c = 'somewhere.com', 
            Type__c = 'Temporary', 
            Link__c = '', 
            Company__c = 'Temporary Devs', 
            Id__c = '-1234567890987654321'
        );

        jobsToInsert.add(jobTempSFDev);

        Job__c jobSrSFDev = new Job__c(
            Title__c = 'Sr Salesforce Developer', 
            Location__c = 'Queens, NY', 
            Snippet__c = '', 
            Salary__c = '', 
            Source__c = '', 
            Type__c = 'Temporary', 
            Link__c = 'https://jooble.org/desc/6407669124240902847?ckey=Salesforce+Developer&rgn=10&pos=20&groupId=40906&elckey=6560772729242811828&p=1&aq=426136413298815402&cid=3389&jobAge=133&relb=100&brelb=100&bscr=7124.704&scr=7124.704000000001', 
            Company__c = 'Hirekeyz Inc', 
            Updated__c = Datetime.now() - 30, 
            Id__c = '6407669124240903000'
        );

        jobsToInsert.add(jobSrSFDev);

        insert jobsToInsert;

        List<Account> acctsToInsert = new List<Account>();

        Account accCodeEveryDay = new Account(Name = jobJrSFDev.Company__c);

        acctsToInsert.add(accCodeEveryDay);

        Account accSalesforce = new Account(Name = jobSFDev.Company__c);

        acctsToInsert.add(accSalesforce);

        insert acctsToInsert;

        List<Job_Application__c> jobApplicationsToInsert = new List<Job_Application__c>();

        Job_Application__c jobApplicationJrSFDev = new Job_Application__c(
            Status__c = 'Interviewing', 
            Position_Title__c = jobJrSFDev.Title__c, 
            Company__c = accCodeEveryDay.Id, 
            Job_Id__c = jobJrSFDev.Id__c
        );

        jobApplicationsToInsert.add(jobApplicationJrSFDev);

        Job_Application__c jobApplicationSFDev = new Job_Application__c(
            Position_Title__c = jobSFDev.Title__c, 
            Company__c = accSalesforce.Id, 
            Job_Id__c = jobSFDev.Id__c
        );

        jobApplicationsToInsert.add(jobApplicationSFDev);

        insert jobApplicationsToInsert;
    }

    @IsTest
    private static void upsert_job_applications_results_in_four_accounts_and_three_job_applications_with_Saved_status() {
        // GIVEN
        List<Job__c> jobs = [
            SELECT Id 
            FROM Job__c
        ];

        List<String> recordIds = new List<String>();

        for (Job__c job : jobs) {
            recordIds.add(job.Id);
        }

        // WHEN
        Test.startTest();

        JobApplicationController.upsertJobApplications(recordIds);

        Test.stopTest();

        // THEN
        List<Account> retrievedAccts = [
            SELECT Id 
            FROM Account
        ];

        System.assertEquals(4, retrievedAccts.size(), 'Expect 4 accounts');

        List<Job_Application__c> retrievedJobApplications = [
            SELECT Id 
            FROM Job_Application__c 
            WHERE Status__c = 'Saved'
        ];

        System.assertEquals(3, retrievedJobApplications.size(), 'Expect 3 job applications with Saved status');
    }
}