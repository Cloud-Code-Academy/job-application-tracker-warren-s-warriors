public with sharing class Taxes {
    
    public static Decimal calculateFederalTaxes(Decimal salary){
        // calculation of net Federal Taxes 
        //netTakeHomePay;
        Decimal fedTaxLiability;
        salary = salary - 13850; 
        if( salary == Null || salary <=0){
            return fedTaxLiability;
        } else 
            if( salary <= 11000){
                    fedTaxLiability = salary*.10;
                    //netTakeHomePay = salary - taxLiability;
                    system.debug('Federal Tax Liability is ' + fedTaxLiability);
            } else if( salary <= 44725){
                    fedTaxLiability = ((salary-11000)*.12 + 1100);
                    //netTakeHomePay = salary - taxLiability;
                    system.debug('Federal Tax Liability is ' + fedTaxLiability);
            } else if( salary <= 95375){
                    fedTaxLiability = ((salary-44725)*.22 + 5147);
                    //netTakeHomePay = salary - taxLiability;
                    system.debug('Federal Tax Liability is ' + fedTaxLiability);
            } else if( salary <= 182100){
                    fedTaxLiability = ((salary-95375)*.24 + 16290);
                    //netTakeHomePay = salary - taxLiability;
                    system.debug('Federal Tax Liability is ' + fedTaxLiability);
            } else if( salary <= 231250){
                    fedTaxLiability = ((salary-182100)*.32 + 37104);
                    //netTakeHomePay = sgalary - taxLiability;
                    system.debug('Federal Tax Liability is ' + fedTaxLiability);
            } else if( salary <= 578125){
                    fedTaxLiability = ((salary-231250)*.35 + 52832);
                    //netTakeHomePay = salary - taxLiability;
                    system.debug('Federal Tax Liability is ' + fedTaxLiability);
            } else if( salary > 578125){
                    fedTaxLiability = ((salary-578125)*.37 + 174238.25);
                    //netTakeHomePay = salary - taxLiability;
                    system.debug('Federal Tax Liability is ' + fedTaxLiability);
            } 
        return fedTaxLiability;
    }
    // calculate Social Security Taxes
    public static Decimal calcSocialSecurityTaxes(Decimal salary){
        Decimal ssTax = salary * .062;
        return ssTax;
    }
    // calculate Medicare Taxes
    public static Decimal calcMedicareTaxes(Decimal salary){
        
        Decimal ssTax = salary * .0145;
        return ssTax;
    }

}