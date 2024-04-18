/*
* @author: Claire VEHRLE
* @date: 25/04/2022
* @ Description Trouver les objets qui n'ont pa sréussi à être transformé
* @TestClass:
* @Coverage:
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class AP00_Objet_Non_transforme {

    public static void foyerNonTransformeMMATPaME() {
        List<Account> allFoyer = [SELECT Id, name, (SELECT Id FROM Panelistes__r) FROM Account
                                 WHERE Type_de_foyer__c = :Label.ACC_Type_de_panel_Pame 
                                                 OR Type_de_foyer__c = :Label.ACC_Type_de_panel_Mediamat];
        List<Account> foyerNonTransformeList = new List<Account>();
        
        for(Account foyer : allFoyer){
            System.debug('NON foyer.Panelistes__r: ' +foyer.Panelistes__r);
            if(foyer.Panelistes__r.isEmpty() && foyer.Panelistes__r.size() == 0) {
                foyerNonTransformeList.add(foyer);
            }
        }
        
        System.debug('NON_TRANSFORME: Taille list Foyer MMAT PaME: ' + foyerNonTransformeList.size());
        for(Account foyerNontransforme :foyerNonTransformeList) {
            System.debug('NON_TRANSFORME: Foyer MMAT PaME: ' + foyerNontransforme);
        }
        
    }
    
    public static void foyerNonTransformeAIP() {
        List<Account> allFoyer = [SELECT Id, name, (SELECT Id FROM Panelistes__r) FROM Account WHERE Type_de_foyer__c = '4'];
        List<Account> foyerNonTransformeList = new List<Account>();
        
        for(Account foyer : allFoyer){ 
            if(foyer.Panelistes__r.isEmpty() && foyer.Panelistes__r.size() == 0) {
                foyerNonTransformeList.add(foyer);
            }
        }
        
        System.debug('NON_TRANSFORME: Taille list Foyer AIP: ' + foyerNonTransformeList.size());
        for(Account foyerNontransforme :foyerNonTransformeList) {
            System.debug('NON_TRANSFORME: Foyer AIP: ' + foyerNontransforme);
        }
        
    }
    
    public static void compoFoyerNonTransformeMMATPaME() {
        List<Contact> allCompositionFoyer = [SELECT id, name, account.Type_de_foyer__c, (SELECT Id FROM Paneliste__r)
                                         	FROM Contact 
                                             WHERE (Account.Type_de_foyer__c = :Label.ACC_Type_de_panel_Pame 
                                                 OR Account.Type_de_foyer__c = :Label.ACC_Type_de_panel_Mediamat) 
                                             	AND AccountID != null AND (NOT(FirstName LIKE 'prenom_%'))];
        
        List<Contact> compoFoyerNonTransformeList = new List<Contact>();
        
        for(Contact compoFoyer : allCompositionFoyer){ 
            if(compoFoyer.Paneliste__r.isEmpty() && compoFoyer.Paneliste__r.size() == 0) {
                compoFoyerNonTransformeList.add(compoFoyer);
            }
        }
        
        System.debug('NON_TRANSFORME: Taille list Composition Foyer MMAT PaME: ' + compoFoyerNonTransformeList.size());
        for(Contact compoFoyer :compoFoyerNonTransformeList) {
            System.debug('NON_TRANSFORME: Composition Foyer MMAT PaME: ' + compoFoyer);
        }
        
    }
    
    public static void compoFoyerNonTransformeAIP() {
        List<Contact> allCompositionFoyer = [SELECT id, name, account.Type_de_foyer__c, (SELECT Id FROM Paneliste__r)
                                         FROM Contact WHERE Account.Type_de_foyer__c = :Label.ACC_Type_de_panel_AIP AND Type__c != '2'];
        
        List<Contact> compoFoyerNonTransformeList = new List<Contact>();
        
        for(Contact compoFoyer : allCompositionFoyer){ 
            if(compoFoyer.Paneliste__r.isEmpty() && compoFoyer.Paneliste__r.size() == 0) {
                compoFoyerNonTransformeList.add(compoFoyer);
            }
        }
        
        System.debug('NON_TRANSFORME: Taille list Composition Foyer AIP: ' + compoFoyerNonTransformeList.size());
        for(Contact compoFoyer :compoFoyerNonTransformeList) {
            System.debug('NON_TRANSFORME: Composition Foyer AIP: ' + compoFoyer);
        }
        
    }
}