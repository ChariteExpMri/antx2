
#Singleinstance force

#ifWinActive ahk_class SunAwtFrame 
{
;   ä::send  {{}    {}} {left 4}
 ;  ö::send  [    ] {left 4}
;  ü::send  (    ) {left 4}
;  +ä::send  {F9}
; #::send abc
;^7::send  (    ) {left 4}  ;control
;^8::send  [    ] {left 4}  ;control
;^9::send  {{}    {}} {left 4} ;control
; ^1::send `%{– 30}


;•••••••••••••••••••••••••••••••••••••••••••••••••
;•••••••••••••••••••••••••••••••••••••••••••••••••


^1::
;{ clipboard:="%% ————3—————––––––————————————————————————————————————————————————————————————————————————————————————————"
{clipboard:="%% ________________________________________________________________________________________________"
;{clipboard:="%% ======================================================================================="
sleep 100
send ^v
send {return 1}
return
}

^2::
{ clipboard:="%% ===============================================" 
sleep 100
send ^v
send {return 1}
return
}

^3::
;{ clipboard:="%________________________________________________"
{ clipboard:="%==================================================================================================="  
sleep 100
send ^v
send {return 1}
return
}

^4::
;{ clipboard:="%———————————————————————————————————————————————`n%%   `n%———————————————————————————————————————————————" 
{ clipboard:="% ==============================================`n%%   `n% ===============================================" 
sleep 100
send ^v
send {return 1}
send {up 2}
send {end 2}
return
}

; ===============  klammern   ============================  
ß:: send []{left 1}      ;   
!ß:: send ] ;    ctrl+sz
^ß:: send [ ;    ctrl+sz

´:: send {{}{}}{left 1} ;
!´:: send {}} ;
^´:: send {{} ;
;=========ausfuehren
ü::Send, ^a{F9}
ö::send,\
ä::send  {F9}
+ä::send, {HOME}+{END}{F9}



; =====================  copy line  =====================================
RAlt & ,::Msgbox,ms
RAlt & .::send, {HOME}+{END}^c

;RAlt & .:: 
;send, {HOME}+{END}^c
 ;  cs := ClipboardAll
;clipwait
;ms:=%cs%+hallo
;Msgbox,ms
;clipboard :=ms

^7::send (){left 1}  ; 
^8::send []{left 1}      ;  
^9::send {{}{}}{left 1} ;   

;====================help======================
#-::MsgBox, 
( LTrim
ctrl+1:         comment===
ctrl+2:         comment•••••
ctrl+2:         comment_____
ctrl+3:         comment  ober/unterstrichen
ß:  []        ctrl+ß:  [                alt+ß: ]
´:  {}         ctrl+´:  {                alt+´:   }
ü:              alles markieren & ausfuehren(f9)
ö:              \ 
ä:              ausfuehren (f9)
shift+ä:    zeile markieren & ausfuehren (f9)
)



; ==========================================================
; RAlt & {+}::Msgbox, hallo    
; +::MsgBox You Set Combo to Win and the "+" key
;   !x:: Msgbox, hallo   ----> altx
;  ^x:: Msgbox, hallo   ----> cmd+x
; RAlt & j::Msgbox, hi 
}
