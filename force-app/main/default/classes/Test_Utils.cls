/*
* @author: Khaled Hammoudeh
* @date: 28/09/2020
* @ Description Class that contains methods commonly used in test classes so we do not create them in each test class
* @Test Classes: AP01_Equipement_Test, Batch004_CreditAutomatique_Test,Batch001_ControleAbandone_Test, Batch008_SMSviaNP6_Test
* @Coverage: 100 %
* History
* <Date of modification>   <Author>      <Description of modification>
	10/12/2021			Nancy Al Kalach  added the method createRefPanel to create Referentiel_Panel__c records
	10/12/2021			Nancy Al Kalach  added the method createIndividuPaneliste to create Individu_Paneliste__c records
*/
@isTest
public class Test_Utils {

    //Method that creates an Account/household (Foyer)
    public static account createFoyer() {
        account foyerToReturn = new account();
        foyerToReturn.Name = 'Foyer Test';
        foyerToReturn.Date_de_l_enquete__c = date.today();
        
        return foyerToReturn;
    }
    
     //Method that creates an Membre de foyer 
    public static contact createMembreFoyer(Id FoyerId) {
        contact cont = new contact();
        cont.LastName='testCont';
        cont.FirstName = 'testCont';
        cont.Nombre_d_heures_travaillees__c=3;
        cont.Date_d_entree_individu__c = Date.today();
        cont.Type__c = '0';
        cont.AccountId = FoyerId;  
        cont.MobilePhone='1234567891';
        cont.Birthdate = date.newInstance(1993, 02, 25);
        cont.Lettre__c = 'A';
        cont.Lien_parente__c = '1';
        cont.Lien_de_parente_stat__c = '1';
        cont.CSP4__c = '1';
        cont.CSP42__c = 'testt';
        return cont;
    }
    
    //Method that creates an Foyer Panéliste 
    public static Foyer_Paneliste__c createFoyerPaneliste () {
        Foyer_Paneliste__c foyerPaneliste = new Foyer_Paneliste__c();
        foyerPaneliste.Name = 'Foyer de test';
        return foyerPaneliste;
    }
     
    //Method that creates an Conge
    public static Conge__c createConge(Id foyerId, Id membreId) {
        Conge__c cong = new Conge__c(); 
        cong.Date_de_debut__c = System.today();
        Cong.Date_de_fin__c= System.today()+4;
        Cong.Type_de_conge__c=Label.CON_Type_Absent;
        cong.Foyer__c=foyerId;
        cong.Motif__c=Label.CONG_Motif_Autre;
        cong.Conge_de_l_individu__c = membreId;
        return cong;
    }
    
    //Method that creates an asset/equipment (Equipement)
    public static asset createEquipement(string foyerId) {
        asset equipementToReturn = new asset();
        equipementToReturn.AccountId = foyerId;
        
        return equipementToReturn;
    }
    
    //Method that creates a case(Requete)
    public static Case createCase(string foyerId) { 
        Case Req =new case();
        Req.Accountid=foyerId; 
        return Req;
    }
    
    //Method that creates an Product(Produit)
    public static Product2 createproduct() {
        Product2 product = new Product2();
        return product;
    }
    
    //Method that creates an Order(Commande)
    public static Order createOrder(Id foyerId) {
        Order order = new Order();
        order.AccountId = foyerId;
        return order;
    }
    
    //Method that creates an OrderItem(Produit commandé)
    public static OrderItem createOrderItem() {
        OrderItem orderItem = new OrderItem();
        return orderItem;
    }
    
    //Method that creates Etiquette
    public static Etiquette__c createEtiquette(string foyerId, string membreId, string posteId, date dateDebut, date dateFin) {
        Etiquette__c etiquetteToReturn = new Etiquette__c();
        etiquetteToReturn.Foyer__c = foyerId;
        etiquetteToReturn.Membre_du_foyer__c = membreId;
        etiquetteToReturn.Poste__c = posteId;
        etiquetteToReturn.Statut__c = Label.ETI_Statut_Actif;
        etiquetteToReturn.Date_de_debut__c = dateDebut;
        etiquetteToReturn.Date_de_fin__c = dateFin;
        
        return etiquetteToReturn;
    }
    
    //Method that creates a controle 
    public static Controle__c createControle(string foyerId, string membreId, string audimetreId, String caseId, Date DateCtrl) { 
        Controle__c Ctrl =new Controle__c();
        Ctrl.Foyer__c = foyerId;
        ctrl.Requete__c = caseId;
        ctrl.Membre_du_foyer__c = membreId;
        ctrl.Audimetre__c = audimetreId;
        ctrl.Date_de_controle__c = DateCtrl;
        return Ctrl;
    }
    
    //Method that creates a Evenement 
    public static Evenement__c createEvenement(Id EquipementId) { 
        Evenement__c evnt =new Evenement__c(); 
        evnt.Meter__c=EquipementId;
        return evnt;
    }
    
    //Method that creates a Etiquettes et controle custom setting 
    public static Etiquettes_et_controles__c createEtqCtrl() { 
        Etiquettes_et_controles__c etqCtrl =new Etiquettes_et_controles__c(); 
        EtqCtrl.name='test';
        return EtqCtrl;
    } 
    
     //Method that creates a Jours feries custom setting 
    public static Jour_ferie__c createJourFerie(Date DatejourFerie,String FerieName) { 
        Jour_ferie__c JrsFerie =new Jour_ferie__c(); 
        JrsFerie.name=FerieName; 
        JrsFerie.Date_du_jour_ferie__c=DatejourFerie;
        return JrsFerie;
    } 
    
      //Method that creates WorkOrder
    public static WorkOrder createWorkOrder(Id FoyerId) { 
        WorkOrder WO =new WorkOrder(); 
        WO.AccountId=FoyerId;  
        return WO;
    } 
    
     //Method that creates serviceAppointment
    public static serviceAppointment createSA( Id WOid) { 
        serviceAppointment SA =new serviceAppointment(); 
        SA.ParentRecordId=WOid;   
        return SA;
    } 
    
    //Method that creates a task
    public static Task createTask () {
        Task taskCreate = new Task();
        return taskCreate;
    }
    
    //Method that creates a Referentiel Panel
    public static Referentiel_Panel__c createRefPanel(String name, String typePanel) { 
        Referentiel_Panel__c refPanel =new Referentiel_Panel__c(); 
        refPanel.Name = name;
        refPanel.Type_de_panel__c = typePanel;
        return refPanel;
    } 
    
    //Method that creates a Individus Paneliste
    public static Individu_Paneliste__c createIndividuPaneliste(Id composition, Id foyerPaneliste, String lettre){
        Individu_Paneliste__c individuPaneliste = new Individu_Paneliste__c();
        individuPaneliste.Composition_du_foyer__c = composition;
        individuPaneliste.Foyer_paneliste__c = foyerPaneliste;
        individuPaneliste.Lettre__c = lettre;
        return individuPaneliste;
    }


    public static listview getListViews(){     
        return [select id,name from listview limit 1];
      }
      public static campaign  createCampaign(){        
        campaign camp=new campaign();
        camp.Name='test Anes';
        camp.CampagneID_Avaya__c  ='Test BOUZOUINA';
        camp.isActive=true;
        return camp;
      }
      public static list<appel__c>  createAppels(integer nb){      
        list<Appel__c> applst = new   list<Appel__c>();
        for(integer i =0 ; i< nb ; i++){
            appel__c app = new appel__c();
            applst.add(app);
        }
        return applst;
      }

}