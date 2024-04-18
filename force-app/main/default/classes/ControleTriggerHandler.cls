/*
* @author: Elio Bou Habib
* @date: 29/03/2021
* @Description Controle Trigger handler updates controles' Tech_Priority__c
* @Ticket MEDIAMETRIE-9
* @Test Class: ControleTriggerHandler_Test
* @Coverage: 100 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
public class ControleTriggerHandler extends TriggerHandler implements ITriggerHandler
{
    private Map<Id, SObject> newMap;
    private Map<Id, SObject> oldMap;
    private List<SObject> triggerNew;
    private List<SObject> triggerOld;
    
    public ControleTriggerHandler(){
        this.newMap = (Map<Id, SObject>) Trigger.newMap;
        this.oldMap = (Map<Id, SObject>) Trigger.oldMap;
        this.triggerNew= (List<SObject>) Trigger.New;
        this.triggerOld= (List<SObject>) Trigger.Old;
    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    public override void beforeInsert() {}
    
    public override void afterInsert() 
    {
        if(Trigger.new != null && 
           !Trigger.new.isEmpty() && 
           !isDisabled() && 
           !TriggerHandler.isBypassed('ControleTriggerHandler'))
        {
            updateTechPriority();
        }
    }
    
    public override void beforeUpdate() {}
    
    public override void afterUpdate() 
    {
        if(Trigger.new != null && 
           !Trigger.new.isEmpty() && 
           Trigger.oldMap != null && 
           !Trigger.oldMap.isEmpty() && 
           !isDisabled() && 
           !TriggerHandler.isBypassed('ControleTriggerHandler'))
        {
            updateTechPriority();
        }
    }
    
    public override void beforeDelete() {}
    
    public override void afterDelete() {}
    
    public override void afterUnDelete() {}
    
    /** 
	* @author Elio Bou Habib
	* @date 29/03/2021
	* @description updates controles' Tech_Priority__c to a number between 1 and 23 according to the custom setting Priorites_de_controles__c
	*/
    public static void updateTechPriority()
    {
        System.debug('Reached1');
        try
        {
            List <Controle__c> controlesToUpdate = new List <Controle__c> ();
            //Get all custom settings
            List <Priorites_de_controles__c> pdcs = [SELECT Id, Name, Origin__c, Type__c, Type_de_controle__c,
                                                     Sous_type_de_controle__c, Type_de_panel__c, Rep_ou_non_rep__c, Priorite__c
                                                     FROM Priorites_de_controles__c];
            if(pdcs != null && !pdcs.isEmpty())
            {
                System.debug('Reached2');
                //Place the custom settings in a map
                Map <String, String> pdcDefToPriorityMap = new Map <String, String>();
                for(Priorites_de_controles__c pdc: pdcs)
                {
                    if(pdc.Type_de_controle__c == Label.CTRL_Type_Connexion || 
                       pdc.Type_de_controle__c == Label.CTRL_Type_NonRepondant ||
                       pdc.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb ||
                       pdc.Type_de_controle__c == Label.CTRL_Type_Foyer_Vacancier)
                    {
                        System.debug('@@@ key 1: ' + pdc.Type_de_controle__c +
                                                '-' + pdc.Type_de_panel__c + '-' +pdc.Rep_ou_non_rep__c);
                        pdcDefToPriorityMap.put(pdc.Type_de_controle__c +
                                                '-' + pdc.Type_de_panel__c + '-' +pdc.Rep_ou_non_rep__c, pdc.Priorite__c);                        
                    }
                    else
                    {
                        System.debug('@@@ key 2: ' + pdc.Type_de_controle__c + '-' + pdc.Sous_type_de_controle__c +
                                                '-' + pdc.Type_de_panel__c + '-' +pdc.Rep_ou_non_rep__c);
                        pdcDefToPriorityMap.put(pdc.Type_de_controle__c + '-' + pdc.Sous_type_de_controle__c +
                                                '-' + pdc.Type_de_panel__c + '-' +pdc.Rep_ou_non_rep__c, pdc.Priorite__c);
                    }
                }
                System.debug('Reached3');
                //Add to controlesToUpdate all controles that have their Tech_Priority__c outdated
                for(Controle__c controle: (List<Controle__c>)Trigger.new)
                {
                    if(Trigger.isInsert ||
                       controle.Rep_ou_non_rep__c != ((Controle__c)Trigger.oldMap.get(controle.Id)).Rep_ou_non_rep__c)
                    {
                        String controleKey;
                        if(controle.Type_de_controle__c == Label.CTRL_Type_Connexion ||
                           controle.Type_de_controle__c == Label.CTRL_Type_NonRepondant ||
                           controle.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb || 
                           controle.Type_de_controle__c == Label.CTRL_Type_Foyer_Vacancier)
                        {
                            /*controleKey = controle.Type_de_controle__c +
                                '-' + controle.Type_de_panel__c + '-' +controle.Rep_ou_non_rep__c;*/                       
                        }
                        else
                        {
                            /*controleKey = controle.Type_de_controle__c + '-' + controle.Sous_type_de_controle__c + 
                                '-' + controle.Type_de_panel__c + '-' +controle.Rep_ou_non_rep__c;*/
                        }
                    	System.debug('Reached4 controleKey: ' + controleKey);
                        if(pdcDefToPriorityMap.containsKey(controleKey) &&
                           (String.isBlank(controle.Tech_Priority__c) || Integer.valueOf(controle.Tech_Priority__c) > Integer.valueOf(pdcDefToPriorityMap.get(controleKey))))
                        {
                            System.debug('Reached5');
                            Controle__c newControle = controle.clone(true, true, false, false);
                            newControle.Tech_Priority__c = pdcDefToPriorityMap.get(controleKey);
                            controlesToUpdate.add(newControle);
                        }
                    }
                }
                if(!controlesToUpdate.isEmpty())
                {
                    System.debug('Reached6');
                    update controlesToUpdate;
                }
            }
        }
        catch(Exception ex)
        {
            ex.setMessage('An error occured on the controle trigger handler:\n' + ex.getMessage());
            throw ex;
        }
    }
}