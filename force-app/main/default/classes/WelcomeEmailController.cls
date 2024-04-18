public class WelcomeEmailController 
{
    public String contactId{get;set;}
    
    public UserInfo getUserInfo()
    {
        UserInfo userInfoWrapper = new UserInfo();
        userInfoWrapper.mailText = label.EXP_WelcomeMail;
        String panelType = '';
        System.debug('contactId ' + contactId);
        List<Individu_Paneliste__c> individuPaneliste = [SELECT Id, Composition_du_foyer__c, Composition_du_foyer__r.Name, 
                                                         Composition_du_foyer__r.Solde_de_points__c, Foyer_paneliste__r.Name, Foyer_paneliste__c, Foyer_paneliste__r.Referentiel_Panel__r.Name,
                                                         Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c
                                                         //Composition_du_foyer__r.Account.Sous_Statut__c
                                                         FROM Individu_Paneliste__c
                                                         WHERE Composition_du_foyer__c = :contactId];
        System.debug('individuPaneliste ' + individuPaneliste);
        
        List<Foyer_paneliste__c> soldeDePoint = new List<Foyer_paneliste__c>();
        if(individuPaneliste.size() > 0){
            soldeDePoint = [
                SELECT Solde_de_points_fid__c
                FROM Foyer_paneliste__c
                WHERE Id =: individuPaneliste[0].Foyer_paneliste__c
            ];
            
            if(individuPaneliste[0].Foyer_paneliste__r.Referentiel_Panel__r.Name == 'AIP'){
                panelType = '1';
            } else if(individuPaneliste[0].Foyer_paneliste__r.Referentiel_Panel__r.Name == 'MMT'){
                panelType = '2';
            } else if(individuPaneliste[0].Foyer_paneliste__r.Referentiel_Panel__r.Name == 'PaME'){
                panelType = '3';
            }
        }
        
        if(individuPaneliste.size() > 0 && soldeDePoint.size() > 0){
            userInfoWrapper.SoldeDePoints = String.valueOf(soldeDePoint[0].Solde_de_points_fid__c);
            userInfoWrapper.NumeroPanel = individuPaneliste[0].Foyer_paneliste__r.Name;
            userInfoWrapper.linkQuest = label.EXP_WelcomeMailLink + 'ID_PANELISTE=' + individuPaneliste[0].Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c + 'tAud&ID_PANEL=' + panelType;
        }
        
        
        
        /*if(individuPaneliste.size() > 0
&& (individuPaneliste[0].Composition_du_foyer__r.Account.Sous_Statut__c == label.ACC_SousStatut_EnCoursDeCreation 
|| individuPaneliste[0].Composition_du_foyer__r.Account.Sous_Statut__c == label.ACC_SousStatut_DefinitionMembre)){
userInfoWrapper.mailText = label.EXP_WelcomeMailV2;
}*/
        
        
        System.debug('userInfoWrapper ' + userInfoWrapper);
        return userInfoWrapper;
    }
    
    public class UserInfo{
        public String NumeroPanel{get;set;}
        public String SoldeDePoints{get;set;}
        public String mailText{get;set;}
        public String linkQuest{get;set;}
    }
}