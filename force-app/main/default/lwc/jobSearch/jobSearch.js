import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import queryJobs from '@salesforce/apex/JobController.queryJobs';
import makePOSTCallout from '@salesforce/apex/JoobleJSONCallout.makePOSTCallout';

export default class JobSearch extends LightningElement {
    keywords;
    location;
    radius = 25;
    salary = 50000;
    datecreatedfrom;
    page = 1;
    resultonpage = 20;

    @wire(queryJobs)
    jobs;

    handleKeywordsChange(event) {
        // console.log('handleKeywordsChange');

        this.keywords = event.target.value;
    }

    handleLocationChange(event) {
        // console.log('handleLocationChange');

        this.location = event.target.value;
    }

    handleRadiusChange(event) {
        // console.log('handleRadiusChange');

        this.radius = this.convertMilesToKilometers(event.target.value);
    }

    convertMilesToKilometers(miles) {
        // console.log('convertMilesToKilometers');

        return miles * 1.609344;
    }

    handleSalaryChange(event) {
        // console.log('handleSalaryChange');

        this.salary = event.target.value;
    }

    handleDateCreatedFromChange(event) {
        // console.log('handleDateCreatedFromChange');

        this.datecreatedfrom = event.target.value;
    }

    handlePageChange(event) {
        // console.log('handlePageChange');

        this.page = event.target.value;
    }

    handleResultOnPageChange(event) {
        // console.log('handleResultOnPageChange');

        this.resultonpage = event.target.value;
    }

    async handleSearchJob(event) {
        // console.log('handleSearchJob');

        event.preventDefault();

        const KEYWORDS = this.keywords;
        const TODAY = new Date();

        TODAY.setMonth(TODAY.getMonth() - 1);

        const LAST_MONTH = TODAY.toISOString().slice(0, 10);

        if (KEYWORDS == null || KEYWORDS.trim() == '') {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Keywords Cannot Be Blank', 
                    message: 'Enter keywords before searching for jobs', 
                    variant: 'error'
                })
            );

            return;
        }

        try {
            await makePOSTCallout({
                keywords: KEYWORDS.trim(), 
                location: this.location == null ? null : this.location.trim(), 
                radius: this.radius == null ? 25 : this.radius, 
                salary: this.salary == null ? 50000 : this.salary, 
                datecreatedfrom: this.datecreatedfrom == null ? LAST_MONTH : this.datecreatedfrom, 
                page: this.page == null ? 1 : this.page, 
                resultonpage: this.resultonpage == null ? 20 : this.resultonpage
            });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success', 
                    message: 'Jobs retrieved', 
                    variant: 'success'
                })
            );
        } catch (e) {
            console.log('JSON.stringify(e) = ' + JSON.stringify(e));

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while searching and retrieving records', 
                    message: e.body.message, 
                    variant: 'error'
                })
            );
        }

        try {
            await refreshApex(this.jobs);
        } catch (e) {
            this.handleErrorWhileRefreshingRecord(e);
        }
    }

    handleErrorWhileRefreshingRecord(e) {
        // console.log('handleErrorWhileRefreshingRecord');
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