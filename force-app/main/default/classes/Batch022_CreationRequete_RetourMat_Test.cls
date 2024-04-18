@istest
public class Batch022_CreationRequete_RetourMat_Test {

    public static testmethod void Batch022_CreationRequete_RetourMat_Test(){
        
       Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();


        
    account acc= new account();
        acc.name='acc';
        insert acc;
        
        Foyer_Paneliste__c fp = new Foyer_Paneliste__c();
        fp.Name='test';
        fp.Foyer__c=acc.id;
        insert fp;
        
        
        
        case cs = new case();
        cs.RecordTypeId=recordTypeIdRequeteDemandePanelisteAIP;
        cs.CreatedDate=Datetime.now().addDays(-45);
        cs.Chute_confirmee__c=true;
        cs.Motif_de_chute__c='Ondes';
        cs.Foyer_paneliste__c=fp.id;
        cs.AccountId=acc.id;
        insert cs;
        //cs.AccountId=acc.id;
		//update cs;
        
        case c= [select id,Jour_de_traitement__c from case where id =: cs.id];
        system.debug('ss '+c.Jour_de_traitement__c);
        upsert c;
        asset equip = new asset();
        equip.name='tv';
        equip.Status='2';
        equip.AccountId=acc.Id;
        equip.Foyer_paneliste__c=fp.id;
        insert equip;
        
        Test.startTest();
        Batch022_CreationRequete_RetourMateriel btch = new Batch022_CreationRequete_RetourMateriel();
        database.executeBatch(btch);
        Test.stopTest();
        
        case ca = [select id,Foyer_paneliste__c,Sous_type__c from case where type=:Label.CAS_Type_Suivi_Chute];
        
        system.assertEquals(ca.Foyer_paneliste__c,fp.id);
        system.assertEquals(Label.CAS_SousType_RestitutionDuMateriel, ca.Sous_type__c);
    }
    
}