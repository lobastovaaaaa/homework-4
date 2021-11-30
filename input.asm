; file.asm - использование файлов в NASM
extern printf
extern fscanf

extern SPHERE
extern TETRAH
extern PARALL

;----------------------------------------------
; // Ввод параметров сферы из файла
; void InSphere(void *s, FILE *ifst) {
;     fscanf(ifst, "%d%d", (int*)s;
; }
global InSphere
InSphere:
section .data
    .infmt db "%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .prect  resq    1   ; адрес сферы
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.prect], rdi          ; сохраняется адрес сферы
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод сферы из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; 
    mov     rdx, [.prect]       ; 
    call    fscanf

leave
ret

; // Ввод параметров тетраэдра из файла
; void InTetrah(void *t, FILE *ifst) {
;     fscanf(ifst, "%d%d", (int*)t;
; }
global InTetrah
InTetrah:
section .data
    .infmt db "%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .prect  resq    1   ; адрес сферы
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.prect], rdi          ; сохраняется адрес сферы
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод тетраэдра из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; 
    mov     rdx, [.prect]       ; 
    call    fscanf

leave
ret

; // Ввод параметров параллелепипеда из файла
; void InParall(void *p, FILE *ifst) {
;     fscanf(ifst, "%d%d%d", (int*)p,
;            (int*)(p+intSize), (int*)(p+2*intSize));
; }
global InParall
InParall:
section .data
    .infmt db "%d%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .trian  resq    1   ; адрес параллелепипеда
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.trian], rdi          ; сохраняется адрес параллелепипеда
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод параллелепипеда из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.trian]       ; &l
    mov     rcx, [.trian]
    add     rcx, 4              ; &w = &l + 4
    mov     r8, [.trian]
    add     r8, 8               ; &h = &l + 8
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

; // Ввод параметров обобщенной фигуры из файла
; int InShape(void *s, FILE *ifst) {
;     int k;
;     fscanf(ifst, "%d", &k);
;     switch(k) {
;         case 1:
;             *((int*)s) = SPHERE;
;             InSphere(s+intSize, ifst);
;             return 1;
;         case 2:
;             *((int*)s) = TETRAH;
;             InTetrah(s+intSize, ifst);
;             return 1;
;         case 1:
;             *((int*)s) = PARALL;
;             InParall(s+intSize, ifst);
;             return 1;
;         default:
;             return 0;
;     }
; }
global InShape
InShape:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pshape     resq    1   ; адрес фигуры
    .shapeTag   resd    1   ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pshape], rdi          ; сохраняется адрес фигуры
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pshape]      ; адрес начала фигуры (ее признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf

    ; Тестовый вывод признака фигуры
;     mov     rdi, .tagOutFmt
;     mov     rax, [.pshape]
;     mov     esi, [rax]
;     call    printf

    mov rcx, [.pshape]          ; загрузка адреса начала фигуры
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [SPHERE]
    je .sphereIn
    cmp eax, [TETRAH]
    je .tetrahIn
    cmp eax, [PARALL]
    je .parallIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.sphereIn:
    ; Ввод сферы
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InSphere
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.tetrahIn:
    ; Ввод тетраэдра
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InTetrah
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.parallIn:
    ; Ввод параллелепипеда
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InParall
    mov     rax, 1  ; Код возврата - true
.return:

leave
ret

; // Ввод содержимого контейнера из указанного файла
; void InContainer(void *c, int *len, FILE *ifst) {
;     void *tmp = c;
;     while(!feof(ifst)) {
;         if(InShape(tmp, ifst)) {
;             tmp = tmp + shapeSize;
;             (*len)++;
;         }
;     }
; }
global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фигур = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InShape     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rbx
    inc rbx

    pop rdi
    add rdi, 16             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret

