@IsTest
private with sharing class JobControllerTest {
    @TestSetup
    private static void setup() {
        List<Job__c> jobsToInsert = new List<Job__c>();

        Job__c jobJrSFDev = new Job__c(
            Title__c = 'Junior Salesforce Developer', 
            Location__c = 'New York, NY', 
            Snippet__c = 'No actual work experience—no problem. Apply if you got the skills to do the work.', 
            Salary__c = '$3,210 per week', 
            Source__c = 'nowhere.com', 
            Type__c = 'Full-time', 
            Link__c = 'https://careers.codeeveryday.com/en/jobs', 
            Company__c = 'CodeEveryDay', 
            Id__c = '-1234567890123456789'
        );

        jobsToInsert.add(jobJrSFDev);

        Job__c jobSFDev = new Job__c(
            Title__c = 'Salesforce Developer', 
            Location__c = 'Jacksonville, FL', 
            Snippet__c = '', 
            Salary__c = '$90.1 - $95.9 per hour', 
            Source__c = 'somewhere.com', 
            Type__c = 'Part-time', 
            Link__c = 'https://careers.salesforce.com/en/jobs', 
            Company__c = 'Salesforce', 
            Id__c = '-2885668755075351000'
        );

        jobsToInsert.add(jobSFDev);

        Job__c jobSrSFDev = new Job__c(
            Title__c = 'Sr Salesforce Developer', 
            Location__c = 'Tampa, FL', 
            Snippet__c = '...POSITION Sr Salesforce Developer LOCATION Tampa FL Hybrid DURATION 6 months INTERVIEW TYPE Video REQUIRED SKILLS Financial Services experience highly preferred Needs a background in other programming...', 
            Salary__c = '$90.25k - $100.75k', 
            Source__c = 'drjobs.ae', 
            Type__c = 'Temporary', 
            Link__c = 'https://jooble.org/desc/6407669124240902847?ckey=Salesforce+Developer&rgn=10&pos=20&groupId=40906&elckey=6560772729242811828&p=1&aq=426136413298815402&cid=3389&jobAge=133&relb=100&brelb=100&bscr=7124.704&scr=7124.704000000001', 
            Company__c = 'Hirekeyz Inc', 
            Id__c = '6407669124240903000'
        );

        jobsToInsert.add(jobSrSFDev);

        insert jobsToInsert;
    }

    @IsTest
    private static void queryJobs_ExpectThreeRetrievedJobs() {
        // GIVEN

        // WHEN
        Test.startTest();

        List<Job__c> retrievedJobs = JobController.queryJobs();

        Test.stopTest();

        // THEN
        System.assertEquals(3, retrievedJobs.size(), 'Expect 3 retrieved jobs');
    }

    @IsTest
    private static void deleteJobs_ExpectZeroJobsAfterDeletion() {
        // GIVEN

        // WHEN
        Test.startTest();

        List<Job__c> jobs = JobController.queryJobs();

        List<String> recordIds = new List<String>();

        for (Job__c job : jobs) {
            recordIds.add(job.Id);
        }

        JobController.deleteJobs(recordIds);

        Test.stopTest();

        // THEN
        List<Job__c> retrievedJobs = [
            SELECT Id 
            FROM Job__c
        ];

        System.assertEquals(0, retrievedJobs.size(), 'Expect 0 jobs after deletion');
    }
}