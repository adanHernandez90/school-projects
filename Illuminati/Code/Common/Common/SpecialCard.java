package Common;

public class SpecialCard extends Card
{

	public SpecialCard(String name, String info,String image) {
		super(name, info,image);
		// TODO Auto-generated constructor stub
	}

	private boolean countsAsAction= false;// Special Card being used counted as
	                              // as an action
	
	boolean allowed = true;       // If the card is allowed to
	                              // to be used 
	
	public String owner = "No one";     // Who owns the card
	
	public String ability ="";    // what the card can do 
	
////////////////////////////////////
// Action
////////////////////////////////////
	public void isAnAction()
	{
		countsAsAction = true;
	}
	
	public void NotAnAction()
	{
		countsAsAction = false;
	}
	
	public boolean isItAnAction()
	{
		return countsAsAction;
	}
//////////////////////////////////
// OWNER
//////////////////////////////////
	public String ownedBy()
	{
		return owner;
	}
	
	public void setOwner(String name)
	{
		owner = name;
	}
//////////////////////////////////
// Ability
//////////////////////////////////
	public void setAbility( String abil)
	{
		ability = abil;
	}
	
	public String getAbility()
	{
		return ability;
	}
}







 
