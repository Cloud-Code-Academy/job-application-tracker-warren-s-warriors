public with sharing class JoobleJSONCallout {
    public class JoobleJSONCalloutException extends Exception {}

    @AuraEnabled
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

        Map<String, Object> reqBodyMap = new Map<String, Object>{
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

        String resBody = res.getBody().stripHtmlTags();

        System.debug('resBody = ' + resBody);

        System.debug('res.getStatusCode() = ' + res.getStatusCode());

        if (res.getStatusCode() == 200) {
            delete [SELECT Id FROM Job__c];

            List<Job__c> jobs = createJobsFromJson(resBody);

            upsert jobs Id__c;
        } else {
            System.debug('HTTP request failed | Status Code: ' + res.getStatusCode());

            throw new JoobleJSONCalloutException('HTTP request failed | Status Code: ' + res.getStatusCode());
        }
    }

    private static List<Job__c> createJobsFromJson(String resBody) {
        List<Object> jobs = getJobsObjectsFromJson(resBody);

        Integer loopCount = 0;

        List<Job__c> jobsToUpsert = new List<Job__c>();

        for (Object job : jobs) {
            loopCount++;

            Map<String, Object> jobFieldMap = (Map<String, Object>) job;

            String title = String.valueOf(jobFieldMap.get('title'));
            String location = String.valueOf(jobFieldMap.get('location'));
            String snippet = String.valueOf(jobFieldMap.get('snippet'));
            String salary = String.valueOf(jobFieldMap.get('salary'));
            String source = String.valueOf(jobFieldMap.get('source'));
            String jobType = String.valueOf(jobFieldMap.get('type'));
            String link = String.valueOf(jobFieldMap.get('link'));
            String company = String.valueOf(jobFieldMap.get('company'));
            String updated = String.valueOf(jobFieldMap.get('updated'));
            String jobId = String.valueOf(jobFieldMap.get('id'));

            Datetime updatedDT = Datetime.valueof(updated.substringBefore('.').replace('T', ' '));

            System.debug('----------BEGIN LOOP ' + loopCount + ' ----------');

            System.debug('title = ' + title);
            System.debug('location = ' + location);
            System.debug('snippet = ' + snippet);
            System.debug('salary = ' + salary);
            System.debug('source = ' + source);
            System.debug('type = ' + jobType);
            System.debug('link = ' + link);
            System.debug('company = ' + company);
            System.debug('updatedDT = ' + updatedDT);
            System.debug('jobId = ' + jobId);

            System.debug('----------END LOOP ' + loopCount + ' ----------');

            Job__c jobToUpsert = new Job__c();

            if (!String.isBlank(title)) {
                jobToUpsert.Title__c = title;
            }

            if (!String.isBlank(location)) {
                jobToUpsert.Location__c = location;
            }

            if (!String.isBlank(snippet)) {
                jobToUpsert.Snippet__c = snippet;
            }

            if (!String.isBlank(salary)) {
                jobToUpsert.Salary__c = salary;
            }

            if (!String.isBlank(source)) {
                jobToUpsert.Source__c = source;
            }

            if (!String.isBlank(jobType)) {
                jobToUpsert.Type__c = jobType;
            }

            if (!String.isBlank(link)) {
                jobToUpsert.Link__c = link;
            }

            if (!String.isBlank(company)) {
                jobToUpsert.Company__c = company;
            }

            if (!String.isBlank(updated)) {
                jobToUpsert.Updated__c = updatedDT;
            }

            if (!String.isBlank(jobId)) {
                jobToUpsert.Id__c = jobId;
            }

            jobsToUpsert.add(jobToUpsert);
        }

        System.debug('jobsToUpsert = ' + jobsToUpsert);

        return jobsToUpsert;
    }

    private static List<Object> getJobsObjectsFromJson(String resBody) {
        Map<String, Object> resBodyMap = (Map<String, Object>) JSON.deserializeUntyped(resBody);

        return (List<Object>) resBodyMap.get('jobs');
    }
}