@IsTest
private with sharing class TaxCalculationTest {
    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_Is_NullOrZero() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(1000);

        System.assertEquals(0.00, federalTax);
    }

    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_LessThanOrEqualTo_11000() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(24850);

        System.assertEquals(1100.00, federalTax);
    }

    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_LessThanOrEqualTo_44725() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(58575);

        System.assertEquals(5147.00, federalTax);
    }

    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_LessThanOrEqualTo_95375() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(109225);

        System.assertEquals(16290.00, federalTax);
    }

    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_LessThanOrEqualTo_182100() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(195950);

        System.assertEquals(37104.00, federalTax);
    }

    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_LessThanOrEqualTo_231250() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(245100);

        System.assertEquals(52832.00, federalTax);
    }

    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_LessThanOrEqualTo_578125() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(591975);

        System.assertEquals(174238.25, federalTax);
    }

    @IsTest
    private static void federalTax_SalaryMinusStandardDeduction_GreaterThan_578125() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(591976);

        System.assertEquals(174238.62, federalTax);
    }

    @IsTest
    private static void socialSecurityTax() {
        Decimal socialSecurityTax = TaxCalculation.calculateSocialSecurityTax(10000);

        System.assertEquals(620.00, socialSecurityTax);
    }

    @IsTest
    private static void medicareTax() {
        Decimal medicareTax = TaxCalculation.calculateMedicareTax(20000);

        System.assertEquals(290.00, medicareTax);
    }

    @IsTest
    private static void insertJobApplicationWithSalary_ExpectTaxFieldsUpdated() {
        // GIVEN
        Job_Application__c jobApplicationToInsert = new Job_Application__c();

        jobApplicationToInsert.Salary__c = 24850;

        // WHEN
        Test.startTest();

        insert jobApplicationToInsert;

        Test.stopTest();

        // THEN
        Job_Application__c retrievedJobApplication = [
            SELECT 
                Id, 
                Salary__c, 
                Federal_Income_Tax__c, 
                Social_Security_Tax__c, 
                Medicare_Withholding__c 
            FROM Job_Application__c 
            WHERE Salary__c = 24850 
            LIMIT 1
        ];

        System.assertEquals(1100.00, retrievedJobApplication.Federal_Income_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
        System.assertEquals(1540.70, retrievedJobApplication.Social_Security_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
        System.assertEquals(360.33, retrievedJobApplication.Medicare_Withholding__c.setScale(2, System.RoundingMode.HALF_UP));
    }
}