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


!classDefinition: #CSVImporterTest category: 'CustomerImporter'!
TestCase subclass: #CSVImporterTest
	instanceVariableNames: 'erpSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVImporterTest methodsFor: 'helpers' stamp: 'FA 11/25/2023 15:27:34'!
cr
	
	^String with: Character cr.! !

!CSVImporterTest methodsFor: 'helpers' stamp: 'FA 11/25/2023 18:35:06'!
getAddressWithName: aStreetName andNumber: aStreetNumber

	| selected |
	
	selected := erpSystem 
		getAddressWithName: aStreetName 
		andNumber: aStreetNumber.

	self assert: selected isNil not.
	
	^ selected.
! !

!CSVImporterTest methodsFor: 'helpers' stamp: 'FA 11/25/2023 18:34:52'!
getCustomerWithId: anIdNumber

	| selected |
	
	selected := erpSystem 
		getCustomerWithId: anIdNumber.

	self assert: selected isNil not.
	
	^ selected.
! !


!CSVImporterTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:00:02'!
runTestAndExpectError: anErrorMessage

	self should: [ self runTest: []. ]
		raise: Error 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: anErrorMessage ].

! !


!CSVImporterTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 15:54:59'!
defaultInputStreamBuilder

	self subclassResponsibility.
! !

!CSVImporterTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 15:28:23'!
runTest: testBlock

	self setUpTest.
	testBlock value.
	self tearDownTest.
! !

!CSVImporterTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 15:54:54'!
setUpTest

	self subclassResponsibility.
! !

!CSVImporterTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 15:54:51'!
tearDownTest

	self subclassResponsibility.
! !


!CSVImporterTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:30:32'!
defaultAlemAddressLine

	^ 'A,Alem,1122,CABA,1001,CABA'
! !

!CSVImporterTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:30:41'!
defaultJuanCustomerLine

	^ 'C,Juan,Perez,C,23-25666777-9'! !

!CSVImporterTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:30:46'!
defaultMaipuAddressLine

	^ 'A,Maipu,888,Florida,1122,Buenos Aires'! !

!CSVImporterTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:30:53'!
defaultPepeCustomerLine

	^ 'C,Pepe,Sanchez,D,22333444'! !

!CSVImporterTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:31:00'!
defaultSanMartinAddressLine

	^ 'A,San Martin,3322,Olivos,1636,BsAs'! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
CSVImporterTest subclass: #ImportTest
	instanceVariableNames: 'inputStreamBuilder openStream sessionBuilder'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 17:31:45'!
defaultInputStreamBuilder

	^[ UniFileStream new open: 'input.txt' forWrite: false ].
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 18:34:24'!
setUpTest
	
	openStream := inputStreamBuilder value.
	erpSystem start.
	
	(CustomerImporter 
		forCustomerSystem: erpSystem
		andInputStream: openStream) import.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 18:34:24'!
tearDownTest

	openStream close.
	erpSystem close.
	
	inputStreamBuilder := self defaultInputStreamBuilder.
! !


!ImportTest methodsFor: 'initialization' stamp: 'FA 11/25/2023 18:34:24'!
initialize

	erpSystem  := Environment getCustomerSystemForCurrentEnvironment.
	inputStreamBuilder := self defaultInputStreamBuilder.
! !


!ImportTest methodsFor: 'test' stamp: 'FA 11/25/2023 18:34:24'!
test01allEntriesAreLoaded

	self runTest: [ 
		self assert: (erpSystem listCustomers) size equals: 2 ].
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

!ImportTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:00:03'!
test09shouldThrowOnUnknownEntryType

	inputStreamBuilder := [ 
		('F,Pedro,Ordep,D,12345678') readStream. ].
	
	self runTestAndExpectError: (
		CustomerImporter unknownEntryTypeError: 'F' atLine: 1 ).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:00:03'!
test10shouldThrowOnNonNumericAddressFields

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,12345678', self cr,
		'A,Virrey del Pino,aaa,belgrano,1234,CABA') readStream. ].
	
	self runTestAndExpectError: (
		CustomerImporter nonIntegerFieldValueError: 'aaa' atLine: 2).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:00:02'!
test11shouldThrowOnWrongAmountOfFieldsForEntry

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D') readStream. ].
	
	self runTestAndExpectError: (
		CustomerImporter missingFieldsError: 1).
		
	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,123456789', self cr,
		 'A,Migueletes,123') readStream. ].
	
	self runTestAndExpectError: (
		CustomerImporter missingFieldsError: 2).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:00:03'!
test12shouldThrowIfFieldsAreEmpty

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,,123456789') readStream. ].
	
	self runTestAndExpectError: (
		CustomerImporter missingFieldsError: 1).
		
	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,123456789', self cr,
		 'A,Migueletes,123,,1234,Buenos Aires') readStream. ].
	
	self runTestAndExpectError: (
		CustomerImporter missingFieldsError: 2).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:00:02'!
test13shouldThrowIfThereAreExtraFields

	inputStreamBuilder := [ 
		('C,Pedro,Ordep,D,123456789,Casado') readStream. ].
	
	self runTestAndExpectError: (
		CustomerImporter unknownFieldsError: 1).
! !

!ImportTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:00:02'!
test14shouldThrowIfAddressHasNoCorrespondingCustomer

	inputStreamBuilder := [ 
		 ('A,Almirante Brown,911,Merlo,1710,BsAs') readStream. ].

	self runTestAndExpectError: (
		CustomerImporter 
			noEntityForCurrentEntryError: 1).
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


!classDefinition: #SupplierTest category: 'CustomerImporter'!
CSVImporterTest subclass: #SupplierTest
	instanceVariableNames: 'inputStreamBuilder openStream sessionBuilder populateWithCustomersBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 18:34:18'!
setUpTest
	
	openStream := inputStreamBuilder value.
	erpSystem start.
	populateWithCustomersBlock value.
	
	(SupplierImporter 
		forSupplierSystem: erpSystem 
		andInputStream: openStream) import.
! !

!SupplierTest methodsFor: 'setUp/tearDown' stamp: 'FA 11/25/2023 18:34:18'!
tearDownTest

	openStream close.
	erpSystem close.
	
	inputStreamBuilder := self defaultInputStreamBuilder.
	populateWithCustomersBlock := self defaultPopulateDatabaseBlock.
! !


!SupplierTest methodsFor: 'initialization' stamp: 'FA 11/25/2023 18:34:18'!
initialize

	erpSystem  := Environment getSupplierSystemForCurrentEnvironment.

	inputStreamBuilder := self defaultInputStreamBuilder.
	populateWithCustomersBlock := self defaultPopulateDatabaseBlock.
! !


!SupplierTest methodsFor: 'helpers' stamp: 'FA 11/25/2023 17:16:05'!
getDefaultSupplier

	^ self getSupplierWithId: '123'.
! !

!SupplierTest methodsFor: 'helpers' stamp: 'FA 11/25/2023 18:34:18'!
getSupplierWithId: anIdNumber

	| selected |
	
	selected := erpSystem 
		getSupplierWithId: anIdNumber.

	self assert: selected isNil not.
	
	^ selected.! !


!SupplierTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:22:06'!
defaultExistingCustomer

	^ Customer 
		withFirstName: 'Bob'
		andLastName: 'Bert' 
		andIdType: 'D'
		andIdNumber: '5456774'.
! !

!SupplierTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:22:02'!
defaultExistingCustomerLine

	^ 'EC,D,5456774'! !

!SupplierTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:30:12'!
defaultInputStreamBuilder

	^[ (self defaultSupplierLine, self cr,
		self defaultNewCustomerLine, self cr,
		self defaultExistingCustomerLine, self cr,
		self defaultSanMartinAddressLine, self cr,
		self defaultMaipuAddressLine) readStream. ].
! !

!SupplierTest methodsFor: 'default' stamp: 'FA 11/25/2023 17:28:33'!
defaultNewCustomerLine

	^ 'NC,Pepe,Sanchez,D,22333444'! !

!SupplierTest methodsFor: 'default' stamp: 'FA 11/25/2023 18:34:18'!
defaultPopulateDatabaseBlock

	^[ erpSystem addCustomer: ( self defaultExistingCustomer ). ].
! !

!SupplierTest methodsFor: 'default' stamp: 'FA 11/25/2023 16:45:41'!
defaultSupplierLine

	^ 'S,Supplier1,D,123'! !


!SupplierTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:10:50'!
test01importsSupplierEntryCorrectly

	inputStreamBuilder := [ (
			self defaultSupplierLine
		) readStream. ].

	self runTest: [
		 self assertIsDefaultSupplier: (self getDefaultSupplier). ].
! !

!SupplierTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:29:37'!
test02importsNewCustomerCorrectly

	inputStreamBuilder := [ (
			self defaultSupplierLine, self cr,
			self defaultNewCustomerLine 
		) readStream. ].

	self runTest: [  | customer |
		
		customer := (self getDefaultSupplier) customers anyOne.
		
		self assertCustomerIsInDatabase: customer.
		self assertIsDefaultNewCustomer: customer. ].
! !

!SupplierTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:23:01'!
test03importsExistingCustomerCorrectly

	inputStreamBuilder := [ (
			self defaultSupplierLine, self cr,
			self defaultExistingCustomerLine 
		) readStream. ].

	self runTest: [  | customer |
		
		customer := (self getDefaultSupplier) customers anyOne.
		
		self assertCustomerIsInDatabase: customer. 
		self assertIsDefaultExistingCustomer: customer. ].
! !

!SupplierTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:00:03'!
test04failsToImportNonExistentExistingCustomer

	inputStreamBuilder := [ (
			self defaultSupplierLine, self cr,
			'EC,D,12345678'
		) readStream. ].
	
	self runTestAndExpectError: ERPSystem noCustomerFoundError.
! !

!SupplierTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:10:50'!
test05importsAddressCorrectly

	inputStreamBuilder := [ (
			self defaultSupplierLine, self cr,
			self defaultMaipuAddressLine 
		) readStream. ].
	
	self runTest: [ | address |
		
		address := (self getDefaultSupplier) addresses anyOne.
		
		self assertAdressIsInDatabase: address.
		self assertIsDefaultMaipuAddress: address. ].
! !

