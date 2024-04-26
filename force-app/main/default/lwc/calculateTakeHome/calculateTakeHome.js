import { LightningElement , track} from 'lwc';
import calculateFederalTax from '@salesforce/apex/TaxCalculation.calculateFederalTax';
import calculateSocialSecurityTax from '@salesforce/apex/TaxCalculation.calculateSocialSecurityTax';
import calculateMedicareTax from '@salesforce/apex/TaxCalculation.calculateMedicareTax';
import inputWidth from './style.css'; 
export default class CalculateTakeHome extends LightningElement {
    @track salary;
    @track fedTax;
    @track ssTax = 0.00;
    @track medicareTax = 0.00;
    @track takeHomePayYearly= 0.00; 
    @track takeHomePayMonthly = 0.00;
    @track isSubmitted = false;


    convertNumberToCurrency(number){
        const formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
        });
        const formattedNumber = formatter.format(number);
    }

    handleSalaryChange(event) {
        this.salary = event.target.value;
        this.isSubmitted = false;
    }

    calculateTaxes() {
        if (!isNaN(this.salary)) {
            Promise.all([
                calculateFederalTax({ salary: this.salary }),
                calculateSocialSecurityTax({ salary: this.salary }),
                calculateMedicareTax({ salary: this.salary })
            ])
            .then(results => {
                this.fedTax = results[0];
                this.ssTax = results[1];
                this.medicareTax = results[2];

                // Calculate takeHomePayYearly
                this.takeHomePayYearly = this.salary - this.fedTax - this.medicareTax - this.ssTax;
                //Calculate Monthly TakeHome Pay
                this.takeHomePayMonthly = this.takeHomePayYearly / 12;

                // Show tax information
                this.isSubmitted = true;
            })
            .catch(error => {
                console.error('Error calculating taxes:', error);
            });
        } else {
            this.fedTax = null;
            this.ssTax = null;
            this.medicareTax = null;
        }
    }

    handleSubmission() {
        this.calculateTaxes();
    }

    resetHandler(){
        this.fedTax = 0.00;
        this.ssTax = 0.00;
        this.medicareTax = 0.00;
        this.takeHomePayYearly = 0.00;
        this.takeHomePayMonthly = 0.00;
        this.isSubmitted = false;
        this.salary ='';
    }



    
}