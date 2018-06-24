package Common;
enum Alignment
{
	AllAlign("ALl Alignments",12),NoAlign("No Alignments",11),Goverment("Goverment",10),Communist("Communist",9),Liberal("Liberal",8),Conservative("Conservative",7),Peaceful("Peaceful",6),
	Violent("Violent",5), Straight("Straight",4),Weird("Weird",3),Criminal("Criminal",2),Fanatic("Fanatic",1),None("None",0);
	public String name;
	public int value;
	
	private Alignment(String name, int value)
	{
		this.name = name;
		this.value= value;
	}
	
	@Override
	public String toString()
	{
		return name;
	}
	
	
	
}

enum Actions
{
	Control("Control",0),Destroy("Destroy",1),Neutralize("Neuralize",2),NoAction("No Action Stated",3),
	//BELOW ONLY TO BE USED FOR: Cards that have enemy cards
	Direct("Direct",10),AnyAttempt("Any Attmept",11);
	
	
	public String name;
 	public int value;
	private Actions(String name,int value)
        {
		this.name = name;
		this.value = value;
		}
	
	@Override
	public String toString()
	{
		return name;
	}
}

enum Ability
{
	Control,Neutralize,Destroy
}
 
