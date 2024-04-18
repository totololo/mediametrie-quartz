/*
* @author: Elio Bou Habib
* @date: 29/03/2021
* @Description Controle Trigger handler test class
* @Tested Class: ControleTriggerHandler
* @Coverage: 100 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class ControleTriggerHandler_Test 
{
    
    /** 
	* @author Elio Bou Habib
	* @date 29/03/2021
	* @description tests the after insert trigger of the controle trigger handler
	*/
    @isTest
    public static void testAfterInsert()
    {
        Priorites_de_controles__c pdc12 = new Priorites_de_controles__c();
        pdc12.Name                      = 'Priorité 12';
        pdc12.Origin__c                 = 'Contrôle';
        pdc12.Type_de_controle__c       = Label.CTRL_Type_Participation;
        pdc12.Sous_type_de_controle__c  = '8';
        pdc12.Type_de_panel__c          = 'MEDIAMAT (MMAT)';
        pdc12.Rep_ou_non_rep__c         = 'Non répondant';
        pdc12.Priorite__c               = '12';
        insert pdc12;
        
        Priorites_de_controles__c pdc22 = new Priorites_de_controles__c();
        pdc22.Name                      = 'Priorité 22';
        pdc22.Origin__c                 = 'Contrôle';
        pdc22.Type_de_controle__c       = Label.CTRL_Type_ParticipationWeb;
        pdc22.Type_de_panel__c          = 'PAME';
        pdc22.Rep_ou_non_rep__c         = 'Répondant';
        pdc22.Priorite__c               = '22';
        insert pdc22;
        
        try
        {
            ControleTriggerHandler.updateTechPriority();
        }
        catch(Exception ex) {}
        
        Account account1                     = Test_Utils.createFoyer();
        account1.Statut_du_foyer__c          = 'Installé';
        account1.Type_de_foyer__c            = Label.ACC_Type_de_panel_Mediamat;
        account1.Numero_de_telephone_fixe__c = '0000000000';
        insert account1;
        
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
           
         Referentiel_Panel__c refPan = new Referentiel_Panel__c();
         refPan.Name	= Label.RFP_TypePanel_PaME;
         refPan.Type_de_panel__c =  Label.REF_PANEL_TypePan_PAME;
         insert refPan;
           
         Foyer_paneliste__c foyerPan = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelMediamatPame,Name='testAip',Foyer__c=account1.id ,Statut_Foyer_paneliste__c=Label.PAN_Statut_panel, Referentiel_Panel__c = refPan.Id);
         insert foyerPan;
        
        Controle__c controle1              = Test_Utils.createControle(account1.Id, null, null, null, System.today());
        controle1.Type_de_controle__c      = Label.CTRL_Type_Participation;
        controle1.Sous_type_de_controle__c = '8';
        controle1.Rep_ou_non_rep__c        = 'Non répondant';
        controle1.Foyer_Paneliste__c = foyerPan.Id;
        insert controle1;
        system.debug('eee'+controle1.Tech_Priority__c);
        controle1 = refreshControle(controle1.Id);
       
        
        Account account2                     = Test_Utils.createFoyer();
        account2.Statut_du_foyer__c          = 'Installé';
        account2.Type_de_foyer__c            = Label.ACC_Type_de_panel_Pame;
        account2.Numero_de_telephone_fixe__c = '0000000000';
        insert account2;
        
        Controle__c controle2              = Test_Utils.createControle(account1.Id, null, null, null, System.today());
        controle2.Foyer__c                 = account2.Id;
        controle2.Type_de_controle__c      = Label.CTRL_Type_ParticipationWeb;
        controle2.Sous_type_de_controle__c = '8';
        controle2.Rep_ou_non_rep__c        = 'Répondant';
        controle2.Foyer_Paneliste__c = foyerPan.Id;
        insert controle2;
        controle2 = refreshControle(controle2.Id);
        system.debug(controle2.Tech_Priority__c);
       
        
        delete controle2;
        undelete controle2;
    }
    
    /** 
	* @author Elio Bou Habib
	* @date 29/03/2021
	* @description refreshes controles's fields
	*/
    public static Controle__c refreshControle(Id controleId)
    {
        Controle__c controle = [SELECT Id, Foyer__c, Type_de_controle__c, Sous_type_de_controle__c, 
                                Rep_ou_non_rep__c, Tech_Priority__c, Type_de_panel__c, Foyer__r.Type_de_foyer__c
                                FROM Controle__c
                                WHERE Id = :controleId];
        return controle;
    }
}