package Common;

public class Illuminati_Card extends Card{

	public Illuminati_Card(String name, String info,String Ability,int transferablePower, int power, int income,String image) {
		super(name, info,image);
		this.power = power;
		this.income = income;
		this.Ability = Ability;
		this.transferablePower = transferablePower;
		
	}
   public int power;
   public int transferablePower;
   public int income;
   public String Ability;
   public void useAbility(){};
   public void canUseAbiliy(){};
   public int getIncome(){ return income;};
   public int getPower(){ return power;};

   
////////////////////////
//Illuuminati Treasury
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
 
