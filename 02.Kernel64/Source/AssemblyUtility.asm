[BITS 64]	; 이하의 코드는 64비트 코드로 설정

SECTION .text	; text 섹션(세그먼트)을 정의

; C 언어에서 호출할 수 있도록 이름을 노출함(Export)
global kInPortByte, kOutPortByte, kLoadGDTR, kLoadTR, kLoadIDTR
global kEnableInterrupt, kDisableInterrupt, kReadRFLAGS

; 포트로부터 1Byte를 읽음
; PARAM: 포트 번호
kInPortByte:
	push rdx	; 함수에서 임시로 사용하는 레지스터를 스택에 저장
				; 함수의 마지막 부분에서 스택에 삽입된 값을 꺼내 복원

	mov rdx, rdi	; RDX 레지스터에 파라미터 1(포트 번호)를 저장
	mov rax, 0		; RAX 레지스터를 초기화
	in al, dx		; DX 레지스터에 저장된 포트 주소에서 한 Byte를 읽어
					; AL 레지스터에 저장, AL 레지스터는 함수의 반환 값으로 사용됨

	pop rdx			; 함수에서 사용이 끝난 레지스터를 복원
	ret				; 함수를 호출한 다음 코드의 위치로 복귀

; 포트에 1Byte를 씀
; PARAM: 포트 번호, 데이터
kOutPortByte:
	push rdx	; 함수에서 임시로 사용하는 레지스터를 스택에 저장
	push rax	; 함수의 마지막 부분에서 스택에 삽입된 값을 꺼내 복원

	mov rdx, rdi	; RDX 레지스터에 파라미터 1(포트 번호)를 저장
	mov rax, rsi	; RAX 레지스터에 파라미터 2(데이터)를 저장
	out dx, al		; DX 레지스터에 저장된 포트 주소에 AL 레지스터에 저장된 한 Byte를 씀

	pop rax			; 함수에서 사용이 끝난 레지스터를 복원
	pop rdx
	ret 			; 함수를 호출한 다음 코드의 위치로 복귀

; GDTR 레지스터에 GDT 테이블을 설정
; PARAM : GDT 테이블의 정보를 저장하는 자료구조의 주소
kLoadGDTR:
	lgdt [rdi]	; 파라미터 1(GDTR의 주소)를 프로세서에 로드하여 GDT 테이블을 설정
	ret

; TR 레지스터에 TSS 세그먼트 디스크립터 설정
; PARAM : TSS 세그먼트 디스크립터의 오프셋
kLoadTR:
	ltr di	; 파라미터 1(TSS 세그먼트 디스크립터의 오프셋)을 프로세서에 설정하여 TSS 세그먼트를 로드
	ret

; IDTR 레지스터에 IDT 테이블을 설정
; PARAM : IDT 테이블의 정보를 저장하는 자료구조의 주소
kLoadIDTR:
	lidt [rdi]	; 파라미터 1(IDTR의 주소)을 프로세서에 로드하여 IDT 테이블을 설정
	ret

; 인터럽트를 활성화
; PARAM : 없음
kEnableInterrupt:
	sti	; 인터럽트를 활성화
	ret

; 인터럽트를 비활성화
; PARAM : 없음
kDisableInterrupt:
	cli	; 인터럽트를 비활성화
	ret

; RFLAGS 레지스터를 읽어서 되돌려줌
; PARAM : 없음
kReadRFLAGS:
	pushfq	; RFLAGS 레지스터를 스택에 저장
	pop rax	; 스택에 저장된 RFLAGS 레지스터를 RAX 레지스터에 저장하여
			; 함수의 반환 값으로 설정
	ret
