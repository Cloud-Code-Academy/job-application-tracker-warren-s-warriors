@IsTest
public with sharing class TestTaxClass {
    
    @IsTest
    static void testFedTaxes(){
        // test data 

        // test 1 
        Decimal fedIncomeTax1 = Taxes.calculateFederalTaxes(24850.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax1);
        System.assertEquals(1100.00, fedIncomeTax1);

        // test 2 
        Decimal fedIncomeTax2 = Taxes.calculateFederalTaxes(58575.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax2);
        System.assertEquals(5147.00, fedIncomeTax2);

        // test 3 
        Decimal fedIncomeTax3 = Taxes.calculateFederalTaxes(109225.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax3);
        System.assertEquals(16290.00, fedIncomeTax3);

        // test 4 
        Decimal fedIncomeTax4 = Taxes.calculateFederalTaxes(195950.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax4);
        System.assertEquals(37104.00, fedIncomeTax4);

        // test 5 
        Decimal fedIncomeTax5 = Taxes.calculateFederalTaxes(245100.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax5);
        System.assertEquals(52832.00, fedIncomeTax5);

        // test 6 
        Decimal fedIncomeTax6 = Taxes.calculateFederalTaxes(591975.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax6);
        System.assertEquals(174238.25, fedIncomeTax6);

        // test 7 
        Decimal fedIncomeTax7 = Taxes.calculateFederalTaxes(591976.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax7);
        System.assertEquals(174238.62, fedIncomeTax7);

        // test 8
        Decimal fedIncomeTax8 = Taxes.calculateFederalTaxes(1000.00);
        system.debug('The Federal Income Tax ' + fedIncomeTax8);
        System.assertEquals(0, fedIncomeTax8);
    }
    
    // Apex Trigger Class Tests
    @IsTest
    static void unitApexTaxesTest(){
         Job_Application__c testNewRecord = new Job_Application__c();
         testNewRecord.Salary__c = 24850;
         
         // perform the test 
         Test.startTest();
         insert testNewRecord;
         test.stopTest();

         // query the data
         Job_Application__c queryData = [SELECT Id, Salary__c, Federal_Income_Tax__c, 
                                                Social_Security_Tax__c, Medicare_Taxes__c
                                         FROM Job_Application__c
                                         WHERE Salary__c = 24850];
        System.debug('The Salary is : $' + queryData.Salary__c);

        //Check and Assert the values of the corresponding tax fields Federal, Social Security and Medicare

         System.debug('The Federal Tax is :' + queryData.Federal_Income_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
         System.debug('The Social Security Tax is :' + queryData.Social_Security_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
         System.debug('The Social Security Tax is :' + queryData.Medicare_Taxes__c.setScale(2, System.RoundingMode.HALF_UP));
         System.assertEquals(1100.00, queryData.Federal_Income_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
         System.assertEquals(1540.70, queryData.Social_Security_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
         System.assertEquals(360.33, queryData.Medicare_Taxes__c.setScale(2, System.RoundingMode.HALF_UP));
    }
    @IsTest
    static void testSocialSecurity(){
        Decimal socialSecurityTaxes = Taxes.calcSocialSecurityTaxes(10000.00);
        system.debug('The Social Security Tax is ' + socialSecurityTaxes);
        System.assertEquals(620.00, socialSecurityTaxes);
    }

    @IsTest
    static void testMedicare(){
        Decimal medicareTaxes = Taxes.calcMedicareTaxes(20000.00);
        system.debug('The Medicare Tax is ' + medicareTaxes);
        System.assertEquals(290.00, medicareTaxes);
    }
}