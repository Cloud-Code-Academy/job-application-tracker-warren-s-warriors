import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import queryJobs from '@salesforce/apex/JobController.queryJobs';
import makePOSTCallout from '@salesforce/apex/JoobleJSONCallout.makePOSTCallout';

export default class JobSearch extends LightningElement {
    keywords;
    location;
    miles = 25;
    kilometers;
    salary = 50000;
    datecreatedfrom;
    page = 1;

    @wire(queryJobs) jobs;

    get lastWeek() {
        const TODAY = new Date();

        TODAY.setDate(TODAY.getDate() - 7);

        const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        const YEAR = TODAY.getFullYear();
        const MONTH = MONTHS[TODAY.getMonth()];
        const DAY = TODAY.getDate();

        return `${MONTH} ${DAY}, ${YEAR}`;
    }

    handleKeywordsChange(event) {
        this.keywords = event.target.value;
    }

    handleLocationChange(event) {
        this.location = event.target.value;
    }

    handleRadiusChange(event) {
        const MILES = event.target.value;

        this.miles = MILES;
        this.kilometers = this.convertMilesToKilometers(MILES);
    }

    convertMilesToKilometers(miles) {
        return miles * 1.609344;
    }

    handleSalaryChange(event) {
        this.salary = event.target.value;
    }

    handleDateCreatedFromChange(event) {
        this.datecreatedfrom = event.target.value;
    }

    handlePageChange(event) {
        this.page = event.target.value;
    }

    async handleSearchJob(event) {
        event.preventDefault();

        const KEYWORDS = this.keywords;
        const LOCATION = this.location;
        const LAST_WEEK = new Date(this.lastWeek).toISOString().slice(0, 10);

        if (
            (KEYWORDS == null || KEYWORDS.trim() == '') 
            && (LOCATION == null || LOCATION.trim() == '')
        ) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Keywords and Location cannot both be blank', 
                    message: 'Enter keywords or location before searching for jobs', 
                    variant: 'error'
                })
            );

            return;
        }

        try {
            await makePOSTCallout({
                keywords: KEYWORDS == null ? null : KEYWORDS.trim(), 
                location: LOCATION == null ? null : LOCATION.trim(), 
                radius: this.kilometers, 
                salary: this.salary || 0, 
                datecreatedfrom: this.datecreatedfrom || LAST_WEEK, 
                page: this.page || 1, 
                resultonpage: 100
            });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success', 
                    message: 'If you see no results, change your job search filters and try again', 
                    variant: 'success'
                })
            );
        } catch (e) {
            this.handleErrorWhileSearchingForJobs(e);
        }

        try {
            await refreshApex(this.jobs);
        } catch (e) {
            this.handleErrorWhileRefreshingRecord(e);
        }
    }

    handleErrorWhileSearchingForJobs(e) {
        console.log('JSON.stringify(e) = ' + JSON.stringify(e));

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error while searching for jobs', 
                message: e.body.message, 
                variant: 'error'
            })
        );
    }

    handleErrorWhileRefreshingRecord(e) {
        console.log('JSON.stringify(e) = ' + JSON.stringify(e));

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error while refreshing records', 
                message: e.body.message, 
                variant: 'error'
            })
        );
    }
}