@IsTest
private with sharing class JobApplicationCleaningSchedulerTest {
    // @TestSetup
    // private static void setup() {}

    @IsTest
    private static void schedule() {
        // GIVEN
        String CRON_EXP = '0 0 1 * * ?';

        JobApplicationCleaningScheduler job = new JobApplicationCleaningScheduler();

        // WHEN
        Test.startTest();

        String jobId = System.schedule('JobApplicationCleaningSchedulerJob', CRON_EXP, job);

        System.debug('jobId = ' + jobId);

        CronTrigger cronTrigger = [
            SELECT 
                Id, 
                NextFireTime, 
                State, 
                TimesTriggered 
            FROM CronTrigger 
            WHERE Id = :jobId 
            LIMIT 1
        ];

        System.debug('cronTrigger = ' + cronTrigger);

        // THEN
        Datetime now = Datetime.now();
        Datetime nextFireTime;

        if (now.hour() < 1) {
            nextFireTime = Datetime.newInstance(now.year(), now.month(), now.day(), 1, 0, 0);
        } else {
            nextFireTime = Datetime.newInstance(now.year(), now.month(), now.day() + 1, 1, 0, 0);
        }

        System.assertEquals(String.valueOf(nextFireTime), String.valueOf(cronTrigger.NextFireTime), 'Expect NextFireTime to be 1:00 AM');
        System.assertEquals('WAITING', cronTrigger.State, 'Expect State to be WAITING');
        System.assertEquals(0, cronTrigger.TimesTriggered, 'Expect TimesTriggered to be 0');

        Test.stopTest();
    }
}