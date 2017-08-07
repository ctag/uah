package Cartogurationatron;
/*
 * Program written by Jean-Luc Burhop, Jared McArthur, and Christopher Bero
 * for Dr. Rochowiak's CS330 class in place of a final exam.
 *
 * This file is for the story blocks themselves. Each storyblock will grab its data from a JSON
 * file stored locally.
*/

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import org.json.*;

public class StoryBlock {

    // Each storyblock has a list of requirements to enter.
    public List<String> required_tokens = new ArrayList<String>();
    public String tagID;
    public static List<StoryBlock> listOfBlocks = new ArrayList<StoryBlock>();
    static String readFile(String path, Charset encoding) throws IOException 
    {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, encoding);
    }
    
    // Function to return list of StoryBlocks as JSONArray
    public static JSONArray getArray() throws IOException
    {
        return new JSONObject(readFile("src/testJSON.txt",StandardCharsets.UTF_8)).getJSONArray("blocks");
    }
    // Function to return list as arrayList
    public static List<StoryBlock> getBlocks()
    {
        return listOfBlocks;
    }
    
    // Function to return the Inputs of the block
    public String getInputs() throws IOException
    {
        JSONArray temp = new JSONObject(readFile("src/testJSON.txt",StandardCharsets.UTF_8)).getJSONArray("blocks");
        for(int i = 0; i < temp.length(); i++)
        {
            if(temp.getJSONObject(i).getString("tag").equals(tagID) )
            {
                String str = temp.getJSONObject(i).getString("inputs");
                return str;
            }
        }
        return "No valid block found.";
    }
    
     // Function to return the Inputs of the block
    public String getOutputs() throws IOException
    {
        JSONArray temp = new JSONObject(readFile("src/testJSON.txt",StandardCharsets.UTF_8)).getJSONArray("blocks");
        for(int i = 0; i < temp.length(); i++)
        {
            if(temp.getJSONObject(i).getString("tag").equals(tagID))
            {
                return temp.getJSONObject(i).getString("outputs");
            }
        }
        return "No valid block found.";
    }
    
    
    // Read JSON into storyblock
    JSONObject block;
    
    //ArrayList<String> InputEvents, ArrayList<String> InputEventsModifiers, ArrayList<String> OutputEvents
    public StoryBlock(String InputEvents,String OutputEvents, String InputEventsModifiers, String id) throws IOException {
        /*this.InputEvents = InputEvents;
        this.InputEventsModifiers = InputEventsModifiers;
        this.OutputEvents = OutputEvents;
        this.BlockID = makeID();*/
        //My Code:
        this.tagID = id;
        this.block = new JSONObject(readFile("src/testJSON.txt",StandardCharsets.UTF_8));
        JSONArray blockList = block.getJSONArray("blocks");
        for(int i = 0; i < blockList.length(); i++)
        {
            // This will output all blocks in JSON file.
            //System.out.println(blockList.getJSONObject(i).getString("tag"));
        }
        this.InputEvents = new ArrayList<String>(Arrays.asList(getInputs().split(",")));
        this.OutputEvents = new ArrayList<String>(Arrays.asList(getOutputs().split(",")));
        this.BlockID = makeID();
        // Add storyblock to list of blocks
        listOfBlocks.add(this);
    }
    
    public String getDialog() throws IOException{
        JSONArray temp = new JSONObject(readFile("src/testJSON.txt",StandardCharsets.UTF_8)).getJSONArray("blocks");
        for(int i = 0; i < temp.length(); i++)
        {
            if(temp.getJSONObject(i).getString("tag").equals(tagID))
            {
                return temp.getJSONObject(i).getString("dialog");
            }
        }
        return "No valid block found.";
    }
    public StoryBlock(String id) throws IOException {
        /*this.InputEvents = InputEvents;
        this.InputEventsModifiers = InputEventsModifiers;
        this.OutputEvents = OutputEvents;
        this.BlockID = makeID();*/
        //My Code:
        this.tagID = id;
        this.block = new JSONObject(readFile("src/testJSON.txt",StandardCharsets.UTF_8));
        JSONArray blockList = block.getJSONArray("blocks");
        for(int i = 0; i < blockList.length(); i++)
        {
            // This will output all blocks in JSON file.
            //System.out.println(blockList.getJSONObject(i).getString("tag"));
        }
        String inputs = getInputs();
        this.InputEvents = new ArrayList<String>(Arrays.asList(inputs.split(",")));
        this.OutputEvents = new ArrayList<String>(Arrays.asList(getOutputs().split(",")));
        this.BlockID = makeID();
        // Add storyblock to list of blocks
        listOfBlocks.add(this);
    }

    public String printFunctionMaps()
    {
        return BlockID + ": " + InputEvents.toString() + " -> " + OutputEvents.toString() + "\n";
    }
    public String printInput()
    {
        String input=""; 
        for(String ele : InputEvents)
        {
            input += ele; 
        }
        
        return input;
        
    }
    public String printOutput()
    {
        String output="";
        for(String ele : OutputEvents)
        {
            output += ele; 
        }
        return output; 
        
    }
     public boolean blockConnect(String dna)
    {
        for(String check : InputEvents)
        {
            if(!dna.contains(check))
            {
                return false;
            }
        }
        return true;
    }
    public boolean equals(StoryBlock obj) {
        if (obj == null) return false;
       return (BlockID.equals(obj.getBlockID()));
    }
    
    
    

    
    /*
    List of elements that are required for character to gain entry into this block
        These will tend to be more concrete boolean variables. 
    List of desired story elements the the character has
        These will tend to be ranges, i.e. Fame from 0->1 
    List of elements that will affect the story state. 
    Story dialog for the console
    Language of describing dialog to the console. . 
    */
    public ArrayList<String> InputEvents;
    public ArrayList<String> InputEventsModifiers;
    public ArrayList<String> OutputEvents;
    private String BlockID;

    public ArrayList<String> getInputEvents() {
        return InputEvents;
    }

    public void setInputEvents(ArrayList<String> InputEvents) {
        this.InputEvents = InputEvents;
    }

    public ArrayList<String> getInputEventsModifiers() {
        return InputEventsModifiers;
    }

    public void setInputEventsModifiers(ArrayList<String> InputEventsModifiers) {
        this.InputEventsModifiers = InputEventsModifiers;
    }

    public ArrayList<String> getOutputEvents() {
        return OutputEvents;
    }

    public void setOutputEvents(ArrayList<String> OutputEvents) {
        this.OutputEvents = OutputEvents;
    }
    

    public void setBlockID(String BlockID) {
        this.BlockID = BlockID;
    }

    public String getBlockID() {
        return BlockID;
    }
    public String makeID()
    {
        return UUID.randomUUID().toString().split("-")[0];
    }
    
    
}
