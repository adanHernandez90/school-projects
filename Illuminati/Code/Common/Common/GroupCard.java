package Common;
import java.util.ArrayList;

//////////////////////////////////////////////////////////////////////////////////////
//					GROUP CARD CLASS
// * extends the CARD class
// * is the basic structure of a group card with NO SPECIAL ABILITES, NO INCREASE STATS
// * 
// Three Constructors:
// 1) Group Card 
//    - Contents
//		- Card Name
//		- Card Description
//		- Power
//		- Resistance 
//		- Income
// 2) Group Card One Alignment
//		- Contents
//		  - Card Name
//	      - Card Description
//	      - Power
//	      - Resistance 
//	      - Income
//	      - Alignment One
// 3) Group Card Two Alignment
//	    - Contents
//  	   - Card Name
//         - Card Description
//         - Power
//         - Resistance 
//         - Income
//         - Alignment One
//         - Alignment Two
///////////////////////////////////////////////
//	FUNCTIONS
////////////////////////////////////////////////
// 1) printAlignments() -- Prints all the cards alignments
// 2) getAlignmentOne() -- Returns Alignment One 
// 3) getAlignmentTwo() -- Returns Alignment Two
// 4) totalAlignments() -- Return total number of Alignments a card has (is a integer)
// 5) hasAlignments()   -- Return boolean if a card has any alignments( true if it does , false if it doesnt)
// 6) valTransferPower()-- Returns the cards Transferable Power ( is an integer)
// 7) valPower()        -- Returns the cards Power Value (is an integer)
// 8) valIncome()       -- Returns the cards Income Value ( is an integer)
// 9) valResistance()   -- Returns the cards Resistance value ( is an integer)

public class GroupCard extends Card
{

	//GROUP CARD WITH NO ALIGNMENTS
		public GroupCard(String cardName,String cardInfo, int transferable_power, int power, int income, int resistance,String image)
		
		{
		super(cardName,cardInfo,image);//calls the card constructor

		this.transferable_power = transferable_power;
		this.power= power;
		this.income = income;
		this.resistance = resistance;
		cardAlignments.add(Alignment.NoAlign);
		}
	
	//GROUP WITH ONE ALIGNMENT
	public GroupCard(String cardName,String cardInfo,Alignment one,
	         int transferable_power, int power, int income, int resistance,String image)
	
	{
	super(cardName,cardInfo,image);//calls the card constructor
	cardAlignments.add(one);
	this.transferable_power = transferable_power;
	this.power= power;
	this.income = income;
	this.resistance = resistance;
	}
	
	//GROUP WITH ONE ALIGNMENT BUT HAS A SPECIAL ABILITY
		public GroupCard(String cardName,String cardInfo,Alignment one,
		         int transferable_power, int power, int income, int resistance,boolean SpecialAbility,String image)
		
		{
		super(cardName,cardInfo,image);//calls the card constructor
		cardAlignments.add(one);
		this.transferable_power = transferable_power;
		this.power= power;
		this.income = income;
		this.resistance = resistance;
		this.SpecialAbilityStatus = SpecialAbility;
		}
		
	//GROUP  WITH TWO ALIGNMENTS
	public GroupCard(String cardName,String cardInfo,Alignment one,Alignment two,
			         int transferable_power, int power, int income, int resistance, String image)
			
	{
		super(cardName,cardInfo,image);//calls the card constructor
		cardAlignments.add(one);
		cardAlignments.add(two);
		this.transferable_power = transferable_power;
		this.power= power;
		this.income = income;
		this.resistance = resistance;
	}
	
	//GROUP  WITH TWO ALIGNMENTS BUT HAS A SPECIAL ABILITY
		public GroupCard(String cardName,String cardInfo,Alignment one,Alignment two,
				         int transferable_power, int power, int income, int resistance,boolean SpecialAbility,String image)
				
		{
			super(cardName,cardInfo,image);//calls the card constructor
			cardAlignments.add(one);
			cardAlignments.add(two);
			this.transferable_power = transferable_power;
			this.power= power;
			this.income = income;
			this.resistance = resistance;
			this.SpecialAbilityStatus = SpecialAbility;
		}
		
	
	//GROUP  WITH THREE ALIGNMENTS
		public GroupCard(String cardName,String cardInfo,Alignment one,Alignment two,Alignment three,
				         int transferable_power, int power, int income, int resistance,String image)
				
		{
			super(cardName,cardInfo,image);//calls the card constructor
			cardAlignments.add(one);
			cardAlignments.add(two);
			cardAlignments.add(three);

			this.transferable_power = transferable_power;
			this.power= power;
			this.income = income;
			this.resistance = resistance;
		}
		
