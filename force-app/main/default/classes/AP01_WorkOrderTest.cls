/*
* @date: 08/03/2022
* @ Description Test Class for AP01_WorkOrder
*/
@isTest
public class AP01_WorkOrderTest {
    @isTest
    public static void NewWorkOrderLineItemsTest(){
        String accExtId = '04722-5ea4';
        MembreFoyerCallout_Mock fakeGetAcc = new MembreFoyerCallout_Mock(accExtId);
        Test.setMock(HttpCalloutMock.class, fakeGetAcc);
        Duree_de_lintervention__c ab = new Duree_de_lintervention__c();
        ab.Type_d_intervention__c = '1';
        ab.Name ='d01';
        ab.Sous_type_d_intervention__c='1';
        ab.Evol__c = 'PAME';
        ab.Duree_initiale__c = 100;
        ab.Duree_2_postes__c = 30;
        insert ab;
        
        Duree_de_lintervention__c abc = new Duree_de_lintervention__c();
        abc.Type_d_intervention__c = '2';
        abc.Name ='d02';
        abc.Sous_type_d_intervention__c='8';
        abc.Evol__c = 'PAME';
        abc.Duree_initiale__c = 100;
        abc.Duree_2_postes__c = 30;
        insert abc;
        
        Duree_de_lintervention__c aa = new Duree_de_lintervention__c();
        aa.Type_d_intervention__c = '1';
        aa.Name ='d03';
        aa.Sous_type_d_intervention__c='27';
        aa.Evol__c = 'PAME';
        aa.Duree_initiale__c = 15;
        insert aa;
        
        account a = new account();
        a.Name = 'Foyer Test';
        a.Date_de_l_enquete__c = date.today();
        a.Statut_audimetrique__c = '1';
        a.Statut_du_foyer__c = '0';
        a.Nombre_TV__c = '3';
        a.Nombre_smartphone__c=2;
        a.Nombre_tablette__c=1;
        a.Numero_de_portable__c = '1234567890';
        a.Intervention_en_cours__c = false;
        insert a;
        
        Equipements_du_foyer__c poste = new Equipements_du_foyer__c();
        poste.foyer__c = a.Id;
        insert poste;
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.name = Label.RFP_Nom_PaME;
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        insert refPanPaME;
        
        Foyer_Paneliste__c foyerPaneliste = new Foyer_Paneliste__c();
        foyerPaneliste.foyer__c = a.Id;
        foyerPaneliste.name = 'FOyer Pan';
        foyerPaneliste.referentiel_panel__c = refPanPaME.Id;
        foyerPaneliste.Intervention_en_cours__c = false;
        Insert foyerPaneliste;
        
        Case requete = new Case();
        requete.AccountId = a.Id;
        requete.foyer_paneliste__c = foyerPaneliste.Id;
        insert requete;
        
        List<WorkOrder> interventionToInsert = new List<WorkOrder>();
        workOrder WO = new workOrder();
        WO.AccountId = a.Id;
        WO.Foyer_paneliste__c = foyerPaneliste.Id;
        WO.CaseId = requete.id;
        WO.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation; 
        WO.Actions__c = Label.WOR_Actions_Nouveau_Foyer;
        WO.Tech_RV03__c = true;
        WO.Nombre_d_equipements__c = 3;
        WO.Nombre_d_ordinateur__c = 1;
        WO.Nombre_de_smartphone__c = 1;
        WO.Nombre_de_tablette__c = 0;
        WO.tech_testClass__c = true;
        interventionToInsert.add(WO);
        
        workOrder WO1 = new workOrder();
        WO1.AccountId = a.Id;
        WO1.Foyer_paneliste__c = foyerPaneliste.Id;
        WO1.CaseId = requete.id;
        WO1.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Desinstallation; 
        WO1.Actions__c = Label.WOR_Actions_Desinstallation_Definitive;
        WO1.Tech_RV03__c = true;
        WO1.Nombre_d_equipements__c = 3;
        WO1.Equipement_du_foyer__c = poste.Id;
        WO1.tech_testClass__c = true;
        interventionToInsert.add(WO1);
        
        workOrder WO2 = new workOrder();
        WO2.AccountId = a.Id;
        WO2.Foyer_paneliste__c = foyerPaneliste.Id;
        WO2.CaseId = requete.id;
        WO2.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation; 
        WO2.Actions__c = Label.WOR_Actions_Nouveau_Foyer;
        WO2.Tech_RV03__c = true;
        WO2.Nombre_d_equipements__c = 3;
        WO2.Nombre_d_ordinateur__c = 2;
        WO2.Nombre_de_smartphone__c = 2;
        WO2.Nombre_de_tablette__c = 2;
        WO2.tech_testClass__c = true;
        interventionToInsert.add(WO2);
        
        insert interventionToInsert;
        
          
        /*List<WorkOrderLineItem> listWOLI = [ SELECT Id FROM workOrderLineItem Where WorkORderId =: WO.ID];
        if(listWOLI != null && listWOLI[0] != null){
            listWOLI[0].description = 'test';
            update listWOLI[0];
            delete listWOLI[0];
        }*/
        
    }
}