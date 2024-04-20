@IsTest
private class JobApplicationCleaningQueueableTest {
    @TestSetup
    private static void setup() {
        List<Job_Application__c> jobApplicationsToInsert = new List<Job_Application__c>();

        Job_Application__c jobApplicationSavedFollowUp29DaysAgo = new Job_Application__c(
            Status__c = 'Saved', 
            Follow_Up_Date__c = Date.today() - 29
        );

        jobApplicationsToInsert.add(jobApplicationSavedFollowUp29DaysAgo);

        Job_Application__c jobApplicationSavedFollowUp30DaysAgo = new Job_Application__c(
            Status__c = 'Saved', 
            Follow_Up_Date__c = Date.today() - 30
        );

        jobApplicationsToInsert.add(jobApplicationSavedFollowUp30DaysAgo);

        Job_Application__c jobApplicationApplyingFollowUp29DaysAgo = new Job_Application__c(
            Status__c = 'Applying', 
            Follow_Up_Date__c = Date.today() - 29, 
            Notes__c = 'test note'
        );

        jobApplicationsToInsert.add(jobApplicationApplyingFollowUp29DaysAgo);

        Job_Application__c jobApplicationApplyingFollowUp30DaysAgo = new Job_Application__c(
            Status__c = 'Applying', 
            Follow_Up_Date__c = Date.today() - 30, 
            Notes__c = 'test note'
        );

        jobApplicationsToInsert.add(jobApplicationApplyingFollowUp30DaysAgo);

        Job_Application__c jobApplicationAcceptedFollowUp29DaysAgo = new Job_Application__c(
            Status__c = 'Accepted', 
            Follow_Up_Date__c = Date.today() - 29
        );

        jobApplicationsToInsert.add(jobApplicationAcceptedFollowUp29DaysAgo);

        Job_Application__c jobApplicationAcceptedFollowUp30DaysAgo = new Job_Application__c(
            Status__c = 'Accepted', 
            Follow_Up_Date__c = Date.today() - 30
        );

        jobApplicationsToInsert.add(jobApplicationAcceptedFollowUp30DaysAgo);

        insert jobApplicationsToInsert;
    }

    @IsTest
    private static void cleanStaleJobApplication_Enqueue_ExpectTwoStaleJobApplicationsWithClosedStatus() {
        // GIVEN

        // WHEN
        Test.startTest();

        Id jobId = System.enqueueJob(new JobApplicationCleaningQueueable());

        System.debug('jobId = ' + jobId);

        AsyncApexJob jobInfo_WHEN = [
            SELECT 
                Status, 
                TotalJobItems, 
                JobItemsProcessed, 
                NumberOfErrors 
            FROM AsyncApexJob 
            WHERE Id = :jobId 
            LIMIT 1
        ];

        System.debug('jobInfo_WHEN = ' + jobInfo_WHEN);

        System.assertEquals('Queued', jobInfo_WHEN.Status, 'Expect Status to be Queued');
        System.assertEquals(0, jobInfo_WHEN.TotalJobItems, 'Expect 0 TotalJobItems');
        System.assertEquals(0, jobInfo_WHEN.JobItemsProcessed, 'Expect 0 JobItemsProcessed');
        System.assertEquals(0, jobInfo_WHEN.NumberOfErrors, 'Expect 0 NumberOfErrors');

        Test.stopTest();

        // THEN
        List<Job_Application__c> retrievedJobApplications = [
            SELECT 
                Status__c, 
                Follow_Up_Date__c 
            FROM Job_Application__c 
            WHERE Status__c = 'Closed' 
                AND Follow_Up_Date__c != null 
                AND Follow_Up_Date__c <= N_DAYS_AGO:30
        ];

        System.assertEquals(2, retrievedJobApplications.size(), 'Expect 2 stale job applications with closed status');

        AsyncApexJob jobInfo_THEN = [
            SELECT 
                Status, 
                TotalJobItems, 
                JobItemsProcessed, 
                NumberOfErrors 
            FROM AsyncApexJob 
            WHERE Id = :jobId 
            LIMIT 1
        ];

        System.debug('jobInfo_THEN = ' + jobInfo_THEN);

        System.assertEquals('Completed', jobInfo_THEN.Status, 'Expect Status to be Completed');
        System.assertEquals(0, jobInfo_THEN.TotalJobItems, 'Expect 0 TotalJobItems');
        System.assertEquals(0, jobInfo_THEN.JobItemsProcessed, 'Expect 0 JobItemsProcessed');
        System.assertEquals(0, jobInfo_THEN.NumberOfErrors, 'Expect 0 NumberOfErrors');
    }
}