!SupplierTest methodsFor: 'test' stamp: 'FA 11/25/2023 17:21:37'!
test06importsMultipleEntryTypesCorrectly
	
	self runTest: [ | supplier customers addresses |
		supplier   := self getDefaultSupplier.
		customers := supplier customers asArray.
		addresses := supplier addresses asArray.
		
		self assertIsDefaultSupplier: supplier.
			
		self assert: customers size equals: 2.
		self assertCustomerIsInDatabase: customers first.
		self assertCustomerIsInDatabase: customers second.
		self assertAreDefaultCustomers: customers.
		 
		self assert: addresses size equals: 2.
		self assertAdressIsInDatabase: addresses first.
		self assertAdressIsInDatabase: addresses second.
		self assertAreDefaultAddresses: addresses. ].

! !


!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:04:12'!
assertAdressIsInDatabase: anAddress

	^ self 
		assert: anAddress 
		equals: ( self 
			getAddressWithName: anAddress streetName
			andNumber: anAddress streetNumber ).
! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:25:14'!
assertAreDefaultAddresses: anAddressArray

	[ 
		self assertIsDefaultMaipuAddress: anAddressArray first.
		self assertIsDefaultSanMartinAddress: anAddressArray second. ] 
	on: TestFailure
	do: [
		self assertIsDefaultMaipuAddress: anAddressArray second.
		self assertIsDefaultSanMartinAddress: anAddressArray first. ].
! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:24:57'!
assertAreDefaultCustomers: aCustomerArray

	[ 
		self assertIsDefaultNewCustomer: aCustomerArray first.
		self assertIsDefaultExistingCustomer: aCustomerArray second. ] 
	on: TestFailure
	do: [
		self assertIsDefaultNewCustomer: aCustomerArray second.
		self assertIsDefaultExistingCustomer: aCustomerArray first. ].
! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:04:07'!
assertCustomerIsInDatabase: aCustomer

	^ self 
		assert: aCustomer 
		equals: ( self getCustomerWithId: aCustomer identificationNumber ).
! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:23:16'!
assertIsDefaultExistingCustomer: aCustomer

	^ self 
		assert: aCustomer firstName equals: 'Bob' ;
		assert: aCustomer lastName equals: 'Bert' ;
		assert: aCustomer identificationNumber equals: '5456774' ;
		assert: aCustomer identificationType equals: 'D'.

! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:09:55'!
assertIsDefaultMaipuAddress: anAddress

	^ self 
		assert: anAddress streetName equals: 'Maipu' ;
		assert: anAddress streetNumber equals: 888 ;
		assert: anAddress town equals: 'Florida' ;
		assert: anAddress zipCode equals: 1122 ;
		assert: anAddress province equals: 'Buenos Aires'.
! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:04:38'!
assertIsDefaultNewCustomer: aCustomer

	^ self 
		assert: aCustomer firstName equals: 'Pepe' ;
		assert: aCustomer lastName equals: 'Sanchez' ;
		assert: aCustomer identificationNumber equals: '22333444' ;
		assert: aCustomer identificationType equals: 'D'.

! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 17:09:32'!
assertIsDefaultSanMartinAddress: anAddress

	^ self 
		assert: anAddress streetName equals: 'San Martin' ;
		assert: anAddress streetNumber equals: 3322 ;
		assert: anAddress town equals: 'Olivos' ;
		assert: anAddress zipCode equals: 1636 ;
		assert: anAddress province equals: 'BsAs'.
! !

!SupplierTest methodsFor: 'assertions' stamp: 'FA 11/25/2023 18:18:12'!
assertIsDefaultSupplier: aSupplier

	^ self 
		assert: aSupplier supplierName equals: 'Supplier1' ;
		assert: aSupplier identificationNumber equals: '123' ;
		assert: aSupplier identificationType equals: 'D'.
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


!classDefinition: #CSVImporter category: 'CustomerImporter'!
Object subclass: #CSVImporter
	instanceVariableNames: 'currentLine currentEntry csvIterator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVImporter methodsFor: 'parsing' stamp: 'BK 11/23/2023 19:49:30'!
asNumber: anEntryField

	[ ^anEntryField asNumber ] on: Error do: [ :anError | 
		self error: (self class 
			nonIntegerFieldValueError: anEntryField
			atLine: currentLine). ].
! !

!CSVImporter methodsFor: 'parsing' stamp: 'BK 11/23/2023 19:49:27'!
getCurrentEntryType

	^self lowercase: currentEntry first.
! !

!CSVImporter methodsFor: 'parsing' stamp: 'BK 11/23/2023 19:26:20'!
lowercase: anEntryField

	^anEntryField collect: [ :aCharacter | aCharacter asLowercase ].
! !


!CSVImporter methodsFor: 'assertions' stamp: 'BK 11/23/2023 19:25:47'!
assertEntryHasExpectedFields: expectedFieldNumber

	(currentEntry size < expectedFieldNumber) ifTrue: [ 
		self error: (self class missingFieldsError: currentLine). ].
	(currentEntry size > expectedFieldNumber) ifTrue: [
		self error: (self class unknownFieldsError: currentLine). ].
! !


!CSVImporter methodsFor: 'import' stamp: 'FA 11/25/2023 16:11:14'!
import

	self subclassResponsibility.
! !


!CSVImporter methodsFor: 'initialization' stamp: 'FA 11/25/2023 16:12:43'!
initializeWithInputStream: anInputStream andDelimiter: aDelimiter

	csvIterator := CSVstreamIterator 
		forInputStream: anInputStream 
		delimitedBy: aDelimiter.
