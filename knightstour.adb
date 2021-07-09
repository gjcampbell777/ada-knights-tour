with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.Float_Text_IO; use ada.Float_Text_IO;
procedure knightstour is
    --Initiate a 2d array with an unknown subrange and other more simple variables
    type board is array (natural range <>, natural range <>) of integer;
    -- arrays a and b are all 8 (x,y) movements a knight can make 
    a: array (1..8) of integer := (2,1,-1,-2,-2,-1,1,2);
    b: array (1..8) of integer := (1,2,2,1,-1,-2,-2,-1);
    size : integer := 5;
    n : integer := 1;
    xpos, ypos : integer;
    q : boolean;
    
    --Recursive procedure that does the solving portion of the algorithm
    procedure try(i, x, y: in integer; q: out boolean; h: in out board) is
        k, u, v : integer;
        q1 : boolean;
    begin
    
        k := 0;
        
        --Loops until all knights movement(k) kas been attempted or a knights move works
        --Loop calls the try procedure resulting in the recursive part of this algorithm 
        loop

            k := k+1;
            q1 := false;
            u := x+(a(k));
            v := y+(b(k));
            
            --Checks if u and v are within the size of the chess board
            if (u in 1..size) and (v in 1..size) then
                if h(u,v) = 0 then
                    h(u,v) := i;
                    --If the number of calls to try is less than all board spaces
                    --the try procedure is called again
                    if i < n then
                        try(i+1,u,v,q1,h);
                        if not q1 then
                            h(u,v) := 0;
                        end if;
                    else 
                        q1 := true;
                    end if;
                    
                end if;
            
            end if;
        
            exit when q1 or k=8;
        end loop;
        q := q1;
    end try;
    
    --Procedure that draws out the board after calling the try procedure
    procedure makeBoard(size, xpos, ypos: in out integer) is
        --Given the input provided by the user a 2d array the 
        --length and width of the chess board is created
        h : board(1..size, 1..size);
        outfp : file_type;
        two: integer := 2;
    begin
    
        create(outfp, out_file, "tour.txt");
    
        --Board array is filled with 0's
        for i in 1..size loop
            for j in 1..size loop
                h(i,j) := 0;
            end loop;
        end loop;
        
        --try procedure is called and starting position is set in board array
        h(xpos,ypos) := 1;
        try(two, xpos, ypos, q, h);
        
        --After the try procedure is finished running, it is checked if the board array
        --has any zeros, if it does this means the algorithm didn't work correctly
        for i in 1..size loop
            for j in 1..size loop
                if h(i,j) = 0 then
                    q := false;
                end if;
            end loop;
        end loop;
        
        --If the knights tour is possible the entire board is printed out with all steps
        --If not "No solution" is printed out instead
        if q then
            for i in 1..size loop
                for j in 1..size loop
                    put(h(i,j));
                    put(outfp, h(i,j));
                end loop;
                new_line;
            end loop;     
        end if; 
        
        if not q then 
            put_line("No Solution. :(");
            put(outfp, "No Solution. :(");
        end if;
        
         close(outfp);
        
        end makeBoard;

--Starting procedure
begin
    
    --Asks for and receives input to figure out the size of the chess board
    --and the starting position of the knight
    --Also calls the makeboard procedure
    Put("Input size of chess board (Between 5 - 10) :");
    Get(size);
    Put("Start Position: x y ");
    Get(xpos);
    Get(ypos);
    n := size*size;
    makeBoard(size, xpos, ypos);
 
end knightstour;
