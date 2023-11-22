!classDefinition: #PersistentSet category: 'CustomerImporter'!
Set subclass: #PersistentSet
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSet methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:31'!
initializeOn: aSession from: aNonPersistentSet

	session := aSession.
	self addAll: aNonPersistentSet ! !


!PersistentSet methodsFor: 'adding' stamp: 'HAW 11/14/2023 08:23:40'!
add: newObject

	super add: newObject.
	session persist: newObject.
	
	^newObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSet class' category: 'CustomerImporter'!
PersistentSet class
	instanceVariableNames: ''!

!PersistentSet class methodsFor: 'instance creation' stamp: 'FA 11/21/2023 20:14:28'!
on: aSession

	^self on: aSession from: #().
! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'FA 11/21/2023 20:14:32'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet.

! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'sessionBuilder inputStreamBuilder openStream currentSession'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/15/2023 23:50:59'!
defaultInputStreamBuilder

	^[ UniFileStream new open: 'input.txt' forWrite: false ].
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/15/2023 23:45:58'!
defaultSessionBuilder

	^[ DataBaseSession for: (Array with: Address with: Customer) ].
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/15/2023 20:34:17'!
runTest: testBlock

	self setUp.
	testBlock value.
	self tearDown.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/15/2023 23:50:51'!
setUp
	
	openStream := inputStreamBuilder value.
	currentSession := sessionBuilder value.
	
	(CustomerImporter 
		forSession: currentSession 
		andInputStream: openStream) import.
	
	currentSession beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/15/2023 23:50:47'!
tearDown

	openStream close.
	currentSession close.
	
	inputStreamBuilder := self defaultInputStreamBuilder.
	sessionBuilder := self defaultSessionBuilder.
! !


!ImportTest methodsFor: 'initialization' stamp: 'FA 11/15/2023 23:46:39'!
initialize

	sessionBuilder := self defaultSessionBuilder.
	inputStreamBuilder := self defaultInputStreamBuilder.
! !


!ImportTest methodsFor: 'helpers' stamp: 'FA 11/16/2023 00:05:31'!
cr
	
	^String with: Character cr.! !

!ImportTest methodsFor: 'helpers' stamp: 'FA 11/21/2023 19:26:10'!
expectImportError: anErrorMessage

	self should: [ self runTest: []. ]
		raise: Error 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: anErrorMessage ].

! !

!ImportTest methodsFor: 'helpers' stamp: 'FA 11/16/2023 00:08:22'!
getAddressWithName: aStreetName andNumber: aStreetNumber

	| selected |
	
	selected := currentSession 
		select: [ :anAddress | 
			(anAddress streetName = aStreetName) and:
			(anAddress streetNumber  = aStreetNumber). ]
 		ofType: Address.

	self assert: selected size equals: 1.
	
	^ selected asArray at: 1.
! !

!ImportTest methodsFor: 'helpers' stamp: 'FA 11/15/2023 23:48:04'!
getCustomerWithId: anIdNumber

	| selected |
	
	selected := currentSession 
		select: [ :aCustomer | 
			aCustomer identificationNumber = anIdNumber. ]
 		ofType: Customer.

	self assert: selected size equals: 1.

	^ selected asArray at: 1. 
! !


