package Common;

public class GroupCard_ChineseCampaignDonor extends GroupCardSA {

	static boolean IS_SPECIAL = true;
	public GroupCard_ChineseCampaignDonor() {
		super("Chinese Campaign Donors", "Treat This Group As Goverment When It Attempts To Control A Goverment Group",Alignment.Communist,0,3, 3, 2,IS_SPECIAL,"/Resources/Chinese Campaign Donors.png");
		
	}
	
	public void swapAlignmentToGoverment()
	{
		cardAlignments.remove(0);//Removes Communist Alignment
		cardAlignments.add(Alignment.Goverment);//Set GovermentAlignment
	}
	
	public void swapAlignmentToOriginalALignment()
	{
		cardAlignments.remove(0);//Removes Goverment Alignment
		cardAlignments.add(Alignment.Communist);//Set Communist Alignment
	}
	
	public boolean canUseSpecialAbility(GroupCard attacking,Actions currentAction,GroupCard cardBeingAttacked)
	{
		if(currentAction == Actions.Control & 
		   attacking.getCardName().equalsIgnoreCase("Chinese Campaign Donors") &
		   cardBeingAttacked.cardAlignments.contains(Alignment.Goverment))
		{
		return true;
		}
		return false;
	}
	
	public String getSpecialAbility()
	{
		return"Being able to switch Alignments: Communist to Alignment: Goverment  if trying to control a Goverment group";
	}
	
	public void useSpecialABility()
	{
		swapAlignmentToGoverment();
	}
	
	public void stopSpecialAbility()
	{
		swapAlignmentToOriginalALignment();
	}
	
	

}
 
