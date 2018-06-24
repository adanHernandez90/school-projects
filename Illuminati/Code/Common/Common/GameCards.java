package Common;

public class GameCards {
	    static int NO_TRANSFERABLEPOWER = 0;
	    static int NO_INCOME = 0;
	    static int NO_POWER= 0;
	    /////////////////////
	    // Blank Card
	    /////////////////////
	    static Card Blank_Card = new Card("Blank Card","Blank Card","");
	    //////////////////////
	    // Special Cards
	    //////////////////////
	    static SpecialCard Media_Campaign = new SpecialCard("Media Campaign","looks like a angry buisnes guy","/Resources/Media Campaign.png");
	    static SpecialCard Computer_Espionage = new SpecialCard(" Computer Espionage","Computer guy and stethescope","/Resources/Computer Espionage.png");
	    static SpecialCard Bribery = new SpecialCard("Bribery","Shaking hands with money inbetween","/Resources/Bribery.png");
	    static SpecialCard Senate_Investigating_Committee =  new SpecialCard("Senate Investigating Committee","Finger Pointing and Sweat","/Resources/Senate Investigating Committee.png");
	    static SpecialCard Slush_Fund = new SpecialCard("Slush Fund","Pig trof with Money","/Resources/Slush Fund.png");
	    static SpecialCard Interference = new SpecialCard("Interference","Bloody Wrench","/Resources/Interferance.png");
	    static SpecialCard Murphys_Law =  new SpecialCard("Murphy's Law","Shocked Guy and Stabbed Dead Guy","/Resources/Murphys Law.png");
	    static SpecialCard Market_Manipulation =  new SpecialCard("Market Manipulation","Bull and Bear","/Resources/Market Manipulation.png");
	    static SpecialCard Deep_Agent = new SpecialCard("Deep Agent","Old maid spy lady","/Resources/Deep Agent.png");
	    static SpecialCard Swiss_Bank_Account = new SpecialCard("Swiss Bank Account","Bank and Money","/Resources/Swiss Bank Account.png");
	    static SpecialCard Assassination = new SpecialCard("Assassination","Exploding red car","/Resources/Assassination.png");
	    static SpecialCard Secrets_Man_Was_Not_Meant_To_Know =  new SpecialCard("Secrets Man Was Not Meant To Know","Guy On Acid","/Resources/Secrets Man Was Not Meant To Know.png");
	    static SpecialCard Whtie_Collar_Crime = new SpecialCard("White Collar Crime","Man in a suit with a suit case full of money","/Resources/White Collar Crime.png");
	    static SpecialCard Whispering_Campaign = new SpecialCard("Whispering Campaign","Whisper Whisper Whisper","/Resources/Whispering Campaign.png");
	    //////////////////////////////////////////////////////////
	    // Group Card
	    //////////////////////////////////////////////////////////
		//GROUP WITH ONE ALIGNMENT
		static GroupCard Convenience_Stores = new GroupCard("Convenience Stores","Chug A Mug and Soylent Sticks",Alignment.Straight,NO_TRANSFERABLEPOWER,1,3,4,"/Resources/Convenience Stores.png");
		
		static GroupCard Empty_Vee = new GroupCard("Empty Vee","Blond Host with Pink Dress Coming Out Of A TV",NO_TRANSFERABLEPOWER,3,4,3,"/Resources/Empty Vee.png");
		
		static GroupCard Big_Media = new GroupCard("Big Media","Black and White TV With The Crowd Reacting",Alignment.Liberal,Alignment.Straight,3,4,3,6,"/Resources/Big Media.png");
		
		static GroupCard Antiwar_Activists = new GroupCard("Antiwar Activists","Flower Power",Alignment.Liberal,Alignment.Peaceful,NO_TRANSFERABLEPOWER,NO_POWER,1,3,"/Resources/Anti War Activists.png");
		
		static GroupCard Nuclear_Power_Companies = new GroupCard("Nuclear Power Companies","Where Homer Simpson Works",Alignment.Conservative,NO_TRANSFERABLEPOWER,4,3,4,"/Resources/Nuclear Power Companies.png");
		
		static GroupCard Post_Office = new GroupCard("Post Office","Illuminati Mail",Alignment.Goverment,3,4,-1,3,"/Resources/Post Office.png");//income is -1; it costs money to keep this card
		
		static GroupCard The_Phone_Company = new GroupCard("The Phone Company","Save! Save! Save!",2,5,3,6,"/Resources/The Phone Company.png");
		
		static GroupCard Moral_Minority = new GroupCard("Moral Minority","Yellow Suit Guy",Alignment.Conservative,Alignment.Straight,Alignment.Fanatic,NO_TRANSFERABLEPOWER,2,2,1,"/Resources/Moral Minorty.png");
	    
		static GroupCard Trekkies = new GroupCard("Trekkies","Hi I'm K'Bob",Alignment.Weird,Alignment.Fanatic,NO_TRANSFERABLEPOWER,NO_POWER,3,4,"/Resources/Trekkies.png");
		
