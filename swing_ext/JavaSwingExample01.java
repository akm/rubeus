import java.awt.Dimension;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.KeyEvent;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.JTextPane;
import javax.swing.JSplitPane;

public class JavaSwingExample01 {

    public static void main(String[] args) {
        JFrame frame = new JFrame("Rubeus Swing Example 01");
        frame.setLayout(new BoxLayout(frame.getContentPane(), BoxLayout.Y_AXIS));
        JSplitPane splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
        frame.add(splitPane);
        JPanel panel = new JPanel();
        splitPane.setTopComponent(panel);
        panel.setLayout(new BoxLayout(panel, BoxLayout.X_AXIS));
        final JTextField textField = new JTextField();
        panel.add(textField);
        final JTextPane textPane = new JTextPane();
        textField.addKeyListener(new KeyAdapter() {
                public void keyPressed(KeyEvent event) {
                    if (event.getKeyCode() == 10) {
                        textPane.setText(textPane.getText() + textField.getText() + "\n");
                        textField.setText("");
                    }
                }
            });
        JButton button = new JButton("append");
        panel.add(button);
        button.addActionListener(new ActionListener(){
                public void actionPerformed(ActionEvent event) {
                    textPane.setText(textPane.getText() + textField.getText() + "\n");
                    textField.setText("");
                }
            });
        JScrollPane scrollPane = new JScrollPane(textPane);
        splitPane.setBottomComponent(scrollPane);
        scrollPane.setPreferredSize(new Dimension(400, 250));
        frame.setSize(400, 300);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }
}