! !


!CSVImporter methodsFor: 'exceptions' stamp: 'BK 11/23/2023 19:58:30'!
throwUnknownEntryTypeError

	self error: (self class 
		unknownEntryTypeError: currentEntry first 
		atLine: currentLine ).! !


!CSVImporter methodsFor: 'evaluate' stamp: 'FA 11/25/2023 15:06:48'!
evaluateCurrentEntry: anEntry atLine: aLineNumber

	currentEntry := anEntry.
	currentLine := aLineNumber.	
	
	self storeEntryOfType: self getCurrentEntryType.
! !


!CSVImporter methodsFor: 'storing' stamp: 'BK 11/23/2023 19:59:31'!
storeEntryOfType: anEntryType

	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CSVImporter class' category: 'CustomerImporter'!
CSVImporter class
	instanceVariableNames: ''!

!CSVImporter class methodsFor: 'error messages' stamp: 'BK 11/23/2023 20:07:55'!
linePosition: aLineNumber

	^'(line: ', aLineNumber asString, ')'.! !

!CSVImporter class methodsFor: 'error messages' stamp: 'BK 11/23/2023 20:07:50'!
missingFieldsError: aLineNumber

	^'line has missing fields ', (self linePosition: aLineNumber).
! !

!CSVImporter class methodsFor: 'error messages' stamp: 'BK 11/23/2023 20:07:42'!
nonIntegerFieldValueError: aFieldValue atLine: aLineNumber.

	^'value should be numeric ', (self linePosition: aLineNumber),': ', aFieldValue.
! !

!CSVImporter class methodsFor: 'error messages' stamp: 'BK 11/23/2023 20:07:35'!
unknownEntryTypeError: aType atLine: aLineNumber

	^'unknown registry type ', (self linePosition: aLineNumber),': ', aType.
! !

!CSVImporter class methodsFor: 'error messages' stamp: 'BK 11/23/2023 20:07:29'!
unknownFieldsError: aLineNumber

	^'unknown fields ', (self linePosition: aLineNumber).
! !


!classDefinition: #ERPImporter category: 'CustomerImporter'!
CSVImporter subclass: #ERPImporter
	instanceVariableNames: 'erpSystem currentEntity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ERPImporter methodsFor: 'initialization' stamp: 'FA 11/25/2023 16:12:56'!
initializeWithErpSystem: anErpSystem andInputStream: anInputStream

	super initializeWithInputStream: anInputStream andDelimiter: $,.
	erpSystem := anErpSystem.
! !


!ERPImporter methodsFor: 'import' stamp: 'FA 11/25/2023 16:10:34'!
import

	erpSystem beginTransaction.	
	
	csvIterator iterate: [ :line :entry | 
		self evaluateCurrentEntry: entry atLine: line ].
	
	erpSystem commit.
! !


!ERPImporter methodsFor: 'storing' stamp: 'FA 11/25/2023 16:16:54'!
storeAddressEntry

	self assertEntryHasExpectedFields: 6.
	self assertCurrentEntityIsNotNil.
	
	currentEntity addAddress: (
		Address 
			withStreetName: currentEntry second
			streetNumber: (self asNumber: currentEntry third)
			town: currentEntry fourth
			zipCode: (self asNumber: currentEntry fifth)
			andProvince: currentEntry sixth).
! !


!ERPImporter methodsFor: 'assertions' stamp: 'FA 11/25/2023 16:18:20'!
assertCurrentEntityIsNotNil

	currentEntity ifNil: [ 
		self error: (self class noEntityForCurrentEntryError: currentLine). ].
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ERPImporter class' category: 'CustomerImporter'!
ERPImporter class
	instanceVariableNames: ''!

!ERPImporter class methodsFor: 'error messages' stamp: 'FA 11/25/2023 16:20:48'!
noEntityForCurrentEntryError: aLineNumber

	^'no entity defined for entry ', (self linePosition: aLineNumber).
! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
ERPImporter subclass: #CustomerImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'BK 11/23/2023 20:24:43'!
initializeForCustomerSystem: aCustomerSystem andInputStream: anInputStream

	super initializeWithErpSystem: aCustomerSystem andInputStream: anInputStream.
! !


!CustomerImporter methodsFor: 'storing' stamp: 'FA 11/25/2023 16:17:47'!
storeCustomerEntry

	self assertEntryHasExpectedFields: 5.
	
	currentEntity := Customer 
		withFirstName: currentEntry second
		andLastName: currentEntry third
		andIdType: currentEntry  fourth
		andIdNumber: currentEntry fifth.	
	
	erpSystem addCustomerInTransaction: currentEntity.
! !

!CustomerImporter methodsFor: 'storing' stamp: 'BK 11/23/2023 20:04:57'!
storeEntryOfType: anEntryType

	(anEntryType = 'c') ifTrue: [ ^self storeCustomerEntry. ].
        (anEntryType = 'a') ifTrue: [ ^self storeAddressEntry. ].

	self throwUnknownEntryTypeError.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'BK 11/23/2023 19:46:38'!
forCustomerSystem: aCustomerSystem andInputStream: anInputStream
	^self new 
		initializeForCustomerSystem: aCustomerSystem 
		andInputStream: anInputStream.
! !


