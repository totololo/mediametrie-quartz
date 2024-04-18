/*
* @date: 21/07/2021
* @ Description : la methode 'FoyerPAnelisteChute'  modifie les champs suivant : statut du foyer = chute temporaire & date de chute = today
afin de chuter le foyer paneliste
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: AP04_FoyerPaneliste_Test
* @Coverage: 90%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP04_FoyerPaneliste {
    public static void FoyerPAnelisteChute(List<Id> ListFoyerPanId){
        system.debug('$$$ in FoyerPAnelisteChute');
        List<Foyer_paneliste__c> ListFoyerPanToUpdate = new List<Foyer_paneliste__c>();
        For(Foyer_paneliste__c fp : [select id , Statut_Foyer_paneliste__c,Date_de_chute_temporaire__c	 from Foyer_paneliste__c where id IN : ListFoyerPanId]){
            System.debug('$$$fp: ' + fp);
            fp.Date_de_chute_temporaire__c= Date.today();
            fp.Statut_Foyer_paneliste__c=Label.PAN_Statut_Panel_Chute_temporaire;
            ListFoyerPanToUpdate.add(fp);
        }
        if(ListFoyerPanToUpdate.size()>0 && ListFoyerPanToUpdate !=null){
            try{ 
               // system.debug('$$$ KHA in foyer paneliste update');
                database.update(ListFoyerPanToUpdate);
            }Catch(exception ex){
                
                system.debug('$$$Update foyer paneliste Exception Error:'+ex.getmessage());
            }
        }
    }
    
}