trigger JobApplicationTrigger on Job_Application__c (before insert, before update, after insert, after update) {
    JobApplicationTriggerHandler jobApplicationTriggerHandler = new JobApplicationTriggerHandler();

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            jobApplicationTriggerHandler.validateApplicationAndFollowUpDate(Trigger.new);
            jobApplicationTriggerHandler.setPrimaryContact(Trigger.new);
            TaxCalculation.calculatePayrollTaxes(Trigger.new);
        }

        when BEFORE_UPDATE {
            jobApplicationTriggerHandler.validateApplicationAndFollowUpDate(Trigger.new);
            jobApplicationTriggerHandler.setPrimaryContact(Trigger.new);
            TaxCalculation.calculatePayrollTaxes(Trigger.new);
        }

        when AFTER_INSERT {
            jobApplicationTriggerHandler.createTaskWhenStatusIsSaved_Insert(Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsApplying_Insert(Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsApplied_Insert(Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsInterviewing_Insert(Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsNegotiating_Insert(Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsAccepted_Insert(Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsClosed_Insert(Trigger.new);
        }

        when AFTER_UPDATE {
            jobApplicationTriggerHandler.createTaskWhenStatusIsSaved_Update(Trigger.oldMap, Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsApplying_Update(Trigger.oldMap, Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsApplied_Update(Trigger.oldMap, Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsInterviewing_Update(Trigger.oldMap, Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsNegotiating_Update(Trigger.oldMap, Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsAccepted_Update(Trigger.oldMap, Trigger.new);
            jobApplicationTriggerHandler.createTaskWhenStatusIsClosed_Update(Trigger.oldMap, Trigger.new);
        }
    }
}