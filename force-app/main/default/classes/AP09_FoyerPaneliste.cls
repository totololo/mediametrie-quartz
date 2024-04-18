/*
* @author: Bastien Pinard
* @date: 
* @ Description 
* @TestClass: AP09_FoyerPaneliste_Test
* @Coverage: 
* History
* Date of modification :
* <Date of modification>   <Author>    <Description of modification>
*/
public class AP09_FoyerPaneliste {
    public static void newIdFoyer(List<Foyer_paneliste__c> ListUpdatedPaneliste){
        //public static void newIdFoyer(){
        system.debug('$$$AP09_FoyerPaneliste newIdFoyer');
        Id recordTypeIdFoyerPanPaME =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        List<Referentiel_Panel__c> refPanMMPaME = [SELECT Id, Name, Type_de_panel__c FROM Referentiel_Panel__c WHERE Type_de_panel__c=:label.RFP_TypePanel_MMAT OR Type_de_panel__c=:label.RFP_TypePanel_PaME];
        Map<String, Id> mapRefPan = new Map<String, Id>();
        for(Referentiel_Panel__c ref : refPanMMPaME){
            if(ref.Type_de_panel__c==label.RFP_TypePanel_MMAT){
                mapRefPan.put('MMT',ref.Id); 
            } else if(ref.Type_de_panel__c==label.RFP_TypePanel_PaME){
                mapRefPan.put('PAME',ref.Id); 
            }
        }        
        
        Map<String, Integer> panelLetters = new Map<String, Integer>();
        panelLetters.put('A', 1);
        panelLetters.put('B', 4);
        panelLetters.put('C', 5);
        panelLetters.put('D', 2);
        panelLetters.put('H', 3);
        panelLetters.put('P', 6);
        panelLetters.put('Q', 7);
        panelLetters.put('R', 8);        
        String sequence = '';
        List<Foyer_paneliste__c> listFoyerToUpdate = new List<Foyer_paneliste__c>();
        Set<Id> IdFoyerPan = new Set<Id>();
        Boolean isExiste = true;
        
        for(Foyer_paneliste__c foyerPan : ListUpdatedPaneliste){
            isExiste = true;
            sequence = '';
            Integer numeroFoyer = 0;
            String letter = '';
            String panelLetter ='';
            while (isExiste == true) {
                sequence = generateRandomSequence(); 
                numeroFoyer = Integer.valueOf(sequence.replace(sequence.left(1), ''));
                letter = sequence.left(1);
                //sequence = integer.valueof(String.valueOf(panelLetters.get(foyerPan.Lettre_operateur__c)) + String.valueOf(foyerPan.Numero_foyer__c));
                List<Foyer_paneliste__c> foyer = [
                    SELECT Id FROM Foyer_paneliste__c 
                    WHERE Lettre_operateur__c =:letter
                    AND Numero_foyer__c=:numeroFoyer
                    AND Id !=: foyerPan.Id
                    //AND Identifiant_foyer_pame__c =:sequence
                ];
                if(foyer.size()==0) {
                    isExiste = false;
                }
            }
            foyerPan.Lettre_operateur__c = letter;
            foyerPan.Numero_foyer__c = numeroFoyer;
            if(foyerPan.Referentiel_Panel__c ==  mapRefPan.get('PAME')) {
                panelLetter =  String.valueOf(panelLetters.get(sequence.left(1)));
                foyerPan.Identifiant_foyer_pame__c = integer.valueof(sequence.replace(sequence.left(1), panelLetter));
            }
            foyerPan.Name = foyerPan.Name + ' (' + sequence + ')';
        }
    }
    
    
    public static String generateRandomSequence() {                
        final String chars = 'BCPQR';
        String randStr = '';
        while (randStr.length() < 1) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        
        String randomNumber = String.valueOf(Integer.valueof((Math.random() * 10)));
        String randomNumber2 = String.valueOf(Integer.valueof((Math.random() * 10)));
        String randomNumber3 = String.valueOf(Integer.valueof((Math.random() * 10)));
        String randomNumber4 = String.valueOf(Integer.valueof((Math.random() * 10)));
        
        String sequence = randStr+randomNumber+randomNumber2+randomNumber3+randomNumber4;
        
        return sequence; 
    }
}