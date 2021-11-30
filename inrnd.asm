; file.asm - использование файлов в NASM
extern printf
extern rand

extern SPHERE
extern TETRAH
extern PARALL


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 20
; int Random() {
;     return rand() % 20 + 1;
; }
global Random
Random:
section .data
    .i20     dq      20
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf

leave
ret

;----------------------------------------------
;// Случайный ввод параметров параллелепипеда
;void InRndRectangle(void *ip) {
    ;int l = Random();
    ;*((int*)ip) = l;
    ;int w = Random();
    ;*((int*)(ip+intSize)) = h;
    ;int h = Random();
    ;*((int*)ip+intSize+intSize) = x;
;//     printf("    Parall %d %d\n", *((int*)ip), *((int*)ip+1)), *((int*)ip+2);
;}
global InRndParall
InRndParall:
section .bss
    .pparall  resq 1   ; адрес параллелепипеда
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес параллелепипеда
    mov     [.pparall], rdi
    ; Генерация сторон параллелепипеда
    call    Random
    mov     rbx, [.pparall]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.pparallt]
    mov     [rbx+4], eax

leave
ret

;----------------------------------------------
;// Случайный ввод параметров тетраэдра
;void InRndTetrah(void *it) {
    ;int t;
    ;t = *((int*)it) = Random();
;//     printf("    Tetrah %d %d %d\n", *((int*)t);
;}
global InRndTetrah
InRndTetrah:
section .bss
    .ptetrah  resq 1   ; адрес тетраэдра
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес тетраэдра
    mov     [.ptetrah], rdi
    ; Генерация стороны тетраэдра
    call    Random
    mov     rbx, [.ptetrah]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.ptetrah]
    mov     [rbx+4], eax
.repeat:
    call    Random
    mov     rbx, [.ptetrah]
    mov     [rbx+8], eax    ; 

leave
ret

;----------------------------------------------
;// Случайный ввод параметров сферы
;void InRndSphere(void *is) {
    ;int s;
    ;s = *((int*)is) = Random();
;//     printf("    Sphere %d %d %d\n", *((int*)s);
;}
global InRndSphere
InRndSphere:
section .bss
    .psphere  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес сферы
    mov     [.psphere], rdi
    ; Генерация сторон сферы
    call    Random
    mov     rbx, [.psphere]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.psphere]
    mov     [rbx+4], eax
.repeat:
    call    Random
    mov     rbx, [.psphere]
    mov     [rbx+8], eax    ; 

leave
ret

;----------------------------------------------
;// Случайный ввод обобщенной фигуры
;int InRndShape(void *s) {
    ;int k = rand() % 3 + 1;
    ;switch(k) {
        ;case 1:
            ;*((int*)s) = SPHERE;
            ;InRndSphere(s+intSize);
            ;return 1;
        ;case 2:
            ;*((int*)s) = TETRAH;
            ;InRndTetrah(s+intSize);
            ;return 1;
        ;case 3:
            ;*((int*)s) = PARALL;
            ;InRndParall(s+intSize);
            ;return 1;
        ;default:
            ;return 0;
    ;}
;}
global InRndShape
InRndShape:
section .data
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pshape     resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov [.pshape], rdi

    ; Формирование признака фигуры
    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    and     eax, 1      ; очистка результата кроме младшего разряда (0 или 1)
    inc     eax         ; фомирование признака фигуры (1 или 2)

    ;mov     [.key], eax
    ;mov     rdi, .rndNumFmt
    ;mov     esi, [.key]
    ;xor     rax, rax
    ;call    printf
    ;mov     eax, [.key]

    mov     rdi, [.pshape]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [SPHERE]
    je .sphereInrnd
    cmp eax, [TETRAH]
    je .tetrahInRnd
    cmp eax, [PARALL]
    je .parallInRnd
    xor eax, eax        ; код возврата = 0
    jmp     .return
.sphereInrnd:
    ; Генерация сферы
    add     rdi, 4
    call    InRndRectangle
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.sphereInrnd:
    ; Генерация тетраэдра
    add     rdi, 4
    call    InRndTetrah
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.trianInRnd:
    ; Генерация параллелепипеда
    add     rdi, 4
    call    InRndParall
    mov     eax, 1      ;код возврата = 1
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InRndContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InRndShape(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InRndShape     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
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
