/**
 * @description Various methods used across multiple classes and not domain specific
 */
public with sharing class Utilities {
    /**
     * @description Logs errors from delete results
     * @param results
     */
    public void handleDeleteResults(List<Database.DeleteResult> results) {
        for (Database.DeleteResult result : results) {
            if (!result.isSuccess()) {
                String errorMessage = '';
                for (Database.Error e : result.getErrors()) {
                    errorMessage += e.getMessage();
                }
                LogUtil.log('DEFAULT', errorMessage, null);
            }
        }
    }

    /**
     * @description Logs errors from upsert results
     * @param results
     */
    public void handleUpsertResults(List<Database.UpsertResult> results) {
        for (Database.UpsertResult result : results) {
            if (!result.isSuccess()) {
                String errorMessage = '';
                for (Database.Error e : result.getErrors()) {
                    errorMessage += e.getMessage();
                }
                LogUtil.log('DEFAULT', errorMessage, null);
            }
        }
    }

    /**
     * @description Logs errors from save results
     * @param results
     */
    public void handleSaveResults(List<Database.SaveResult> results) {
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                String errorMessage = '';
                for (Database.Error e : result.getErrors()) {
                    errorMessage += e.getMessage();
                }
                LogUtil.log('DEFAULT', errorMessage, null);
            }
        }
    }

    /**
     * @description Generates a random string with length provided.
     * @param length 
     * @return  `String`
     */
    public String generateRandomString(Integer length) {
        final String CHARACTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randomString = '';
        while (randomString.length() < length) {
           Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()), CHARACTERS.length());
           randomString += CHARACTERS.substring(index, index+1);
        }
        return randomString; 
    }

    /**
     * @description Accepts an integer and returns a number with same number of digits as integer.
     * @param length 
     * @return  `String`
     */
    public String generateRandomNumber(Integer length) {
        final String CHARACTERS = '0123456789';
        String randomString = '';
        while (randomString.length() < length) {
            Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()), CHARACTERS.length());
            randomString += CHARACTERS.substring(index, index + 1);
        }
        return randomString;
    }

    /**
     * @description Returns a random date between two dates.
     * @param min 
     * @param max 
     * @return  `Date`
     */
    @SuppressWarnings('PMD.OneDeclarationPerLine')
    public Date generateRandomDate(Date min, Date max) {
      
        DateTime mint = min, maxt = max.addDays(1);
        Long minms = mint.getTime(), maxms = maxt.getTime(), diff = maxms - minms;
        return DateTime.newInstance(
            minms + Math.mod(Math.abs(Crypto.getRandomLong()), diff)
        ).date();
    }
}
