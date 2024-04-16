public with sharing class JobApplicationTriggerHandler {
    public void validateApplicationAndFollowUpDate(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Application_Date__c > newJobApplication.Follow_Up_Date__c) {
                newJobApplication.addError('Application Date cannot be after Follow-Up Date');
            }
        }
    }

    public void createTaskWhenStatusIsSaved_Insert(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c == 'Saved') {
                String description = 
                    '• Check if the job description aligns with your interests and values\n' 
                    + '• Review the highlighted skills to see if the role is a good fit\n' 
                    + '• Research the company or role and mark your excitement level'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Things to do for a job saved', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Low', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsSaved_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c == 'Saved' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Applying' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Applied' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Interviewing' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Negotiating' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Accepted' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Closed'
            ) {
                String description = 
                    '• Check if the job description aligns with your interests and values\n' 
                    + '• Review the highlighted skills to see if the role is a good fit\n' 
                    + '• Research the company or role and mark your excitement level'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Things to do for a job saved', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Low', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsApplying_Insert(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c == 'Applying') {
                String description = 
                    '• Find and research someone who works at the company and add them as a contact\n' 
                    + '• Set up an informational interview to learn more about the role/company\n' 
                    + '• Identify potential referrals to help get your application on the top of the pile\n' 
                    + '• Customize your work achievements using the job description keywords\n' 
                    + '• Submit your application on the company website if possible'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Things to do for a job to apply', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Normal', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsApplying_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c == 'Applying' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Applied' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Interviewing' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Negotiating' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Accepted' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Closed'
            ) {
                String description = 
                    '• Find and research someone who works at the company and add them as a contact\n' 
                    + '• Set up an informational interview to learn more about the role/company\n' 
                    + '• Identify potential referrals to help get your application on the top of the pile\n' 
                    + '• Customize your work achievements using the job description keywords\n' 
                    + '• Submit your application on the company website if possible'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Things to do for a job to apply', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Normal', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsApplied_Insert(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c == 'Applied') {
                String description = 
                    '• Reach out to the hiring manager or recruiter\n' 
                    + '• Follow up on your application via email weekly\n' 
                    + '• Continue identifying and saving similar job opportunities\n' 
                    + '• Set up weekly networking calls to explore similar companies/roles'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Things to do after applying for a job', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Normal', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsApplied_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c == 'Applied' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Interviewing' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Negotiating' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Accepted' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Closed'
            ) {
                String description = 
                    '• Reach out to the hiring manager or recruiter\n' 
                    + '• Follow up on your application via email weekly\n' 
                    + '• Continue identifying and saving similar job opportunities\n' 
                    + '• Set up weekly networking calls to explore similar companies/roles'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Things to do after applying for a job', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Normal', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsInterviewing_Insert(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c == 'Interviewing') {
                String description = 
                    '• Prepare your blurb or "tell me about yourself" response\n' 
                    + '• Practice answering behavioral interview questions\n' 
                    + '• Research the company and your interviewers\n' 
                    + '• Set up your virtual interview space and test your tech\n' 
                    + '• Send thank you emails within 24 hours'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Interview prep', 
                    ActivityDate = Date.today().addDays(1), 
                    Priority = 'High', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsInterviewing_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c == 'Interviewing' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Negotiating' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Accepted' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Closed'
            ) {
                String description = 
                    '• Prepare your blurb or "tell me about yourself" response\n' 
                    + '• Practice answering behavioral interview questions\n' 
                    + '• Research the company and your interviewers\n' 
                    + '• Set up your virtual interview space and test your tech\n' 
                    + '• Send thank you emails within 24 hours'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Interview prep', 
                    ActivityDate = Date.today().addDays(1), 
                    Priority = 'High', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsNegotiating_Insert(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c == 'Negotiating') {
                String description = 
                    '• Research your market value and know your numbers\n' 
                    + '• Prepare your negotiation scripts\n' 
                    + '• Evaluate your offer and decline or accept'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Negotiation prep', 
                    ActivityDate = Date.today().addDays(1), 
                    Priority = 'High', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsNegotiating_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c == 'Negotiating' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Accepted' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Closed'
            ) {
                String description = 
                    '• Research your market value and know your numbers\n' 
                    + '• Prepare your negotiation scripts\n' 
                    + '• Evaluate your offer and decline or accept'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Negotiation prep', 
                    ActivityDate = Date.today().addDays(1), 
                    Priority = 'High', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsAccepted_Insert(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c == 'Accepted') {
                String description = 
                    '• Plan your resignation if applicable\n' 
                    + '• Take some time to relax and recharge\n' 
                    + '• Prepare for your first day of onboarding'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Celebration', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Low', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsAccepted_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c == 'Accepted' 
                && triggerDotOldMap.get(newJobApplication.Id).Status__c != 'Closed'
            ) {
                String description = 
                    '• Plan your resignation if applicable\n' 
                    + '• Take some time to relax and recharge\n' 
                    + '• Prepare for your first day of onboarding'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Celebration', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Low', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsClosed_Insert(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c == 'Closed') {
                String description = 
                    '• Send a follow-up email thanking the interviewer and asking for feedback\n' 
                    + '• Review your notes and reflect on areas of improvement'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Closed job application', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Normal', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void createTaskWhenStatusIsClosed_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c == 'Closed'
            ) {
                String description = 
                    '• Send a follow-up email thanking the interviewer and asking for feedback\n' 
                    + '• Review your notes and reflect on areas of improvement'
                ;

                Task taskToInsert = new Task(
                    Subject = 'Closed job application', 
                    ActivityDate = Date.today().addDays(7), 
                    Priority = 'Normal', 
                    Description = description, 
                    WhatId = newJobApplication.Id, 
                    WhoId = newJobApplication.Primary_Contact__c, 
                    OwnerId = newJobApplication.OwnerId
                );

                insert taskToInsert;
            }
        }
    }

    public void setPrimaryContact(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Primary_Contact__c == null) {
                Id primaryContactId = getPrimaryContact(newJobApplication);

                if (primaryContactId != null) {
                    newJobApplication.Primary_Contact__c = primaryContactId;
                }
            }
        }
    }

    private Id getPrimaryContact(Job_Application__c newJobApplication) {
        List<Job_Application_Contact__c> retrievedJobApplicationContacts = [
            SELECT Contact__c 
            FROM Job_Application_Contact__c 
            WHERE Job_Application__c = :newJobApplication.Id 
            ORDER BY SystemModStamp ASC 
            LIMIT 1
        ];

        Id primaryContactId;

        if (!retrievedJobApplicationContacts.isEmpty()) {
            for (Job_Application_Contact__c retrievedJobApplicationContact : retrievedJobApplicationContacts) {
                primaryContactId = retrievedJobApplicationContact.Contact__c;
            }
        }

        if (
            primaryContactId == null 
            && newJobApplication.Company__c != null
        ) {
            List<Contact> retrievedContacts = [
                SELECT Id 
                FROM Contact 
                WHERE AccountId = :newJobApplication.Company__c 
                ORDER BY SystemModStamp ASC 
                LIMIT 1
            ];

            if (!retrievedContacts.isEmpty()) {
                for (Contact retrievedContact : retrievedContacts) {
                    primaryContactId = retrievedContact.Id;
                }
            }
        }

        return primaryContactId;
    }

    // handler method to calculate payroll taxes > Federal / Social Security / Medicare
    public void calculatePayrollTaxes(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if(newJobApplication.Salary__c != null) {
                newJobApplication.Federal_Income_Tax__c = Taxes.calculateFederalTaxes(newJobApplication.Salary__c);
                newJobApplication.Medicare_Taxes__c = Taxes.calcMedicareTaxes(newJobApplication.Salary__c);
                newJobApplication.Social_Security_Tax__c = Taxes.calcSocialSecurityTaxes(newJobApplication.Salary__c);
            }
        }
    }
}