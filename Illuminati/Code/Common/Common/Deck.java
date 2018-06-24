package Common;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;


public class Deck {
	 boolean BeginningOFGame = true;
	
	public  ArrayList<Card> Cards = new ArrayList<Card>();
	 
	 public Deck()
	 {
		 Initialize();
		 randomizeCards();
		 
	 };
	public boolean isEmpty()
	{
		return Cards.isEmpty();
	}
	 private void Initialize()
	 {
		 Cards.add(GameCards.Whtie_Collar_Crime);
		 Cards.add(GameCards.Swiss_Bank_Account);
		 Cards.add(GameCards.Slush_Fund);
		 Cards.add(GameCards.Senate_Investigating_Committee);
		 Cards.add(GameCards.Murphys_Law);
		 Cards.add(GameCards.Secrets_Man_Was_Not_Meant_To_Know);
		 Cards.add(GameCards.Interference);
		 Cards.add(GameCards.Market_Manipulation);
		 Cards.add(GameCards.Deep_Agent);
		 Cards.add(GameCards.Computer_Espionage);
		 Cards.add(GameCards.Bribery);
		 Cards.add(GameCards.Assassination);
		 Cards.add(GameCards.Whispering_Campaign);
		 Cards.add(GameCards.Media_Campaign);
		 Cards.add(GameCards.Video_Games);
		 Cards.add(GameCards.TV_Preachers);
		 Cards.add(GameCards.Trekkies);
		 Cards.add(GameCards.The_Phone_Company);
		 Cards.add(GameCards.Tabloids);
		 Cards.add(GameCards.SMOF);
		 Cards.add(GameCards.Semiconscious_Liberation_Army);
		 Cards.add(GameCards.Science_Fiction_Fans);
		 Cards.add(GameCards.Punk_Rockers);
		 Cards.add(GameCards.Post_Office);
		 Cards.add(GameCards.Phone_Phreaks);
		 Cards.add(GameCards.Orbitial_Mind_Control_Lasers);
		 Cards.add(GameCards.Nuclear_Power_Companies);
		 Cards.add(GameCards.Moral_Minority);
		 Cards.add(GameCards.Militia);
		 Cards.add(GameCards.Madison_Avenue);
		 Cards.add(GameCards.L4_Society);
		 Cards.add(GameCards.KGB);
		 Cards.add(GameCards.Junk_Mail);
		 Cards.add(GameCards.International_Communist_Conspiracy);
		 Cards.add(GameCards.International_Cocain_Smugglers);
		 Cards.add(GameCards.Hollywood);
		 Cards.add(GameCards.Health_Food_Stores);
		 Cards.add(GameCards.Hackers);
		 Cards.add(GameCards.Feminists);
		 Cards.add(GameCards.Evil_Genuises_For_A_Better_Tomorrow);
		 Cards.add(GameCards.Empty_Vee);
		 Cards.add(GameCards.Cycle_Gangs);
		 Cards.add(GameCards.Convenience_Stores);
		 Cards.add(GameCards.Clone_Arrangers);
		 Cards.add(GameCards.Big_Media);
		 Cards.add(GameCards.Antiwar_Activists);
	 }
	 
	 public void randomizeCards()
	 {
		 long seed = System.nanoTime();
		 Collections.shuffle(Cards, new Random(seed));
		 
	 }
	 
	 public void printDeckContents()
	 {
		 System.out.println("Deck Contents: ");
		 for(int i = 0; i < Cards.size(); i ++)
		 {
			 System.out.println((i+1+" : "+ Cards.get(i).getCardName()+"\n"));
		 }
	 }
	 
	 public Card DrawCard()
	 {
		 return popCard();
	 }
	 
	 private Card popCard()
	 {
		 Card poppedCard;
		 poppedCard = Cards.get(0);
		 Cards.remove(0);
		 return poppedCard;
	 }
	 
	 public void insertCard(Card cardToInsert)
	 {
		 Cards.add(cardToInsert);
		 randomizeCards();
	 }
	 
	 public boolean containsCard(Card chosenCard)
	 {
		 if(Cards.indexOf(chosenCard)>-1)
		 {
			 return true;
		 }
		 else 
		 {
			 return false;
		 }
	 }
}
