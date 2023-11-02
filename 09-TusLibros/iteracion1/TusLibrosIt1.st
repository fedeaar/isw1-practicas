!classDefinition: #PurchaseCartTest category: 'TusLibros'!
TestCase subclass: #PurchaseCartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:33:59'!
test01elCarritoComienzaVacio

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
		
	self assert: cart isEmpty.
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:33:39'!
test02sePuedeAgregarUnLibroAlCarrito

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 .
		 	
	cart add: '1234' copies: 1.

	self assert: (cart isEmpty not).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:34:24'!
test03sePuedenAgregarDosLibrosDiferentesAlCarrito

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
	cart 
		add: '1234' copies: 1 ;
		add: '2345' copies: 1 .

	self assert: (
		(cart size = 2) and: 
		(cart has: '1234') and: 
		(cart has: '2345')).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:32:40'!
test04sePuedeAgregarVariasVecesElMismoLibro

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
		
	cart add: '1234' copies: 3 .

	self assert: (
		(cart size = 3) and: 
		((cart count: '1234') = 3)).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:32:04'!
test05sePuedeAgregarVariasVecesVariosLibros

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
		
	cart  add: '1234' copies: 3 ;
		add: '2345' copies: 2 .

	self assert: (
		(cart size = 5) and: 
		((cart count: '1234') = 3) and: 
		((cart count: '2345') = 2)).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:30:55'!
test06noSePuedeAgregarUnLibroQueNoEstaALaVenta

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->1.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1235' copies: 1 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart bookNotSoldAtStoreError . 
		].! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:30:43'!
test07noSePuedeAgregarUnLibroQueNoTieneStock

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->0.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1234' copies: 1 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart bookOutOfStockError.
		].! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:24:55'!
test08noSePuedeAgregarUnaCantidadMayorAlStockDisponible

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->1.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1234' copies: 2 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart notEnoughStockError. 
		].! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:35:44'!
test09noSePuedeAgregarUnaCantidadNoPositivaDeLibros

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->1.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1234' copies: 0 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart bookQuantityShouldBePositiveError. 
		].! !


!classDefinition: #PurchaseCart category: 'TusLibros'!
Object subclass: #PurchaseCart
	instanceVariableNames: 'contents storeReference'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:53:05'!
count: aBook

	^ contents occurrencesOf: aBook.! !

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:50:22'!
has: aBook

	^ contents includes: aBook.! !

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:43:15'!
isEmpty

	^ contents isEmpty.! !

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:48:43'!
size

	^ contents size.! !


!PurchaseCart methodsFor: 'operation' stamp: 'fa 11/2/2023 19:40:00'!
add: aBook copies: aQuantity

	| stock |
	
	(aQuantity < 1) ifTrue: [ self error: self class bookQuantityShouldBePositiveError. ].
	
	stock := storeReference at: aBook ifAbsent: -1.
	(stock = -1) ifTrue: [ self error: self class bookNotSoldAtStoreError.].
	(stock = 0)    ifTrue: [ self error: self class bookOutOfStockError.].
	(stock < aQuantity) ifTrue: [ self error: self class notEnoughStockError. ].
	
	contents add: aBook withOccurrences: aQuantity.
! !


!PurchaseCart methodsFor: 'initialization' stamp: 'fa 11/2/2023 18:43:28'!
initialize

	contents := Bag new.! !

!PurchaseCart methodsFor: 'initialization' stamp: 'fa 11/2/2023 19:15:33'!
initializeWith: aStoreDictionary

	storeReference := aStoreDictionary.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PurchaseCart class' category: 'TusLibros'!
PurchaseCart class
	instanceVariableNames: ''!

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:28:40'!
bookNotSoldAtStoreError

	^ 'store does not sell the requested book'.! !

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:29:11'!
bookOutOfStockError

	^ 'store does not have stock for the requested book'.! !

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:36:39'!
bookQuantityShouldBePositiveError

	^ 'must add at least one copy of the requested book'.! !

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:29:40'!
notEnoughStockError

	^ 'store does not have enough stock available'.! !


!PurchaseCart class methodsFor: 'instance creation' stamp: 'fa 11/2/2023 19:24:02'!
forStore: aStoreDictionary

	^self new initializeWith: aStoreDictionary.! !
