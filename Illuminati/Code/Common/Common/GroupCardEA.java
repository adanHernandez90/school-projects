package Common;
import java.util.ArrayList;

/////////////////////////////////////////////////////////////
// GROUP CARDS THAT ONLY HAVE ENEMIES OF CERTAIN ALIGNMENTS
//
//
//
//
//
//
/////////////////////////////////////////////////////////////
public class GroupCardEA extends GroupCard {

///////////////////////////////
// CONSTRUCTORS
///////////////////////////////
	
//1) Title:  GROUP CARD : ONE CARD ALIGNMENT,  ONE ENEMY ALIGNMENT , ONE ENEMY STAT INCREASE ATTACK////
public GroupCardEA(String cardName, String cardInfo, Alignment one, int transferable_power, int power, int income, int resistance, 
	              Alignment enemyOne, Actions attackOne , int statInc,String image) //<--- LOOK HERE
{
	super(cardName, cardInfo, one, transferable_power, power, income,resistance,image );
	enemyAlignments.add(enemyOne);
	statActionIncreases.add(attackOne);
	this.statInc = statInc;
	
}

//2) Title:  GROUP CARD : TWO CARD ALIGNMENT,  ONE ENEMY ALIGNMENT , ONE ENEMY STAT INCREASE ATTACK////
public GroupCardEA(String cardName, String cardInfo, Alignment one, Alignment two,int transferable_power, int power, int income, int resistance, 
	              Alignment enemyOne, Actions attackOne , int statInc,String image) //<--- LOOK HERE
{
	super(cardName, cardInfo, one,two, transferable_power, power, income,resistance,image);
	enemyAlignments.add(enemyOne);
	statActionIncreases.add(attackOne);
	this.statInc = statInc;
	
}
//3) Title:  GROUP CARD : THREE CARD ALIGNMENT,  ONE ENEMY ALIGNMENT , ONE ENEMY STAT INCREASE ATTACK////
public GroupCardEA(String cardName, String cardInfo, Alignment one, Alignment two,Alignment three,int transferable_power, int power, int income, int resistance, 
	              Alignment enemyOne, Actions attackOne , int statInc,String image) //<--- LOOK HERE
{
	super(cardName, cardInfo, one,two,three, transferable_power, power, income,resistance,image);
	enemyAlignments.add(enemyOne);
	statActionIncreases.add(attackOne);
	this.statInc = statInc;
	
}
//4) Title:  GROUP CARD : FOUR CARD ALIGNMENT,  ONE ENEMY ALIGNMENT , ONE ENEMY STAT INCREASE ATTACK////
public GroupCardEA(String cardName, String cardInfo, Alignment one, Alignment two,Alignment three,Alignment four,int transferable_power, int power, int income, int resistance, 
	              Alignment enemyOne, Actions attackOne , int statInc,String image) //<--- LOOK HERE
{
	super(cardName, cardInfo, one,two,three,four, transferable_power, power, income,resistance,image);
	enemyAlignments.add(enemyOne);
	statActionIncreases.add(attackOne);
	this.statInc = statInc;
	
}
//5) Title:  GROUP CARD : FIVE CARD ALIGNMENT,  ONE ENEMY ALIGNMENT , ONE ENEMY STAT INCREASE ATTACK////
public GroupCardEA(String cardName, String cardInfo, Alignment one, Alignment two,Alignment three,Alignment four,Alignment five,int transferable_power, int power, int income, int resistance, 
	              Alignment enemyOne, Actions attackOne , int statInc,String image) //<--- LOOK HERE
{
	super(cardName, cardInfo, one,two,three,four,five, transferable_power, power, income,resistance,image);
	enemyAlignments.add(enemyOne);
	statActionIncreases.add(attackOne);
	this.statInc = statInc;
	
}
//6) Title:  GROUP CARD : TWO CARD ALIGNMENT,  TWO ENEMY ALIGNMENT , ONE ENEMY STAT INCREASE ATTACK////
public GroupCardEA(String cardName, String cardInfo, Alignment one, Alignment two,int transferable_power, int power, int income, int resistance, 
	              Alignment enemyOne,Alignment enemyTwo ,Actions attackOne , int statInc,String image) //<--- LOOK HERE
{
	super(cardName, cardInfo, one,two, transferable_power, power, income,resistance,image);
	enemyAlignments.add(enemyOne);
	enemyAlignments.add(enemyTwo);
	statActionIncreases.add(attackOne);
	this.statInc = statInc;
	
}

//7) Title:  GROUP CARD : TWO CARD ALIGNMENT,  TWO ENEMY ALIGNMENT , ONE ENEMY STAT INCREASE ATTACK////
public GroupCardEA(String cardName, String cardInfo, Alignment one, Alignment two,int transferable_power, int power, int income, int resistance, 
	              Alignment enemyOne,Alignment enemyTwo ,Alignment enemyThree,Actions attackOne , int statInc,String image) //<--- LOOK HERE
{
	super(cardName, cardInfo, one,two, transferable_power, power, income,resistance,image);
	enemyAlignments.add(enemyOne);
	enemyAlignments.add(enemyTwo);
	enemyAlignments.add(enemyThree);
	statActionIncreases.add(attackOne);
	this.statInc = statInc;
	
}
/////////////////////
//To String
////////////////////
@Override 
public String toString()
{
StringBuilder allInfo = new StringBuilder();// makes a string we can add on to to make a longer string
allInfo.append("Card: "+ getCardName()+ "\n");
allInfo.append("Card Info: "+ getCardInfo()+"\n");
allInfo.append("+ "+statIncrease()+" on any attmept to "+ getStatIncreaseAttack(0)+ " any ");
if(enemyAlignments.contains(Alignment.AllAlign))
{
	allInfo.append(" group");
}
else
{
	allInfo.append(enemyAlignments.get(0)+ " group "+ "\n");
}
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
// ENEMY ALIGNMNETS 
////////////////////////////////////////

ArrayList<Alignment> enemyAlignments = new ArrayList<Alignment>();
//Actions that increase stats if done on enemy alignments
ArrayList<Actions> statActionIncreases = new ArrayList<Actions>();

public  boolean isAnEnemyAlignment(GroupCard Card)
{

	if( enemyAlignments.contains(Alignment.AllAlign))
	{
		return true;
	}
	
	for ( int i = 0; i <Card.totalAlignments(); i++)
	{
		if((enemyAlignments).contains(Card.cardAlignments.get(i)))
				{
					return true;
				}
	}
	
	
	return false;
	
}
public int totalEnemyAlignments()
{
	return enemyAlignments.size();
}

public void printEnemyAlignments()
{	
	for( int i = 0 ; i < enemyAlignments.size();i++ )
	{
		System.out.println(enemyAlignments.get(i));
	}
}

///////////////////////////////////////////
// ACTIONS ON ENEMIES THAT INCREASE STATS
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
// Enemy Stat Increase
///////////////////////////////
private int statInc = 0;

public int statIncrease()
{
	return statInc;
}

	
} 
