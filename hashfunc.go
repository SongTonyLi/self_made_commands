package main

import (
	"crypto/sha256"
	"fmt"
	"os"
	"strconv"
)

func hash(data []byte) []byte {
	hashVal := sha256.Sum256(data)
	result := hashVal[:]
	return result
}

func main() {
	argsLen := len(os.Args)
	if argsLen != 3 {
		fmt.Println("Error!! Correct Usage: hashfunc string len")
		return
	} else {
		hashBytes := hash([]byte(os.Args[1]))
		i, err := strconv.Atoi(os.Args[2])
		if i == 0 || err != nil {
			fmt.Println("Error!! Correct Usage: hashfunc string len")
			return
		}
		hashStr := fmt.Sprintf("%x", hashBytes)
		fmt.Println(hashStr[:i])
		return
	}
}