!ImportTest methodsFor: 'test' stamp: 'FA 11/15/2023 23:47:54'!
test01allEntriesAreLoaded

	self runTest: [ 
		self assert: (currentSession selectAllOfType: Customer) size equals: 2 ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/15/2023 21:16:45'!
test02customerDataFieldsAreCorrectlyLoaded

	self runTest: [ | customer |
		customer := self getCustomerWithId: '22333444'.
		self 
		 	assert: customer firstName equals: 	'Pepe' ;
			assert: customer lastName equals: 'Sanchez' ;
			assert: customer identificationType equals: 'D' ;
			assert: customer identificationNumber equals: '22333444'. ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/15/2023 23:51:24'!
test03addressDataIsLoaded

	self runTest: [
		self assert: (self getCustomerWithId: '22333444') addresses size equals: 2. 
		self assert: (self getCustomerWithId: '23-25666777-9') addresses size equals: 1. ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/15/2023 23:51:28'!
test04addressesReferencesAreHeldByTheCorrectCustomer

	self runTest: [ | address1 address2 customer1 customer2 |
		customer1 := self getCustomerWithId: '22333444'.
		customer2 := self getCustomerWithId: '23-25666777-9'.
		address1 := self getAddressWithName: 'San Martin' andNumber: 3322.
		address2 := self getAddressWithName: 'Maipu' andNumber: 888.
		self 
			assert: customer1 addresses includes: address1 ;
			assert: customer1 addresses includes: address2 ;
			assert: (customer2 addresses includes: address1) not ; 
			assert: (customer2 addresses includes: address2) not. ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/16/2023 00:07:29'!
test05addressDataFieldsAreCorrectlyLoaded

	self runTest: [ | address |
		address := self getAddressWithName: 'San Martin' andNumber: 3322.
		self 
		 	assert: address town equals: 'Olivos' ;
		 	assert: address zipCode equals: 1636 ;
		 	assert: address province equals: 'BsAs'. ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 19:21:39'!
test06canImportFromStringStream

	inputStreamBuilder := [ 
		('C,Jack,Black,D,12345678', self cr,
		 'A,Almirante Brown,911,Merlo,1710,Buenos Aires') readStream. ].

	self runTest: [ 
		self getCustomerWithId: '12345678'.
		self getAddressWithName: 'Almirante Brown' andNumber: 911. ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 19:21:32'!
test07shouldStripWhitespace

	inputStreamBuilder := [ 
		('  C,  Jack,Black   ,  D  ,         12345678        ', self cr,
		 'A , Almirante  Brown  ,911,   Merlo,1710, Buenos Aires  ') readStream. ].

	self runTest: [ | customer address | 
		customer := self getCustomerWithId: '12345678'.
		address := self getAddressWithName: 'Almirante  Brown' andNumber: 911.  
		self 
			assert: customer firstName equals: 'Jack' ;
			assert: customer lastName equals: 'Black' ;
			assert: customer identificationType equals: 'D' ;
			assert: customer identificationNumber equals: '12345678' ;
			assert: address town equals: 'Merlo' ;
			assert: address zipCode equals: 1710 ;
			assert: address province equals: 'Buenos Aires'. ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 19:21:26'!
test08shouldSkipBlankLines

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,12345678', self cr, 
		 self cr,
		 'A,Almirante Brown,911,Merlo,1710,Buenos Aires', self cr,
		'') readStream. ].

	self runTest: [  
		self getCustomerWithId: '12345678'.
		self getAddressWithName: 'Almirante Brown' andNumber: 911. ].
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 21:21:30'!
test09shouldThrowOnUnknownEntryType

	inputStreamBuilder := [ 
		('F,Pedro,Ordep,D,12345678') readStream. ].
	
	self expectImportError: (
		CustomerImporter unknownEntryTypeError: 'F' atLine: 1 ).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 21:04:59'!
test10shouldThrowOnNonNumericAddressFields

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,12345678', self cr,
		'A,Virrey del Pino,aaa,belgrano,1234,CABA') readStream. ].
	
	self expectImportError: (
		CustomerImporter nonIntegerFieldValueError: 'aaa' atLine: 2).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 21:05:16'!
test11shouldThrowOnWrongAmountOfFieldsForEntry

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D') readStream. ].
	
	self expectImportError: (
		CustomerImporter missingFieldsError: 1).
		
	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,123456789', self cr,
		 'A,Migueletes,123') readStream. ].
	
	self expectImportError: (
		CustomerImporter missingFieldsError: 2).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 21:05:28'!
test12shouldThrowIfFieldsAreEmpty

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,,123456789') readStream. ].
	
	self expectImportError: (
		CustomerImporter missingFieldsError: 1).
		
	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,123456789', self cr,
		 'A,Migueletes,123,,1234,Buenos Aires') readStream. ].
	
	self expectImportError: (
		CustomerImporter missingFieldsError: 2).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 21:05:36'!
