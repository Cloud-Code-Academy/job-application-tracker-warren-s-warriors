public with sharing class JobApplicationController {
    @AuraEnabled
    public static void upsertJobApplications(List<String> recordIds) {
        List<Job__c> jobs = [
            SELECT 
                Id, 
                Title__c, 
                Location__c, 
                Snippet__c, 
                Salary__c, 
                Source__c, 
                Type__c, 
                Link__c, 
                Company__c, 
                Updated__c, 
                Id__c 
            FROM Job__c 
            WHERE Id IN :recordIds
        ];

        List<Job_Application__c> jobApplicationsToUpsert = new List<Job_Application__c>();

        for (Job__c job : jobs) {
            Job_Application__c jobApplicationToUpsert = new Job_Application__c(Status__c = 'Saved');

            if (!String.isBlank(job.Title__c)) {
                jobApplicationToUpsert.Position_Title__c = job.Title__c;
            }

            if (!String.isBlank(job.Location__c)) {
                jobApplicationToUpsert.Location__c = job.Location__c;
            }

            if (!String.isBlank(job.Snippet__c)) {
                jobApplicationToUpsert.Job_Description__c = job.Snippet__c;
            }

            if (!String.isBlank(job.Salary__c)) {
                try {
                    jobApplicationToUpsert.Salary__c = Decimal.valueOf(job.Salary__c);
                } catch (TypeException e) {
                    System.debug(
                        'Cannot put non-numerical value in Salary__c field — putting Salary__c in Job_Description__c field instead' 
                        + ' | Exception Type = ' + e.getTypeName() 
                        + ' | Exception Message = ' + e.getMessage()
                    );

                    String salaryToJobDescription = '\n\nSalary: ' + job.Salary__c;

                    System.debug('salaryToJobDescription = ' + salaryToJobDescription.trim());

                    if (String.isBlank(jobApplicationToUpsert.Job_Description__c)) {
                        jobApplicationToUpsert.Job_Description__c = salaryToJobDescription.trim();
                    } else {
                        jobApplicationToUpsert.Job_Description__c += salaryToJobDescription;
                    }
                }
            }

            if (!String.isBlank(job.Source__c)) {
                System.debug('Putting Source__c in Job_Description__c field');

                String sourceToJobDescription = '\n\nSource: ' + job.Source__c;

                System.debug('sourceToJobDescription = ' + sourceToJobDescription.trim());

                if (String.isBlank(jobApplicationToUpsert.Job_Description__c)) {
                    jobApplicationToUpsert.Job_Description__c = sourceToJobDescription.trim();
                } else {
                    jobApplicationToUpsert.Job_Description__c += sourceToJobDescription;
                }
            }

            if (
                !String.isBlank(job.Type__c) 
                && (job.Type__c == 'Full-time' 
                    || job.Type__c == 'Part-time' 
                    || job.Type__c == 'Contract' 
                    || job.Type__c == 'Internship' 
                    || job.Type__c == 'Temporary'
                )
            ) {
                jobApplicationToUpsert.Job_Type__c = job.Type__c;
            }

            if (!String.isBlank(job.Link__c)) {
                jobApplicationToUpsert.URL__c = job.Link__c;
            }

            if (!String.isBlank(job.Company__c)) {
                jobApplicationToUpsert.Company__c = getAccId(job.Company__c);
            }

            if (!String.isBlank(String.valueOf(job.Updated__c))) {
                System.debug('Putting Updated__c in Job_Description__c field');

                String updatedToJobDescription = '\n\nUpdated: ' + String.valueOf(job.Updated__c);

                System.debug('updatedToJobDescription = ' + updatedToJobDescription.trim());

                if (String.isBlank(jobApplicationToUpsert.Job_Description__c)) {
                    jobApplicationToUpsert.Job_Description__c = updatedToJobDescription.trim();
                } else {
                    jobApplicationToUpsert.Job_Description__c += updatedToJobDescription;
                }
            }

            if (!String.isBlank(job.Id__c)) {
                jobApplicationToUpsert.Job_Id__c = job.Id__c;
            }

            jobApplicationsToUpsert.add(jobApplicationToUpsert);
        }

        Set<String> jobIds = new Set<String>();

        for (Job_Application__c jobApplicationToUpsert : jobApplicationsToUpsert) {
            jobIds.add(jobApplicationToUpsert.Job_Id__c);
        }

        List<Job_Application__c> existingJobApplicationsWithStatusNotNullAndSaved = [
            SELECT 
                Status__c, 
                Job_Id__c 
            FROM Job_Application__c 
            WHERE Job_Id__c = :jobIds 
                AND Status__c != null 
                AND Status__c != 'Saved' 
        ];

        Map<String, String> statusesByJobId = new Map<String, String>();

        for (Job_Application__c existingJobApplicationWithStatusNotNullAndSaved : existingJobApplicationsWithStatusNotNullAndSaved) {
            if (!statusesByJobId.containsKey(existingJobApplicationWithStatusNotNullAndSaved.Job_Id__c)) {
                statusesByJobId.put(existingJobApplicationWithStatusNotNullAndSaved.Job_Id__c, existingJobApplicationWithStatusNotNullAndSaved.Status__c);
            }
        }

        for (Job_Application__c jobApplicationToUpsert : jobApplicationsToUpsert) {
            if (statusesByJobId.containsKey(jobApplicationToUpsert.Job_Id__c)) {
                jobApplicationToUpsert.Status__c = statusesByJobId.get(jobApplicationToUpsert.Job_Id__c);
            }
        }

        System.debug('jobApplicationsToUpsert = ' + jobApplicationsToUpsert);

        upsert jobApplicationsToUpsert Job_Id__c;
    }

    private static String getAccId(String company) {
        String accId;

        if (company != null) {
            List<Account> retrievedAccts = [
                SELECT 
                    Id, 
                    Name 
                FROM Account 
                WHERE Name = :company 
                LIMIT 1
            ];

            if (retrievedAccts.isEmpty()) {
                accId = createAcc(company);
            } else {
                accId = retrievedAccts[0].Id;
            }
        }

        return accId;
    }

    private static Id createAcc(String company) {
        Account acctToInsert = new Account(Name = company);

        insert acctToInsert;

        return acctToInsert.Id;
    }
}