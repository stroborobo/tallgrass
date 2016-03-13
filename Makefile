NAME=                   tallgrass
GO_OUT=                 ${NAME}

GO_FILES=               $(shell find . -name '*.go')
EMBED=                  embed.go
SPRITE_DIR=             sprites
#SPRITE_FILES=           $(shell find ${SPRITE_DIR} -name '*.png')

# deps
FRAMECUT=               $(shell which framecut)
ifeq "${FRAMECUT}" ""
FRAMECUT=               get-framecut
endif

RESOURCES=              $(shell which resources)
ifeq "${RESOURCES}" ""
RESOURCES=              get-resources
endif


.PHONY: all cross clean get-framecut get-resources

all: ${GO_OUT}

cross:
	GOOS=linux GOARCH=amd64 go build -o ${GO_OUT}-linux-amd64
	GOOS=linux GOARCH=arm go build -o ${GO_OUT}-linux-arm
	GOOS=freebsd GOARCH=amd64 go build -o ${GO_OUT}-freebsd-amd64
	GOOS=darwin GOARCH=amd64 go build -o ${GO_OUT}-darwin-amd64

${GO_OUT}: ${GO_FILES} ${EMBED}
	go build -o ${GO_OUT} -i

${EMBED}: ${SPRITE_DIR} ${RESOURCES}
	resources -output ${EMBED} -package main -var files -declare -trim ${SPRITE_DIR}/ $(shell find ${SPRITE_DIR} -name '*.png')

${SPRITE_DIR}: ${FRAMECUT}
	./get-sprites.sh

get-framecut:
	go get -u github.com/stroborobo/framecut

get-resources:
	go get -u github.com/omeid/go-resources/cmd/resources

clean:
	rm -rf ${GO_OUT} ${EMBED}
	rm -rf ${GO_OUT}-linux-amd64
	rm -rf ${GO_OUT}-linux-arm
	rm -rf ${GO_OUT}-freebsd-amd64
	rm -rf ${GO_OUT}-darwin-amd64
