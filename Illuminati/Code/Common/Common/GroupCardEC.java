package Common;
import java.util.ArrayList;

/////////////////////////////////////////////////////////////
// GROUP CARDS THAT ONLY HAVE ENEMIES OF A CERTAIN CARDS
/////////////////////////////////////////////////////////////
public class GroupCardEC extends GroupCard 
{

	
	
	
//1) Title:  GROUP CARD : NO CARD ALIGNMENT,  ONE ENEMY CARD , ONE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo,int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,Actions attackOne, Actions form,int statInc,String image)
    {
		super(cardName, cardInfo,   transferable_power, power, income, resistance,image);
		enemyCards.add(enemyOne.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}
//2) Title:  GROUP CARD : NO CARD ALIGNMENT,  TWO ENEMY CARDS , ONE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo,int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,GroupCard enemyTwo,Actions attackOne, Actions form,int statInc,String image)
  {
		super(cardName, cardInfo,   transferable_power, power, income,resistance,image);
		enemyCards.add(enemyOne.getCardName());
		enemyCards.add(enemyTwo.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}
//3) Title:  GROUP CARD : ONE CARD ALIGNMENT,  ONE ENEMY CARD , ONE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo, Alignment one, int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,Actions attackOne, Actions form,int statInc,String image)
  {
		super(cardName, cardInfo, one,  transferable_power, power, income,resistance,image);
		enemyCards.add(enemyOne.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}
//4) Title:  GROUP CARD : ONE CARD ALIGNMENT,  ONE ENEMY CARD , THREE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo, Alignment one,int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,Actions attackOne, Actions attackTwo, Actions attackThree, Actions form,int statInc,String image)
{
		super(cardName, cardInfo, one, transferable_power, power, income,resistance,image);
		enemyCards.add(enemyOne.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreases.add(attackTwo);
		statActionIncreases.add(attackThree);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}
//5) Title:  GROUP CARD : ONE CARD ALIGNMENT,  TWO ENEMY CARD , ONE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo, Alignment one, int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,GroupCard enemyTwo,Actions attackOne, Actions form,int statInc,String image)
{
		super(cardName, cardInfo, one,  transferable_power, power, income,resistance,image);
		enemyCards.add(enemyOne.getCardName());
		enemyCards.add(enemyTwo.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}
//6) Title:  GROUP CARD : ONE CARD ALIGNMENT,  THREE ENEMY CARD , ONE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo, Alignment one, int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,GroupCard enemyTwo,GroupCard enemyThree,Actions attackOne, Actions form,int statInc,String image)
{
		super(cardName, cardInfo, one,  transferable_power, power, income,resistance,image);
		enemyCards.add(enemyOne.getCardName());
		enemyCards.add(enemyTwo.getCardName());
		enemyCards.add(enemyThree.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}
//7) Title:  GROUP CARD : TWO CARD ALIGNMENT,  ONE ENEMY CARD , ONE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo, Alignment one,Alignment two, int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,Actions attackOne, Actions form,int statInc,String image)
{
		super(cardName, cardInfo, one,two,  transferable_power, power, income,resistance,image);
		enemyCards.add(enemyOne.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}

//5) Title:  GROUP CARD : TWO CARD ALIGNMENT,  ONE ENEMY CARD , THREE ENEMY STAT INCREASE ATTACK, ONE ATTACK FORM////
public GroupCardEC(String cardName, String cardInfo, Alignment one,Alignment two, int transferable_power, int power, int income,int resistance,
			       GroupCard enemyOne,Actions attackOne, Actions attackTwo, Actions attackThree, Actions form,int statInc,String image)
{
		super(cardName, cardInfo, one,two,  transferable_power, power, income,resistance,image);
		enemyCards.add(enemyOne.getCardName());
		statActionIncreases.add(attackOne);
		statActionIncreases.add(attackTwo);
		statActionIncreases.add(attackThree);
		statActionIncreasesForm.add(form);
		this.statInc = statInc;
	}
ArrayList<Actions> statActionIncreases = new ArrayList<Actions>();//actions that done by the card increase one of its stats
ArrayList<String> enemyCards = new ArrayList<String>();
//Actions that increase stats if done on enemy cards
ArrayList<Actions> statActionIncreasesForm = new ArrayList<Actions>();
/////////////////////
//To String
////////////////////
@Override 
public String toString()
{
StringBuilder allInfo = new StringBuilder();// makes a string we can add on to to make a longer string
allInfo.append("Card: "+ getCardName()+ "\n");
allInfo.append("Card Info: "+ getCardInfo()+"\n");


if(statActionIncreasesForm.contains(Actions.Direct))
{
allInfo.append("+ "+statIncrease()+" for direct ");

for(int i  = 0; i <totalStatIncreaseAttack();i++)
{
	allInfo.append(getStatIncreaseAttack(i)+ "|");
}
allInfo.append(" of ");
for(int i  = 0; i <totalenemyCards();i++)
{
	allInfo.append(enemyCards.get(i)+ "|");
}
}




else
{
allInfo.append("+ "+statIncrease()+" on any attempt to ");
for(int i  = 0; i <totalStatIncreaseAttack();i++)
{
	allInfo.append(getStatIncreaseAttack(i)+ " |");
}
for(int i  = 0; i <totalenemyCards();i++)
{
	allInfo.append(enemyCards.get(i)+ "|");
}
}
allInfo.append("\n");
int totalAli = totalAlignments();
for(int i  = 0; i <totalAli; i ++ )
{
allInfo.append("Alignment "+ (i+1)+ ") "+cardAlignments.get(i)+"\n");
}
allInfo.append("Power     : "+ valPower()+ " / "+ valTransferPower()+"\n");

allInfo.append("Resistance: "+ valResistance()+"\n");
allInfo.append("Income    : "+ valIncome()+"\n");

return allInfo.toString();//changes ift from stringbuilder to string

}
////////////////////////////////////////
//ENEMY CARDS
////////////////////////////////////////

public  boolean isAnEnemyCard(GroupCard Card)
{

if( enemyCards.contains(Card.getCardName()))
{
return true;
}
else
{
return false;
}
}


public int totalenemyCards()
{
return enemyCards.size();
}

public void printenemyCards()
{	
for( int i = 0 ; i < enemyCards.size();i++ )
{
System.out.println(enemyCards.get(i));
}
}

///////////////////////////////////////////
//ACTIONS ON ENEMIES THAT INCREASE STATS
///////////////////////////////////////////


public boolean isAStatIncreaseAttack(Actions action)
{
boolean answer = (statActionIncreases).contains(action);
return answer;
}
public int totalStatIncreaseAttack()
{
return statActionIncreases.size();
}

public void printStatIncreaseAttack()
{	
for( int i = 0 ; i < statActionIncreases.size();i++ )
{
System.out.println(statActionIncreases.get(i));
}
}

public Actions getStatIncreaseAttack( int i)
{
return statActionIncreases.get(i);
}

///////////////////////////////
//Enemy Stat Increase
///////////////////////////////
private int statInc = 0;

public int statIncrease()
{
return statInc;
}
	
public boolean statIncreaseAllowed(GroupCard attackingCard,GroupCard attackedCard, Actions action)
{
	if(statActionIncreasesForm.contains(Actions.Direct))
	{
		if(attackingCard.getCardName() != getCardName())
		{
			return false;
		}
		else
		{
			if(statActionIncreases.contains(action))
			{
				if(enemyCards.contains(attackedCard.getCardName()))
				{
					if(getCardName() == "S.M.O.F")
					{
						SMOFCardStatIncreaseAssigning(attackedCard);
					}
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
	}
	else
	{
		if(statActionIncreases.contains(action))
		{
			if(enemyCards.contains(attackedCard.getCardName()))
			{
				
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
}
/////////////////////////////////
// Special Case for S.M.O.F Card
//////////////////////////////////
public void SMOFCardStatIncreaseAssigning( GroupCard enemyCard)
{
	if( enemyCard.getCardName() == "Science Fiction Fans")
	{
		statInc = 5;
	}
	
	if( enemyCard.getCardName() == "Trekkies")
	{
		statInc =  2;
	}
	
}
}

 
