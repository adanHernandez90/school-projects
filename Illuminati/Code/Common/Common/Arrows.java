package Common;

public enum Arrows {
//////////////////////////
//      North == 1
//         ^
//		   |
// West<--------> East ==2
// == 4    |
//         v   
//      South == 3
//////////////////////////////
North("North",1),East("East",2),West("West",3),South("South",4),None("None",5);
public String name;
public int value;
public String status = "closed";
boolean blocked=false;// o if no cards are blocked
	private Arrows(String name, int value)
	{
		this.name = name;
		this.value= value;
	}

	@Override
	public String toString()
	{
		return name;
	}
	public int Value()
	{
		return value;
	}
	public boolean isOpen()
	{
		if(status.equalsIgnoreCase("closed"))
		{
	   return false;
		}
		else
		{
			return true;
		}
	}
	public boolean isClosed()
	{
		if(status.equalsIgnoreCase("open"))
		{
	    return false;
		}
		else
		{
			return true;
		}
	}
	public void setClose()
	{
		status = "closed";
	}
	public void setOpen()
	{
		status = "open";
	}
	public void setBlocked()
	{
		blocked= true;
	}
	public void setUnBlocked()
	{
		blocked= false;
	}
	public boolean isBlocked()
	{
		if(blocked == true)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	public String stringBlockedStatus()
	{
		if(blocked == false)
		{
			return "not blocked";
		}
		else
		{
			return "blocked";
		}
	}
}

