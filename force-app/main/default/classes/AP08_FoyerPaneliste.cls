/*
* @author: Claire VEHRLE
* @date: 26/04/2022
* @ Description : Ajout/Suppression des valeurs du champ Types de panel sur Foyer
* @TestClass: AP08_FoyerPaneliste_Test
* @Coverage: 
* History
* <Date of modification>   			<Author>   		 <Description of modification>
*		
*/
public class AP08_FoyerPaneliste {
    
    public static void foyerAModifier (List<Id> foyerIdList, List<Id> foyerPanelisteIdList, Boolean isDelete, Boolean byPassRDD) {
        
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();
        List<Account> foyerList = new List<Account>();
        foyerPanelisteList = [SELECT referentiel_panel__r.Type_de_panel__c, Foyer__c, Statut_Foyer_Paneliste__c FROM Foyer_Paneliste__c WHERE Id IN: foyerPanelisteIdList];
        foyerList = [SELECT Id, Types_de_panel__c FROM Account WHERE Id IN :foyerIdList];
        
        for (Foyer_Paneliste__c foyerPaneliste: foyerPanelisteList) {
            for (Account foyer: foyerList) {
                if (foyerPaneliste.Foyer__c == foyer.Id) {
                    System.debug('$$$isDelete: ' + isDelete);
                    System.debug('$$$foyerPaneliste.Statut_Foyer_Paneliste__c: ' + foyerPaneliste.Statut_Foyer_Paneliste__c);
                    System.debug('$$$foyer.Types_de_Panel__c: ' + foyer.Types_de_Panel__c);
                    if(isDelete) {
                        suppressionTypesPanelFoyer(foyer, foyerPaneliste.referentiel_panel__r.Type_de_panel__c);
                    }
                    else if(foyerPaneliste.Statut_Foyer_Paneliste__c == Label.PAN_Statut_panel ||
                            foyerPaneliste.Statut_Foyer_Paneliste__c == Label.PAN_Statut_panel_Installe ||
                            foyerPaneliste.Statut_Foyer_Paneliste__c == Label.PAN_Statut_panel_Equipe ||
                            foyerPaneliste.Statut_Foyer_Paneliste__c == Label.PAN_Statut_panel_Integre) {
                                ajoutTypesPanelFoyer(foyer, foyerPaneliste.referentiel_panel__r.Type_de_panel__c);
                            }
                    else if (foyerPaneliste.Statut_Foyer_Paneliste__c == Label.PAN_Statut_panel_Desinstalle ||
                             foyerPaneliste.Statut_Foyer_Paneliste__c == Label.PAN_Statut_panel_Chute_Temporaire ||
                             foyerPaneliste.Statut_Foyer_Paneliste__c == Label.PAN_Statut_panel_Chute_Definitive) {
                                 if (!byPassRDD & foyer.Types_de_Panel__c != null) {
                                     suppressionTypesPanelFoyer(foyer, foyerPaneliste.referentiel_panel__r.Type_de_panel__c);
                                 }                                 
                             }
                }
                System.debug('$$$foyer.Types_de_Panel__c: ' + foyer.Types_de_Panel__c);
            }
        }
        
        update foyerList;
        
    }
    
    public static void foyerAModifierInsert (List<Id> foyerIdList, List<Id> foyerPanelisteIdList, Boolean isDelete, Boolean byPassRDD) {
        
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();
        List<Account> foyerList = new List<Account>();
        foyerPanelisteList = [SELECT referentiel_panel__r.Type_de_panel__c, Foyer__c, Statut_Foyer_Paneliste__c FROM Foyer_Paneliste__c WHERE Id IN: foyerPanelisteIdList];
        foyerList = [SELECT Id, Types_de_panel__c FROM Account WHERE Id IN :foyerIdList];
        
        for (Foyer_Paneliste__c foyerPaneliste: foyerPanelisteList) {
            for (Account foyer: foyerList) {
                if (foyerPaneliste.Foyer__c == foyer.Id) {
                    System.debug('$$$isDelete: ' + isDelete);
                    System.debug('$$$foyerPaneliste.Statut_Foyer_Paneliste__c: ' + foyerPaneliste.Statut_Foyer_Paneliste__c);
                    System.debug('$$$foyer.Types_de_Panel__c: ' + foyer.Types_de_Panel__c);
                    ajoutTypesPanelFoyer(foyer, foyerPaneliste.referentiel_panel__r.Type_de_panel__c);
                }
                System.debug('$$$foyer.Types_de_Panel__c: ' + foyer.Types_de_Panel__c);
            }
        }
        
        update foyerList;
        
    }    
    
    public static void ajoutTypesPanelFoyer (Account foyer, String typesPanelFoyer) {
        System.debug('$$$ Ajout: ');
        Boolean typePasDansList = true;
        List<String> typesPanelFoyerList= new List<String>();
        if(foyer.Types_de_Panel__c != null) {
            typesPanelFoyerList.addAll(foyer.Types_de_Panel__c.split(';'));
            for (String panel:typesPanelFoyerList) {
                if (panel == typesPanelFoyer) {
                    typePasDansList = false;
                }
            }
            
            if (typePasDansList) {
                foyer.Types_de_Panel__c = foyer.Types_de_Panel__c + ';' + typesPanelFoyer;
            }
        }
        else {
            foyer.Types_de_Panel__c = typesPanelFoyer;
        }
    }
    
    public static void suppressionTypesPanelFoyer (Account foyer, String typesPanelFoyer) {
        String newTypesPanelFoyerValue;
        system.debug('$$$ Supression: ' +foyer.Types_de_Panel__c);
        Boolean premiereFois = true;
        List<String> typesPanelFoyerList= new List<String>();
        typesPanelFoyerList.addAll(foyer.Types_de_Panel__c.split(';'));
        for (Integer i = 0; i < typesPanelFoyerList.size(); i++) {
            if (typesPanelFoyerList[i] == typesPanelFoyer) {
                typesPanelFoyerList.remove(i);
            }
        }
        
        for(String panel: typesPanelFoyerList) {
            if(panel != null) {
                if (premiereFois) {
                    newTypesPanelFoyerValue = panel;
                }
                else {
                    newTypesPanelFoyerValue = newTypesPanelFoyerValue + ';' + panel;
                    premiereFois = false;
                }
            }
        }
        
        System.debug('$$$newTypesPanelFoyerValue: ' + newTypesPanelFoyerValue);
        foyer.Types_de_Panel__c = newTypesPanelFoyerValue;
    }
}