package Common;

import java.util.concurrent.ThreadLocalRandom;

public class Dice {
int diceVal = 0;
 public int roll()
 {
	 int randomNum = ThreadLocalRandom.current().nextInt(1, 6 + 1);
	 diceVal = randomNum;
	 return randomNum;
 }
 
 public int Value()
 {
	 return diceVal;
 }
 

}
 