!classDefinition: #SupplierImporter category: 'CustomerImporter'!
ERPImporter subclass: #SupplierImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImporter methodsFor: 'initialization' stamp: 'BK 11/23/2023 20:25:01'!
initializeForSupplierSystem: aSupplierSystem  andInputStream: anInputStream

	super initializeWithErpSystem: aSupplierSystem andInputStream: anInputStream.
! !


!SupplierImporter methodsFor: 'storing' stamp: 'FA 11/25/2023 16:07:24'!
storeEntryOfType: anEntryType

	(anEntryType = 's') ifTrue: [ ^self storeSupplierEntry. ].
	(anEntryType = 'nc') ifTrue: [ ^self storeNewCustomerEntry. ].
	(anEntryType = 'ec') ifTrue: [ ^self storeExistingCustomerEntry. ].
	(anEntryType = 'a') ifTrue: [ ^self storeAddressEntry. ].
	
	self throwUnknownEntryTypeError.
! !

!SupplierImporter methodsFor: 'storing' stamp: 'FA 11/25/2023 18:24:25'!
storeExistingCustomerEntry

	self assertEntryHasExpectedFields: 3.
	self assertCurrentEntityIsNotNil.
	
	currentEntity addCustomer: (erpSystem getCustomerWithIdInTransaction: currentEntry third).


! !

!SupplierImporter methodsFor: 'storing' stamp: 'FA 11/25/2023 16:19:25'!
storeNewCustomerEntry

	self assertEntryHasExpectedFields: 5.
	self assertCurrentEntityIsNotNil.
	
	currentEntity addCustomer: (
		Customer 
			withFirstName: currentEntry second
			andLastName: currentEntry third
			andIdType: currentEntry  fourth
			andIdNumber: currentEntry fifth ).	
! !

!SupplierImporter methodsFor: 'storing' stamp: 'FA 11/25/2023 16:16:26'!
storeSupplierEntry
	
	self assertEntryHasExpectedFields: 4.
	
	currentEntity := Supplier 
		withName: currentEntry second 
		andIdType: currentEntry third 
		andIdNumber: currentEntry fourth.
	
	erpSystem addSupplierInTransaction: currentEntity.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SupplierImporter class' category: 'CustomerImporter'!
SupplierImporter class
	instanceVariableNames: ''!

!SupplierImporter class methodsFor: 'instance creation' stamp: 'BK 11/23/2023 20:19:24'!
forSupplierSystem: aSupplierSystem andInputStream: anInputStream
	
	^self new 
		initializeForSupplierSystem:  aSupplierSystem
		andInputStream: anInputStream.
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

!CSVstreamIterator methodsFor: 'parsing' stamp: 'FA 11/25/2023 15:09:08'!
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

!DataBaseSession methodsFor: 'persistence - private' stamp: 'FA 11/25/2023 18:18:12'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType supplierName, ' are not configured to be persisted' ].! !

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


!DataBaseSession methodsFor: 'persistence' stamp: 'HAW 11/14/2023 09:06:24'!
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


!classDefinition: #ERPSystem category: 'CustomerImporter'!
Object subclass: #ERPSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ERPSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:33:42'!
beginTransaction

	self subclassResponsibility.
! !

!ERPSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:34:03'!
close

	self subclassResponsibility.
! !

!ERPSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:34:08'!
commit

	self subclassResponsibility.
! !

!ERPSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:34:19'!
start

	self subclassResponsibility.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ERPSystem class' category: 'CustomerImporter'!
ERPSystem class
	instanceVariableNames: ''!

!ERPSystem class methodsFor: 'error messages' stamp: 'FA 11/25/2023 15:57:46'!
noAddressFoundError

	^ 'address not found'.
! !

!ERPSystem class methodsFor: 'error messages' stamp: 'FA 11/25/2023 15:57:52'!
noCustomerFoundError

	^ 'no customer found'.
! !

!ERPSystem class methodsFor: 'error messages' stamp: 'FA 11/25/2023 15:58:31'!
noSupplierFoundError

	^ 'no supplier found'.
! !


!classDefinition: #CustomerSystem category: 'CustomerImporter'!
ERPSystem subclass: #CustomerSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:28:45'!
addCustomer: aCustomer

	self subclassResponsibility.
! !

!CustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:28:52'!
addCustomerInTransaction: aCustomer

	self subclassResponsibility.
! !

!CustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:29:48'!
getAddressWithName: aName andNumber: aNumber

	self subclassResponsibility.! !

!CustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:30:07'!
getCustomerWithId: anIdNumber

	self subclassResponsibility.
! !

!CustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:30:24'!
listAddresses

	self subclassResponsibility.
! !

!CustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:30:32'!
listCustomers

	self subclassResponsibility.
! !


!classDefinition: #PersistentCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #PersistentCustomerSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentCustomerSystem methodsFor: 'interface - private' stamp: 'FA 11/22/2023 19:09:48'!
runInTransaction: aBlock

	| result |
	
	session beginTransaction.
	result := aBlock value.
	session commit.
	
	^result.
! !


!PersistentCustomerSystem methodsFor: 'transactions interface' stamp: 'FA 11/22/2023 19:01:53'!
beginTransaction

	session beginTransaction.

! !

