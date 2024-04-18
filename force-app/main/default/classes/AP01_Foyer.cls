/*
* @author: Joyce Saidy
* @date: 02/09/2020
* @ Description Class that updates service territory on account based on custom settings "Territoire de Service" 
and second method to create case 
and a third Method that check the validity of the address chosen
* @TestClass: AP01_Foyer_Test
* @Coverage: 100 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
public class AP01_Foyer {
    public static void MajTerritoireDeService(List<Account> ListNewAccount)
    {
        Map<String,Territoire_de_Service__c> MapDepTerritoire = Territoire_de_Service__c.getAll();
        Map<String,Id> MapIdTerritoireDeService = new map<String,Id>();
        List<ServiceTerritory> ListerritoireDeService = new List<ServiceTerritory>();
        //Récuperer la liste de territoire de service 
        ListerritoireDeService=[Select id,name from ServiceTerritory];
        for(ServiceTerritory TS:ListerritoireDeService)
        {
            if(!MapIdTerritoireDeService.containskey(TS.name))
            {
                //Stocker le nom et l'id du territoire dans une Map
                MapIdTerritoireDeService.put(TS.name,TS.id);
            }
        }
        For(Account acc:ListNewAccount)
        {
            if(acc.ShippingPostalCode!=null)
            {
                //récuperer les deux premiers numéros du code Postal qui correspond au departement
                String CodePostal=acc.ShippingPostalCode.substring(0,2);
                if(MapDepTerritoire.containskey(CodePostal) && MapIdTerritoireDeService.containskey(MapDepTerritoire.get(CodePostal).Nom_du_territoire__c))
                {
                    //Chercher le nom de territoire en comparant le code Postal au departement du paramètre personnalisé "Territoire de Service"
                    //Finalement la recherche de l'id correspondant à ce territoire pour renseigné le champ "Territoire de service" du foyer
                    acc.Territoire_de_service__c=MapIdTerritoireDeService.get(MapDepTerritoire.get(CodePostal).Nom_du_territoire__c);  
                }
            }
        }
    }

    //Create new case for "Installation nouveau foyer"
    public static void NouvelleReq(List<Account> ListNewAccount)
    {
         Id recordTypeIdRequeteDemandePaneliste =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePaneliste).getRecordTypeId();
        List<Case> listCaseToInsert = new List<Case>();   
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;
        for(Account acc :ListNewAccount)
        {
            Case cs=new Case();
            cs.description=Label.CASE_Description_InstallationNouveauFoyer;
            cs.RecordTypeId=recordTypeIdRequeteDemandePaneliste;
            cs.Origin=Label.CAS_Origine_NouveauFoyer;
            cs.AccountId=acc.Id;
            cs.ContactId=Acc.Personne_de_reference__c;
            cs.Type = Label.CAS_Type;
            cs.Sous_type__c = Label.CAS_Sous_type_Installation_Nouveau_Foyer;
            cs.setOptions(dmo);
            listCaseToInsert.add(cs); 
        }
        if(listCaseToInsert!=null && listCaseToInsert.size()>0)
        {
            try{ 
                database.insert(listCaseToInsert);
            }Catch(exception ex){
                system.debug('Insert Case Nouveau Foyer Exception Error:'+ex.getmessage());
            }
        }
    }


    //check validity of the address
    public static void validateAddress(List<Account> ListAccount){
        List<Code_Postal_Commune__c> listCodePostalCommune = new List<Code_Postal_Commune__c>();
        listCodePostalCommune=[Select id,name,Code_postal__c from Code_Postal_Commune__c];

        Map<Decimal,List<String>> MapIdCodePostalCommune = new map<Decimal,List<String>>();

        for(Code_Postal_Commune__c c:listCodePostalCommune){
            if(MapIdCodePostalCommune.get(c.Code_postal__c)==null){
                MapIdCodePostalCommune.put(c.Code_postal__c,new list<String>{c.name});
            } 
            else{
                MapIdCodePostalCommune.get(c.Code_postal__c).add(c.name);
            }
        }
        
        for(Account acc :ListAccount)
        {
            if(acc.ShippingPostalCode==null){
                acc.addError('Veuillez choisir un code postal');
            }
            else if(!MapIdCodePostalCommune.containskey(decimal.valueOf(acc.ShippingPostalCode))){
                acc.addError('Aucune commune n\'est associée à ce code postal '+acc.ShippingPostalCode);
            }
            else if(!(MapIdCodePostalCommune?.get(decimal.valueOf(acc.ShippingPostalCode)))?.isEmpty()){
                List<String> s=MapIdCodePostalCommune.get(decimal.valueOf(acc.ShippingPostalCode));
                if(acc.ShippingCity==null){
                    acc.addError('Pour le code postal '+acc.ShippingPostalCode+' veuillez choisir la bonne commune '+s );
                }
                else if(!s.contains(acc.ShippingCity)){
                    acc.addError('Pour le code postal '+acc.ShippingPostalCode+' veuillez choisir la bonne commune '+s );
                }
            }
        }
        

    }

}