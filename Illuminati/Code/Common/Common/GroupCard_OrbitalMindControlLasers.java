package Common;

public class GroupCard_OrbitalMindControlLasers extends GroupCardSA{
	Alignment Origianl_Alignment = Alignment.NoAlign;
	String action = "";
	
	public GroupCard_OrbitalMindControlLasers() {
		super("Orbital Mind Control Lasers", "On his turn, owner can add , remove, or reverse an alignment of any other group in play; change lasts for that turn only",Alignment.Communist, 2, 4, 0, 5,
				IS_SPECIAL,"/Resources/Orbital Mind Control Lasers.png");
		// TODO Auto-generated constructor stub
	}
	
	public void removeAlignment(GroupCard cardBeingAttacked, int alignmentToRemove)
	{
	Origianl_Alignment = cardBeingAttacked.cardAlignments.get(alignmentToRemove);
	cardBeingAttacked.cardAlignments.remove(alignmentToRemove);
	}
	
	public void addAlignment(GroupCard cardBeingAttacked , Alignment alignmentToAdd)
	{
	cardBeingAttacked.cardAlignments.add(alignmentToAdd);
	}
	
	public void performReverseAlignments(GroupCard cardBeingAttacked, int alignmentToReverse)
	{
		Origianl_Alignment = cardBeingAttacked.cardAlignments.get(alignmentToReverse);
		Alignment reverseAlignment = reverseAlignment(Origianl_Alignment);
		cardBeingAttacked.cardAlignments.remove(alignmentToReverse);
		cardBeingAttacked.cardAlignments.add(reverseAlignment);
	}
	
	public Alignment reverseAlignment(Alignment original)
	{
		Alignment reverseAlignment = Alignment.NoAlign;
		switch(original)
		{
		case Goverment : reverseAlignment = Alignment.Communist; break;
		case Liberal : reverseAlignment = Alignment.Conservative; break;
		case Peaceful : reverseAlignment = Alignment.Violent; break;
		case Straight : reverseAlignment = Alignment.Straight; break; 	
		case Criminal : reverseAlignment = Alignment.Criminal; break;//theres no reverse for them
		case Fanatic : reverseAlignment = Alignment.Fanatic; break;  //they are their own reverse
		default: reverseAlignment = Alignment.NoAlign;
			break;
		}
		return reverseAlignment;
	}
	
	

	
}
 
