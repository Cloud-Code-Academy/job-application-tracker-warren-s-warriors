public with sharing class JobApplicationCleaningScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.debug('sc.getTriggerId() = ' + sc.getTriggerId());

        JobApplicationCleaningQueueable queueableJob = new JobApplicationCleaningQueueable();

        Id jobId = System.enqueueJob(queueableJob);

        AsyncApexJob jobInfo = [
            SELECT 
                Status, 
                TotalJobItems, 
                JobItemsProcessed, 
                NumberOfErrors 
            FROM AsyncApexJob 
            WHERE Id = :jobId 
            WITH USER_MODE 
            LIMIT 1
        ];

        System.debug('jobInfo = ' + jobInfo);

        System.assertEquals('Queued', jobInfo.Status, 'Expect Status to be Queued');
        System.assertEquals(0, jobInfo.TotalJobItems, 'Expect 0 TotalJobItems');
        System.assertEquals(0, jobInfo.JobItemsProcessed, 'Expect 0 JobItemsProcessed');
        System.assertEquals(0, jobInfo.NumberOfErrors, 'Expect 0 NumberOfErrors');
    }
}