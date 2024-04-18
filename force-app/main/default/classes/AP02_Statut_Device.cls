/*
* @date: 16/08/2023
* @ Description : Automatisme pour auto-increment extID_prestataire__c
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: AP02_Statut_Device_Test
* @Coverage: --%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP02_Statut_Device {
    
    public static void autoIncrementIdDevice(List<Statut_Device_Equipement_Mesure__c> statutDeviceList) {
        
        List<Id> eqtFoyerIdList = new List<Id>();
        List<Id> foyerIdList = new List<Id>();
        List<Equipements_du_foyer__c> eqtFoyerList = new List<Equipements_du_foyer__c>();
        List<Statut_Device_Equipement_Mesure__c> allStatutDeviceListTV = new List<Statut_Device_Equipement_Mesure__c>();
        List<Statut_Device_Equipement_Mesure__c> allStatutDeviceListAutre = new List<Statut_Device_Equipement_Mesure__c>();
        List<Statut_Device_Equipement_Mesure__c> statutDeviceToUpdateList = new List<Statut_Device_Equipement_Mesure__c>();
        Id recordTypeIdPosteTV =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        
        for(Statut_Device_Equipement_Mesure__c statutDevice:statutDeviceList) {
            eqtFoyerIdList.add(statutDevice.Equipement_du_foyer__c);
        }
        
        eqtFoyerList = [SELECT Id, Foyer__c FROM Equipements_du_foyer__c WHERE Id IN :eqtFoyerIdList];
        
        for(Equipements_du_foyer__c eqtFoyer:eqtFoyerList) {
            foyerIdList.add(eqtFoyer.Foyer__c);
        }
        
        allStatutDeviceListTV = [SELECT Id, ExtID_partenaire__c, Equipement_du_foyer__r.foyer__c FROM Statut_Device_Equipement_Mesure__c 
                                 WHERE Equipement_du_foyer__r.recordTypeId = :recordTypeIdPosteTV AND Equipement_du_foyer__r.foyer__c IN :foyerIdList];
        allStatutDeviceListAutre = [SELECT Id, ExtID_partenaire__c, Equipement_du_foyer__r.foyer__c FROM Statut_Device_Equipement_Mesure__c 
                                 WHERE Equipement_du_foyer__r.recordTypeId != :recordTypeIdPosteTV AND Equipement_du_foyer__r.foyer__c IN :foyerIdList];
                
        statutDeviceToUpdateList.addAll(calculautoIncrementIdDevice(allStatutDeviceListTV, foyerIdList, initListExtIdPrestataireTV()));
        statutDeviceToUpdateList.addAll(calculautoIncrementIdDevice(allStatutDeviceListAutre, foyerIdList, initListExtIdPrestataireAutre()));
            
        if(statutDeviceToUpdateList.size() > 0  && statutDeviceToUpdateList != null) {
            try{ 
                database.update(statutDeviceToUpdateList);
            }Catch(exception ex){
                system.debug('Update statut device ExtID_partenaire__c Exception Error:' + ex.getmessage());
            }
        }
        
    }
    
    public static List<Statut_Device_Equipement_Mesure__c> calculautoIncrementIdDevice(List<Statut_Device_Equipement_Mesure__c> allStatutDeviceList, List<Id> foyerIdList, List<Integer> initListExtIdPrestataire) {
        List<Equipements_du_foyer__c> eqtFoyerList = new List<Equipements_du_foyer__c>();
        List<Statut_Device_Equipement_Mesure__c> statutDeviceToUpdateList = new List<Statut_Device_Equipement_Mesure__c>();
        Map<Id, List<Statut_Device_Equipement_Mesure__c>> idFoyerStatutDeviceListMap = new Map<Id, List<Statut_Device_Equipement_Mesure__c>>();
        Map<Id, List<Integer>> idFoyerExtIdPrestataireListMap = new Map<Id, List<Integer>>();
                
        for(Statut_Device_Equipement_Mesure__c statutDevice:allStatutDeviceList) {
            if (idFoyerStatutDeviceListMap.get(statutDevice.Equipement_du_foyer__r.foyer__c) != null) {
                idFoyerStatutDeviceListMap.get(statutDevice.Equipement_du_foyer__r.foyer__c).add(statutDevice);
            }
            else {
                idFoyerStatutDeviceListMap.put(statutDevice.Equipement_du_foyer__r.foyer__c, new List<Statut_Device_Equipement_Mesure__c>{statutDevice});
            }
            if(idFoyerExtIdPrestataireListMap.get(statutDevice.Equipement_du_foyer__r.foyer__c) == null) {
                idFoyerExtIdPrestataireListMap.put(statutDevice.Equipement_du_foyer__r.foyer__c, initListExtIdPrestataire);
            }
        }
                
        for(id foyerId:foyerIdList) {
            for(Statut_Device_Equipement_Mesure__c statutDevice:idFoyerStatutDeviceListMap.get(foyerId)) {
                if(statutDevice.ExtID_partenaire__c != null) {
                    idFoyerExtIdPrestataireListMap.get(statutDevice.Equipement_du_foyer__r.foyer__c).remove(idFoyerExtIdPrestataireListMap.get(statutDevice.Equipement_du_foyer__r.foyer__c).indexOf(Integer.valueOf(statutDevice.ExtID_partenaire__c)));
                }
            }
        }
        
        for(id foyerId:foyerIdList) {
            for(Statut_Device_Equipement_Mesure__c statutDevice:idFoyerStatutDeviceListMap.get(foyerId)) {
                if(statutDevice.ExtID_partenaire__c == null) {
                    statutDevice.ExtID_partenaire__c = idFoyerExtIdPrestataireListMap.get(foyerId)[0];
                    idFoyerExtIdPrestataireListMap.get(foyerId).remove(0);
                    statutDeviceToUpdateList.add(statutDevice);
                }
            }
        }
        return statutDeviceToUpdateList;
    }
    
    public static List<Integer> initListExtIdPrestataireTV() {
         List<Integer> extIdPrestataireList = new List<Integer>();
        
        for(Integer i =1; i <=10; i++) {
            extIdPrestataireList.add(i);
        }
        return extIdPrestataireList;
    }
    
    public static List<Integer> initListExtIdPrestataireAutre() {
         List<Integer> extIdPrestataireList = new List<Integer>();
        
        for(Integer i =10; i <=99; i++) {
            extIdPrestataireList.add(i);
        }
        return extIdPrestataireList;
    }

}