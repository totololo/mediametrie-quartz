/*
* @date: 09/08/2023
* @ Description : Classe aura Component Equipement du foyer de l'individu
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: AP01_Equipement_Du_Foyer_Individu_Test
* @Coverage: --%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP01_Equipement_Du_Foyer_De_l_Individu {
    @AuraEnabled
    public static List<Equipement_du_foyer_de_l_individu__c> getEquipementFoyerIndividu(Id recordId) {
        return [SELECT Id, Nom_Composition_Foyer__c, Utilisation_de_l_equipement__c FROM Equipement_du_foyer_de_l_individu__c WHERE Equipement_du_foyer__c = :recordId];
    }
    
    @AuraEnabled
    public static String updateEquipementFoyerIndividu(List<Equipement_du_foyer_de_l_individu__c> eqtFoyerIndividuList) {
        String result;
        try{ 
            database.update(eqtFoyerIndividuList);
            result = 'OK';
        } Catch(exception ex){
            result = ex.getmessage();
        }
        
        return result;
    }
    
    
}