build:
	swift build

update: 
	swift package update

release:
	swift build -c release

install:
	cp -f .build/release/nmaps-uploader ~/bin

test:
	swift test --parallel

clean:
	rm -rf .build

.PHONY: clean build test
