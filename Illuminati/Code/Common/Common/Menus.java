package Common;
import java.util.ArrayList;


public class Menus {
	public static void main(String[] args) {
		playerGridStruct struct = new playerGridStruct();
		
		struct.placeIllCard(GameCards.The_Gnomes_of_Zurich);
		struct.printGrid();
	}
}