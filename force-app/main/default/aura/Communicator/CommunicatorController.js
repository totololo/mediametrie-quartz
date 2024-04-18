({
    doInit: function(component, event, helper) {
        const EXPECTED_ORIGIN = "https://auracrm.mediametrie.fr:8484";
        const EXPECTED_TARGET = window.location.origin;
        //component.set('v.compteId', "5007E00000D1xAoQAJ");
        

        let newMessageHandler = function(message) {
            try {
                console.log(message);
                let data = undefined;
                if (message && message.data && message.data.includes("AvayaEvent")) {
                    data = JSON.parse(message.data);
                } else {
                    return;
                }
               
                //let data = (message && message.data && message.data.includes("AvayaEvent")) ? JSON.parse(message.data) : undefined;
                if ((data.class) && (data.class === "AvayaEvent")) {
                    
                    console.log("%cSalesforce Received Message", "color:green", data);
                    //alert(message.origin+data.origin);
                    if (message.origin !== EXPECTED_ORIGIN || data.origin !== EXPECTED_ORIGIN || data.origin !== message.origin) {
                        console.warn( "%cInvalid Origin","color:DarkRed", message.origin, data.origin);
                        return;
                    }
                    if (message.currentTarget.location.origin !== EXPECTED_TARGET || data.target !== EXPECTED_TARGET) {
                        console.warn("%cInvalid Target", "color:DarkRed", message.currentTarget.location.origin, data.target);
                        return;
                    }
                    
                    //var avayaEvent = $A.get("e.c:AvayaEvent");
                    let avayaEvent = component.getEvent("avayaEvent");
                    avayaEvent.setParams({"payload": data });
                   // alert('the event is fired');
                    avayaEvent.fire();
                   // console.log('Anes Data event type=' + data.payload.eventType);

                    console.log("%cNew Avaya Message Aura Component Event Fired", "color:Navy", data);
                } else {
                    
                    console.log("%cNot Avaya Mesasage", "color:DarkRed", data);
                    return;
                }
            } catch (e){console.log(e);}
        };
        window.addEventListener('message', newMessageHandler, false);
    },
    
    // CasePop: function(component, event, helper){
    //     helper.navigate(component,helper,event,'5007E00000D1xAoQAJ');

    // },
    // 
    handleAvayaEvent: function(component, event, helper) {
        let data = event.getParam("payload");
        let value = component.get("v.markedupText") || "";
        value += "<br>"+ JSON.stringify(data);
        component.set("v.markedupText", value);
        console.log("%cNew Avaya Message Aura Component Event Received by Handler", "color:#C00", data);
        console.log('Anes Data ' +JSON.stringify(data.payload));
       
                   
        if(data.payload.eventType =='EstablishedEvent'){
            console.log('hey Anes it\'s an EstablishedEvent ');
            helper.putdatatype(component, "c.IncomingEventMethod", JSON.stringify(data.payload));
            console.log('hey Anes JSON.stringify(data.payload) ' + JSON.stringify(data.payload));
         }

         if(data.payload.eventType =='ReleasedEvent'){
            console.log('hey Anes it\'s an ReleasedEvent');
            setTimeout(() => { helper.putdatatype(component, "c.ReleasedEventMethod", JSON.stringify(data.payload))}, 1500);
           
             }

    },

})