test13shouldThrowIfThereAreExtraFields

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,123456789,Casado') readStream. ].
	
	self expectImportError: (
		CustomerImporter unknownFieldsError: 1).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 21:05:47'!
test14shouldThrowIfAddressHasNoCorrespondingCustomer

	inputStreamBuilder := [ 
		 ('A,Almirante Brown,911,Merlo,1710,BsAs') readStream. ].

	self expectImportError: (
		CustomerImporter 
			noCustomerForAddressError: 1).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/21/2023 20:25:27'!
test15canImportIfTypesAreLowercase

	inputStreamBuilder := [ 
		('c,Jack,Black,D,12345678', self cr,
		 'a,Almirante Brown,911,Merlo,1710,Buenos Aires') readStream. ].

	self runTest: [ 
		self getCustomerWithId: '12345678'.
		self getAddressWithName: 'Almirante Brown' andNumber: 911. ].
! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !


!Address methodsFor: 'town' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !


!Address methodsFor: 'initialization' stamp: 'FA 11/21/2023 18:00:16'!
initializeWithStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode andProvince: aProvince

	streetName := aStreetName.
	streetNumber := aStreetNumber.
	town := aTown.
	zipCode := aZipCode.
	province := aProvince.
! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Address class' category: 'CustomerImporter'!
Address class
	instanceVariableNames: ''!

!Address class methodsFor: 'instance creation' stamp: 'FA 11/21/2023 18:15:58'!
withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode andProvince: aProvince

	^self new 
		initializeWithStreetName: aStreetName 
		streetNumber: aStreetNumber
		town: aTown 
		zipCode: aZipCode 
		andProvince: aProvince. 
! !


!classDefinition: #CSVstreamIterator category: 'CustomerImporter'!
Object subclass: #CSVstreamIterator
	instanceVariableNames: 'session inputStream currentLine currentCustomer currentLineSplit delimiter iterationBlock currentLineNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVstreamIterator methodsFor: 'initialization' stamp: 'FA 11/21/2023 20:37:30'!
initializeForInputStream: anInputStream delimitedBy: aDelimiter

	inputStream := anInputStream.
	delimiter := aDelimiter.
! !


!CSVstreamIterator methodsFor: 'iteration' stamp: 'FA 11/21/2023 20:38:29'!
iterate: aBlock
	
	iterationBlock := aBlock.
	self readStream.
! !

!CSVstreamIterator methodsFor: 'iteration' stamp: 'FA 11/21/2023 21:10:07'!
readStream

	currentLine := inputStream nextLine.
	currentLineNumber := 1.
	
	[ currentLine notNil ] whileTrue: [  
		
		self splitCurrentLine.
		currentLineSplit isEmpty ifFalse: [ 
			iterationBlock value: currentLineNumber value: currentLineSplit. ]. 
		
		currentLineNumber := currentLineNumber + 1.
		currentLine := inputStream nextLine. ].
! !


!CSVstreamIterator methodsFor: 'parsing' stamp: 'FA 11/21/2023 20:36:43'!
splitCurrentLine

	currentLineSplit := (currentLine findTokens: delimiter) collect: [ :field | self strip: field ].
! !

!CSVstreamIterator methodsFor: 'parsing' stamp: 'FA 11/21/2023 20:36:43'!
strip: aLineField

	| start end |
	
	1 to: aLineField size do: [ :index |
		(aLineField at: index) isSeparator ifFalse: [
			start isNil ifTrue: [ start := index ].
			end := index. ]. ].
	
	^aLineField copyFrom: start to: end.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CSVstreamIterator class' category: 'CustomerImporter'!
CSVstreamIterator class
	instanceVariableNames: ''!

