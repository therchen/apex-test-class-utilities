/**
 * @description Factory class for creating test data in unit tests. 
 * This class is designed to be flexible and reusable across different test classes, 
 * with the ability to specify default field values through separate defaults classes. 
 * It also includes helper methods for creating specific types of users and other common test data.
 */
@isTest
public class TestFactory {

    /**
     * @description A map to hold the name field for different sObject types, since not all sObjects use 'Name' as their name field. 
     * This can be expanded as needed for other sObject types used in tests.
     */
    private static Map<Schema.SObjectType, Schema.SObjectField> nameFieldMap = new Map<Schema.SObjectType, Schema.SObjectField>{
        Contact.sObjectType => Contact.LastName,
        Case.sObjectType => Case.CaseNumber
    };

    /**
     * @description Creates a new instance of the specified sObject type, 
     * applying any default field values if a corresponding defaults class exists.
     * @param sObj The sObject instance to create.
     * @return The created sObject instance with default field values applied.
     */
    public static SObject createSObject(SObject sObj) {
        String objectName = String.valueOf(sObj.getSObjectType());
        String defaultClassName = objectName.replaceAll('__(c|C)$|__', '') + 'Defaults';
        if (Type.forName('TestFactoryDefaults.' + defaultClassName) != null) {
            sObj = createSObject(sObj, 'TestFactoryDefaults.' + defaultClassName);
        }
        return sObj;
    }

    /**
     * @description Creates a new instance of the specified sObject type, 
     * applying any default field values if a corresponding defaults class exists, and optionally inserts it.
     * @param sObj The sObject instance to create.
     * @param doInsert Whether to insert the created sObject.
     * @return The created sObject instance with default field values applied.
     */
    public static SObject createSObject(SObject sObj, Boolean doInsert) {
        SObject retObject = createSObject(sObj);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }

    /**
     * @description Creates a new instance of the specified sObject type, 
     * applying any default field values from the specified defaults class.
     * @param sObj The sObject instance to create.
     * @param defaultClassName The name of the defaults class to use.
     * @return The created sObject instance with default field values applied.
     */
    public static SObject createSObject(SObject sObj, String defaultClassName) {
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            throw new TestFactoryException('Invalid defaults class.');
        }
        FieldDefaults defaults = (FieldDefaults) t.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }

    /**
     * @description Creates a new instance of the specified sObject type, 
     * applying any default field values from the specified defaults class, and optionally inserts it.
     * @param sObj The sObject instance to create.
     * @param defaultClassName The name of the defaults class to use.
     * @param doInsert Whether to insert the created sObject.
     * @return The created sObject instance with default field values applied.
     */
    public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
        SObject retObject = createSObject(sObj, defaultClassName);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }

    /**
     * @description Creates a list of sObjects with the specified number of objects.
     * @param sObj The sObject instance to create.
     * @param numberOfObjects The number of sObjects to create.
     * @return An array of created sObjects.
     */
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
        return createSObjectList(sObj, numberOfObjects, (String) null);
    }

    /**
     * @description Creates a list of sObjects with the specified number of objects, and optionally inserts them.
     * @param sObj The sObject instance to create.
     * @param numberOfObjects The number of sObjects to create.
     * @param doInsert Whether to insert the created sObjects.
     * @return An array of created sObjects.
     */
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, (String) null);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }

    /**
     * @description Creates a list of sObjects with the specified number of objects, applying any default field values from the specified defaults class, and optionally inserts them.
     * @param sObj The sObject instance to create.
     * @param numberOfObjects The number of sObjects to create.
     * @param defaultClassName The name of the defaults class to use.
     * @param doInsert Whether to insert the created sObjects.
     * @return An array of created sObjects.
     */
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, defaultClassName);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }

    /**
     * @description Creates a list of sObjects with the specified number of objects, applying any default field values from the specified defaults class.
     * @param sObj The sObject instance to create.
     * @param numberOfObjects The number of sObjects to create.
     * @param defaultClassName The name of the defaults class to use.
     * @return An array of created sObjects.
     */
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
        SObject[] sObjs = new List<SObject>{};
        SObject newObj;

        if (defaultClassName == null) {
            newObj = createSObject(sObj);
        } else {
            newObj = createSObject(sObj, defaultClassName);
        }

        String nameField = String.valueOf(nameFieldMap.get(sObj.getSObjectType()));
        if (nameField == null) {
            nameField = 'Name';
        }
        Boolean nameIsAutoNumber = sObj.getSobjectType().getDescribe().fields.getMap().get(nameField).getDescribe().isAutoNumber();

        for (Integer i = 0; i < numberOfObjects; i++) {
            SObject clonedSObj = newObj.clone(false, true);
            if (!nameIsAutoNumber) {
                clonedSObj.put(nameField, (String) clonedSObj.get(nameField) + ' ' + i);
            }
            sObjs.add(clonedSObj);
        }
        return sObjs;
    }

    /**
     * @description Adds default field values to the specified sObject.
     * @param sObj The sObject instance to which to add default field values.
     * @param defaults A map of field defaults to apply.
     */
    private static void addFieldDefaults(SObject sObj, Map<Schema.SObjectField, Object> defaults) {
        Map<String, Object> populatedFields = sObj.getPopulatedFieldsAsMap();
        for (Schema.SObjectField field : defaults.keySet()) {
            if (!populatedFields.containsKey(String.valueOf(field))) {
                sObj.put(field, defaults.get(field));
            }
        }
    }

    /**
     * @description Exception class for the TestFactory utility class.
     */
    public class TestFactoryException extends Exception {
    }

    /**
     * @description Interface for classes that provide default field values for sObjects.
     */
    public interface FieldDefaults {
        Map<Schema.SObjectField, Object> getFieldDefaults();
    }

    /**
     * @description Creates a user with minimum access permissions.
     * @param doInsert Whether to insert the created user.
     * @return The created user.
     */
    public static User createMinAccessUser(Boolean doInsert) {
        Id profileId = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Minimum Access - Salesforce'
        ]
        .Id;
        return TestFactory.createTestUser(profileId, doInsert);
    }

    /**
     * @description Creates a test user with the specified profile.
     * @param profileId The Id of the profile to assign to the user.
     * @param doInsert Whether to insert the created user.
     * @return The created user.
     */
    public static User createTestUser(Id profileId, boolean doInsert) {
        User u = new User(
            profileId = profileId,
            LastName = 'last',
            Email = 'testuser@test.com',
            Username = 'testuser@test.example.com' + Crypto.getRandomInteger(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        if (doInsert) {
            insert u;
        }
        return u;
    }

    /**
     * @description Creates a marketing user with the specified profile.
     * @param doInsert Whether to insert the created user.
     * @return The created user.
     */
    public static User createMarketingUser(Boolean doInsert) {
        Id profileId = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Marketing User'
        ]
        .Id;
        return TestFactory.createTestUser(profileId, doInsert);
    }

    /**
     * @description Helper method to retrieve the Id of a profile by name. This can be used in tests to assign specific profiles to test users without hardcoding Ids.
     * @param profileName The name of the profile for which to retrieve the Id.
     * @return The Id of the profile with the specified name.
     */
    public static Id getProfileId(String profileName) {
        Id profileId;
        Profile profile = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
        profileId = profile.Id;
        return profileId;
    }
}