!PersistentCustomerSystem methodsFor: 'transactions interface' stamp: 'FA 11/22/2023 19:02:14'!
close

	session close.

! !

!PersistentCustomerSystem methodsFor: 'transactions interface' stamp: 'FA 11/22/2023 19:02:00'!
commit

	session commit.

! !

!PersistentCustomerSystem methodsFor: 'transactions interface' stamp: 'FA 11/22/2023 20:15:01'!
start

	session := DataBaseSession for: (Array with: Address with: Customer).
! !


!PersistentCustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:23:15'!
addCustomer: aCustomer

	self runInTransaction: [ session persist: aCustomer. ].
! !

!PersistentCustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:23:54'!
addCustomerInTransaction: aCustomer

	session persist: aCustomer.

! !

!PersistentCustomerSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:29:20'!
getAddressWithName: aStreetName andNumber: aStreetNumber

	| select |
	
	select := self runInTransaction: [ 
		session 
			select: [ :anAddress | (anAddress streetName = aStreetName) and: (anAddress streetNumber  = aStreetNumber). ]
 			ofType: Address. ].
	
	(select isEmpty) ifTrue: [ self error: self class noAddressFoundError. ].
	
	^select anyOne.
! !

!PersistentCustomerSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:29:30'!
getCustomerWithId: anIdNumber

	| select |
	
	select := self runInTransaction: [ 
		session 
			select: [ :aCustomer | aCustomer identificationNumber = anIdNumber. ]
 			ofType: Customer. ].
	
	(select isEmpty) ifTrue: [ self error: self class noCustomerFoundError. ].
	
	^select anyOne.
! !

!PersistentCustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:11:31'!
listAddresses

	^self runInTransaction: [ session selectAllOfType: Address ].
! !

!PersistentCustomerSystem methodsFor: 'interface' stamp: 'FA 11/22/2023 19:10:12'!
listCustomers

	^self runInTransaction: [ session selectAllOfType: Customer ].
! !


!classDefinition: #TransientCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #TransientCustomerSystem
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientCustomerSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:35:21'!
beginTransaction

	"do nothing"


! !

!TransientCustomerSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:35:21'!
close

	"do nothing"


! !

!TransientCustomerSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:35:21'!
commit

	"do nothing"


! !

!TransientCustomerSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:51:26'!
start

	customers := Set new.
! !


!TransientCustomerSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:35:21'!
addCustomer: aCustomer

	customers add: aCustomer.
! !

!TransientCustomerSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:35:21'!
addCustomerInTransaction: aCustomer

	self addCustomer: aCustomer.
! !

!TransientCustomerSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:35:21'!
getAddressWithName: aStreetName andNumber: aStreetNumber
	
	^self listAddresses 
		detect: [ :anAddress | (anAddress streetName  = aStreetName) and: (anAddress streetNumber = aStreetNumber) ]
		ifNone: [ self error: self class noAddressFoundError . ].

! !

!TransientCustomerSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:35:21'!
getCustomerWithId: anIdNumber

	^customers 
		detect: [ :aCustomer | aCustomer identificationNumber = anIdNumber ]
		ifNone: [ self error: self class noCustomerFoundError. ].
! !

!TransientCustomerSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:28:40'!
listAddresses

	| addresses |
	
	addresses := Set new.
	
	customers do: [ :aCustomer | aCustomer addresses do: [ :anAddress | addresses add: anAddress ]. ].

	^addresses.
! !

!TransientCustomerSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:35:21'!
listCustomers

	^customers copy.
! !


!classDefinition: #SupplierSystem category: 'CustomerImporter'!
ERPSystem subclass: #SupplierSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:31:00'!
addSupplier: aSupplier

	self subclassResponsibility.
! !

!SupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:30:57'!
addSupplierInTransaction: aSupplier

	self subclassResponsibility.
! !

!SupplierSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:32:03'!
getAddressWithName: aName andNumber: aNumber

	self subclassResponsibility.! !

!SupplierSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:32:03'!
getCustomerWithId: anIdNumber

	self subclassResponsibility.
! !

!SupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:30:51'!
getCustomerWithIdInTransaction: anIdNumber

	self subclassResponsibility.
! !

!SupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:30:47'!
getSupplierWithId: anIdNumber

	self subclassResponsibility.
! !

!SupplierSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:32:03'!
listAddresses

	self subclassResponsibility.
! !

!SupplierSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:32:03'!
listCustomers

	self subclassResponsibility.
! !

!SupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:30:40'!
listSuppliers

	self subclassResponsibility.
! !


!classDefinition: #PersistentSupplierSystem category: 'CustomerImporter'!
SupplierSystem subclass: #PersistentSupplierSystem
	instanceVariableNames: 'session customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSupplierSystem methodsFor: 'interface - private' stamp: 'FA 11/25/2023 18:27:19'!
runInTransaction: aBlock

	| result |
	
	session beginTransaction.
	result := aBlock value.
	session commit.
	
	^result.

! !


!PersistentSupplierSystem methodsFor: 'transactions interface' stamp: 'FA 11/25/2023 17:34:16'!
beginTransaction

	session beginTransaction.

! !

!PersistentSupplierSystem methodsFor: 'transactions interface' stamp: 'FA 11/25/2023 17:34:16'!
close

	session close.

! !

