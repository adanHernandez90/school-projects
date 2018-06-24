package Common;

public class GroupCardSA extends GroupCard {

	public GroupCardSA(String cardName, String cardInfo, Alignment one,
			int transferable_power, int power, int income, int resistance,
			boolean SpecialAbility,String image) {
		super(cardName, cardInfo, one, transferable_power, power, income, resistance,
				SpecialAbility,image);
		
	}
	
	public GroupCardSA(String cardName, String cardInfo, Alignment one,
			Alignment two, int transferable_power, int power, int income,
			int resistance, boolean SpecialAbility,String image) {
		super(cardName, cardInfo, one, two, transferable_power, power, income,
				resistance, SpecialAbility,image);
		
	}

	
	static boolean IS_SPECIAL = true;
	
	
	public boolean canUseSpecialAbility(GroupCard attacking,Actions currentAction,GroupCard cardBeingAttacked)
	{
		
		return false;
	}
	
	public String getSpecialAbility()
	{
		return"Blank";
	}
	
	public void useSpecialABility()
	{
	}
	
	public void stopSpecialAbility()
	{
		
	}

}
 