		static GroupCard Hollywood = new GroupCard("Hollywood","Puppet Master and Puppet",Alignment.Liberal,NO_TRANSFERABLEPOWER,2,5,0,"/Resources/Hollywood.png");
		
		static GroupCard Punk_Rockers = new GroupCard("Punk Rockers","Singing Punk",Alignment.Weird,NO_TRANSFERABLEPOWER,NO_POWER,1,4,"/Resources/Punk Rockers.png");
		
		 /////////////////////////////////////
	    // Group Cards With Special Abilites
	    /////////////////////////////////////
	    
	    static GroupCard_OrbitalMindControlLasers Orbitial_Mind_Control_Lasers = new GroupCard_OrbitalMindControlLasers();
		///////////////////////////////////////////////////////////
	    //Group Cards With Enemy Alignment
	    ///////////////////////////////////////////////////////////
	    // Card Name, Card Info, Card Alignment One, Card Alignment Two,Transferable POwer, Power,Income,Resistance, Enemy Alignment, Stat Increase Attack, Stat Increase value
		static GroupCardEA Militia = new GroupCardEA("Militia","Army looking card",Alignment.Violent,Alignment.Conservative,NO_TRANSFERABLEPOWER,2,2,4,Alignment.Communist,Actions.Destroy,6,"/Resources/Militia.png");
		
		static GroupCardEA KGB = new GroupCardEA("KGB","Army looking card",Alignment.Communist,Alignment.Violent,2,2,NO_INCOME,6,Alignment.AllAlign,Actions.Destroy,2,"/Resources/KGB.png");
		
		static GroupCardEA Science_Fiction_Fans = new GroupCardEA("Science Fiction Fans","Stranger in a Strange Land",Alignment.Weird,NO_TRANSFERABLEPOWER,NO_POWER,1,5,Alignment.Weird,Actions.Control,2,"/Resources/Science Fiction Fans.png");
		
		static GroupCardEA Feminists = new GroupCardEA("Feminists","Pointy Bra On Fire",Alignment.Liberal,NO_TRANSFERABLEPOWER,2,1,2,Alignment.Liberal,Actions.Control,3,"/Resources/Feminists.png");
		
		static GroupCardEA Clone_Arrangers = new GroupCardEA("Clone Arrangers","Tank 23",Alignment.Violent,Alignment.Communist,Alignment.Criminal,2,6,1,6,Alignment.AllAlign,Actions.Destroy,3,"/Resources/Clone Arrangers.png");
		
		static GroupCardEA Hackers = new GroupCardEA("Hackers","Click click click",Alignment.Weird,Alignment.Fanatic,1,1,2,4,Alignment.AllAlign,Actions.Destroy,3,"/Resources/Hackers.png");
		
		static GroupCardEA International_Communist_Conspiracy = new GroupCardEA("International Communist Conspiracy","Hammer and Sickle, Russian Revolution",Alignment.Communist,NO_TRANSFERABLEPOWER,7,6,8,Alignment.Communist,Actions.Control,3,"/Resources/International Communist Conspiracy.png");
		
		static GroupCardEA Cycle_Gangs = new GroupCardEA ("Cycle Gangs","Blonde biker and chains",Alignment.Violent,Alignment.Weird,NO_TRANSFERABLEPOWER,NO_POWER,NO_INCOME,4,Alignment.AllAlign,Actions.Destroy,2,"/Resources/Cycle Gangs.png");
		
		static GroupCardEA Semiconscious_Liberation_Army = new GroupCardEA ("Semiconscious Liberation Army","Police and Molotov Cocktail",Alignment.Criminal,Alignment.Violent,Alignment.Liberal,Alignment.Weird,Alignment.Communist,NO_TRANSFERABLEPOWER,NO_POWER,NO_INCOME,8,Alignment.AllAlign,Actions.Destroy,1,"/Resources/Semiconscious Liberation Army.png");
		
		/////////////////////////////////////////////////////////
		// Group Cards with Enemy Card(s)
		/////////////////////////////////////////////////////////
		static GroupCardEC Video_Games = new GroupCardEC("Video Games","Stoner Looking Guy",NO_TRANSFERABLEPOWER,2,7,3,Convenience_Stores,Actions.Control,Actions.Direct,3,"/Resources/Video Games.png");
		
		static GroupCardEC Madison_Avenue = new GroupCardEC("Madison Avenue","You Need More Stuff",3,3,2,3,Big_Media,Empty_Vee,Actions.Control,Actions.AnyAttempt,5,"/Resources/Madison Avenue.png");
		
		static GroupCardEC Junk_Mail = new GroupCardEC("Junk Mail","Mailbox Full Of Trash",Alignment.Criminal,NO_TRANSFERABLEPOWER,1,2,3,Post_Office,Actions.Control,Actions.AnyAttempt,4,"/Resources/Junk Mail.png");
		
		static GroupCardEC Tabloids = new GroupCardEC("Tabloids","Alien and Sasquatch In Love",Alignment.Weird,NO_TRANSFERABLEPOWER,2,3,3,Convenience_Stores,Actions.Control,Actions.Direct,3,"/Resources/Tabloids.png");
		