!PersistentSupplierSystem methodsFor: 'transactions interface' stamp: 'FA 11/25/2023 17:34:16'!
commit

	session commit.

! !

!PersistentSupplierSystem methodsFor: 'transactions interface' stamp: 'FA 11/25/2023 17:53:37'!
start

	session := DataBaseSession for: (Array with: Supplier with: Customer with: Address).
! !


!PersistentSupplierSystem methodsFor: 'interface - testing' stamp: 'FA 11/25/2023 18:08:17'!
addCustomer: aCustomer

	"for testing only."
	
	self runInTransaction: [ session persist: aCustomer ].
! !


!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 17:40:11'!
addSupplier: aSupplier

	self runInTransaction: [ session persist: aSupplier. ].
! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 17:40:20'!
addSupplierInTransaction: aSupplier

	session persist: aSupplier.
! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:26:59'!
getAddressWithName: aStreetName andNumber: aStreetNumber

	| select |
	
	select := self runInTransaction: [ 
		session 
			select: [ :anAddress | (anAddress streetName = aStreetName) and: (anAddress streetNumber  = aStreetNumber). ]
 			ofType: Address. ].
	
	(select isEmpty) ifTrue: [ self error: self class noAddressFoundError. ].
	
	^select anyOne.
! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:25:21'!
getCustomerWithId: anIdNumber

	^self runInTransaction: [ self getCustomerWithIdInTransaction: anIdNumber ].
! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:26:22'!
getCustomerWithIdInTransaction: anIdNumber

	| select |
	
	select := session 
		select: [ :aCustomer | aCustomer identificationNumber = anIdNumber. ]
 		ofType: Customer.
	
	(select isEmpty) ifTrue: [ self error: self class noCustomerFoundError. ].
	
	^select anyOne.
! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:26:37'!
getSupplierWithId: anIdNumber

	| select |
	
	select := self runInTransaction: [ 
		session 
			select: [ :aSupplier | aSupplier identificationNumber = anIdNumber. ]
 			ofType: Supplier. ].
	
	(select isEmpty) ifTrue: [ self error: self class noSupplierFoundError. ].
	
	^select anyOne.


! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 17:34:16'!
listAddresses

	^self runInTransaction: [ session selectAllOfType: Address ].
! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 17:55:49'!
listCustomers

	^self runInTransaction: [ session selectAllOfType: Customer ].
! !

!PersistentSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 17:45:31'!
listSuppliers

	^self runInTransaction: [ session selectAllOfType: Supplier ].
! !


!classDefinition: #TransientSupplierSystem category: 'CustomerImporter'!
SupplierSystem subclass: #TransientSupplierSystem
	instanceVariableNames: 'suppliers customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientSupplierSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:37:14'!
beginTransaction

	"do nothing"
! !

!TransientSupplierSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:37:12'!
close

	"do nothing"
! !

!TransientSupplierSystem methodsFor: 'transactions interface' stamp: 'BK 11/23/2023 20:37:08'!
commit

	"do nothing"
! !

!TransientSupplierSystem methodsFor: 'transactions interface' stamp: 'FA 11/25/2023 18:12:19'!
start
	
	suppliers := Set new.
	customers := Set new.

! !


!TransientSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 17:57:32'!
addSupplier: aSupplier

	self addSupplierInTransaction:  aSupplier.
! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:12:39'!
addSupplierInTransaction: aSupplier

	suppliers add: aSupplier.
! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:37:00'!
getAddressWithName: aStreetName andNumber: aStreetNumber
	
	^self listAddresses 
		detect: [ :anAddress | (anAddress streetName  = aStreetName) and: (anAddress streetNumber = aStreetNumber) ]
		ifNone: [ self error: self class noAddressFoundError . ].
! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:25:54'!
getCustomerWithId: anIdNumber
	
	^self getCustomerWithIdInTransaction: anIdNumber.

! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:25:42'!
getCustomerWithIdInTransaction: anIdNumber
	
	^self listCustomers 
		detect: [ :aCustomer | aCustomer identificationNumber = anIdNumber ]
		ifNone: [ self error: self class noCustomerFoundError. ].

! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 18:56:56'!
getSupplierWithId: anIdNumber

	^suppliers 
		detect: [ :aSupplier | aSupplier identificationNumber = anIdNumber ]
		ifNone: [ self error: self class noCustomerFoundError. ].
! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:27:48'!
listAddresses

	| addresses |
	
	addresses := Set new.
	
	suppliers do: [ :aSupplier | aSupplier addresses do: [ :anAddress | addresses add: anAddress ]. ].

	^addresses.
! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'FA 11/25/2023 18:27:54'!
listCustomers

	| customerSet |
	
	customerSet := customers copy.
	
	suppliers do: [ :aSupplier | aSupplier customers do: [ :anAddress | customerSet add: anAddress ]. ].

	^customerSet.
! !

!TransientSupplierSystem methodsFor: 'interface' stamp: 'BK 11/23/2023 20:41:59'!
listSuppliers

	^suppliers copy.

! !


!TransientSupplierSystem methodsFor: 'interface - testing' stamp: 'FA 11/25/2023 18:08:06'!
addCustomer: aCustomer

	"for testing only."
	
	customers add: aCustomer.
! !


