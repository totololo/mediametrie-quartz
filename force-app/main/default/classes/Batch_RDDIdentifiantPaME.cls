/*
* @date: 24/04/2023
* @ Description : RDD Post MES des identifiants PaME 
* @Auteur : Claire VEHRLE
* @TestClass: Batch_RDDIdentifiantPaME_Test
* @Coverage: -- %
History
* <Date of modification> 		<Author> 	<Description of modification>
* 
*/
public class Batch_RDDIdentifiantPaME implements Database.Batchable<sObject>, Database.Stateful {

    public List<Foyer_Paneliste__c> start(Database.BatchableContext bc) {
        
        List<Foyer_Paneliste__c> FoyerPanPaMEList = new List<Foyer_Paneliste__c>();
        
        FoyerPanPaMEList = [SELECT Id, name, identifiant_foyer_PaME__c, Numero_foyer__c, Lettre_operateur__c 
                            FROM Foyer_Paneliste__c 
                            WHERE Numero_foyer__c != null AND Lettre_operateur__c != null
                            ANd Referentiel_Panel__r.Type_de_panel__c = :Label.RFP_TypePanel_PaME
                            AND Foyer_equipe__c = true];
        
        return FoyerPanPaMEList;
    }
    
    public void execute(Database.BatchableContext bc, List<Foyer_Paneliste__c> scope) {
        System.debug('$$$scope: ' + scope);
        
        String numeroFoyer;
        Map<String, String> panelLetters = new Map<String, String>();
        panelLetters.put('A', '1');
        panelLetters.put('B', '4');
        panelLetters.put('C', '5');
        panelLetters.put('D', '2');
        panelLetters.put('H', '3');
        panelLetters.put('P', '6');
        panelLetters.put('Q', '7');
        panelLetters.put('R', '8');    
        
        for(Foyer_paneliste__c foyerPan:scope) {
                numeroFoyer = String.valueOf(foyerPan.Numero_foyer__c);
                if (numeroFoyer.length() != 4) {
                    if(numeroFoyer.length() == 1) {
                        numeroFoyer = '000' + numeroFoyer;
                    }
                    else if(numeroFoyer.length() == 2) {
                        numeroFoyer = '00' + numeroFoyer;
                    }
                    else {
                        numeroFoyer = '0' + numeroFoyer;
                    }
                }
            foyerPan.Identifiant_foyer_pame__c = Integer.valueOf(panelLetters.get(foyerPan.Lettre_operateur__c) + numeroFoyer);
            System.debug('$$$foyerPan.Identifiant_foyer_pame__c: ' + foyerPan.Identifiant_foyer_pame__c);
        }
        
        if(scope.size() > 0 && scope != null) {
            Update scope;
            /*try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Remplissage identifiant PaME Error:' + ex.getmessage());
            }*/
        }
    }
    
    public void finish(Database.BatchableContext BC) {}
}