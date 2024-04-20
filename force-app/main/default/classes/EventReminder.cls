public with sharing class EventReminder {
    public void emailUserDayBeforeInterview() {
        Datetime tomorrow = Datetime.now() + 1;
        Datetime dayAftertomorrow = tomorrow + 1;

        Integer n;

        String day;

        if (tomorrow.format('E') != 'Sat' && tomorrow.format('E') != 'Sun') {
            n = 1;

            day = 'tomorrow';
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') != 'Sat' && dayAftertomorrow.format('E') != 'Sun')
        ) {
            n = 2;

            day = 'in 2 days';
        } else if (
            (tomorrow.format('E') == 'Sat' || tomorrow.format('E') == 'Sun') 
            && (dayAftertomorrow.format('E') == 'Sat' || dayAftertomorrow.format('E') == 'Sun')
        ) {
            n = 3;

            day = 'in 3 days';
        }

        List<Event> events = Database.query(
            'SELECT ' 
                + 'Id, ' 
                + 'Subject, ' 
                + 'StartDateTime, ' 
                + 'EndDateTime, ' 
                + 'Location, ' 
                + 'Account.Name, ' 
                + 'Type, ' 
                + 'Description, ' 
                + 'WhoId, ' 
                + 'OwnerId, ' 
                + 'Interview_Format__c ' 
            + 'FROM Event ' 
            + 'WHERE StartDateTime = NEXT_N_DAYS:' + n
        );

        if (events.isEmpty()) {
            return;
        }

        Set<Id> eventOwnerIds = new Set<Id>();
        Set<Id> eventWhoIds = new Set<Id>();

        for (Event event : events) {
            eventOwnerIds.add(event.OwnerId);

            eventWhoIds.add(event.WhoId);
        }

        List<User> users = [
            SELECT 
                Id, 
                Email 
            FROM User 
            WHERE Id = :eventOwnerIds
        ];

        Map<Id, String> emailsByEventId = new Map<Id, String>();

        for (Event event : events) {
            for (User user : users) {
                if (event.OwnerId == user.Id && !emailsByEventId.containsKey(event.Id)) {
                    emailsByEventId.put(event.Id, user.Email);

                    break;
                }
            }
        }

        List<Contact> contacts = [
            SELECT 
                Id, 
                Name 
            FROM Contact 
            WHERE Id = :eventWhoIds
        ];

        Map<Id, String> contactNamesByEventId = new Map<Id, String>();

        for (Event event : events) {
            for (Contact contact : contacts) {
                if (event.WhoId == contact.Id && !contactNamesByEventId.containsKey(event.Id)) {
                    contactNamesByEventId.put(event.Id, contact.Name);

                    break;
                }
            }
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for (Event event : events) {
            List<String> emailAddresses = new List<String>{emailsByEventId.get(event.Id)};
            String contactName = contactNamesByEventId.get(event.Id);

            mails.add(createEmailToSend(emailAddresses, event, day, contactName));
        }

        Messaging.sendEmail(mails);
    }

    private Messaging.SingleEmailMessage createEmailToSend(
        List<String> emailAddresses, 
        Event event, 
        String day, 
        String contactName
    ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(emailAddresses);

        mail.setSubject('Reminder — Event ' + day);

        mail.setHtmlBody(
            '<html><body>' 
            + 'You have a scheduled event ' + day + '<br><br>' 
            + 'Subject: <br>' + event.Subject +'<br><br>' 
            + 'Start: <br>' + event.StartDateTime +'<br><br>' 
            + 'End: <br>' + event.EndDateTime +'<br><br>' 
            + 'Contact: <br>' + contactName +'<br><br>' 
            + 'Location: <br>' + event.Location +'<br><br>' 
            + 'Company or Organization: <br>' + event.Account.Name +'<br><br>' 
            + 'Type: <br>' + event.Type +'<br><br>' 
            + 'Interview Format: <br>' + event.Interview_Format__c +'<br><br>' 
            + 'Description: <br>' + event.Description 
            + '</body></html>'
        );

        return mail;
    }
}