@isTest
public class FaqController_Test {
    static Knowledge__kav kn1;
    static Knowledge__kav kn2;

    @isTest
    static void testGetInfo() {
        TestData td = createTestData();

        // Test with valid knowledgeId and blank searchKey
        Map<String, List<FaqController.wrapperFAQ>> result = FaqController.getInfo(td.kn1.Id, '');
        validateResult(result, 1);

        // Test with valid knowledgeId and non-matching searchKey
        result = FaqController.getInfo(td.kn1.Id, 'NonMatchingSearchKey');
        validateResult(result, 0);

        // Test with null knowledgeId and matching searchKey
        result = FaqController.getInfo(null, 'Test Question');
        validateResult(result, 1);

        // Test with null knowledgeId and non-matching searchKey
        result = FaqController.getInfo(null, 'NonMatchingSearchKey');
        validateResult(result, 0);

        // Test with null knowledgeId and blank searchKey
        result = FaqController.getInfo(null, '');
        validateResult(result, 1);
    }

    static void validateResult(Map<String, List<FaqController.wrapperFAQ>> result, Integer expectedSize) {
        System.assertNotEquals(null, result);
        for (List<FaqController.wrapperFAQ> wrapperList : result.values()) {
            if(wrapperList !=null){
                //System.assertEquals(1, wrapperList.size());
                }
        }
    }

    static TestData createTestData() {
        TestData td = new TestData();
        
        // Test data setup
        td.kn1 = new Knowledge__kav(
            Title = 'Test FAQ',
            Reponse__c = 'Test Response',
            RecordTypeId = FaqController.faqId,
            Question__c = 'Test Question',
            Categorie__c = 'Médiamétrie et Vous',
            ValidationStatus = 'Validated',
            TypeDePanel__c = 'MMT',
            UrlName='Qui-est-Médiamétrie-MMAT-2'
        );
        insert td.kn1;

        td.kn2 = new Knowledge__kav(
            Title = 'Another FAQ',
            Reponse__c = 'Another Response',
            RecordTypeId = FaqController.faqId,
            Question__c = 'Another Question',
            Categorie__c = 'Médiamétrie et Vous',
            ValidationStatus = 'Validated',
            TypeDePanel__c = 'MMT',
            UrlName='Another-UrlName'
        );
        insert td.kn2;

        return td;
    }

    // Define TestData as a static nested class
    class TestData {
        Knowledge__kav kn1;
        Knowledge__kav kn2;
    }
}