!classDefinition: #Environment category: 'CustomerImporter'!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: 'CustomerImporter'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'select environment' stamp: 'FA 11/25/2023 18:33:21'!
currentEnvironment

	^DevelopmentEnvironment.
! !


!Environment class methodsFor: 'systems' stamp: 'FA 11/22/2023 20:51:01'!
getCustomerSystemForCurrentEnvironment

	^self currentEnvironment getCustomerSystem.
! !

!Environment class methodsFor: 'systems' stamp: 'BK 11/23/2023 20:53:26'!
getSupplierSystemForCurrentEnvironment

	^self currentEnvironment getSupplierSystem.
! !


!classDefinition: #EnvironmentOptions category: 'CustomerImporter'!
Object subclass: #EnvironmentOptions
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnvironmentOptions class' category: 'CustomerImporter'!
EnvironmentOptions class
	instanceVariableNames: ''!

!EnvironmentOptions class methodsFor: 'systems' stamp: 'FA 11/22/2023 20:45:25'!
getCustomerSystem

	self subclassResponsibility.

! !

!EnvironmentOptions class methodsFor: 'systems' stamp: 'BK 11/23/2023 20:53:44'!
getSupplierSystem

	self subclassResponsibility.

! !


!classDefinition: #DevelopmentEnvironment category: 'CustomerImporter'!
EnvironmentOptions subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: 'CustomerImporter'!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'systems' stamp: 'BK 11/23/2023 20:51:03'!
getCustomerSystem

	^ TransientCustomerSystem new.
! !

!DevelopmentEnvironment class methodsFor: 'systems' stamp: 'BK 11/23/2023 20:56:29'!
getSupplierSystem

	^ TransientSupplierSystem new.
! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
EnvironmentOptions subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: 'CustomerImporter'!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'systems' stamp: 'FA 11/22/2023 20:45:57'!
getCustomerSystem

	^ PersistentCustomerSystem new.
! !

!IntegrationEnvironment class methodsFor: 'systems' stamp: 'FA 11/25/2023 18:15:36'!
getSupplierSystem

	^ PersistentSupplierSystem new.
! !


!classDefinition: #Party category: 'CustomerImporter'!
Object subclass: #Party
	instanceVariableNames: 'id identificationNumber identificationType addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Party methodsFor: 'identification' stamp: 'FA 11/25/2023 15:24:36'!
identificationNumber

	^identificationNumber.! !

!Party methodsFor: 'identification' stamp: 'FA 11/25/2023 15:24:43'!
identificationType

	^identificationType.
! !


!Party methodsFor: 'addresses' stamp: 'FA 11/25/2023 15:25:56'!
addAddress: anAddress

	addresses add: anAddress ! !

!Party methodsFor: 'addresses' stamp: 'FA 11/25/2023 15:26:02'!
addresses

	^ addresses copy.
! !


!Party methodsFor: 'initialization' stamp: 'FA 11/25/2023 16:23:05'!
initialize

	addresses := Set new.! !

!Party methodsFor: 'initialization' stamp: 'FA 11/25/2023 18:22:22'!
initializeWithIdType: anIdType andNumber: anIdNumber

	identificationType := anIdType.
	identificationNumber := anIdNumber.! !


!classDefinition: #Customer category: 'CustomerImporter'!
Party subclass: #Customer
	instanceVariableNames: 'firstName lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'name' stamp: 'FA 11/25/2023 16:23:30'!
firstName

	^firstName.
! !

!Customer methodsFor: 'name' stamp: 'FA 11/25/2023 16:23:34'!
lastName

	^lastName.
 ! !


!Customer methodsFor: 'initialization' stamp: 'FA 11/25/2023 18:22:42'!
initializeWithFirstName: aFirstName andLastName: aLastName andIdType: anIdType andIdNumber: anIdNumber	

	super initializeWithIdType: anIdType andNumber: anIdNumber.
	firstName := aFirstName.
	lastName  := aLastName.! !

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


!classDefinition: #Supplier category: 'CustomerImporter'!
Party subclass: #Supplier
	instanceVariableNames: 'customers supplierName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'initialization' stamp: 'BK 11/23/2023 18:52:01'!
initialize

	super initialize.
	customers := Set new.! !

!Supplier methodsFor: 'initialization' stamp: 'FA 11/25/2023 18:22:56'!
initializeWithName: aSupplierName andIdType: anIdType andIdNumber: anIdNumber

	super initializeWithIdType: anIdType andNumber: anIdNumber.
	supplierName := aSupplierName.
! !


!Supplier methodsFor: 'customers' stamp: 'BK 11/23/2023 18:43:14'!
addCustomer: aCustomer

	customers add: aCustomer.! !

!Supplier methodsFor: 'customers' stamp: 'FA 11/25/2023 15:24:16'!
customers

	^ customers copy.
! !


!Supplier methodsFor: 'name' stamp: 'FA 11/25/2023 18:19:14'!
supplierName

	^supplierName.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Supplier class' category: 'CustomerImporter'!
Supplier class
	instanceVariableNames: ''!

!Supplier class methodsFor: 'instance creation' stamp: 'BK 11/23/2023 18:55:41'!
withName: aSupplierName andIdType: anIdType andIdNumber: anIdNumber	

	^self new 
		initializeWithName: aSupplierName 
		andIdType: anIdType 
		andIdNumber: anIdNumber.
! !
