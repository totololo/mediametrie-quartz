/*
* @date: 06/09/2021
* @ Description : modifier le statut foyer paneliste a installe si tous les equipements sont au statut installe
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: AP03_FoyerPaneliste_Test
* @Coverage: 93%
 History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP03_FoyerPaneliste {
    public static void MajStatutInstalle(List<Id> ListIdFoyerPen){
        Id recordTypeIdAssetAip =Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdFoyerPanAip =Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        boolean Recrute;
        System.debug('recordTypeIdAssetAip: ' + recordTypeIdAssetAip);
        List<Foyer_paneliste__c> foyerPanToUpdate = new List<Foyer_paneliste__c>() ;
        for(Foyer_paneliste__c fp :[select id ,name,Statut_Foyer_paneliste__c,Date_d_installation__c, (select id,name,Status,RecordTypeId from Equipements__r where RecordTypeId=:recordTypeIdAssetAip)
                                    from foyer_paneliste__c where id IN:ListIdFoyerPen AND Statut_Foyer_paneliste__c = :Label.PAN_Statut_panel AND id in (Select Foyer_paneliste__c from Asset Where Status =:label.ASS_Statut_Installe )
                                     AND RecordTypeId   = : recordTypeIdFoyerPanAip]){
                                        
            list<Asset> verifAsset= new list<Asset>();
            for(Asset ass : fp.Equipements__r){
            System.debug('ass: ' + ass);
            System.debug('fp.Statut_Foyer_paneliste__c: ' + fp.Statut_Foyer_paneliste__c);
                if (fp.Statut_Foyer_paneliste__c== label.PAN_Statut_panel){
                    Recrute=true;
                }
                //Modifier par KHA ticket 16508 : le statut du foyer panéliste de doit pas obligatoirement être recruté
                if(ass.Status==Label.ASS_Statut_Installe){
                    verifAsset.add(ass);
                }
            }
            if(verifAsset != null && fp.Equipements__r !=null && verifAsset.size()>0 && verifAsset.size()==fp.Equipements__r.size() && fp.Date_d_installation__c ==null){
                fp.Statut_Foyer_paneliste__c= Recrute ?  Label.PAN_Statut_Panel_Installe : fp.Statut_Foyer_paneliste__c;
                fp.Date_d_installation__c =  date.today();
                foyerPanToUpdate.add(fp);
            }
        }
        if(foyerPanToUpdate.size()>0 && foyerPanToUpdate != null){
            try{ 
                database.update(foyerPanToUpdate);
            }Catch(exception ex){
                
                system.debug('Update foyer paneliste Exception Error:'+ex.getmessage());
            }
        }
    }
}