;---------------------------------------------------------------------------------------
; surfacearea.asm - единица компиляции, вбирающая функции вычисления площади поверхности
;---------------------------------------------------------------------------------------

extern SPHERE
extern TETRAH
extern PARALL

;----------------------------------------------
; Вычисление площади поверхности сферы
;double SurfaceAreaSphere(void *s) {
;    return 3.14 * (*((int*)s)) * (*((int*)s));
;}
global SurfaceAreaSphere
SurfaceAreaSphere:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес сферы
    mov eax, [rdi]
    shl eax, 1
    cvtsi2sd    xmm0, eax

leave
ret

;----------------------------------------------
; Вычисление площади поверхности тетраэдра
;double SurfaceAreaTetrah(void *t) {
;    return 1.73 * (*((int*)t)) * (*((int*)t));
;}
global SurfaceAreaTetrah
SurfaceAreaTetrah:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес тетраэдра
    mov eax, [rdi]
    shl eax, 1
    cvtsi2sd    xmm0, eax

leave
ret

;----------------------------------------------
; Вычисление площади поверхности параллелепипеда
; double SurfaceAreaParall(void *p) {
;    return (double)(*((int*)p)
;       + *((int*)(p+intSize))
;       + *((int*)(p+2*intSize)));
;}
global SurfaceAreaParall
SurfaceAreaParall:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес параллелепипеда
    mov eax, [rdi]
    add eax, [rdi+4]
    add eax, [rdi+8]
    cvtsi2sd    xmm0, eax

leave
ret

;----------------------------------------------
; Вычисление площади поверхности фигуры
;double SurfaceAreaShape(void *s) {
;    int k = *((int*)s);
;    if(k == SPHERE) {
;        return SurfaceAreaSphere(s+intSize);
;    }
;    else if(k == TETRAH) {
;        return SurfaceAreaSphere(s+intSize);
;    }
;    else if(k == PARALL) {
;       return SurfaceAreaParall(s+intSize);
;    }
;    else {
;        return 0.0;
;    }
;}
global SurfaceAreaShape
SurfaceAreaShape:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [SPHERE]
    je sphereSurfaceArea
    cmp eax, [TETRAH]
    je tetrahSurfaceArea
    cmp eax, [PARALL]
    je parallSurfaceArea
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return
sphereSurfaceArea:
    ; Вычисление площади поверхности сферы
    add     rdi, 4
    call    SurfaceAreaSphere
    jmp     return
tetrahSurfaceArea:
    ; Вычисление площади поверхности тетраэдра
    add     rdi, 4
    call    SurfaceAreaTetrah
    jmp     return
parallSurfaceArea:
    ; Вычисление площади поверхности параллелепипеда
    add     rdi, 4
    call    SurfaceAreaParall
return:
leave
ret

;----------------------------------------------
;// Вычисление суммы площадей поверхности всех фигур в контейнере
;double SurfaceAreaSumContainer(void *c, int len) {
;    double sum = 0.0;
;    void *tmp = c;
;    for(int i = 0; i < len; i++) {
;        sum += SurfaceAreaShape(tmp);
;        tmp = tmp + shapeSize;
;    }
;    return sum;
;}
global SurfaceAreaSumContainer
SurfaceAreaSumContainer:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov ebx, esi            ; число фигур
    xor ecx, ecx            ; счетчик фигур
    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    call SurfaceAreaShape     ; Получение площади поверхности первой фигуры
    addsd xmm1, xmm0        ; накопление суммы
    inc rcx                 ; индекс следующей фигуры
    add r10, 16             ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    movsd xmm0, xmm1
leave
ret
