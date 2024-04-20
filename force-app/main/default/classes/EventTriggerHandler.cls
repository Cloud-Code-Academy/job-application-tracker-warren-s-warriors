public with sharing class EventTriggerHandler {
    public void validateEventDateTime(List<Event> triggerDotNew) {
        List<Event> events = [
            SELECT 
                StartDateTime, 
                EndDateTime
            FROM Event 
            WHERE Event.Id NOT IN :triggerDotNew
        ];

        for (Event newEvent : triggerDotNew) {
            Datetime newEventStartDT = newEvent.StartDateTime;
            Datetime newEventEndDT = newEvent.EndDateTime;

            Long newEventStartDTInMilliseconds = newEventStartDT.getTime();
            Long newEventEndDTInMilliseconds = newEventEndDT.getTime();

            if (
                newEventStartDT.format('E') == 'Sat' 
                || newEventStartDT.format('E') == 'Sun' 
                || newEventEndDT.format('E') == 'Sat' 
                || newEventEndDT.format('E') == 'Sun' 
            ) {
                newEvent.addError('Cannot schedule event on the weekend');
            } else if (!events.isEmpty()) {
                String error = validateNoEventOverlap(events, newEventStartDTInMilliseconds, newEventEndDTInMilliseconds);

                if (error != null) {
                    newEvent.addError(error);
                }
            }
        }
    }

    private String validateNoEventOverlap(List<Event> events, Long newEventStartDTInMilliseconds, Long newEventEndDTInMilliseconds) {
        String error;

        for (Event event : events) {
            Long eventStartDTInMilliseconds = event.StartDateTime.getTime();
            Long eventEndDTInMilliseconds = event.EndDateTime.getTime();

            if (
                (newEventStartDTInMilliseconds <= eventStartDTInMilliseconds && eventStartDTInMilliseconds < newEventEndDTInMilliseconds) 
                && (newEventStartDTInMilliseconds < eventEndDTInMilliseconds && eventEndDTInMilliseconds <= newEventEndDTInMilliseconds)
            ) {
                error = 'Cannot overlap event: newStartDT existingStartDT existingEndDT newEndDT';
            } else if (
                (newEventStartDTInMilliseconds <= eventStartDTInMilliseconds && eventStartDTInMilliseconds < newEventEndDTInMilliseconds) 
                && (eventStartDTInMilliseconds < newEventEndDTInMilliseconds && newEventEndDTInMilliseconds <= eventEndDTInMilliseconds)
            ) {
                error = 'Cannot overlap event: newStartDT existingStartDT newEndDT existingEndDT';
            } else if (
                (eventStartDTInMilliseconds <= newEventStartDTInMilliseconds && newEventStartDTInMilliseconds < eventEndDTInMilliseconds) 
                && (newEventStartDTInMilliseconds < eventEndDTInMilliseconds && eventEndDTInMilliseconds <= newEventEndDTInMilliseconds)
            ) {
                error = 'Cannot overlap event: existingStartDT newStartDT existingEndDT newEndDT';
            } else if (
                (eventStartDTInMilliseconds <= newEventStartDTInMilliseconds && newEventStartDTInMilliseconds < eventEndDTInMilliseconds) 
                && (eventStartDTInMilliseconds < newEventEndDTInMilliseconds && newEventEndDTInMilliseconds <= eventEndDTInMilliseconds)
            ) {
                error = 'Cannot overlap event: existingStartDT newStartDT newEndDT existingEndDT';
            }
        }

        return error;
    }
}