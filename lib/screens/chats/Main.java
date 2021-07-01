/**
 * Main
 */

import java.awt.*;
import javax.swing.*;

public class Main {

    public static void main(String [] args) {
        Exercise1   ex =  new Exercise1();
        ex.setTitle("Exercise 1");

        ex.setSize(600 ,  600);
        ex.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        ex.setVisible(true);
    }
}

class  Exercise1 extends JFrame{

Exercise1(){
    Container c =   getContentPane();
    //1
    c.setLayout(new BorderLayout());


    /////////////////////////////////////////////
    JPanel p1 =  new JPanel();

    JButton   b1 =  new JButton("button1");

    JButton   b2 =  new JButton("button2");
    JButton   b3 =  new JButton("button3");



     p1.setLayout(new GridLayout(2,3));  
      p1.add(b1);
      p1.add(b2);
      p1.add(b3);

////////////////////////////////////////////////////////////


        JPanel p2 =  new JPanel();


        JButton   b4 =  new JButton("button4");

    JButton   b5 =  new JButton("button5");
    JButton   b6 =  new JButton("button6");

p2.setLayout(new GridLayout(2,3));  
      p2.add(b4);
      p2.add(b5);
      p2.add(b6);



////////////////////////////////////////////////////////////////////






c.add(p1 ,    BorderLayout.SOUTH);
c.add(p2 ,  BorderLayout.CENTER);

    
}



}