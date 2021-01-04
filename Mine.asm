; Minesweeper
; By: Kevin Chen
; Due: 11/21/2018
org 100h
.model small
.stack
.data 

msg db   'Move the cursor using the arrow keys. Press spacebar to select. DO NOT MOVE CURSOR TO A KNOWN NUMBER','$'        
promptlose db  'BOOM! You Lose.','$'
 
prompt1 db  'Minesweeper By: Kevin Chen','$'

promptwin db  'Good Game, You Won!','$'

player db  01h
player_index  dw 0

value dw 0h 
adder db 0h
adjacent db 30h

minindex db 2d,11d,13d,23d,36d,43d,57d,60d,65d,75d 

Board  db   '--------',0dh,0ah
       db   '--------',0dh,0ah
       db   '--------',0dh,0ah
       db   '--------',0dh,0ah
       db   '--------',0dh,0ah
       db   '--------',0dh,0ah
       db   '--------',0dh,0ah
       db   '--------',0dh,0ah,'$'

up    db 48h
down  db 50h
left  db 4bh
right db 4dh 
space db 39h
  
  crlf db 0dh,0ah,'$'
.code  
  mov ax,@data
  mov ds,ax   
       call  start  
       call  firstboard_display
; 
continue:  call  scndboard_display  ;display board
       mov dx,offset crlf
       mov ah,09
       int 21h    
       mov dx,offset msg
       mov ah,09
       int 21h
       mov ah,0
       int 16h 
       cmp ah,space
       jz label1
       call  move      
       jmp label2
       label1:
       call check_mine 
       call winner
       call display_mines
       label2:
       jmp   continue       

start proc    
        mov ah,02h     
        mov dh,11d
        mov dl,27d
        mov bh,0
        int 10h          
        lea   dx,prompt1    
        mov   ah,09h        
        int   21h 
        mov ah,02h     
        mov dh,3d
        mov dl,27d
        mov bh,0
        int 10h
        mov ah,7              
        mov al,0
        mov cx,0
        mov dh,24
        mov dl,79
        mov bh,00110100b
        int 10h  
    ret
    start endp

firstboard_display proc
        mov ah,02h
        mov dh,5d
        mov dl,33d
        mov bh,0
        int 10h  
        mov si,0
        mov di,0
        mov ah,player[si]
        mov Board[di],ah
    lea dx , crlf
          mov ah,09h
          int  21h
          lea dx , Board
          mov ah,09h
          int 21h       
        ret
firstboard_display endp

scndboard_display proc
        mov ah,02h
        mov dh,5d
        mov dl,33d
        mov bh,0
        int 10h  
    lea dx , crlf
          mov ah,09h
          int  21h
          lea dx , Board
          mov ah,09h
          int 21h    
        ret
scndboard_display endp


winner proc
    mov al,53d      
    cmp al,adder
    jz w1
    jmp w2
    w1: 
    mov ah,7               ;window
        mov al,0
        mov cx,0
        mov dh,24
        mov dl,79
        mov bh,10110100b
        int 10h  
         mov ah,02h     ;move cursor
        mov dh,3d
        mov dl,27d
        mov bh,0
        int 10h
    
       mov dx,offset promptwin
       mov ah,09
       int 21h
       jmp game_over1
    w2:
    ret
winner endp     

