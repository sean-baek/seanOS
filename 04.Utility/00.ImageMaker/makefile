# 기본적으로 빌드 를 수행할 목록
all: ImageMaker

# ImageMaker 빌드
ImageMaker: ImageMaker.c
	gcc -o $@ $<
	mv $@ ../../
	
# 소스 파일을 제외한 나머지 파일 정리
clean:
	rm -f ../../ImageMaker

	
