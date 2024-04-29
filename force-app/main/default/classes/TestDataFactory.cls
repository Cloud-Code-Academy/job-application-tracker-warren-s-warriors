public with sharing class TestDataFactory {
    @TestVisible
    private List<Account> createAccts_setup() {
        List<Account> accts = new List<Account>();

        Account accBAH = new Account(Name = 'Booz Allen Hamilton');

        accts.add(accBAH);

        Account accSalesforce = new Account(Name = 'Salesforce');

        accts.add(accSalesforce);

        return accts;
    }

    @TestVisible
    private List<Contact> createContacts_setup() {
        List<Contact> contacts = new List<Contact>();

        Contact contactBooz = new Contact(LastName = 'Booz');

        contacts.add(contactBooz);

        Contact contactBear = new Contact(LastName = 'Bear');

        contacts.add(contactBear);

        return contacts;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setup(
        Id accBlackthornId, 
        Id contactThornieId, 
        Id accHTSId, 
        Id contactHudsonId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBlackthorn = createJobApplication(
            null, 
            'jobApplicationBlackthorn', 
            accBlackthornId, 
            contactThornieId
        );

        jobApplications.add(jobApplicationBlackthorn);

        Job_Application__c jobApplicationHTS = createJobApplication(
            'Closed', 
            'jobApplicationHTS', 
            accHTSId, 
            contactHudsonId
        );

        jobApplications.add(jobApplicationHTS);

        return jobApplications;
    }

    private Job_Application__c createJobApplication(
        String status, 
        String position_title, 
        Id accId, 
        Id contactId
    ) {
        Job_Application__c jobApplication = new Job_Application__c(
            Status__c = status, 
            Rating__c = '3 Star', 
            Notes__c = 'Notes', 
            Position_Title__c = position_title, 
            Work_Model__c = 'Remote', 
            Job_Type__c = 'Temporary', 
            Salary__c = 50000, 
            URL__c = 'https://trailhead.salesforce.com/en/career-path', 
            Job_Description__c = 'Description', 
            Company__c = accId, 
            Primary_Contact__c = contactId
        );

        return jobApplication;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTaskWhenStatusIsSaved(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Saved', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTaskWhenStatusIsApplying(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Applying', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTaskWhenStatusIsApplied(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Applied', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTaskWhenStatusIsInterviewing(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Interviewing', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTaskWhenStatusIsNegotiating(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Negotiating', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTaskWhenStatusIsAccepted(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Accepted', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTaskWhenStatusIsClosed(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Closed', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setPrimaryContact(
        Id accBlackthornId, 
        Id accHTSId, 
        Id contactBoozId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz', 
            accBlackthornId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationBlackthorn_NoJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationBlackthorn_NoJobApplicationContacts_PrimaryContactBooz', 
            accBlackthornId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBlackthorn_NoJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact', 
            accBlackthornId, 
            null
        );

        jobApplications.add(jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationBlackthorn_NoJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationBlackthorn_NoJobApplicationContacts_NoPrimaryContact', 
            accBlackthornId, 
            null
        );

        jobApplications.add(jobApplicationBlackthorn_NoJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz', 
            accHTSId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationHTS_NoJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationHTS_NoJobApplicationContacts_PrimaryContactBooz', 
            accHTSId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationHTS_NoJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact', 
            accHTSId, 
            null
        );

        jobApplications.add(jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationHTS_NoJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationHTS_NoJobApplicationContacts_NoPrimaryContact', 
            accHTSId, 
            null
        );

        jobApplications.add(jobApplicationHTS_NoJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz', 
            null, 
            contactBoozId
        );

        jobApplications.add(jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationNoAcc_NoJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationNoAcc_NoJobApplicationContacts_PrimaryContactBooz', 
            null, 
            contactBoozId
        );

        jobApplications.add(jobApplicationNoAcc_NoJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact', 
            null, 
            null
        );

        jobApplications.add(jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationNoAcc_NoJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationNoAcc_NoJobApplicationContacts_NoPrimaryContact', 
            null, 
            null
        );

        jobApplications.add(jobApplicationNoAcc_NoJobApplicationContacts_NoPrimaryContact);

        return jobApplications;

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
    }

    @TestVisible
    private List<Job_Application_Contact__c> createJobApplicationContacts_setPrimaryContact(
        Id contactHudsonId, 
        Id contactBearId, 
        Id jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId, 
        Id jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId, 
        Id jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId, 
        Id jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId, 
        Id jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId, 
        Id jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
    ) {
        List<Job_Application_Contact__c> jobApplicationContacts = new List<Job_Application_Contact__c>();

        Job_Application_Contact__c jobApplicationContactBlackthorn_Hudson_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Hudson_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Bear_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Bear_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Hudson_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Hudson_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Bear_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Bear_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactHTS_Hudson_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Hudson_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactHTS_Bear_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Bear_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactHTS_Hudson_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Hudson_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactHTS_Bear_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Bear_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactHTS_NoAcc_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_NoAcc_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactNoAcc_Bear_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactNoAcc_Bear_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactHTS_NoAcc_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_NoAcc_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactNoAcc_Bear_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactNoAcc_Bear_NoPrimaryContact);

        return jobApplicationContacts;

        // 12 job application contacts
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setPrimaryContact(
        Id accBAHId, 
        Id accSalesforceId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            null, 
            'jobApplicationBAH', 
            accBAHId, 
            null
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            null
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application_Contact__c> createJobApplicationContacts_setPrimaryContact(
        Id contactBoozId, 
        Id contactBearId, 
        Id jobApplicationBlackthornId, 
        Id jobApplicationHTSId, 
        Id jobApplicationBAHId, 
        Id jobApplicationSalesforceId
    ) {
        List<Job_Application_Contact__c> jobApplicationContacts = new List<Job_Application_Contact__c>();

        Job_Application_Contact__c jobApplicationContactBlackthorn_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationBlackthornId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Booz);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBlackthornId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Bear);

        Job_Application_Contact__c jobApplicationContactHTS_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationHTSId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Booz);

        Job_Application_Contact__c jobApplicationContactHTS_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationHTSId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Bear);

        Job_Application_Contact__c jobApplicationContactBAH_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationBAHId
        );

        jobApplicationContacts.add(jobApplicationContactBAH_Booz);

        Job_Application_Contact__c jobApplicationContactBAH_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBAHId
        );

        jobApplicationContacts.add(jobApplicationContactBAH_Bear);

        Job_Application_Contact__c jobApplicationContactSalesforce_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationSalesforceId
        );

        jobApplicationContacts.add(jobApplicationContactSalesforce_Bear);

        Job_Application_Contact__c jobApplicationContactSalesforce_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationSalesforceId
        );

        jobApplicationContacts.add(jobApplicationContactSalesforce_Booz);

        return jobApplicationContacts;

        // 8 job application contacts
    }
}