!CSVstreamIterator class methodsFor: 'instance creation' stamp: 'FA 11/21/2023 20:41:27'!
forInputStream: anInputStream delimitedBy: aDelimiter
	^self new 
		initializeForInputStream: anInputStream 
		delimitedBy: aDelimiter.
! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !


!Customer methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:42'!
initialize

	super initialize.
	addresses := Set new.! !

!Customer methodsFor: 'initialization' stamp: 'FA 11/21/2023 18:11:03'!
initializeWithFirstName: aFirstName andLastName: aLastName andIdType: anIdType andIdNumber: anIdNumber	

	firstName := aFirstName.
	lastName  := aLastName.
	identificationType := anIdType.
	identificationNumber := anIdNumber.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'instance creation' stamp: 'FA 11/21/2023 18:13:01'!
withFirstName: aFirstName andLastName: aLastName andIdType: anIdType andIdNumber: anIdNumber	

	^self new 
		initializeWithFirstName: aFirstName 
		andLastName: aLastName 
		andIdType: anIdType 
		andIdNumber: anIdNumber.
! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session currentLine currentCustomer csvIterator currentEntry'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'FA 11/21/2023 21:11:32'!
initializeForSession: aSession andInputStream: anInputStream

	session := aSession.
	csvIterator := CSVstreamIterator 
		forInputStream: anInputStream 
		delimitedBy: $,.
! !


!CustomerImporter methodsFor: 'import' stamp: 'FA 11/21/2023 21:20:45'!
import

	session beginTransaction.	
	
	csvIterator iterate: [ :line :entry | 
		self evaluateCurrentEntry: entry atLine: line ].
	
	session commit.
! !


!CustomerImporter methodsFor: 'evaluate' stamp: 'FA 11/21/2023 21:21:30'!
evaluateCurrentEntry: anEntry atLine: aLineNumber

	| currentEntryType |
	
	currentEntry := anEntry.
	currentLine := aLineNumber.
		
	currentEntryType := self getCurrentEntryType.
	(currentEntryType = 'c') ifTrue: [ ^self storeCustomerEntry. ].
	(currentEntryType = 'a') ifTrue: [ ^self storeAddressEntry. ].
	
	self error: (self class 
		unknownEntryTypeError: currentEntry first 
		atLine: currentLine ).
! !


!CustomerImporter methodsFor: 'parsing' stamp: 'FA 11/21/2023 21:20:00'!
asNumber: anEntryField

	[ ^ anEntryField asNumber ] on: Error do: [ :anError | 
		self error: (self class 
			nonIntegerFieldValueError: anEntryField
			atLine: currentLine). ].
! !

!CustomerImporter methodsFor: 'parsing' stamp: 'FA 11/21/2023 21:20:19'!
getCurrentEntryType

	^ self lowercase: currentEntry first.
! !

!CustomerImporter methodsFor: 'parsing' stamp: 'FA 11/21/2023 21:20:26'!
lowercase: anEntryField

	^anEntryField collect: [ :aCharacter | aCharacter asLowercase ].
! !


!CustomerImporter methodsFor: 'assertions' stamp: 'FA 11/21/2023 20:59:20'!
assertCurrentCustomerIsNotNil

	currentCustomer ifNil: [ 
		self error: (self class noCustomerForAddressError: currentLine). ].
! !

!CustomerImporter methodsFor: 'assertions' stamp: 'FA 11/21/2023 21:22:04'!
assertEntryHasExpectedFields: expectedFieldNumber

	(currentEntry size < expectedFieldNumber) ifTrue: [ 
		self error: (self class missingFieldsError: currentLine). ].
	(currentEntry size > expectedFieldNumber) ifTrue: [
		self error: (self class unknownFieldsError: currentLine). ].
! !


!CustomerImporter methodsFor: 'storing' stamp: 'FA 11/21/2023 21:22:04'!
storeAddressEntry

	self assertEntryHasExpectedFields: 6.
	self assertCurrentCustomerIsNotNil.
	
	currentCustomer addAddress: (
		Address 
			withStreetName: currentEntry second
			streetNumber: (self asNumber: currentEntry third)
			town: currentEntry fourth
			zipCode: (self asNumber: currentEntry fifth)
			andProvince: currentEntry sixth).
