.PHONY : swiftshield

swiftshield:
	cd ../ && make build && make package
	../.build/release/_PRODUCT/bin/swiftshield obfuscate -p ./Maodou.xcworkspace -s Maodou --ignore-public -i YDFutureManager.h
	open ./Maodou/Maodou.xcworkspace
	open ./Maodou/swiftshield-output
