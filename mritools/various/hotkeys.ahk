
#Singleinstance force

#ifWinActive ahk_class SunAwtFrame 
{
;   �::send  {{}    {}} {left 4}
 ;  �::send  [    ] {left 4}
;  �::send  (    ) {left 4}
;  +�::send  {F9}
; #::send abc
;^7::send  (    ) {left 4}  ;control
;^8::send  [    ] {left 4}  ;control
;^9::send  {{}    {}} {left 4} ;control
; ^1::send `%{� 30}


;�������������������������������������������������
;�������������������������������������������������


^1::
{ clipboard:="%====================================" 
sleep 100
send ^v
return
}
^2::
{ clipboard:="%����������������������������`n������������������������������������������������������������������������" 
sleep 100
send ^v
return
}
^3::
{ clipboard:="%________________________________________________" 
sleep 100
send ^v
return
}
^4::
{ clipboard:="%�����������������������������������������������`n%%   `n%�����������������������������������������������" 
sleep 100
send ^v
return
}

; ===============  klammern   ============================  
�:: send []{left 1}      ;   
!�:: send ] ;    ctrl+sz
^�:: send [ ;    ctrl+sz

�:: send {{}{}}{left 1} ;
!�:: send {}} ;
^�:: send {{} ;
;=========ausfuehren
�::Send, ^a{F9}
�::send,\
�::send  {F9}
+�::send, {HOME}+{END}{F9}



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
ctrl+2:         comment�����
ctrl+2:         comment_____
ctrl+3:         comment  ober/unterstrichen
�:  []        ctrl+�:  [                alt+�: ]
�:  {}         ctrl+�:  {                alt+�:   }
�:              alles markieren & ausfuehren(f9)
�:              \ 
�:              ausfuehren (f9)
shift+�:    zeile markieren & ausfuehren (f9)
)



; ==========================================================
; RAlt & {+}::Msgbox, hallo    
; +::MsgBox You Set Combo to Win and the "+" key
;   !x:: Msgbox, hallo   ----> altx
;  ^x:: Msgbox, hallo   ----> cmd+x
; RAlt & j::Msgbox, hi 
}