		//GROUP  WITH FOUR ALIGNMENTS
				public GroupCard(String cardName,String cardInfo,Alignment one,Alignment two,Alignment three,Alignment four,
						         int transferable_power, int power, int income, int resistance,String image)
						
				{
					super(cardName,cardInfo,image);//calls the card constructor
					cardAlignments.add(one);
					cardAlignments.add(two);
					cardAlignments.add(three);
					cardAlignments.add(four);

					this.transferable_power = transferable_power;
					this.power= power;
					this.income = income;
					this.resistance = resistance;
				}
				
	
	
			//GROUP  WITH FIVE ALIGNMENTS
			public GroupCard(String cardName,String cardInfo,Alignment one,Alignment two,Alignment three,Alignment four,
					Alignment five,int transferable_power, int power, int income, int resistance,String image)
					
			{
				super(cardName,cardInfo,image);//calls the card constructor
				cardAlignments.add(one);
				cardAlignments.add(two);
				cardAlignments.add(three);
				cardAlignments.add(four);
				cardAlignments.add(five);
				this.transferable_power = transferable_power;
				this.power= power;
				this.income = income;
				this.resistance = resistance;
			}
				
/////////////////////
// To String
////////////////////
			@Override 
			public String toString()
			{
			StringBuilder allInfo = new StringBuilder();// makes a string we can add on to to make a longer string
			allInfo.append("Card: "+ getCardName()+ "\n");
			allInfo.append("Card Info: "+ getCardInfo()+"\n");
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
/////////////////////
// Alignment
/////////////////////
	
	ArrayList<Alignment> cardAlignments = new ArrayList<Alignment>();
	
	
	
	public int totalAlignments()
	{
		if(cardAlignments.get(0) == Alignment.NoAlign )
		{
			return 0;
		}
		else 
		{
		return cardAlignments.size();	
		}
	}

	public boolean hasAlignments()
	{
		if(cardAlignments.get(0) == Alignment.NoAlign )
		{
			return false;
		}
		else 
		{
		return true;	
		}
	}

	public void printAlignments()
	{	
		for( int i = 0 ; i < cardAlignments.size();i++ )
		{
			System.out.println((1+i)+ ") "+cardAlignments.get(i));
		}
	}
		
	
	public void printSelectedAlignment(int selectedAlignment)
	{
		if( selectedAlignment>cardAlignments.size())
		{
		  System.out.println("Card only has "+ cardAlignments.size()+" Alignments.");
		}
		
		else if (selectedAlignment <0)
		{
			System.out.println("Entered value is not allowed");
		}
		
		else
		{
			System.out.println(cardAlignments.get(selectedAlignment));
		}
		}
	
	public Alignment getAlignmentOne()
	{
		return cardAlignments.get(0);
	}
	
	public Alignment getAlignmentTwo()
	{
		if(cardAlignments.size()<2)
		{
			return cardAlignments.get(0);
		}
		return cardAlignments.get(1);
	}
	

//////////////////
// Power
/////////////////
	private int transferable_power = 0;
	private int power = 0;;
	private int income = 0;
	
   public int valTransferPower()
   {
	   return transferable_power;
   }
   public int valPower()
   {
	   return power;
   }
   
   public int valIncome()
   {
	   return income;
   }
 
//////////////////////
// Resistance   
//////////////////////
   private int resistance = 0;
   
   public int valResistance()
   {
	   return resistance;
   }
/////////////////////////
// Has A Special Ability
/////////////////////////
   public boolean SpecialAbilityStatus = false;
   public boolean hasSpecialAbility()
   {
	   return SpecialAbilityStatus;
   }
   
////////////////////////
// Group Treasury
////////////////////////
int treasury = 0;
   public void addIncomeToTreasury()
   {
	   treasury += income;
   }
   
   public int sendFromTreasury(int amount)
   {
	   int amountToSend = amount;
	   treasury -= amount;
	   return amountToSend;
   }
   
   public void addAmountToTreasury(int amount)
   {
	   treasury += amount;
   }
   
   public void printValueOfTreasury()
   {
	   System.out.println(treasury);
   }
   
   public int getValueOfTreasury()
   {
	   return treasury;
   }
   public void TransferMoney( GroupCard transferer , GroupCard transferee, int amountToTransfer)
	{
		transferer.sendFromTreasury(amountToTransfer);
		transferee.addAmountToTreasury(amountToTransfer);
	}
   
}
 