! !

!CustomerImporter methodsFor: 'storing' stamp: 'FA 11/21/2023 21:22:04'!
storeCustomerEntry

	self assertEntryHasExpectedFields: 5.
	
	currentCustomer := Customer 
		withFirstName: currentEntry second
		andLastName: currentEntry third
		andIdType: currentEntry  fourth
		andIdNumber: currentEntry fifth.	
	
	session persist: currentCustomer.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'FA 11/21/2023 20:13:51'!
forSession: aSession andInputStream: anInputStream
	^self new 
		initializeForSession: aSession 
		andInputStream: anInputStream.
! !


!CustomerImporter class methodsFor: 'error messages' stamp: 'FA 11/21/2023 21:14:10'!
linePosition: aLineNumber

	^'(line: ', aLineNumber asString, ')'.! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FA 11/21/2023 21:14:30'!
missingFieldsError: aLineNumber

	^'line has missing fields ', (self linePosition: aLineNumber).
! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FA 11/21/2023 21:14:58'!
noCustomerForAddressError: aLineNumber

	^'no customer for address ', (self linePosition: aLineNumber).
! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FA 11/21/2023 21:15:28'!
nonIntegerFieldValueError: aFieldValue atLine: aLineNumber.

	^'value should be numeric ', (self linePosition: aLineNumber),': ', aFieldValue.
! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FA 11/21/2023 21:21:30'!
unknownEntryTypeError: aType atLine: aLineNumber

	^'unknown registry type ', (self linePosition: aLineNumber),': ', aType.
! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FA 11/21/2023 21:15:36'!
unknownFieldsError: aLineNumber

	^'unknown fields ', (self linePosition: aLineNumber).
! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction closed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:25'!
beginTransaction

	inTransaction := true.! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:18'!
commit

	inTransaction := false.! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 11/14/2023 08:52:30'!
close

	closed := true.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:49:30'!
assertCanUseDatabase

	self assertIsOpen.
	self assertInTransaction ! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:43'!
assertInTransaction

	inTransaction ifFalse: [ self error: 'Not in transaction' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:16'!
assertIsOpen

	closed ifTrue: [ self error: 'Connection with database closed' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:09:07'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType name, ' are not configured to be persisted' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
isRelationToPersist: possibleRelation

	^ possibleRelation class = Set! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
persistPossibleRelationOf: anObject at: anInstVarOffset

	| possibleRelation |
		
	possibleRelation := anObject instVarAt: anInstVarOffset.
	(self isRelationToPersist: possibleRelation) ifTrue: [ self persistRelationOf: anObject at: anInstVarOffset with: possibleRelation ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:03'!
persistRelationOf: anObject at: anInstVarOffset with: aRelation

	| persistentRelation |
	
	persistentRelation := PersistentSet on: self from: aRelation.
	anObject instVarAt: anInstVarOffset put: persistentRelation! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:34'!
persistRelationsOf: anObject

	anObject class instVarNamesAndOffsetsDo: [ :anInstVarName :anInstVarOffset | self persistPossibleRelationOf: anObject at: anInstVarOffset]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:06:24'!
tableOfType: aType

	^ tables at: aType ifAbsentPut: [ Set new ]! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:44:19'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	closed := false.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 11/14/2023 09:06:24'!
persist: anObject

	| table |

	self assertCanUseDatabase.
	self assertTypeIsPersisted: anObject class.
	self delay.
	
	table := self tableOfType: anObject class.
	self defineIdOf: anObject.
	table add: anObject.
	self persistRelationsOf: anObject.
! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:06:56'!
select: aCondition ofType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:07:12'!
selectAllOfType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'FA 11/21/2023 20:14:22'!
for: aConfiguration

	^self new initializeFor: aConfiguration.
! !
