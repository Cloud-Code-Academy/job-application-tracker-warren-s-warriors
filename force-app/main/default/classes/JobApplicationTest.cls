@IsTest
private with sharing class JobApplicationTest {
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
    private static void application_date_cannot_be_after_follow_up_date() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBearId = contactIdMap.get('Bear');

        Job_Application__c jobApplicationSalesforce = new Job_Application__c(
            Rating__c = '3 Star', 
            Notes__c = 'Notes', 
            Position_Title__c = 'Junior Salesforce Developer', 
            Work_Model__c = 'Onsite', 
            Location__c = 'San Francisco, CA', 
            Job_Type__c = 'Temporary', 
            Salary__c = 50000, 
            URL__c = 'https://careers.salesforce.com', 
            Job_Description__c = 'Description', 
            Company__c = accSalesforceId, 
            Primary_Contact__c = contactBearId
        );

        // WHEN
        Test.startTest();

        insert jobApplicationSalesforce;

        jobApplicationSalesforce.Application_Date__c = Date.today() + 1;
        jobApplicationSalesforce.Follow_Up_Date__c = Date.today();

        try {
            update jobApplicationSalesforce;

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.debug('Exception message = ' + e.getMessage());

            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Application Date cannot be after Follow-Up Date', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
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

    @IsTest
    private static void creates_two_tasks_if_job_application_status_is_Saved() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_createTaskWhenStatusIsSaved(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                )
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Saved';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Saved';
            }
        }

        delete [SELECT Id FROM Task];

        // WHEN
        Test.startTest();

        insert jobApplicationsToInsert;

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Saved';
            }
        }

        update jobApplicationsToUpdate;

        Test.stopTest();

        // THEN
        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = 'Things to do for a job saved' 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = 'Low'
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void creates_two_tasks_if_job_application_status_is_Applying() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_createTaskWhenStatusIsApplying(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                )
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applying';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Applying';
            }
        }

        delete [SELECT Id FROM Task];

        // WHEN
        Test.startTest();

        insert jobApplicationsToInsert;

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applying';
            }
        }

        update jobApplicationsToUpdate;

        Test.stopTest();

        // THEN
        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = 'Things to do for a job to apply' 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = 'Normal'
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void creates_two_tasks_if_job_application_status_is_Applied() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_createTaskWhenStatusIsApplied(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                )
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applied';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Applied';
            }
        }

        delete [SELECT Id FROM Task];

        // WHEN
        Test.startTest();

        insert jobApplicationsToInsert;

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applied';
            }
        }

        update jobApplicationsToUpdate;

        Test.stopTest();

        // THEN
        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = 'Things to do after applying for a job' 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = 'Normal'
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void creates_two_tasks_if_job_application_status_is_Interviewing() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_createTaskWhenStatusIsInterviewing(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                )
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Interviewing';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Interviewing';
            }
        }

        delete [SELECT Id FROM Task];

        // WHEN
        Test.startTest();

        insert jobApplicationsToInsert;

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Interviewing';
            }
        }

        update jobApplicationsToUpdate;

        Test.stopTest();

        // THEN
        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = 'Interview prep' 
                AND ActivityDate = TOMORROW 
                AND Priority = 'High'
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void creates_two_tasks_if_job_application_status_is_Negotiating() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_createTaskWhenStatusIsNegotiating(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                )
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Negotiating';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Negotiating';
            }
        }

        delete [SELECT Id FROM Task];

        // WHEN
        Test.startTest();

        insert jobApplicationsToInsert;

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Negotiating';
            }
        }

        update jobApplicationsToUpdate;

        Test.stopTest();

        // THEN
        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = 'Negotiation prep' 
                AND ActivityDate = TOMORROW 
                AND Priority = 'High'
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void creates_two_tasks_if_job_application_status_is_Accepted() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_createTaskWhenStatusIsAccepted(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                )
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Accepted';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Accepted';
            }
        }

        delete [SELECT Id FROM Task];

        // WHEN
        Test.startTest();

        insert jobApplicationsToInsert;

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Accepted';
            }
        }

        update jobApplicationsToUpdate;

        Test.stopTest();

        // THEN
        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = 'Celebration' 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = 'Low'
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void creates_two_tasks_if_job_application_status_is_Closed() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_createTaskWhenStatusIsClosed(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                )
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Closed';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Closed';
            }
        }

        delete [SELECT Id FROM Task];

        // WHEN
        Test.startTest();

        insert jobApplicationsToInsert;

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        update jobApplicationsToUpdate;

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Closed';
            }
        }

        update jobApplicationsToUpdate;

        Test.stopTest();

        // THEN
        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = 'Closed job application' 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = 'Normal'
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void updates_job_applications_primary_contact() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactThornieId = contactIdMap.get('Thornie');
        Id contactHudsonId = contactIdMap.get('Hudson');
        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Contact> contactsToUpdate = [
            SELECT 
                LastName, 
                AccountId 
            FROM Contact 
            WHERE Id = :contactThornieId 
            LIMIT 1
        ];

        for (Contact contactToUpdate : contactsToUpdate) {
            if (contactToUpdate.LastName == 'Thornie') {
                contactToUpdate.AccountId = accBlackthornId;
            }
        }

        update contactsToUpdate;

        // only Blackthorn account has a related contact

        List<Job_Application__c> jobApplications = new TestDataFactory().createJobApplications_setPrimaryContact(
            accBlackthornId, 
            accHTSId, 
            contactBoozId
        );

        // 12 job applications
            // acc = Blackthorn | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Blackthorn | no contact related list | primary contact = Booz
            // acc = Blackthorn | contact related list = Hudson, Bear | no primary contact
            // acc = Blackthorn | no contact related list | no primary contact

            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Hudson Technology Systems | no contact related list | primary contact = Booz
            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | no primary contact
            // acc = Hudson Technology Systems | no contact related list | no primary contact

            // no acc | contact related list = Hudson, Bear | primary contact = Booz
            // no acc | no contact related list | primary contact = Booz
            // no acc | contact related list = Hudson, Bear | no primary contact
            // no acc | no contact related list | no primary contact

        // WHEN
        Test.startTest();

        insert jobApplications;

        // THEN
        List<Job_Application__c> retrievedJobApplicationsAfterInsert = [
            SELECT 
                Id, 
                Primary_Contact__c, 
                Position_Title__c 
            FROM Job_Application__c 
            WHERE Id IN :jobApplications
        ];

        List<Job_Application__c> retrievedJobApplicationsAfterInsert_Thornie = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterInsert_Hudson = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterInsert_Booz = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterInsert_Bear = new List<Job_Application__c>();

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterInsert) {
            if (retrievedJobApplication.Primary_Contact__c == contactThornieId) {
                retrievedJobApplicationsAfterInsert_Thornie.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactHudsonId) {
                retrievedJobApplicationsAfterInsert_Hudson.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBoozId) {
                retrievedJobApplicationsAfterInsert_Booz.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBearId) {
                retrievedJobApplicationsAfterInsert_Bear.add(retrievedJobApplication);
            }
        }

        System.assertEquals(2, retrievedJobApplicationsAfterInsert_Thornie.size(), 'Expect 2 job applications with Thornie as primary contact');
        System.assertEquals(0, retrievedJobApplicationsAfterInsert_Hudson.size(), 'Expect 0 job application with Hudson as primary contact');
        System.assertEquals(6, retrievedJobApplicationsAfterInsert_Booz.size(), 'Expect 6 job applications with Booz as primary contact');
        System.assertEquals(0, retrievedJobApplicationsAfterInsert_Bear.size(), 'Expect 0 job application with Bear as primary contact');

        Id jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId;
        Id jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId;
        Id jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId;
        Id jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId;
        Id jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId;
        Id jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId;

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterInsert) {
            if (retrievedJobApplication.Position_Title__c == 'jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz') {
                jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact') {
                jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz') {
                jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact') {
                jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz') {
                jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact') {
                jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else {
                retrievedJobApplication.Primary_Contact__c = null;
            }
        }

        List<Job_Application_Contact__c> jobApplicationContacts = new TestDataFactory().createJobApplicationContacts_setPrimaryContact(
            contactHudsonId, 
            contactBearId, 
            jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId, 
            jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId, 
            jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId, 
            jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId, 
            jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId, 
            jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
        );

        insert jobApplicationContacts;

        update retrievedJobApplicationsAfterInsert;

        Test.stopTest();

        List<Job_Application__c> retrievedJobApplicationsAfterUpdate = [
            SELECT Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Id IN :retrievedJobApplicationsAfterInsert
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

        System.assertEquals(2, retrievedJobApplicationsAfterUpdate_Thornie.size(), 'Expect 2 job applications with Thornie as primary contact');
        System.assertEquals(6, retrievedJobApplicationsAfterUpdate_Hudson.size(), 'Expect 6 job applications with Hudson as primary contact');
        System.assertEquals(0, retrievedJobApplicationsAfterUpdate_Booz.size(), 'Expect 0 job application with Booz as primary contact');
        System.assertEquals(0, retrievedJobApplicationsAfterUpdate_Bear.size(), 'Expect 0 job application with Bear as primary contact');
    }
}