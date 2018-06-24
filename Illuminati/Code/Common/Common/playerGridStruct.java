package Common;

import java.util.ArrayList;
import java.util.LinkedList;

public class playerGridStruct {
	private static final Card NULL = null;
	int rows = 5;// must always be an odd number-->rows == cols
	int cols = 5;// must always be an odd number-->rows == cols
	int row_center = ((rows+1)/2)-1;
	int col_center = ((cols+1)/2)-1;
	// Status of cards located North, East,West and South at a stated grid location
	int N_Status = 0;
	int E_Status = 0;
	int S_Status = 0;
	int W_Status = 0;
	/////////////////////////////
	// Card Location
	/////////////////////////
	int xCords = 0;
	int yCords = 0;
	int open = 0;
	int closed = 1;
	Card [] [] playerCardGrid = new Card[rows][cols];

	public static void main(String [ ] args)
	{
	     playerGridStruct test =  new playerGridStruct();
	     test.printGrid();
	     System.out.println("--------------------------------------------");
	     test.placeIllCard(GameCards.The_Bavarian_Illuminati);
	     test.printGrid();
	     test.insertToGrid(GameCards.The_Discordian_Society, 1, 2);
	     System.out.println("--------------------------------------------");
	     test.printGrid();
	     
	    
	     
	}
	public  playerGridStruct ()
	{
		initGrid();
		
	}
	public  Card getGroupCard(Card card)
	{
		findCardCoords(card);
		return playerCardGrid[xCords][yCords];
	}
	public void printGrid()
	{
	   for(int i = 0; i < rows; i++)
	   {
	      for(int j = 0; j < cols; j++)
	      {
	    	 {
	    		 if(playerCardGrid[i][j].getCardName() =="Blank Card")
	    		 {
	    			 System.out.printf("%5d",0);
	    		 }
	    		 else
	    		 {
	                 // System.out.printf("%5s ", playerCardGrid[i][j].getCardName());
	    			 System.out.printf("%5d",1);
	    		 }
	    	 }
	      }
	      System.out.println();
	   }
	}
	public void initGrid()
	{
		 for(int i = 0; i < rows; i++)
		   {
		      for(int j = 0; j < cols; j++)
		      {
		    	 {
		        playerCardGrid[i][j] = GameCards.Blank_Card;
		    	 }
		      }
	
		   }
	}
	
	public void insertToGrid(Card card, int row, int col)
	{
		playerCardGrid[row][col]= card;
		findCardCoords(card);
		System.out.println("("+xCords +","+yCords+")");
		//upDateCardsArrows(card);
	}
	
	public void placeIllCard(Card illCard)
	{
		playerCardGrid[row_center][col_center]= illCard;
		//upDateCardsArrows(illCard);
	}
	public void upDateCardsArrows(Card Card)
	{
		findCardCoords(Card);
		
		Card.East_Arrow.isBlocked();
		
	}
	
	public void findCardCoords(Card card)
	{
	for (int i = 0 ; i < rows; i++)
	    for(int j = 0 ; j < cols ; j++)
	    {
	         if (playerCardGrid[i][j] == card)
	         {
	              xCords = i;
	              yCords = j;
	              break;
	         }
	    }
	
	}
	
	public boolean containsCard(Card card)
	{
	
		for(int i = 0; i < rows; i++)
		   {
		      for(int j = 0; j < cols; j++)
		      {
		    	 {
		         playerCardGrid[i][j] = card;
		         return true;
		         
		    	 }
		      }
	
		   }
		return false;
	}

	public void updateCardArrows( Card card , int x , int y)
	{
		 
	}
}
