/**@description Provides default field values for various sObjects/record types used in tests.
 * 
 */
@IsTest
public class TestFactoryDefaults {


    /**
     * @description Provides default field values for Account sObjects.
     */
    public class AccountDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Account.Name => 'Test Account' };
        }
    }

    /**
     * @description Provides custom default field values for Account sObjects.
     */
    public class MyAccountDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Account.Name => 'My Test Account' };
        }
    }

    /**
     * @description Provides default field values for Contact sObjects.
     */
    public class ContactDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Contact.FirstName => 'First', Contact.LastName => 'Last' };
        }
    }

    /**
     * @description Provides default field values for Opportunity sObjects.
     */
    public class OpportunityDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{
                Opportunity.Name => 'Test Opportunity',
                Opportunity.StageName => 'Closed Won',
                Opportunity.CloseDate => System.today()
            };
        }
    }

    /**
     * @description Provides default field values for Case sObjects.
     */
    public class CaseDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Case.Subject => 'Test Case' };
        }
    }
}
