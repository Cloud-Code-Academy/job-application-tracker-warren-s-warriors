public with sharing class JobApplicationCleaningQueueable implements Queueable {
    public void execute(QueueableContext context) {
        List<Job_Application__c> staleJobApplications = [
            SELECT 
                Status__c, 
                Follow_Up_Date__c 
            FROM Job_Application__c 
            WHERE Status__c NOT IN (
                    'Closed', 
                    'Accepted'
                ) 
                AND Follow_Up_Date__c != null 
                AND Follow_Up_Date__c <= N_DAYS_AGO:30
        ];

        delete staleJobApplications;
    }
}