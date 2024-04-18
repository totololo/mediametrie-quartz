/*
* @author: Khaled Hammoudeh
* @date: 21/10/2020
* @ Description Send SMS to the paneliste via NP6
* @TestClass: AP01_SendSMS_Test
* @Coverage:
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
public class AP01_SendSMS {
  
    public static void sendSMSViaNP6(list<serviceAppointment> listRendezVous)
    {
        system.debug('listRendezVous###'+listRendezVous);
        list<SmsNp6_Manager.FieldsWrap> listFieldsWrap = new list<SmsNp6_Manager.FieldsWrap>();
        map<String,SmsNp6_Manager.FieldsWrap> mapFieldIdToFieldWrap = SmsNp6_Manager.GetallFields();
       system.debug('mapFieldIdToFieldWrap### '+mapFieldIdToFieldWrap);
        system.debug('mapFieldIdToFieldWrapSize### '+mapFieldIdToFieldWrap.size());
        string idSMSConfirmationJMoins1 = Label.IdSMSJ_1_NP6;
        /* list<object> listActionsInfoObj = SmsNp6_Manager.getActionsInfo();
       system.debug('listActionsInfoObj### '+listActionsInfoObj);
         system.debug('listActionsInfoObjSize### '+listActionsInfoObj.size());
        list<string> listActionInfo = new list<string>();
        for(object actionInfoObj : listActionsInfoObj)
        {
            system.debug('actionInfoObj###'+actionInfoObj);
            list<string> listActionInfoTemp = string.ValueOf(actionInfoObj).split(',');
            for(string actionInfo : listActionInfoTemp)
            {
                 system.debug('actionInfo###'+actionInfo);
                if(actionInfo.split('=')[0].deleteWhitespace() == 'name')
                {
                    if(actionInfo.split('=')[1].deleteWhitespace().remove('{').remove('}') == Label.NP6_SMSConfirmationRendezVous)
                    {
                        system.debug('listActionInfoTemp###'+listActionInfoTemp);
                        listActionInfo = listActionInfoTemp;
                        break;
                    }
                }
            }
            
            if(listActionInfo.size() > 0)
            {
                break;
            }
        }
        
        if(listActionInfo.size() > 0)
        {
            for(string actionInfo : listActionInfo)
            {
                 system.debug('actionInfo2###'+actionInfo);
                if(actionInfo.split('=')[0].deleteWhitespace().remove('{').remove('}') == 'id')
                {
                    idSMSConfirmationJMoins1 = actionInfo.split('=')[1].deleteWhitespace();
                    system.debug('idSMSConfirmationJMoins1###'+idSMSConfirmationJMoins1);
                    break;
                }
            } 
        }
        */
        if(mapFieldIdToFieldWrap != Null && idSMSConfirmationJMoins1 != Null)
        {
            List<Task> taskList = new List<Task>();
            list<SmsNp6_Manager.SMSInfo> listSMSInfo = new list<SmsNp6_Manager.SMSInfo>();
            for(serviceAppointment serviceAppoint : listRendezVous)
            {
                date dateRendezVous = serviceAppoint.SchedStartTime.date();
                string heureRendezVous = string.valueOf(serviceAppoint.SchedStartTime.hour());
                string MinuteRendezVous = string.valueOf(serviceAppoint.SchedStartTime.Minute());
                String TimeRDV = (heureRendezVous.length()==1?'0'+ heureRendezVous:heureRendezVous) + ':' + (MinuteRendezVous.length()==1?'0'+ MinuteRendezVous:MinuteRendezVous);
                string contactEmail = serviceAppoint.Contact.Email;
                
                string contactPhone = serviceAppoint.Contact.MobilePhone;
                string foyermail=serviceAppoint.Account.Adresse_e_mail_principale__c;
                string foyerphone= serviceAppoint.Account.Numero_de_portable__c;
                system.debug('dateRendezVous### '+dateRendezVous);
                system.debug('heureRendezVous### '+heureRendezVous);
                system.debug('contactEmail### '+contactEmail);
                system.debug('contactPhone### '+contactPhone);
                system.debug('TimeRDV### '+TimeRDV);
                
                //
               
                //YH MM 488
                if ( contactPhone!=null ){
                    system.debug('test contact');
                map<string, object> targetIdResponse = SmsNp6_Manager.GetTargetId(mapFieldIdToFieldWrap, contactEmail, 
                                                                                  contactPhone, dateRendezVous, TimeRDV);
                string targetId = string.valueOf(targetIdResponse.get('id'));
                     SmsNp6_Manager.SendMessage(idSMSConfirmationJMoins1, targetId, 'POST');
                datetime myDateTime = datetime.now();

                string mydtstring = mydatetime.format();

                    
                Task ts = new Task();
                ts.Subject = 'Sms de confirmation';
                ts.TaskSubtype = 'Task';
                ts.ActivityDate = Date.today();
                ts.Description =  'le sms de confirmation de rdv a été envoyé le '+mydtstring;
                ts.WhatID      =  serviceAppoint.AccountId;
                ts.WhoID       =  serviceAppoint.ContactId;
                ts.Status = 'Completed';
                taskList.add(ts);
                }
                else if (contactPhone==null ){
                    datetime myDateTime = datetime.now();

                string mydtstring = mydatetime.format();
                    system.debug('test foyer');
                    map<string, object> targetIdResponse = SmsNp6_Manager.GetTargetId(mapFieldIdToFieldWrap, foyermail, 
                                                                                  foyerphone, dateRendezVous, TimeRDV);
                string targetId = string.valueOf(targetIdResponse.get('id'));
                     SmsNp6_Manager.SendMessage(idSMSConfirmationJMoins1, targetId, 'POST');
                     
                Task ts = new Task();
                ts.Subject = 'Sms de confirmation';
                ts.ActivityDate=system.today();
                ts.TaskSubtype = 'Task';
                ts.ActivityDate = Date.today();
                ts.Description =  'le sms de confirmation de rdv a été envoyé le '+mydtstring;
                ts.WhatID      =  serviceAppoint.AccountId;
                    system.debug('cccc'+serviceAppoint.AccountId);
                ts.WhoID       =  serviceAppoint.ContactId;
                ts.Status = 'Completed';
                taskList.add(ts);
                 
                   //SmsNp6_Manager.setSaveAsActivity(true);
                }
            
                //system.debug('targetIdResponse### '+targetIdResponse);
                //system.debug('targetIdResponseSize()### '+targetIdResponse.size());
                
              // system.debug('targetId### '+targetId);
                
            }
            
            if(taskList!=null && taskList.size()>0){
            insert taskList;  
              
        }
    
    
                
    }
                             
    }}