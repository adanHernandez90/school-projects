package Common;
///////////////////////////////
// NOT DONE
////////////////////////////////
public class GroupCard_FederalReserve extends GroupCardSA{
	public GroupCard_FederalReserve() {
		super("Federal Reserve","When it transfers money, that money can go to any group in the same Power Structure", Alignment.Goverment, 3, 5, 6, 7, IS_SPECIAL,"/Resources/Federal Reserve.png");
	
	}
/*	public boolean canUseSpecialAbility(GroupCard attacking,Actions currentAction,GroupCard cardBeingAttacked)
	{
		
		return false;
	}*/
	public void useSpecialABility(GroupCard transferer,GroupCard tranferee, int amountToTransfer)
	{
		TransferMoney(transferer,tranferee,amountToTransfer);
	}
	public String getSpecialAbility()
	{
		return"When it transfers money, that money can go to any group in the same Power Structure";
	}

}
  
