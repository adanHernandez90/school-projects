package Common;

import java.util.ArrayList;

public class Player {

	String userName;
	int wins = 0;
	int loses = 0;
	Illuminati_Card IlluminatiCard;
	ArrayList<Card> specialCards = new ArrayList<Card>();
	ArrayList<Card> heldCards = new ArrayList<Card>();
	playerGridStruct heldGroupCards =  new playerGridStruct();
	
	public Card getHeldCardsAtIndex( int x)
	{
		return heldCards.get(x);
	}
	public boolean hasCards()
	{
		if( heldCards.isEmpty())
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	public void setUserName(String name)
	{
		this.userName = name;
	}
	public String getUserName()
	{
		return userName;
	}

	public void winner()
	{
		wins +=1;
	}
	public void losser()
	{
		loses += 1;
	}
	
	public int getWins()
	{
		return wins;
	}
	
	public void setIlluminati( Illuminati_Card illumCard)
	{
		IlluminatiCard = illumCard;
	}
	public Illuminati_Card getIlluminatiCard( )
	{
		return IlluminatiCard ;
	}
	public void addSpecialCard( Card card)
	{
		if( card instanceof SpecialCard)
		{
			specialCards.add(card);
		}
		else 
		{
			System.out.println(card.getCardName()+ " was not added to Player: "+getUserName()+" because it wasnt a special card");
		}
	}
	
	public void addGroupCard( Card card)
	{
		if( card instanceof GroupCard)
		{
			heldCards.add(card);
		}
		else 
		{
			System.out.println(card.getCardName()+ " was not added to Player: "+getUserName()+" because it wasnt a group card");
		}
	}
	
	
	public String stringSpecialCard(int pos )
	{
		return specialCards.get(pos).getCardName();
	}
	
	public void printAllSpecialCards()
	{
		for(int i = 0; i<specialCards.size(); i++)
		{
			System.out.println(i+")"+specialCards.get(i).getCardName()+"\n");
		}
	}
	public int indexOfSpecialCard(Card card)
	{
	   for(int i = 0; i <specialCards.size();i++)
	   {
		   if(specialCards.get(i) == card)
		   {
			   return i;
		   }
	   }
	   
	   return -1;
	}
}
