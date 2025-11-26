@IsTest
private class UtilitiesTests {
    private static Utilities utilities = new Utilities();


    @IsTest
    static void testGenerateRandomDate(){
        Date minDate = Date.newInstance(2024, 01, 01);
        Date maxDate = Date.newInstance(2025, 01, 01);

        Test.startTest();
        Date randomDate = utilities.generateRandomDate(minDate, maxDate);
        Test.stopTest();

        Assert.isTrue(randomDate >= minDate, 'Expected Utilities.generateRandomDate to return a date greater or equal to then minimum date.');
        Assert.isTrue(randomDate <= maxDate, 'Expected Utilities.generateRandomDate to return a date greater or equal to then maximum date.');
    }

    @IsTest
    static void testGenerateRandomNumber(){
        Integer length = 10;
        Test.startTest();
        String randomString = utilities.generateRandomNumber(length);
        Test.stopTest();

        Assert.areEqual(length, randomString.length(), 'Expected Utilities.generateRandomNumber to return a string of equal length.');
    }

    @IsTest
    static void testGenerateRandomString(){
        Integer length = 10;
        Test.startTest();
        String randomString = utilities.generateRandomString(length);
        Test.stopTest();

        Assert.areEqual(length, randomString.length(), 'Expected Utilities.generateRandomString to return a string of equal length.');
    }

    @IsTest
    static void testHandleUpsertResults() {
        List<Database.UpsertResult> results = new List<Database.UpsertResult>();

        Database.UpsertResult result = (Database.UpsertResult) JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}',
            Database.UpsertResult.class
        );
        results.add(result);

        Test.startTest();
        utilities.handleUpsertResults(results);
        Test.stopTest();

        Integer logCount = [SELECT COUNT() FROM ApplicationErrorLog__c];

        Assert.isTrue(logCount > 0, 'Expected TransferToolJobHelper.handleUpsertResults to create Log Events.');
    }
    @IsTest
    static void testHandleSaveResults() {
        List<Database.SaveResult> results = new List<Database.SaveResult>();

        Database.SaveResult result = (Database.SaveResult) JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}',
            Database.SaveResult.class
        );
        results.add(result);

        Test.startTest();
        utilities.handleSaveResults(results);
        Test.stopTest();

        Integer logCount = [SELECT COUNT() FROM ApplicationErrorLog__c];

        Assert.isTrue(logCount > 0, 'Expected TransferToolJobHelper.handleSaveResults to create Log Events.');
    }

    @IsTest
    static void testHandleDeleteResults() {
        List<Database.DeleteResult> results = new List<Database.DeleteResult>();

        Database.DeleteResult result = (Database.DeleteResult) JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}',
            Database.DeleteResult.class
        );
        results.add(result);

        Test.startTest();
        utilities.handleDeleteResults(results);
        Test.stopTest();

        Integer logCount = [SELECT COUNT() FROM ApplicationErrorLog__c];

        Assert.isTrue(logCount > 0, 'Expected TransferToolJobHelper.handleDeleteResults to create Log Events.');
    }
}
