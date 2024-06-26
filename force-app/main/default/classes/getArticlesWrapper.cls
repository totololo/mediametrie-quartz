// 
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public without sharing class getArticlesWrapper {

	public  class GetArticlesWrappers {
        @AuraEnabled
		public String id_article {get;set;} 
        @AuraEnabled
		public String titre {get;set;} 
        @AuraEnabled
		public String message {get;set;} 
        @AuraEnabled
		public String date_article {get;set;} 
        @AuraEnabled
		public String redacteur {get;set;} 
        @AuraEnabled
		public String image {get;set;} 
        @AuraEnabled
		public String video {get;set;} 
        @AuraEnabled
		public String extrait {get;set;} 
        @AuraEnabled
		public String sous_titre {get;set;} 
        @AuraEnabled
		public String type_article {get;set;} 
        @AuraEnabled
		public String etat_article {get;set;} 
        @AuraEnabled
		public String Commentaires {get;set;} 
        @AuraEnabled
		public String NbComm {get;set;} 
        @AuraEnabled
		public String Tags {get;set;} 
        @AuraEnabled
		public List<String> Theme {get;set;} 
        @AuraEnabled
		public List<String> LL_Theme {get;set;} 
        @AuraEnabled
		public Integer time_Z {get;set;} // in json: time
        @AuraEnabled
		public String dtDeb {get;set;} 
        @AuraEnabled
		public String dtFin {get;set;} 
        @AuraEnabled
		public String typeSplash {get;set;} 
        @AuraEnabled
		public String libBtn {get;set;} 
        @AuraEnabled
		public String dtMajArt {get;set;} 
        @AuraEnabled
		public String accesPanelistes {get;set;} 
        @AuraEnabled
		public Boolean fl_lu {get;set;} 
        @AuraEnabled
		public Boolean fl_favoris {get;set;} 
        @AuraEnabled
		public Boolean fl_like {get;set;} 
        @AuraEnabled
		public Integer nbLike {get;set;} 

		public GetArticlesWrappers(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();            
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id_article') {
							id_article = parser.getText();
						} else if (text == 'titre') {
							titre = parser.getText();
						} else if (text == 'message') {
							message = parser.getText();
						} else if (text == 'date_article') {
							date_article = parser.getText();
						} else if (text == 'redacteur') {
							redacteur = parser.getText();
						} else if (text == 'image') {
							image = parser.getText();
						} else if (text == 'video') {
							video = parser.getText();
						} else if (text == 'extrait') {
							extrait = parser.getText();
						} else if (text == 'sous_titre') {
							sous_titre = parser.getText();
						} else if (text == 'type_article') {
							type_article = parser.getText();
						} else if (text == 'etat_article') {
							etat_article = parser.getText();
						} else if (text == 'Commentaires') {
							Commentaires = parser.getText();
						} else if (text == 'NbComm') {
							NbComm = parser.getText();
						} else if (text == 'Tags') {
							Tags = parser.getText();
						} else if (text == 'Theme') {
							Theme = arrayOfString(parser);
						} else if (text == 'LL_Theme') {
							LL_Theme = arrayOfString(parser);
						} else if (text == 'time') {
							time_Z = parser.getIntegerValue();
						} else if (text == 'dtDeb') {
							dtDeb = parser.getText();
						} else if (text == 'dtFin') {
							dtFin = parser.getText();
						} else if (text == 'typeSplash') {
							typeSplash = parser.getText();
						} else if (text == 'libBtn') {
							libBtn = parser.getText();
						} else if (text == 'dtMajArt') {
							dtMajArt = parser.getText();
						} else if (text == 'accesPanelistes') {
							accesPanelistes = parser.getText();
						} else if (text == 'fl_lu') {
							fl_lu = parser.getBooleanValue();
						} else if (text == 'fl_favoris') {
							fl_favoris = parser.getBooleanValue();
						} else if (text == 'fl_like') {
							fl_like = parser.getBooleanValue();
						} else if (text == 'nbLike') {
							nbLike = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'GetArticlesWrapper consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
            

			
            
		}
	}
	
	
	public static List<GetArticlesWrappers> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfGetArticlesWrapper(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<GetArticlesWrappers> arrayOfGetArticlesWrapper(System.JSONParser p) {
        List<GetArticlesWrappers> res = new List<GetArticlesWrappers>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new GetArticlesWrappers(p));
        }
        return res;
    }




    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }




}