.model tiny 
code    segment
        assume cs:code, ds:code
        org 100h

start:
        jmp load    ; переход на нерезидентную часть
        old dd 0    ; адрес старого обработчика 
        buf db ' 00:00:00 ', 0  ; шаблон для вывода времени
        date db 'M:00 D:00', 0  ; шаблон для вывода дня и месяца
        done dw 1234


get_time_trans  proc         ; процедура заполнения шаблона времени
        mov     ah,  al      ; преобразование двоично-десятичного 
        and     al,  15      ; числа в регистре AL
        shr     ah,  1       ; в пару ASCII символов
        shr     ah,  1
        shr     ah,  1
        shr     ah,  1
        add     al,  '0'
        add     ah,  '0'
        mov     buf[bx + 1],  ah  ; запись ASCII символов
        mov     buf[bx + 2],  al
        add     bx,  3
        ret                   ; возврат из процедуры
get_time_trans  endp          ; конец процедуры 


; аналогично для даты
get_date_trans proc
        mov     ah,  al
        and     al,  15
        shr     ah,  1
        shr     ah,  1
        shr     ah,  1
        shr     ah,  1
        add     al,  '0'
        add     ah,  '0'
        mov     date[bx + 2],  ah
        mov     date[bx + 3],  al
        add     bx,  5
        ret 
get_date_trans endp

clock   proc     ; процедура обработчика прерываний от таймера
        pushf    ; создание в стеке структуры для IRET(сохранение флагов)
        call    cs:old  ; вызов старого обработчика прерываний
        push    ds       ; сохранение регистров
        push    es
	    push    ax
	    push    bx
        push    cx
        push    dx
	    push    di
        push    cs
        pop     ds

        mov     ah,  2  ; функция BIOS для получения текущего времени
        int     1Ah     ; прерывание BIOS

        xor     bx,  bx         ; настройка BX для индексации шаблона
        mov     al,  ch         ; часы
        call    get_time_trans  ; переводим число и записываем в шаблон
        mov     al,  cl         ; минуты
        call    get_time_trans
        mov     al,  dh         ; секунды
        call    get_time_trans

        mov     ah,  4  ; функция BIOS для получения текущей даты
        int     1Ah

        ; аналогично для даты
        xor     bx,  bx
        mov     al,  dh         ; месяц
        call    get_date_trans
        mov     al,  dl         ; день
        call    get_date_trans
  
        mov     ax,  0B800h     ; настройка AX на сегмент видеопамяти
        mov     es,  ax         ; запись в ES значения сегмента видеопамяти
        xor     di,  di         ; настройка DI на начало сегмента видеопамяти 
                                ; (di = 0 - левый верхний угол)
        xor     bx,  bx         ; настройка BX для индексации шаблона
        mov     ah,  10         ; зелёный цвет символов


date_output:
        mov     al,  date[bx]   ; цикл для записи символов шаблона в видеопамять
        stosw                   ; запись очередного символа и атрибута
        inc     bx
        cmp     buf[bx],  0     ; запись пока не конец шаблона
        jnz     date_output
        
        ; разделим дату от времени пробелом
        mov     al, ' '
        stosw
        xor     bx,  bx

; аналогично для времени
time_output:   
        mov     al,  buf[bx]
        stosw
        inc     bx
        cmp     buf[bx],  0
        jnz     time_output

 ; восстановление  регистров      
ending:    
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     es
        pop     ds
        iret    ; возврат из обработчика
clock   endp
end_clock:   ; метка для определения размера резидентной части прогр.

load:   
        mov     ax,  351Ch ; получение адреса старого обработчика 3509h 351ch
        int     21h        ; прерываний от таймера

        cmp es:done, 1234
        je quit

        mov     word ptr old,  bx ; сохранение смещения обработчика
        mov     word ptr old + 2,  es ; сохранение сегмента обработчика
        mov     ax,  251Ch            ; установка адреса нашего обработчика
        mov     dx,  offset clock     ; указание смещения нашего обработчика
        int     21h
        
        mov     dx, (end_clock - start + 10Fh) / 16  ;определение размера резидентной
                                                        ; части программы в параграфах
        mov     ax,  3100h      ; функция DOS завершения резидентной программы         
        int     21h
quit:
        push    es
        push    ds

        mov     dx, word ptr es:old
        mov     ds, word ptr es:old + 2
        mov     ax,  251Ch
        int     21h

        pop     ds
        pop     es

        mov     ah, 49h
        int     21h               
        mov     ax, 4C00h
        int     21h
code    ends
        end     start

;mov     ax, 27h  ; Прерывание для завершения программы и сохранения её резидентной в памяти.