public with sharing class JobController {
    @AuraEnabled(cacheable=true)
    public static List<Job__c> queryJobs() {
        return [
            SELECT 
                Id, 
                Title__c, 
                Company__c, 
                Location__c, 
                Type__c, 
                Salary__c, 
                Snippet__c, 
                Link__c, 
                Source__c, 
                Updated__c, 
                Id__c 
            FROM Job__c
        ];
    }

    @AuraEnabled
    public static void deleteJobs(List<String> recordIds) {
        delete [SELECT Id FROM Job__c WHERE Id IN :recordIds];
    }

    @AuraEnabled
    public static void deleteAllJobs() {
        delete [SELECT Id FROM Job__c];
    }
}