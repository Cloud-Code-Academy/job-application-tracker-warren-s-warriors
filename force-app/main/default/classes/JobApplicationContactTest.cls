@IsTest
private with sharing class JobApplicationContactTest {
    @TestSetup
    private static void setup() {
        TestDataFactory testDataFactory = new TestDataFactory();

        List<Account> acctsToInsert = testDataFactory.createAccts_setup();

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        acctsToInsert.add(accBlackthorn);

        Account accHTS = new Account(Name = 'Hudson Technology Systems');

        acctsToInsert.add(accHTS);

        insert acctsToInsert;

        List<Contact> contactsToInsert = testDataFactory.createContacts_setup();

        Contact contactThornie = new Contact(LastName = 'Thornie');

        contactsToInsert.add(contactThornie);

        Contact contactHudson = new Contact(LastName = 'Hudson');

        contactsToInsert.add(contactHudson);

        insert contactsToInsert;

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_setup(
            accBlackthorn.Id, 
            contactThornie.Id, 
            accHTS.Id, 
            contactHudson.Id
        );

        insert jobApplicationsToInsert;
    }

    @IsTest
    private static void updates_job_applications_primary_contact() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactThornieId = contactIdMap.get('Thornie');
        Id contactHudsonId = contactIdMap.get('Hudson');
        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplications = new TestDataFactory().createJobApplications_setPrimaryContact(
            accBAHId, 
            accSalesforceId
        );

        insert jobApplications;

        List<Job_Application__c> retrievedJobApplicationsAfterInsertingApplications = [
            SELECT 
                Id, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId, 
                    :accBAHId, 
                    :accSalesforceId
                )
        ];

        Id jobApplicationBlackthornId;
        Id jobApplicationHTSId;
        Id jobApplicationBAHId;
        Id jobApplicationSalesforceId;

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterInsertingApplications) {
            if (retrievedJobApplication.Company__c == accBlackthornId) {
                jobApplicationBlackthornId = retrievedJobApplication.Id;
            } else if (retrievedJobApplication.Company__c == accHTSId) {
                jobApplicationHTSId = retrievedJobApplication.Id;
            } else if (retrievedJobApplication.Company__c == accBAHId) {
                jobApplicationBAHId = retrievedJobApplication.Id;
            } else if (retrievedJobApplication.Company__c == accSalesforceId) {
                jobApplicationSalesforceId = retrievedJobApplication.Id;
            }
        }

        List<Job_Application_Contact__c> jobApplicationContacts = new TestDataFactory().createJobApplicationContacts_setPrimaryContact(
            contactBoozId, 
            contactBearId, 
            jobApplicationBlackthornId, 
            jobApplicationHTSId, 
            jobApplicationBAHId, 
            jobApplicationSalesforceId
        );

        // WHEN
        Test.startTest();

        insert jobApplicationContacts;

        Test.stopTest();

        // THEN
        List<Job_Application__c> retrievedJobApplicationsAfterInsertingContacts = [
            SELECT Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Id IN :retrievedJobApplicationsAfterInsertingApplications
        ];

        List<Job_Application__c> retrievedJobApplicationsAfterInsertingContacts_Thornie = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterInsertingContacts_Hudson = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterInsertingContacts_Booz = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterInsertingContacts_Bear = new List<Job_Application__c>();

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterInsertingContacts) {
            if (retrievedJobApplication.Primary_Contact__c == contactThornieId) {
                retrievedJobApplicationsAfterInsertingContacts_Thornie.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactHudsonId) {
                retrievedJobApplicationsAfterInsertingContacts_Hudson.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBoozId) {
                retrievedJobApplicationsAfterInsertingContacts_Booz.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBearId) {
                retrievedJobApplicationsAfterInsertingContacts_Bear.add(retrievedJobApplication);
            }
        }

        System.assertEquals(1, retrievedJobApplicationsAfterInsertingContacts_Thornie.size(), 'Expect 1 job application with Thornie as primary contact');
        System.assertEquals(1, retrievedJobApplicationsAfterInsertingContacts_Hudson.size(), 'Expect 1 job application with Hudson as primary contact');
        System.assertEquals(1, retrievedJobApplicationsAfterInsertingContacts_Booz.size(), 'Expect 1 job application with Booz as primary contact');
        System.assertEquals(1, retrievedJobApplicationsAfterInsertingContacts_Bear.size(), 'Expect 1 job application with Bear as primary contact');

        for (Job_Application_Contact__c jobApplicationContact : jobApplicationContacts) {
            jobApplicationContact.Contact__c = null;
        }

        update jobApplicationContacts;

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterInsertingContacts) {
            retrievedJobApplication.Primary_Contact__c = null;
        }

        update retrievedJobApplicationsAfterInsertingContacts;

        for (Job_Application_Contact__c jobApplicationContact : jobApplicationContacts) {
            if (jobApplicationContact.Job_Application__c == jobApplicationBlackthornId) {
                jobApplicationContact.Contact__c = contactThornieId;
            } else if (jobApplicationContact.Job_Application__c == jobApplicationHTSId) {
                jobApplicationContact.Contact__c = contactHudsonId;
            } else if (jobApplicationContact.Job_Application__c == jobApplicationBAHId) {
                jobApplicationContact.Contact__c = contactBoozId;
            } else if (jobApplicationContact.Job_Application__c == jobApplicationSalesforceId) {
                jobApplicationContact.Contact__c = contactBearId;
            }
        }

        update jobApplicationContacts;

        List<Job_Application__c> retrievedJobApplicationsAfterUpdate = [
            SELECT Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Id IN :retrievedJobApplicationsAfterInsertingContacts
        ];

        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Thornie = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Hudson = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Booz = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Bear = new List<Job_Application__c>();

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterUpdate) {
            if (retrievedJobApplication.Primary_Contact__c == contactThornieId) {
                retrievedJobApplicationsAfterUpdate_Thornie.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactHudsonId) {
                retrievedJobApplicationsAfterUpdate_Hudson.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBoozId) {
                retrievedJobApplicationsAfterUpdate_Booz.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBearId) {
                retrievedJobApplicationsAfterUpdate_Bear.add(retrievedJobApplication);
            }
        }

        System.assertEquals(1, retrievedJobApplicationsAfterUpdate_Thornie.size(), 'Expect 1 job application with Thornie as primary contact');
        System.assertEquals(1, retrievedJobApplicationsAfterUpdate_Hudson.size(), 'Expect 1 job application with Hudson as primary contact');
        System.assertEquals(1, retrievedJobApplicationsAfterUpdate_Booz.size(), 'Expect 1 job application with Booz as primary contact');
        System.assertEquals(1, retrievedJobApplicationsAfterUpdate_Bear.size(), 'Expect 1 job application with Bear as primary contact');
    }

    private static Map<String, Id> getAccIdMap() {
        List<Account> retrievedAccts = [
            SELECT 
                Id, 
                Name 
            FROM Account 
            WHERE Name IN (
                    'Blackthorn', 
                    'Hudson Technology Systems', 
                    'Booz Allen Hamilton', 
                    'Salesforce'
                )
        ];

        Map<String, Id> accIdMap = new Map<String, Id>();

        for (Account retrievedAcct : retrievedAccts) {
            if (retrievedAcct.Name == 'Blackthorn') {
                accIdMap.put('Blackthorn', retrievedAcct.Id);
            } else if (retrievedAcct.Name == 'Hudson Technology Systems') {
                accIdMap.put('HTS', retrievedAcct.Id);
            } else if (retrievedAcct.Name == 'Booz Allen Hamilton') {
                accIdMap.put('BAH', retrievedAcct.Id);
            } else if (retrievedAcct.Name == 'Salesforce') {
                accIdMap.put('Salesforce', retrievedAcct.Id);
            }
        }

        return accIdMap;
    }

    private static Map<String, Id> getContactIdMap() {
        List<Contact> retrievedContacts = [
            SELECT 
                Id, 
                LastName 
            FROM Contact 
            WHERE LastName IN (
                    'Thornie', 
                    'Hudson', 
                    'Booz', 
                    'Bear'
                )
        ];

        Map<String, Id> contactIdMap = new Map<String, Id>();

        for (Contact retrievedContact : retrievedContacts) {
            if (retrievedContact.LastName == 'Thornie') {
                contactIdMap.put('Thornie', retrievedContact.Id);
            } else if (retrievedContact.LastName == 'Hudson') {
                contactIdMap.put('Hudson', retrievedContact.Id);
            } else if (retrievedContact.LastName == 'Booz') {
                contactIdMap.put('Booz', retrievedContact.Id);
            } else if (retrievedContact.LastName == 'Bear') {
                contactIdMap.put('Bear', retrievedContact.Id);
            }
        }

        return contactIdMap;
    }
}