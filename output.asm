; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern SurfaceAreaSphere
extern SurfaceAreaTetrah
extern SurfaceAreaParall

extern SPHERE
extern TETRAH
extern PARALL

;----------------------------------------------
;// Вывод параметров сферы в файл
;void OutSphere(void *s, FILE *ofst) {
;    fprintf(ofst, "It is Sphere: radius = %d. SurfaceArea = %g\n",
;            *((int*)s), SurfaceAreaSphere(s));
;}
global OutSphere
OutSphere:
section .data
    .outfmt db "It is Sphere: radius = %d. SurfaceArea = %g",10,0
section .bss
    .prect  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная площадь поверхности сферы
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.psphere], rdi          ; сохраняется адрес сферы
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление площади поверхности сферы (адрес уже в rdi)
    call    SurfaceAreaSphere
    movsd   [.p], xmm0          ; сохранение (может лишнее) площади поверхности

    ; Вывод информации о сфере в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.psphere]     ; адрес сферы
;     mov     esi, [rax]          ; 
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о сфере в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.psphere]     ; адрес сферы
    mov     edx, [rax]          ; 
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
;// Вывод параметров тетраэдра в файл
;void OutTetrah(void *t, FILE *ofst) {
;    fprintf(ofst, "It is Tetrah: edge = %d. SurfaceArea = %g\n",
;            *((int*)t), SurfaceAreaSphere(t));
;}
global OutTetrah
OutTetrah:
section .data
    .outfmt db "It is Tetrah: edge = %d. SurfaceArea = %g",10,0
section .bss
    .prect  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная площадь поверхности тетраэдра
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.ptetrah], rdi          ; сохраняется адрес тетраэдра
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление площади поверхности сферы (адрес уже в rdi)
    call    SurfaceAreaTetrah
    movsd   [.p], xmm0          ; сохранение (может лишнее) площади поверхности тетраэдра

    ; Вывод информации о сфере в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.ptetrah]     ; адрес тетраэдра
;     mov     esi, [rax]          ; 
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о сфере в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.ptetrah]     ; адрес тетраэдра
    mov     edx, [rax]          ; 
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров параллелепипеда в файл
; void OutParall(void *p, FILE *ofst) {
;     fprintf(ofst, "It is Parall: length = %d, width = %d, height = %d. SurfaceArea = %g\n",
;            *((int*)p), *((int*)(p+intSize)), *((int*)(p+2*intSize)),
;             SurfaceAreaParall(t));
; }
global OutParall
OutParall:
section .data
    .outfmt db "It is Parall: length = %d, width = %d, height = %d. SurfaceArea = %g",10,0
section .bss
    .ptrian  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленный площади поверхности параллелепипеда
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.pparall], rdi        ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление площади поверхности параллелепипеда (адрес уже в rdi)
    call    SurfaceAreaParall
    movsd   [.p], xmm0          ; сохранение (может лишнее) площади поверхности параллелепипеда

    ; Вывод информации о параллелепипеде в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.pparall]     ; адрес параллелепипеда
;     mov     esi, [rax]          ; 
;     mov     edx, [rax+4]        ; 
;     mov     ecx, [rax+8]        ; 
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о треугольнике в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pparall]     ; адрес параллелепипеда
    mov     edx, [rax]          ; 
    mov     ecx, [rax+4]        ; 
    mov      r8, [rax+8]        ; 
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров текущей фигуры в файл
; void OutShape(void *s, FILE *ofst) {
;     int k = *((int*)s);
;     if(k == SPHERE) {
;         OutSphere(s+intSize, ofst);
;     }
;     else if(k == TETRAH) {
;         OutTetrah(s+intSize, ofst);
;     }
;     else if(k == PARALL) {
;         OutParall(s+intSize, ofst);
;     }
;     else {
;         fprintf(ofst, "Incorrect figure!\n");
;     }
; }
global OutShape
OutShape:
section .data
    .erShape db "Incorrect figure!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [SPHERE]
    je sphereOut
    cmp eax, [TETRAH]
    je tetrahOut
    cmp eax, [PARALL]
    je parallOut
    mov rdi, .erShape
    mov rax, 0
    call fprintf
    jmp     return
sphereOut:
    ; Вывод сферы
    add     rdi, 4
    call    OutSphere
    jmp     return
tetrahOut:
    ; Вывод тетраэдра
    add     rdi, 4
    call    OutTetrah
    jmp     return
parallOut:
    ; Вывод параллелепипеда
    add     rdi, 4
    call    OutParall
return:
leave
ret

;----------------------------------------------
; // Вывод содержимого контейнера в файл
; void OutContainer(void *c, int len, FILE *ofst) {
;     void *tmp = c;
;     fprintf(ofst, "Container contains %d elements.\n", len);
;     for(int i = 0; i < len; i++) {
;         fprintf(ofst, "%d: ", i);
;         OutShape(tmp, ofst);
;         tmp = tmp + shapeSize;
;     }
; }
global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor ecx, ecx            ; счетчик фигур = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод номера фигуры
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фигуры
    mov     edx, ecx        ; индекс текущей фигуры
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutShape     ; Получение площади поверхности первой фигуры

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующей фигуры

    mov     rax, [.pcont]
    add     rax, 16         ; адрес следующей фигуры
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret

