public with sharing class JobApplicationCleaningQueueable implements Queueable {
    public void execute(QueueableContext context) {
        List<Job_Application__c> staleJobApplications = [
            SELECT 
                Status__c, 
                Follow_Up_Date__c, 
                Notes__c 
            FROM Job_Application__c 
            WHERE Status__c NOT IN (
                    'Closed', 
                    'Accepted'
                ) 
                AND Follow_Up_Date__c != null 
                AND Follow_Up_Date__c <= N_DAYS_AGO:30
        ];

        for (Job_Application__c staleJobApplication : staleJobApplications) {
            staleJobApplication.Status__c = 'Closed';

            String note = '\n\n Update: Stale job application was closed by an automated process on ' + Datetime.now().format();

            if (String.isBlank(staleJobApplication.Notes__c)) {
                staleJobApplication.Notes__c = note.trim();
            } else {
                staleJobApplication.Notes__c += note;
            }
        }

        update staleJobApplications;
    }
}