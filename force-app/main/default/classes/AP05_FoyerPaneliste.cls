/*
* @date: 05/10/2021
* @ Description : Mise à jour de la localisation de l’équipement de mesure à « Perdu » si le statut du foyer paneliste est 'chute definitive' et le statut audimetrique est non-repondant 
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: AP05_FoyerPaneliste_Test
* @Coverage: 88%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP05_FoyerPaneliste {
    
    public static void MajStatusEquipementPerdu (List<Foyer_paneliste__c> listFoyerPAn){
        List<Asset> assetToUpdate = new List<Asset>();
        for(asset equi : [select id , localisation__c from asset where localisation__c=:label.ASS_Localisation_Foyer and Status=:Label.ASS_Statut_Valide and Foyer_paneliste__c IN :listFoyerPAn]){
            equi.Status= Label.ASS_Statut_Perdu;
            assetToUpdate.add(equi);
        }
        if(assetToUpdate.size()>0 && assetToUpdate!=null){
            try{ 
                database.update(assetToUpdate);
            }Catch(exception ex){
                
                system.debug('Update asset to perdu Exception Error:'+ex.getmessage());
            }
        }
        
    }
}