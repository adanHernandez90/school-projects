package Common;
//////////////////////////////////////////////////////////////////////////////////////
//					CARD CLASS
// * is the basic structure of a card - just a card name and card info
// * 
// Constructors:
// 1) Card 
//    - Contents
//		- Card Name
//		- Card Description
///////////////////////////////////////////////
//	FUNCTIONS
////////////////////////////////////////////////
// 1) setCardName( String ) -- sets card name
// 2) getCardName() -- Returns card name ( return type: string )
// 3) getCardInfo() -- Returns card name ( return type: string )
// 4) setCardInfo( String ) -- sets card info

public class Card {

	private String cardName;
	private String cardInfo;
	private String image;
	
	
	public String getCardName()
	{
		return cardName;
	}
	
	public void setCardName(String name)
	{
		cardName = name;
	}
	
	public String getCardInfo()
	{
		return cardInfo;
	}
	
	public void setCardInfo(String info)
	{
		cardInfo = info;
	}
	public Card(String name,String info,String image)
	{
		cardName = name;
		cardInfo =info;
		this.image=image;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}
	
   Arrows North_Arrow = Arrows.North;
   Arrows South_Arrow = Arrows.South;
   Arrows East_Arrow  = Arrows.East;
   Arrows West_Arrow = Arrows.West;
   public void arrowStatus()
   {
	   System.out.println("North Arrow : "+ North_Arrow.stringBlockedStatus()+"\n"+
			   			  "South Arrow : "+ South_Arrow.stringBlockedStatus()+"\n"+
			   			  "East Arrow  : "+ East_Arrow.stringBlockedStatus()+"\n"+
			   			  "West Arrow  : "+ West_Arrow.stringBlockedStatus()+"\n");
   }
   int arrowAmount = 0;
   public void setArrowAmount(int i ){ arrowAmount = i;}
}
