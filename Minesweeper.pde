import de.bezier.guido.*;
import java.util.Arrays;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public final int NUM_ROWS =15;
public final int NUM_COLS = 15;
public final int NUM_MINES = 40;
public boolean firstMove = true;

void setup (){
    size(600, 600);
    textAlign(CENTER,CENTER);
    Interactive.make(this);
    mines = new ArrayList<MSButton>();
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int j = 0;j<buttons.length;j++){
        for(int i = 0;i<buttons.length;i++){
            buttons[i][j] = new MSButton(i,j);
        }
    }
}
public void setMines(int r, int c){   
    for(int i = 1;i<=NUM_MINES;i++){
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])&&row!=r&&col!=c)
        mines.add(buttons[row][col]);
    }
}

public void draw (){
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon(){
    if(firstMove) return false;
    for(MSButton m : mines){
        if(!m.isFlagged())
            return false;
    }
    return true;
}
public void displayLosingMessage(){
    for(MSButton[] b1 : buttons){
        for(MSButton b : b1){
            b.endGameColor();
        }
    }
    for(MSButton[] r : buttons)
        for(MSButton c : r)
            c.setLabel("L");
}
public void displayWinningMessage(){
    for(MSButton[] r : buttons)
        for(MSButton c : r)
            c.setLabel("W");
}
public boolean isValid(int r, int c){
    return(c<NUM_COLS&&r<NUM_ROWS&&r>=0&&c>=0);
}
public int countMines(int row, int col){
    int count = 0;
    for(int r = row-1;r<=row+1;r++)
                for(int c = col-1; c<=col+1;c++)
                    if(isValid(r,c)&&mines.contains(buttons[r][c]))
                        count++;
    return count;
}
public class MSButton{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, ended;
    private String myLabel;
    
    public MSButton ( int row, int col ){
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = ended = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () {
        if(firstMove)
        {
            setMines(myRow,myCol);
            firstMove=false;
        }
        clicked = true;
        if(mouseButton==RIGHT&&myLabel.length()==0){
            if(flagged){
                flagged=false;
                clicked = false;
            }
            else if(!flagged){
                flagged=true;
                clicked=false;
            }
        }
        else if(mines.contains(this)) displayLosingMessage();
        else if(countMines(myRow,myCol)>0) myLabel = ""+countMines(myRow,myCol);
        else{
            for(int r = myRow-1;r<=myRow+1;r++)
                for(int c = myCol-1; c<=myCol+1;c++)
                    if(isValid(r,c) && !buttons[r][c].clicked)
                        buttons[r][c].mousePressed();
        }
    }
    public void draw () {   
        if(!ended){
            if(flagged)
                fill(0);
            else if(clicked && mines.contains(this)) 
                fill(255,0,0);
            else if(clicked)
                fill(200);
            else 
                fill(100);
        }
        else
        {
            if(mines.contains(this))
                fill(255,0,0);
            else
                fill(200);
        }
            rect(x, y, width, height);
            fill(0);
            textSize(width/5+5);
            text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){
        myLabel = newLabel;
    }
    public void setLabel(int newLabel){
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged(){
        return flagged;
    }
    public void endGameColor(){
        ended = true;
    }
}