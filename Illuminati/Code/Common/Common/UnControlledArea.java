package Common;
import java.util.ArrayList;


public class UnControlledArea {

	public UnControlledArea(){}
	public ArrayList<Card> Cards = new ArrayList<Card>();
	
	public void insertIntoUncontrolledArea(Card cardToInsert)
	{
		Cards.add(cardToInsert);
	}
	public void insertIntoUncontrolledAreaWithIndex(int t,Card cardToInsert)
	{
		
		Cards.add(t, cardToInsert);
	}
	
	public Card viewCard(int i)
	{
		return Cards.get(i);
	}
	public Card takeFromUncontrolledArea(int cardPosition)
	{
		Card takenCard = Cards.get(cardPosition);
		Cards.remove(cardPosition);
		return takenCard;
	}
	
	public Card takeFromUncontrolledArea(Card cardChosen)
	{
		Card takenCard;
		int location = Cards.indexOf(cardChosen);	
		takenCard = Cards.get(location);
		Cards.remove(location);
		return takenCard;
	}
	
	public int totalCardsInUncontrolledArea()
	{
		return Cards.size();
	}
	
	public String toString()
	{
		StringBuilder info = new StringBuilder();
		for(int i = 0 ; i < Cards.size();i++)
		{
			info.append((i+1)+") "+ Cards.get(i).getCardName()+"\n");
			
		}
		if(Cards.size() == 0)
		{
			info.append("No Cards in Uncontrolled Area");
		}
		return info.toString();
	}
	
	
}
 