		static GroupCardEC Anti_Nuclear_Activists = new GroupCardEC("Anti-Nuclear Activists","Two Headed Guy In A Tank Top",Alignment.Liberal,NO_TRANSFERABLEPOWER,2,1,5,Nuclear_Power_Companies,Actions.Destroy,Actions.AnyAttempt,2,"/Resources/Anti_Nuclear_Activists.png");
		
		static GroupCardEC Health_Food_Stores = new GroupCardEC("Health Food Stores","Twig Bar Made With Real Tree Twigs",Alignment.Liberal,NO_TRANSFERABLEPOWER,1,2,3,Anti_Nuclear_Activists,Actions.Control,Actions.AnyAttempt,2,"/Resources/Health Food Stores.png");
		
	    static GroupCardEC SMOF = new GroupCardEC("S.M.O.F","Conspiracy XXIII",Alignment.Weird,NO_TRANSFERABLEPOWER,1,0,1,Trekkies,Science_Fiction_Fans,Actions.Control,Actions.Direct,5,"/Resources/S.M.O.F.png");
	   
	    static GroupCardEC L4_Society = new GroupCardEC("L-4 Society","N20 High",Alignment.Weird,NO_TRANSFERABLEPOWER,1,0,2,Orbitial_Mind_Control_Lasers,Actions.Control,Actions.Neutralize,Actions.Destroy,Actions.Direct,4,"/Resources/L-4 Society.png");

	    static GroupCardEC International_Cocain_Smugglers = new GroupCardEC("International Cocaine Smugglers","Drugs For Sale",Alignment.Criminal,NO_TRANSFERABLEPOWER,3,5,5,Punk_Rockers,Cycle_Gangs,Hollywood,Actions.Control,Actions.AnyAttempt,4,"/Resources/International Cocain Smugglers.png");
	   
	    static GroupCardEC TV_Preachers = new GroupCardEC("TV Preachers","Emotional Preacher",Alignment.Fanatic,Alignment.Straight,NO_TRANSFERABLEPOWER,3,4,6,Moral_Minority,Actions.Control,Actions.Direct,3,"/Resources/TV Preachers.png");
	   
	    static GroupCardEC Phone_Phreaks = new GroupCardEC("Phone Phreaks","Phone Booth With A Rocker Calling",Alignment.Criminal,Alignment.Liberal,1,NO_POWER,1,1,The_Phone_Company,Actions.Control,Actions.Neutralize,Actions.Destroy,Actions.AnyAttempt,3,"/Resources/Phone Phreaks.png");
	   
	    static GroupCardEC Evil_Genuises_For_A_Better_Tomorrow = new GroupCardEC("Evil Genuises For A Better Tomorrow","Think Weird Al Yankovic But A Scientist",Alignment.Violent,Alignment.Weird,2,NO_POWER,3,6,Orbitial_Mind_Control_Lasers,Actions.Control,Actions.Neutralize,Actions.Destroy,Actions.AnyAttempt,4,"/Resources/Evil Genuises For A Better Tomorrow.png");
	    //////////////////////////////////////////
	    // Illuminati Cards
	    //////////////////////////////////////////
	    public static Illuminati_Card The_Bermuda_Triangle = new Illuminati_Card("The Bermuda Triangle","Sinking Boat In A Triangle","May reorganize groups freely at end of turn",8,8,9,"/Resources/The Bermuda Triangle.png");
	    
	    public static Illuminati_Card The_Gnomes_of_Zurich = new Illuminati_Card("The Gnomes of Zurich","Golden Coins","May move money freely at end of turn.",7,7,12,"/Resources/The Gnomes of Zurich.png");
	    
	    public static Illuminati_Card The_UFOs = new Illuminati_Card("The UFOs","Flying UFO","Illuminati group may participate in two attacks per turn.",6,6,8,"/Resources/The UFOs.png");
	    
	    public static Illuminati_Card The_Network = new Illuminati_Card("The Network","Map with data lines","Turns over two cards at beginning of turn.",7,7,9,"/Resources/The Network.png");
	    
	    public static Illuminati_Card The_Bavarian_Illuminati = new Illuminati_Card("The Bavarian Illuminati","Triangle With Eye","May make one priviledged attack each turn at a cost of 5MB",10,10,9,"/Resources/The Bavarian Illuminati.png");
	    
	    public static Illuminati_Card The_Society_of_Assassins = new Illuminati_Card("The Soceity of Assassins","Dagger on cloth","+4 on any attempt to neutralize any group0",8,8,8,"/Resources/The Society Of Assassins.png");
	    
	    public static Illuminati_Card The_Discordian_Society = new Illuminati_Card("The Discordian Society","Golden Apply Etched With The Word : Kallisti","+4 on any attempt to control Weird Groups; \n immune to any attacks from Goverment or Straight groups",8,8,8,"/Resources/The Discordian Society.png");
	    
	    public static Illuminati_Card The_Servants_of_Cthulhu = new Illuminati_Card("The Servants of Cthulhu","One eyed skull","+2 on any attempt to destroy any group",9,9,7,"/Resources/The Servants of Cthulhu.png");
	    
}
