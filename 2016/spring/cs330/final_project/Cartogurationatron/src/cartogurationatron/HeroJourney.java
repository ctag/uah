/*
 * Program written by Jean-Luc Burhop, Jared McArthur, and Christopher Bero
 * for Dr. Rochowiak's CS330 class in place of a final exam.
 */
package Cartogurationatron;

import java.util.ArrayList;
public class HeroJourney {
    //Abstract the steps here http://www.thewritersjourney.com/hero's_journey.htm
    //This class will handle some of the DNA conversions
    //show each dna sub string that is used to make each step of the heros journey
    /*
    http://www.thewritersjourney.com/hero's_journey.htm
    
    1.        THE ORDINARY WORLD.  The hero, uneasy, uncomfortable or unaware, is introduced sympathetically so the audience can identify with the situation or dilemma.  The hero is shown against a background of environment, heredity, and personal history.  Some kind of polarity in the hero’s life is pulling in different directions and causing stress.
    2.        THE CALL TO ADVENTURE.  Something shakes up the situation, either from external pressures or from something rising up from deep within, so the hero must face the beginnings of change. 
    3.        REFUSAL OF THE CALL.  The hero feels the fear of the unknown and tries to turn away from the adventure, however briefly.  Alternately, another character may express the uncertainty and danger ahead.
    4.        MEETING WITH THE MENTOR.  The hero comes across a seasoned traveler of the worlds who gives him or her training, equipment, or advice that will help on the journey.  Or the hero reaches within to a source of courage and wisdom.
urse
    5.        CROSSING THE THRESHOLD.  At the end of Act One, the hero commits to leaving the Ordinary World and entering a new region or condition with unfamiliar rules and values. 

    6.        TESTS, ALLIES AND ENEMIES.  The hero is tested and sorts out allegiances in the Special World.
    7.        APPROACH.  The hero and newfound allies prepare for the major challenge in the Special world.
    
    8.        THE ORDEAL.  Near the middle of the story, the hero enters a central space in the Special World and confronts death or faces his or her greatest fear.  Out of the moment of death comes a new life. 
    
    9.        THE REWARD.  The hero takes possession of the treasure won by facing death.  There may be celebration, but there is also danger of losing the treasure again.
    10.      THE ROAD BACK.  About three-fourths of the way through the story, the hero is driven to complete the adventure, leaving the Special World to be sure the treasure is brought home.  Often a chase scene signals the urgency and danger of the mission.

    11.     THE RESURRECTION.  At the climax, the hero is severely tested once more on the threshold of home.  He or she is purified by a last sacrifice, another moment of death and rebirth, but on a higher and more complete level.  By the hero’s action, the polarities that were in conflict at the beginning are finally resolved.
    12.       RETURN WITH THE ELIXIR.  The hero returns home or continues the journey, bearing some element of the treasure that has the power to transform the world as the hero has been transformed.

    */
    public static ArrayList<StoryBlock> createTestJourney(int blocks)
    {
        
        ArrayList<StoryBlock> events = new ArrayList<StoryBlock>();
        //if(blocks > 12)
        blocks = 100;
        ArrayList<String> genes = StateDB.pullTopGenoTypes(blocks, true);
        /*
        for(int x = 0; x<blocks; x++)
        {
            StoryBlock temp;
            String blockID = "[" + x +"]";
            String id = genes.get(x);
            if(x==0)
                temp = new StoryBlock("", genes.get(x)  , StateDB.getPheno(id.substring(0,4), blockID));
            else if(x==11)
                temp = new StoryBlock(genes.get(x-1), genes.get(x)  , StateDB.getPheno(id.substring(0,4), blockID));
            else temp = new StoryBlock(genes.get(x-1), genes.get(x) , StateDB.getPheno(id.substring(0,4), blockID));
            
            events.add(temp);
            
        }*/
        return (ArrayList<StoryBlock>) StoryBlock.getBlocks();//events;
        
                  
        
    }
    
    
}
