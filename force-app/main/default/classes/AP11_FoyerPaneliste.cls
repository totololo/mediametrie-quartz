/*
* @date: 08/08/2023
* @ Description : Création statut device
* @Auteur Claire VEHRLE
* @TestClass: AP11_FoyerPaneliste_Test
* @Coverage: --%
History
* <Date of modification> 		<Author> 	<Description of modification>
*
*/
public class AP11_FoyerPaneliste {

    public static void creationStatutDevice(List<Id> foyerIdList) {
        List<Equipements_du_foyer__c> eqtFoyerList = new List<Equipements_du_foyer__c>();
        List<Statut_Device_Equipement_Mesure__c> statutDeviceToInsert = new List<Statut_Device_Equipement_Mesure__c>();
        
        eqtFoyerList = [SELECT Id FROM Equipements_du_foyer__c WHERE Foyer__c IN :foyerIdList];
        
        for (Equipements_du_foyer__c eqtFoyer: eqtFoyerList) {
            Statut_Device_Equipement_Mesure__c newStatutDevice = new Statut_Device_Equipement_Mesure__c();
            newStatutDevice.Equipement_du_foyer__c = eqtFoyer.Id;
            statutDeviceToInsert.add(newStatutDevice);
        }
        
        if(statutDeviceToInsert.size()>0 && statutDeviceToInsert !=null){
            try{ 
                database.insert(statutDeviceToInsert);
            }Catch(exception ex){
                system.debug('$$$Insert Equipement de mesure Device rattaché à l\'équipement du foyer Exception Error:'+ex.getmessage());
            }
        }
    }
}