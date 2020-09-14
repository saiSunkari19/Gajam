PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=Dharani \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=Dharanid \
	-X github.com/cosmos/cosmos-sdk/version.ClientName=Dharanicli \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) 

BUILD_FLAGS := -ldflags '$(ldflags)'

all: install

install: go.sum
		go install  $(BUILD_FLAGS) ./cmd/Dharanid
		go install  $(BUILD_FLAGS) ./cmd/Dharanicli

go.sum: go.mod
		@echo "--> Ensure dependencies have not been modified"
		GO111MODULE=on go mod verify

init-pre:
	rm -rf ~/.Dharanicli
	rm -rf ~/.Dharanid
	Dharanid init mynode --chain-id Dharani
	Dharanicli config keyring-backend test

init-user1:
	Dharanicli keys add user1 --output json 2>&1

init-user2:
	Dharanicli keys add user2 --output json 2>&1
