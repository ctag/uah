/*
 * Program written by Jean-Luc Burhop, Jared McArthur, and Christopher Bero
 * for Dr. Rochowiak's CS330 class in place of a final exam.
 *
 * This file is what creates the jung graph and assigns the edges.
 */
package Cartogurationatron;

import edu.uci.ics.jung.graph.DirectedGraph;
import edu.uci.ics.jung.graph.DirectedSparseMultigraph;

import java.io.IOException;
import static java.lang.Math.abs;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StorySystem {
    public static Map<String, String> nodeValues = new HashMap<String, String>();
    private ArrayList<StoryBlock> AvailableBlocks;
    private ArrayList<StoryBlock> UsedBlocks;
    public DirectedGraph<String, String> StoryMap = new DirectedSparseMultigraph<String, String>();
    private String DNA = "";

    public StorySystem(ArrayList<StoryBlock> AvailableBlocks, ArrayList<StoryBlock> UsedBlocks) {
        this.AvailableBlocks = AvailableBlocks;
        this.UsedBlocks = UsedBlocks;
    }
    public StorySystem(ArrayList<StoryBlock> AvailableBlocks) {
        this.AvailableBlocks = AvailableBlocks;
        this.UsedBlocks = new ArrayList<StoryBlock>();
    }
    public StorySystem() {
        this.AvailableBlocks = new ArrayList<StoryBlock>();
        this.UsedBlocks = new ArrayList<StoryBlock>();
    }
    public static StorySystem makeTestHero()
    {
        StorySystem newSS = new StorySystem();
        newSS.AvailableBlocks = HeroJourney.createTestJourney(12);
        return newSS;
    }
    public static StorySystem makeRandomSetBlocks(int numBlocks) throws IOException
    {
        StorySystem newSS = new StorySystem();
        Random rand = new Random();
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        
        for(int n = 0; n < numBlocks; n++)
        {
            String prereq = "";
            //rand.nextInt((max - min) + 1) + min;
            int r_pre = rand.nextInt((3 - 1) + 1) + 1;
            for(int i = 0; i < r_pre; i++)//make the pre_reqs
            {
                String r_Char = chars.charAt(rand.nextInt(chars.length())) + "";
                prereq += r_Char;
                if(i < numBlocks-1)
                     prereq += ",";
            }
            String post = "";
            //rand.nextInt((max - min) + 1) + min;
            int r_post = rand.nextInt((2 - 1) + 1) + 1;
            for(int i = 0; i < r_post; i++) //make the post_reqs
            {
                String r_Char = chars.charAt(rand.nextInt(chars.length())) + "";
                if(!post.contains(r_Char))
                {
                    post += r_Char;
                    if(i < numBlocks-1)
                         post += ",";
                }
                else if(i == 0)
                    i = -1;
                else
                    i--;
            }
            StoryBlock newBlock = new StoryBlock(prereq, null, post,"");
            newSS.AvailableBlocks.add(newBlock);
        }
        return newSS;
        
    }
    public String printAvailable()
    {
        String returnString = "";
        for(StoryBlock temp : AvailableBlocks)
        {
            returnString += temp.printFunctionMaps();
        }
        return returnString; 
    }
    public void buildTestGraph() throws IOException
    {
        StoryBlock currentNode;
        Random rand = new Random(System.currentTimeMillis());
        int currentNodeAddress = 0; //abs(rand.nextInt()%(AvailableBlocks.size()+1));
        ArrayList<StoryBlock> possibles = grabNewPaths2(10);
        // this random simulates the user selecting one of the blocks
        currentNodeAddress = abs(rand.nextInt()) % (possibles.size());
        currentNode = AvailableBlocks.remove(currentNodeAddress);
        StoryMap.addVertex("Unused Blocks"); 
        DNA += currentNode.printOutput();
        DNA += currentNode.printInput();
        Cartogurationatron.out.add("\n\nListing all potential nodes during pathing.\n");
        Cartogurationatron.out.add(currentNode.printOutput());
        Cartogurationatron.out.add(currentNode.printInput());
        List<String> nodesNotUsed = new ArrayList<String>();
        while(true)
        {
            ArrayList<StoryBlock> possible = grabNewPaths(10);
            if(possible.isEmpty())
                break;
            // this random simulates the user selecting one of the blocks
            int nextNodeAdress = abs(rand.nextInt()) % (possible.size());
            StoryBlock nextNode = possible.remove(nextNodeAdress);
            AvailableBlocks.remove(nextNode);
            for(Iterator<StoryBlock> i = possible.iterator(); i.hasNext(); ) {
                StoryBlock item = i.next();
                StoryMap.addVertex(item.getBlockID());
            }
            if(!DNA.contains(nextNode.OutputEvents.get(0)))
                {
                try {
                    System.out.println("Dialog: " + currentNode.getDialog());
                    System.out.println("Input: " + currentNode.InputEvents);
                    System.out.println("Output: " + currentNode.OutputEvents + "\n\n");
                    Cartogurationatron.out.add("\nDialog:\t"+currentNode.getDialog() + "\nInput:\t"+currentNode.getInputs()
                    + "\nOutput:\t"+currentNode.getOutputs() + "\n\n");
                    Cartogurationatron.finalStory.add(currentNode.getDialog());
                } catch (IOException ex) {
                    Logger.getLogger(StorySystem.class.getName()).log(Level.SEVERE, null, ex);
                }
                    try{nodeValues.put(nextNode.getBlockID(), nextNode.getDialog());}
                    catch(NullPointerException e)
                    {
                        System.out.println(e.toString());
                    }
                    StoryMap.addVertex(nextNode.getBlockID()); 
                    DNA += nextNode.printOutput();
                    StoryMap.addEdge(DNA, currentNode.getBlockID(), nextNode.getBlockID());
                    currentNode = nextNode;
                }
            else
            {
                nodesNotUsed.add(nextNode.getBlockID());
                try{nodeValues.put(nextNode.getBlockID(), nextNode.getDialog());}
                    catch(NullPointerException e)
                    {
                        System.out.println(e.toString());
                    }
            }
        }
        //StoryMap.addVertex(nextNode.getBlockID());
        /*for(Iterator<String> i = nodesNotUsed.iterator(); i.hasNext(); ) {
            String item = i.next();
            StoryMap.addVertex(item);

        } */ 
        if(!DNA.contains(currentNode.OutputEvents.get(0)))
        {
            StoryMap.addVertex(currentNode.getBlockID()); 
            DNA += currentNode.printOutput();
        }
    }
    public ArrayList<StoryBlock> grabNewPaths(int num_options)
    {
        ArrayList<StoryBlock> possible = new ArrayList<>();
        //Grab next node
        for(StoryBlock block : AvailableBlocks)
        {
            int index = DNA.lastIndexOf("[(]*[)]");
            if(index<0)
                index = 0;
            if(block.blockConnect(DNA.substring(index)))
                possible.add(block);
            if(possible.size() >= num_options-1)
                break;
        }
        return possible;
    }
    public ArrayList<StoryBlock> grabNewPaths2(int num_options)
    {
        ArrayList<StoryBlock> possible = new ArrayList<>();
        //Grab next node
        for(StoryBlock block : AvailableBlocks)
        {
            int index = DNA.lastIndexOf("[(]*[)]");
            if(index<0)
                index = 0;
            if(block.blockConnect(""))
                possible.add(block);
            if(possible.size() >= num_options-1)
                break;
        }
        return possible;
    }
    
}
