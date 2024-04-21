public with sharing class JoobleJSONCallout {
    @AuraEnabled(cacheable=true)
    @future(callout=true)
    public static void makePOSTCallout(
        String keywords, 
        String location, 
        String radius, 
        Integer salary, 
        String datecreatedfrom, 
        String page, 
        String resultonpage
    ) {
        HttpRequest req = new HttpRequest();

        API_Key__mdt joobleAPIKeyMDT = API_Key__mdt.getInstance('Jooble_API_Key');

        req.setEndpoint('callout:Jooble_REST_API/' + joobleAPIKeyMDT.Key__c);

        req.setHeader('Content-Type', 'application/json');

        req.setMethod('POST');

        Map<String, Object> reqBodyMap = new Map<String,Object>{
            'keywords' => keywords, 
            'location' => location, 
            'radius' => radius, 
            'salary' => salary, 
            'datecreatedfrom' => datecreatedfrom, 
            'page' => page, 
            'resultonpage' => resultonpage
        };

        req.setBody(JSON.serialize(reqBodyMap));

        Http http = new Http();

        HttpResponse res = http.send(req);

        String resBody = res.getBody().replaceAll('\n', '').replaceAll('\r', '').replaceAll('<b>', '').replaceAll('</b>', '').replaceAll('&nbsp;', '');

        System.debug('resBody = ' + resBody);

        if (res.getStatusCode() == 200) {
            List<Job_Application__c> jobApplications = createJobApplicationsFromJson(resBody);

            upsert jobApplications Job_Id__c;
        } else {
            System.debug('HTTP request failed. Status Code: ' + res.getStatusCode() + ' | Response Body: ' + resBody);
        }
    }

    private static List<Job_Application__c> createJobApplicationsFromJson(String resBody) {
        Map<String, Object> resBodyMap = (Map<String, Object>) JSON.deserializeUntyped(resBody);

        List<Object> jobs = (List<Object>) resBodyMap.get('jobs');

        List<Job_Application__c> jobApplicationsToUpsert = new List<Job_Application__c>();

        Integer loopCount = 0;

        for (Object job : jobs) {
            loopCount++;

            Job_Application__c jobApplicationToUpsert = new Job_Application__c(Status__c = 'Saved');

            Map<String, Object> jobFieldMap = (Map<String, Object>) job;

            String title = String.valueOf(jobFieldMap.get('title'));
            String location = String.valueOf(jobFieldMap.get('location'));
            String snippet = String.valueOf(jobFieldMap.get('snippet'));
            String salary = String.valueOf(jobFieldMap.get('salary'));
            String link = String.valueOf(jobFieldMap.get('link'));
            String company = String.valueOf(jobFieldMap.get('company'));
            String id = String.valueOf(jobFieldMap.get('id'));
    
            System.debug('----------BEGIN LOOP ' + loopCount + ' ----------');
    
            System.debug('title = ' + title);
            System.debug('location = ' + location);
            System.debug('snippet = ' + snippet);
            System.debug('salary = ' + salary);
            System.debug('link = ' + link);
            System.debug('company = ' + company);
            System.debug('id = ' + id);
    
            System.debug('----------END LOOP ' + loopCount + ' ----------');

            if (!String.isBlank(title)) {
                jobApplicationToUpsert.Position_Title__c = title;
            }

            if (!String.isBlank(location)
            ) {
                jobApplicationToUpsert.Location__c = location;
            }

            if (!String.isBlank(snippet)) {
                jobApplicationToUpsert.Job_Description__c = snippet;
            }

            if (!String.isBlank(salary)
            ) {
                try {
                    jobApplicationToUpsert.Salary__c = Decimal.valueOf(salary);
                } catch (TypeException e) {
                    System.debug('Cannot put non-numerical value in salary field — see salary in job description field | Exception Type: ' + e.getTypeName() + ' | Exception Message: ' + e.getMessage());

                    String salaryInfo = '\n\n Salary as of ' + Datetime.now().format() + ': ' + salary;

                    if (String.isBlank(jobApplicationToUpsert.Job_Description__c)) {
                        jobApplicationToUpsert.Job_Description__c = salaryInfo.trim();
                    } else {
                        jobApplicationToUpsert.Job_Description__c += salaryInfo;
                    }
                }
            }

            if (!String.isBlank(link)) {
                jobApplicationToUpsert.URL__c = link;
            }

            if (!String.isBlank(company)) {
                jobApplicationToUpsert.Company__c = getAccId(company);
            }

            if (!String.isBlank(id)) {
                jobApplicationToUpsert.Job_Id__c = id;
            }

            jobApplicationsToUpsert.add(jobApplicationToUpsert);
        }

        System.debug('jobApplicationsToUpsert = ' + jobApplicationsToUpsert);

        return jobApplicationsToUpsert;
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