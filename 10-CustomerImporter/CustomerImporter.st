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

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:24:32'!
on: aSession

	^self on: aSession from: #()! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:25:00'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet
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

!ImportTest methodsFor: 'test' stamp: 'FA 11/16/2023 00:06:06'!
test06canImportFromStringStream

	inputStreamBuilder := [ 
		('C,Jack,Black,D,12345678', self cr,
		 'A,Almirante Brown,911,Merlo,1710,Buenos Aires') readStream.
	].

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

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


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
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:42'!
initialize

	super initialize.
	addresses := Set new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session inputStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'FA 11/15/2023 23:22:57'!
initializeForSession: aSession andInputStream: anInputStream

	session := aSession.
	inputStream := anInputStream.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'FA 11/15/2023 23:22:41'!
import

	"
	self importCustomers
	"
	|  newCustomer line |

	session beginTransaction.
	
	line := inputStream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth ].

		line := inputStream nextLine. ].

	session commit.

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'FA 11/15/2023 23:22:41'!
forSession: aSession andInputStream: anInputStream
	^self new initializeForSession: aSession andInputStream: anInputStream! !


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

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