move proc
     cmp ah,right 
     jz move_right
     cmp ah,left
     jz move_left
     cmp ah,up
     jz moveup
     cmp ah,down
     jz down1
     
   move_right: 

      mov bx,player_index
      add player_index,1d
      mov si,bx
      mov al,Board[si]
      cmp al,30h 
      jz target
      cmp al,31h 
      jz target
      cmp al,32h 
      jz target
      cmp al,33h 
      jz target 
      cmp al,34h 
      jz target 
      cmp al,35h 
      jz target
      cmp al,36h 
      jz target
      mov si,0
      mov si , player_index
      mov al,Board[si] 
      mov di, bx
      mov Board[di],al
      
      target: 
      mov si,0
      mov ah,player[si]
      mov di, player_index
      mov Board[di],ah
     jmp skip 
     moveup: 
    jmp move_up
  
    skip:
       jmp skip1
     down1: 
    jmp move_down
  
    skip1:
      jmp  end_mov
     
   move_left:
      mov bx,player_index
      sub player_index,1d 
      mov si,bx
      mov al,Board[si]
      cmp al,30h 
      jz target1
      cmp al,31h 
      jz target1 
      cmp al,32h 
      jz target1
      cmp al,33h 
      jz target1 
      cmp al,34h 
      jz target1 
      cmp al,35h 
      jz target1
      cmp al,36h 
      jz target1
      mov si,0
      mov si , player_index
      mov al,Board[si] 
      mov di, bx
      mov Board[di],al
      
      target1:
      mov si,0
      mov ah,player[si]
      mov di, player_index
      mov Board[di],ah
      jmp  end_mov

   move_up: 
      mov bx,player_index
      sub player_index,10d
      mov si,bx
      mov al,Board[si]
      cmp al,30h 
      jz target2
      cmp al,31h 
      jz target2 
      cmp al,32h 
      jz target2 
      cmp al,33h 
      jz target2 
      cmp al,34h 
      jz target2 
      cmp al,35h 
      jz target2
      cmp al,36h 
      jz target2 
      mov si,0
      mov si , player_index
      mov al,Board[si] 
      mov di, bx
      mov Board[di],al

      target2:
      mov si,0
      mov ah,player[si]
      mov di, player_index
      mov Board[di],ah
      jmp  end_mov
   
   move_down: 
      mov bx,player_index
      add player_index,10d
      mov si,bx
      mov al,Board[si]
      cmp al,30h 
      jz target3
      cmp al,31h 
      jz target3
      cmp al,32h 
      jz target3
      cmp al,33h 
      jz target3 
      cmp al,34h 
      jz target3 
      cmp al,35h 
      jz target3
      cmp al,36h 
      jz target3
      mov si,0
      mov si , player_index
      mov al,Board[si] 
      mov di, bx
      mov Board[di],al

      target3:
      mov si,0
      mov ah,player[si]
      mov di, player_index
      mov Board[di],ah
      jmp end_mov

   end_mov:
    ret
move endp 

game_over:
       mov ah,4ch
       int 21h

check_mine proc 
   mov cx,10
   mov si,offset minindex
   
  label3:
     mov ax,[si] 
     mov bx, player_index
     cmp al,bl
     jz label4 
     inc si
     loop label3 
     jmp label5
     
     label4: 
     mov ah,7               
        mov al,0
        mov cx,0
        mov dh,24
        mov dl,79
        mov bh,10010100b
        int 10h  
        mov ah,02h     
        mov dh,3d
        mov dl,27d
        mov bh,0
        int 10h
      lea   dx,promptlose    
      mov   ah,09h        
      int   21h
      jmp game_over1
      
      label5:
     ret   
     
check_mine endp     

display_mines proc 
    inc adder
    mov bx,player_index
    inc bx
    mov cx,10
    mov si,offset minindex

     first:
     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q1
     
     add adjacent,1
     
     q1: 
     inc si
     loop first  
     jmp skip3
     game_over1: 
    jmp game_over
  
    skip3: 
   mov bx,player_index
   dec bx 
   mov cx,10
   mov si,offset minindex

   secnd:
     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q2
     add adjacent,1
     
     q2: 
     inc si
     loop secnd
   mov bx,player_index  
   add bx,10d 
   mov cx,10
   mov si,offset minindex

   third:

     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q3
     add adjacent,1
     
     q3: 
     inc si
     loop third 
   mov bx,player_index  
   sub bx,10
   mov cx,10
   mov si,offset minindex

   fourth:
   
     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q4
     add adjacent,1

     q4: 
     inc si
     loop fourth 
   mov bx,player_index  
   sub bx,11
   mov cx,10
   mov si,offset minindex

   fifth:
     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q5
     add adjacent,1

     q5: 
     inc si
     loop fifth 
   mov bx,player_index  
   add bx,11
   mov cx,10
   mov si,offset minindex

   sixth:
     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q6
     add adjacent,1

     q6: 
     inc si
     loop sixth
   mov bx,player_index  
   add bx,9
   mov cx,10
   mov si,offset minindex

   seventh:
     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q7
     add adjacent,1

     q7: 
     inc si
     loop seventh
   mov bx,player_index  
   sub bx,9
   mov cx,10
   mov si,offset minindex

   eigth:
   
     mov ax,[si] 
     mov ah,0h 
     cmp ax,bx
     jnz q8
     add adjacent,1

     q8: 
     inc si
     loop eigth
    mov ch,adjacent
    mov di,player_index
    mov Board[di],ch
    mov adjacent,30h
     ret
display_mines endp
     
end start
