/*
 * Program written by Jean-Luc Burhop, Jared McArthur, and Christopher Bero
 * for Dr. Rochowiak's CS330 class in place of a final exam.
 */
package Cartogurationatron;

import edu.uci.ics.jung.algorithms.layout.DAGLayout;
import edu.uci.ics.jung.algorithms.layout.Layout;
import edu.uci.ics.jung.visualization.GraphZoomScrollPane;
import edu.uci.ics.jung.visualization.VisualizationViewer;
import edu.uci.ics.jung.visualization.control.DefaultModalGraphMouse;
import edu.uci.ics.jung.visualization.decorators.EdgeShape;
import edu.uci.ics.jung.visualization.decorators.ToStringLabeller;
import edu.uci.ics.jung.visualization.renderers.DefaultVertexLabelRenderer;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.TextArea;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JPanel;
import org.apache.commons.collections15.Transformer;
import org.apache.commons.collections15.functors.ConstantTransformer;

public class Cartogurationatron {
    // We need a few lists to keep track of our pathing throughout the other files
    static List<String> out = new ArrayList<String>();
    static List<String> finalStory = new ArrayList<String>();
    public static void main(String[] args) throws IOException {
        // Create a list of our class object
        ArrayList<StoryBlock> list_of_blocks = new ArrayList<StoryBlock>();
        // the 'out' list will be keeping track of content to be pushed to the JTextField 'console'
        out.add("Displaying all existing blocks in JSON file.\n\n");
        // Create some story blocks. The reason we are using x=32 is because out JSON contains 33 blocks
        for(int x=1; x<32;x++)
        {
            // Grab each block by its tag [x] where x is iterating
            StoryBlock temp = new StoryBlock("[" +x+"]");
            // Output the functionmaps to both the console and screen.
            System.out.println(temp.printFunctionMaps());
            out.add(temp.printFunctionMaps());
            
        }
        // Create a StorySystem object and make a test game.
        StorySystem game = StorySystem.makeTestHero();
        // And then build the example graph.
        game.buildTestGraph();
        
        // this will print each availible node path
        System.out.print(game.printAvailable());
        out.add(game.printAvailable());
        System.out.print(game.StoryMap.toString());
        out.add(game.StoryMap.toString());
        
        // Create a DAGLayout to arrange the graph with jung.
        Layout<Integer, String> layout = new DAGLayout(game.StoryMap);
        layout.setSize(new Dimension(800,800)); // sets the initial size of the space
        // The BasicVisualizationServer<V,E> is parameterized by the edge types
        // Here we are just adding a ton of stuff to allow you to change colors of the graph. We stuck with near defaults
        // for this but the option to change them is nice.
        VisualizationViewer<Integer,String> vv = new VisualizationViewer<Integer,String>(layout, new Dimension(500, 500));
        vv.setPreferredSize(new Dimension(java.awt.Toolkit.getDefaultToolkit().getScreenSize().width/2, java.awt.Toolkit.getDefaultToolkit().getScreenSize().height-100)); //Sets the viewing area size
        vv.setBackground(Color.WHITE);
        vv.getRenderContext().setEdgeShapeTransformer(new EdgeShape.Line());
        vv.getRenderContext().setVertexLabelTransformer(new ToStringLabeller());
        // add a listener for ToolTips
        vv.setVertexToolTipTransformer(new ToStringLabeller());
        vv.getRenderContext().setArrowFillPaintTransformer(new ConstantTransformer(Color.BLACK));
        vv.getRenderContext().setVertexFillPaintTransformer(new ConstantTransformer(Color.GREEN));
        vv.getRenderContext().setEdgeDrawPaintTransformer(new ConstantTransformer(Color.BLACK));
        final Color vertexLabelColor = Color.BLACK;
        DefaultVertexLabelRenderer vertexLabelRenderer = 
            new DefaultVertexLabelRenderer(vertexLabelColor)
        {
            @Override
            public <V> Component getVertexLabelRendererComponent(JComponent vv, Object value, Font font, 
                boolean isSelected, V vertex) 
            {
                super.getVertexLabelRendererComponent(
                    vv, value, font, isSelected, vertex);
                setForeground(vertexLabelColor);
                return this;
            }
        };
        vv.getRenderContext().setVertexLabelRenderer(vertexLabelRenderer);
        vv.getRenderContext().setVertexLabelTransformer(new ToStringLabeller<>());
        DefaultModalGraphMouse graphMouse = new DefaultModalGraphMouse();
        vv.setGraphMouse(graphMouse);
        // Uncomment this if you want the mouse to drag nodes rather than scroll.
        //graphMouse.setMode(ModalGraphMouse.Mode.PICKING);
        
        // Create out main JFrame
        JFrame frame = new JFrame("Cartogurationatron");
        frame.setLayout(new FlowLayout());
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // We went with a zoomable panel
        GraphZoomScrollPane panel = new GraphZoomScrollPane((VisualizationViewer) vv);
        frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
        
        // Create secondary pane for the text output.
        JPanel pane = new JPanel();
        pane.setBounds(0, 0, 250, 100);
        TextArea output;
        output = new TextArea("", 0, 0, TextArea.SCROLLBARS_VERTICAL_ONLY);
        output.setPreferredSize(new Dimension(java.awt.Toolkit.getDefaultToolkit().getScreenSize().width/2 - 50, java.awt.Toolkit.getDefaultToolkit().getScreenSize().height-120)); //Sets the viewing area size
        pane.add(output);
        // Throw text into the output console.
        for(Iterator<String> i = out.iterator(); i.hasNext(); ) {
            String item = i.next();
            output.setText(output.getText() + item);
        }  
        output.setText(output.getText() + "\n\nAnd the final output/story:\n\n\n");
        for(Iterator<String> i = finalStory.iterator(); i.hasNext(); ) {
            String item = i.next();
            output.setText(output.getText() + item + "\n");
        }  
        output.setText(output.getText()+"\n\n\n\n\n");
        frame.add(pane);
        frame.add(panel);
        
        // Here we are doing some fun things to let the tooltip for each node output its dialog.
        vv.setVertexToolTipTransformer(new Transformer(){
            @Override
            public Object transform(Object i) {
                String tmp = i.toString();
                return StorySystem.nodeValues.get(i);
            }
        });
        
        // Render frame.
        frame.setVisible(true);  
    }
    
}
