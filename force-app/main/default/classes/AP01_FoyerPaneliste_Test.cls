/*
* @date: 08/07/2021
* @ Description Class qui teste AP01_FoyerPaneliste . Associatée au declencher : PanelAfterUpdate
* @version 1.00   
* pourcentage : 96%
* @Auteur Ayoub Ghammaz EIT
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP01_FoyerPaneliste_Test {
    @testSetup static void setup() {
      Profile pfAdmin= [Select Id from profile where Name='Administrateur système' or  Name='System Administrator']; 

      User uu=new User(firstname = 'testFirst', 
                         lastName = 'testLast', 
                         email = 't@test.org', 
                         Username = 't@test.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'test12', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pfAdmin.Id,
                       	 isActive = true
                        ); 
        
        insert uu;  
        
            /*Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
            Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
            // Créer un foyer pour l'insérer dans le panel
            Account foyerTest = new Account(Name='testPanel');
            insert foyerTest;
            // Créer un panel Aip
            List<Foyer_paneliste__c> testPanelAip = new List<Foyer_paneliste__c>(); 
            for(Integer i=0;i<2;i++) {
            testPanelAip.add(new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip'+i,Foyer__c=foyerTest.id,	Statut_Foyer_paneliste__c=Label.PAN_Statut_panel));
            System.debug('-->'+testPanelAip);
            }
            insert testPanelAip;  
            // Créer un panel MediaMat
            List<Foyer_paneliste__c> testPanelMM = new List<Foyer_paneliste__c>();
            for(Integer i=0;i<2;i++) {
            testPanelMM.add(new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelMediamatPame,Name='testAip'+i,Foyer__c=foyerTest.id ,Statut_Foyer_paneliste__c=Label.PAN_Statut_panel));
            System.debug('-->'+testPanelMM);
            }
            insert testPanelMM;  */
		}
    @isTest static void testPanelAipMethod1() {//tester la methode NouvelleReqAIP
        
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and email like '%t@test.org%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        System.debug('je suis u, ');
        System.debug(u);
        update u;
        
        System.runAs(u){
            
            Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
            
            // Créer un foyer pour l'insérer dans le panel
            Account foyerTest = new Account(Name='testPanel');
            
            /* // Insert Pricebook
                PriceBook2 customPriceBook = new PriceBook2();
                customPriceBook.Name='Standard';
                customPriceBook.IsActive=true;
                insert customPriceBook;*/

            test.startTest();
            insert foyerTest;
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerTest.id)); 
            test.stopTest();
            
            
           Pricebook2 standardPricebook = new Pricebook2(Id =Test.getStandardPricebookId(),IsActive = true, Name='Standard Price Book');
			update standardPricebook;
            
            
            
            Product2 prod = new Product2();
            prod.Name='test';
            INSERT prod; 
            
            System.debug('$$$pricebook: ' + [SELECT Id,name FROm pricebook2]);
            
            PricebookEntry pbe = [SELECT Id FROM PricebookEntry WHERE product2id= :prod.id LIMIT 1];
            
            pbe.UnitPrice = 2;
            update(pbe);      
            
            Order ord = Test_Utils.createOrder(foyerTest.id);
            ord.EffectiveDate=system.today()+3;
            ord.Status='1';
            ord.Pricebook2Id=Test.getStandardPricebookId();
            insert ord;
            
            OrderItem orderItem1 = new OrderItem();
            orderItem1.OrderId=ord.id;
            orderItem1.Product2Id=prod.id;
            orderItem1.PricebookEntryId=pbe.id;
            orderItem1.UnitPrice=1.21;
            orderItem1.Quantity=2;
            insert orderItem1;
            List<Foyer_paneliste__c> testPanelMM = new List<Foyer_paneliste__c>();
            for(Integer i=0;i<2;i++) {
                testPanelMM.add(new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip'+i,Foyer__c=foyerTest.id ,Statut_Foyer_paneliste__c=Label.PAN_Statut_panel));
                System.debug('-->'+testPanelMM);
            }
            insert testPanelMM;
            for(Foyer_paneliste__c i : testPanelMM){
                i.Date_de_creation__c = date.today();
            }
            update testPanelMM;
            /*insert foyerTest;
foyerTest.Date_de_creation__c = date.today();
foyerTest.Foyer_equipe__c = true;
update foyerTest;*/
            // Créer un panel Aip
            /*List<Foyer_paneliste__c> testPanelAip = new List<Foyer_paneliste__c>(); 
for(Integer i=0;i<2;i++) {
testPanelAip.add(new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip'+i,Foyer__c=foyerTest.id,	Statut_Foyer_paneliste__c=Label.PAN_Statut_panel));
System.debug('-->'+testPanelAip);
}*/
            //insert testPanelAip;  
            /* List<Foyer_paneliste__c> pan = [SELECT Id,foyer__c FROM Foyer_paneliste__c where RecordTypeId=:recordTypeIdPanelAIP];
System.debug('pan ->'+pan);*/
            //AP01_FoyerPaneliste.NouvelleReqAIP(testPanelAip);
            List<Case> testCase =[select id from Case ];
            System.debug('testcase ->'+testCase);
            System.debug('testcase size ->'+testCase.size());
            //System.assertEquals(2, testCase.size());
        }
        
    }
    
    static testMethod void testPanelMadiaMatMethod2() {// tester la methode NouvelleReq
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and email like '%t@test.org%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        u.Bypass_validation_rules__c=True;
        update u;
         System.debug('je suis testPanelMadiaMatMethod2');
        Database.DMLOptions dml = new Database.DMLOptions(); 
		dml.DuplicateRuleHeader.AllowSave = true;
        
        System.runAs(u){
            Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
            // Créer un foyer pour l'insérer dans le panel
            Account foyerTest = new Account(Name='testPanel');
            test.startTest();
            insert foyerTest;
            Pricebook2 standardPricebook = new Pricebook2(Id =Test.getStandardPricebookId(),IsActive = true, Name='Standard Price Book');
			update standardPricebook;
            
            
            Product2 prod = new Product2();
            prod.Name='test2';
            INSERT prod; 
            
            PricebookEntry pbe1= new PricebookEntry(pricebook2id = Test.getStandardPricebookId(), product2id = prod.id,unitprice=10.0, isActive=true);
            Database.SaveResult sr = Database.insert(pbe1, dml);
            if (sr.isSuccess()) {
                System.debug('Duplicate PricebookEntry has been inserted in Salesforce!');
            }
            
            
            PricebookEntry pbe = [SELECT Id FROM PricebookEntry WHERE pricebook2id=:standardPricebook.id AND product2id= :prod.id LIMIT 1];
            
            pbe.UnitPrice = 2;
            update(pbe);            
            
            Order ord = Test_Utils.createOrder(foyerTest.id);
            ord.EffectiveDate=system.today()+3;
            ord.Status='1';
            ord.Pricebook2Id=Test.getStandardPricebookId();
            insert ord;
            
            OrderItem orderItem1 = new OrderItem();
            orderItem1.OrderId=ord.id;
            orderItem1.Product2Id=prod.id;
            orderItem1.PricebookEntryId=pbe.id;
            orderItem1.UnitPrice=1.21;
            orderItem1.Quantity=2;
            insert orderItem1;
            
            
            
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerTest.id)); 
            test.stopTest();
            // Créer un panel MediaMat
            List<Foyer_paneliste__c> testPanelMM = new List<Foyer_paneliste__c>();
            for(Integer i=0;i<2;i++) {
                testPanelMM.add(new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelMediamatPame,Name='testAip'+i,Foyer__c=foyerTest.id ,Statut_Foyer_paneliste__c=Label.PAN_Statut_panel));
                System.debug('-->'+testPanelMM);
            }
            insert testPanelMM;  
            update testPanelMM;
            //List<Foyer_paneliste__c> pan = [SELECT Id,foyer__c FROM Foyer_paneliste__c where RecordTypeId=:recordTypeIdPanelMediamatPame];
            //AP01_FoyerPaneliste.NouvelleReq(pan);
            List<Case> testCase =[select id from Case];
            //System.assertEquals(2, testCase.size());
            
        }   
    }
    
    @isTest static void NouvelleReq(){
        System.debug('NouvelleReq');
        
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and email like '%t@test.org%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande;AP01_Requete';
        u.Bypass_validation_rules__c=True;
        update u;
        
        System.runAs(u){
            Foyer_paneliste__c pan=Test_Utils.createFoyerPaneliste();
            pan.RecordTypeId=recordTypeIdPanelMediamatPame;
            pan.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
            pan.Foyer_equipe__c=true;
            pan.Date_de_creation__c = null;
            insert pan;
            
            pan.Date_de_creation__c=system.today();
            update pan;
        }
    }
    
}