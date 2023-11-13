!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:30:12'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSoldByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSoldByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:30:12'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSoldByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSoldByTheStore.
	self assert: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSoldByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSoldByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:51:52'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSoldByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: (cashier checkOut at: 1) = (testObjectsFactory itemSoldByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test04CheckoutRegistersASale

	| cart cashier salesBook transactionDetails id total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	transactionDetails := cashier checkOut.
	total := transactionDetails at: 1.
	id := transactionDetails at: 2.
					
	self assert: salesBook size = 1.
	self assert: (salesBook at: id) total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut at: 1.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'fa 11/9/2023 22:26:29'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSoldByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #InterfaceTest category: 'TusLibros'!
TestCase subclass: #InterfaceTest
	instanceVariableNames: 'testObjectsFactory authenticationValue authenticationBehavior debitBehavior clockBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:10'!
test01CannotAddCartWithInvalidCredentials

	authenticationValue := false.
	
	self 
		operation: [ :interface |
		 	^interface 
				createCartWithClientId: 'pepe' 
				andPassword: 'pepito' ] 
		forInterface: self defaultInterface
		shouldFailWithError: (Interface invalidCredentialsErrorDescription).
	
	self resetBehavior.

! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:18'!
test02CanAddCartWithValidCredentials

	| interface cartId |
	
	interface := self defaultInterface.
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	
	self assert: (interface listCartWithId: cartId) isEmpty.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:24'!
test03InterfaceAddsValidItemToCart

	| interface cartId item expected |
	
	item := testObjectsFactory itemSoldByTheStore .
	expected := Bag new.
	expected add: item.
	
	interface := self defaultInterface.
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn: item 
		withOcurrances: 1.
	
	self assert: (interface listCartWithId: cartId) equals: expected.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:29'!
test04CanNotAddItemsThatDoNotBelongToStore

	self 
		operation: [ :interface | | cartId |
			cartId := interface 
				createCartWithClientId: 'pepe' 
				andPassword: 'pepito'.
			interface 
				addToCartWithId: cartId 
				withIsbn:  testObjectsFactory itemNotSoldByTheStore 
				withOcurrances: 1.
		]
		forInterface:  self defaultInterface
		shouldFailWithError:  Interface invalidItemErrorMessage.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:34'!
test05CanNotAddNonPositiveNumberOfItems
	
	self 
		operation: [ :interface | | cartId |
			cartId := interface 
				createCartWithClientId: 'pepe' 
				andPassword: 'pepito'.
			interface 
				addToCartWithId: cartId 
				withIsbn:  testObjectsFactory itemSoldByTheStore 
				withOcurrances: 0.
		]
		forInterface:  self defaultInterface
		shouldFailWithError:  Interface invalidQuantityErrorMessage.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:40'!
test06InterfaceAddsMultipleValidItemsToCart

	| interface cartId item expected |
	
	item := testObjectsFactory itemSoldByTheStore .
	expected := Bag new.
	expected add: item withOccurrences: 2.
	
	interface := self defaultInterface.
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn: item 
		withOcurrances: 1 ;
		addToCartWithId: cartId 
		withIsbn: item 
		withOcurrances: 1.
	
	self assert: (interface listCartWithId: cartId) equals: expected.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:46'!
test07InterfaceFulfillsValidPurchase

	| interface cartId |
	
	interface := self defaultInterface.
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn: testObjectsFactory itemSoldByTheStore 
		withOcurrances: 1 ;
		checkoutCartWithID: cartId 
		andCard: testObjectsFactory notExpiredCreditCard.
	
	self assert: (interface ledger salesBookFor: 'pepeBueno') isEmpty not.

! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:09:53'!
test08CanNotCheckoutAnEmptyCart

	| interface cartId |
	
	interface := self defaultInterface.
	cartId := interface 
		createCartWithClientId: 'pepe' 
		andPassword: 'pepito'.
	self
		should: [
			interface 
				checkoutCartWithID: cartId 
				andCard: testObjectsFactory notExpiredCreditCard. ]
		raise: Error
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: Interface cartCanNotBeEmptyErrorMessage.
			self assert: (interface ledger salesBookFor: 'pepeBueno') isEmpty ].

! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:10:01'!
test09CanNotCheckoutWithAnExpiredCreditCart

	| interface cartId |
	
	interface := self defaultInterface.
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn:  testObjectsFactory itemSoldByTheStore  
		withOcurrances: 1.
	self
		should: [ 
			interface 
				checkoutCartWithID: cartId 
				andCard: testObjectsFactory expiredCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Interface canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: (interface ledger salesBookFor: 'pepeBueno') isEmpty. ].
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:10:13'!
test10CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| interface cartId |
	
	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage ].
	
	interface := self defaultInterface.
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn: testObjectsFactory itemSoldByTheStore  
		withOcurrances: 1.
	self
		should: [ 
			interface 
				checkoutCartWithID: cartId 
				andCard: testObjectsFactory 
				notExpiredCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Interface creditCardHasNoCreditErrorMessage.
			self assert: (interface ledger salesBookFor: 'pepeBueno') isEmpty. ].

	self resetBehavior.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:10:19'!
test11canListNoPurchases

	| listAndTotal |
	
	listAndTotal := self defaultInterface 
		listPurchasesWithClientId: 'pepeBueno' 
		andPassword: 'pepito'. 
	self assert: (
	 	(listAndTotal at: 1) isEmpty and:
		(listAndTotal at: 2) = 0).
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:10:23'!
test12canListSinglePurchase

	| interface cartId item listAndTotal expected |
	
	item := testObjectsFactory itemSoldByTheStore .
	expected := Bag new.
	expected add: item.
	
	interface := self defaultInterface.	
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn: item 
		withOcurrances: 1 ;
	 	checkoutCartWithID: cartId 
		andCard: testObjectsFactory notExpiredCreditCard.
		
	listAndTotal := interface 
		listPurchasesWithClientId: 'pepeBueno' 
		andPassword: 'pepito'. 
		
	self assert: (
	 	(listAndTotal at: 1) = expected and:
		(listAndTotal at: 2) = testObjectsFactory itemSoldByTheStorePrice ).
! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:10:29'!
test13canListMultiplePurchase

	| interface cartId item listAndTotal expected |
	
	item := testObjectsFactory itemSoldByTheStore .
	expected := Bag new.
	expected add: item withOccurrences: 2.
	
	interface := self defaultInterface.	
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn: item 
		withOcurrances: 1 ;
	 	checkoutCartWithID: cartId 
		andCard: testObjectsFactory notExpiredCreditCard .
	
	cartId := interface 
		createCartWithClientId: 'pepeBueno' 
		andPassword: 'pepito'.
	interface 
		addToCartWithId: cartId 
		withIsbn: item 
		withOcurrances: 1 ;
	 	checkoutCartWithID: cartId 
		andCard: testObjectsFactory notExpiredCreditCard .
		
	listAndTotal := interface 
		listPurchasesWithClientId: 'pepeBueno' 
		andPassword: 'pepito'. 
		
	self assert: (
	 	(listAndTotal at: 1) = expected and:
		(listAndTotal at: 2) = ((testObjectsFactory itemSoldByTheStorePrice) * 2 )).

! !

!InterfaceTest methodsFor: 'tests' stamp: 'fa 11/9/2023 23:10:46'!
test14sessionsLast30minutes

	| time |
	
	time := Time now.
	clockBehavior := [ ^ time ].
	
	self operation:  [ :interface | | cartId |
			cartId := interface 
				createCartWithClientId: 'pepeBueno' 
				andPassword: 'pepito'.
			time := time + 30 minutes.
			interface 
				addToCartWithId: cartId 
				withIsbn: testObjectsFactory itemSoldByTheStore  
				withOcurrances: 1. ]
		forInterface: self defaultInterface 
		shouldFailWithError: Interface cartSessionExpiredError.
		
	self resetBehavior.

! !


!InterfaceTest methodsFor: 'setup' stamp: 'fa 11/9/2023 23:08:16'!
resetBehavior 

	authenticationValue := true.
	authenticationBehavior := [:aUsername :aPassword | authenticationValue ].
	debitBehavior := [ :anAmount :aCreditCard | ].
	clockBehavior := [ Time now ].
! !

!InterfaceTest methodsFor: 'setup' stamp: 'fa 11/9/2023 23:08:23'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	self resetBehavior.
! !


!InterfaceTest methodsFor: 'support' stamp: 'fa 11/9/2023 21:06:19'!
attemptLoginTo: aClientId with: aPassword 
	
	^authenticationBehavior value: aClientId value: aPassword.! !

!InterfaceTest methodsFor: 'support' stamp: 'BK 11/8/2023 20:42:27'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !

!InterfaceTest methodsFor: 'support' stamp: 'fa 11/9/2023 21:25:24'!
defaultInterface

	^Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self 
		andMerchant: self 
		andClock: self 
		onDate:  testObjectsFactory today.
! !

!InterfaceTest methodsFor: 'support' stamp: 'fa 11/9/2023 21:05:02'!
now

	^ clockBehavior value.! !

!InterfaceTest methodsFor: 'support' stamp: 'fa 11/9/2023 21:26:01'!
operation: anOperation forInterface: anInterface shouldFailWithError: anErrorMessage

	self 
		should: [ anOperation value: anInterface. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: (anError messageText = anErrorMessage).
		].
! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'fa 11/9/2023 19:38:35'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := Bag new.! !

!Cart methodsFor: 'initialization' stamp: 'fa 11/9/2023 19:39:00'!
initializeAcceptingItemsOf: aCatalog forUser: aClientId

	self initializeAcceptingItemsOf: aCatalog.
	owner := aClientId.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !

!Cart methodsFor: 'queries' stamp: 'fa 11/9/2023 22:39:25'!
owner

	^owner.! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'fa 11/9/2023 18:14:25'!
items

	^items copy.! !

!Cart methodsFor: 'total' stamp: 'fa 11/9/2023 19:46:18'!
total
	^ items sum: [ :anItem | catalog at: anItem ]
	! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'fa 11/9/2023 19:39:50'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !

!Cart class methodsFor: 'instance creation' stamp: 'fa 11/9/2023 18:28:50'!
acceptingItemsOf: aCatalog forUser: aClientId

	^self new initializeAcceptingItemsOf: aCatalog forUser: aClientId.! !


!classDefinition: #CartSession category: 'TusLibros'!
Object subclass: #CartSession
	instanceVariableNames: 'cart clock startedAt creationTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartSession methodsFor: 'initialization' stamp: 'fa 11/9/2023 20:41:33'!
initializeWithCart: aCart atTime: aTime

	cart := aCart.
	creationTime := aTime.! !


!CartSession methodsFor: 'accessing' stamp: 'fa 11/9/2023 20:41:54'!
cart

	^ cart.! !

!CartSession methodsFor: 'accessing' stamp: 'fa 11/9/2023 20:41:46'!
creationTime

	^creationTime.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSession class' category: 'TusLibros'!
CartSession class
	instanceVariableNames: ''!

!CartSession class methodsFor: 'instance creation' stamp: 'fa 11/9/2023 20:42:52'!
withCart: aCart atTime: aTime

	^ self new initializeWithCart: aCart atTime: aTime.! !


!CartSession class methodsFor: 'error messages' stamp: 'fa 11/9/2023 20:31:57'!
timeExpiredError

	^ 'cart session has expired.'! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total transactionId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'fa 11/9/2023 19:35:08'!
createSale

	^ Sale of: total for: cart items.
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'fa 11/9/2023 18:09:03'!
registerSale

	salesBook add: self createSale.
	transactionId := salesBook size.! !


!Cashier methodsFor: 'checkout' stamp: 'fa 11/9/2023 18:09:44'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ OrderedCollection with: total with: transactionId.! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #Interface category: 'TusLibros'!
Object subclass: #Interface
	instanceVariableNames: 'credentialAuthenticator cartSessions catalog merchantProcessor date ledger clock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Interface methodsFor: 'initialization' stamp: 'fa 11/9/2023 23:15:25'!
initializeWithCatalog: anItemCatalog andAuthenticator: anAuthenticator  andMerchant: aMerchantProcessor andClock: aClock onDate: aDate

	cartSessions := Dictionary new.
	ledger := Ledger new.
	catalog  := anItemCatalog.
	credentialAuthenticator := anAuthenticator.
	merchantProcessor := aMerchantProcessor.
	clock := aClock.
	date := aDate.
	! !


!Interface methodsFor: 'operators' stamp: 'fa 11/9/2023 20:49:00'!
addToCartWithId: cartId withIsbn: item withOcurrances: aQuantity
	
	(self getCartWithId: cartId) add: aQuantity of: item.

	 
	! !

!Interface methodsFor: 'operators' stamp: 'fa 11/9/2023 20:50:39'!
checkoutCartWithID: aCartID andCard: aCard
	
	| cashier cart |
	
	cart := self getCartWithId: aCartID.
	
	cashier := Cashier
		toCheckout: cart
		charging: aCard
		throught: merchantProcessor
		on: date
		registeringOn: (ledger salesBookFor: (cart owner)).
		
	^ cashier checkOut at: 2.
! !

!Interface methodsFor: 'operators' stamp: 'fa 11/9/2023 20:54:07'!
createCartWithClientId: aClientId andPassword: aPassword

	self loginClient: aClientId withPassword: aPassword.
	
	cartSessions at: (cartSessions size + 1) put: (
		CartSession 
			withCart: (Cart acceptingItemsOf: 	catalog forUser: aClientId)
			atTime: clock now).
	
	^ cartSessions size.
! !

!Interface methodsFor: 'operators' stamp: 'fa 11/9/2023 20:54:56'!
listCartWithId: cartId

	^(self getCartWithId: cartId) items.
	
! !

!Interface methodsFor: 'operators' stamp: 'fa 11/9/2023 20:58:46'!
listPurchasesWithClientId: aClientId andPassword: aPassword

	| purchases total |
	
	self loginClient: aClientId withPassword: aPassword.

	purchases := Bag new.
	total := 0.
	(ledger salesBookFor: aClientId) do: [ :aPurchase | 
		aPurchase items do: [ :item | purchases add: item].
		total := total + aPurchase total.
	].

	^ OrderedCollection with: purchases with: total.

	! !

!Interface methodsFor: 'operators' stamp: 'fa 11/9/2023 20:52:23'!
loginClient: aClientId withPassword: aPassword

	^ (credentialAuthenticator attemptLoginTo: aClientId with: aPassword) ifFalse: [
		self error: self class invalidCredentialsErrorDescription.
	].! !


!Interface methodsFor: 'accessing' stamp: 'fa 11/9/2023 21:27:15'!
getCartWithId: aCartId 

	| session |
	
	session := cartSessions at: aCartId.
	
	((clock now - session creationTime) minutes > 30) ifTrue: [
		self error: self class timeExpiredError.
	].
	
	^session cart.

	! !

!Interface methodsFor: 'accessing' stamp: 'fa 11/9/2023 19:12:53'!
ledger

	^ ledger.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Interface class' category: 'TusLibros'!
Interface class
	instanceVariableNames: ''!

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:50:30'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^ Cashier canNotChargeAnExpiredCreditCardErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:50:05'!
cartCanNotBeEmptyErrorMessage
	
	^ Cashier cartCanNotBeEmptyErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'fa 11/9/2023 20:33:49'!
cartSessionExpiredError

	^ CartSession timeExpiredError.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:51:26'!
creditCardHasNoCreditErrorMessage
	
	^ Cashier creditCardHasNoCreditErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:51:50'!
invalidCredentialsErrorDescription

	^ 'Invalid credentials'.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:17:44'!
invalidItemErrorMessage

	^ Cart new invalidItemErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:20:56'!
invalidQuantityErrorMessage

	^ Cart new invalidQuantityErrorMessage.! !


!Interface class methodsFor: 'instance creation' stamp: 'fa 11/9/2023 20:36:54'!
withCatalog: anItemCatalog andAuthenticator: anAuthenticator andMerchant: aMerchantProcessor andClock: aClock onDate: aDate

	^self new initializeWithCatalog: anItemCatalog andAuthenticator: anAuthenticator andMerchant: aMerchantProcessor andClock: aClock onDate: aDate! !


!classDefinition: #Ledger category: 'TusLibros'!
Object subclass: #Ledger
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ledger methodsFor: 'initialization' stamp: 'fa 11/9/2023 18:38:25'!
initialize

	books := Dictionary new.! !


!Ledger methodsFor: 'accessing' stamp: 'fa 11/9/2023 20:48:28'!
salesBookFor: aClientId
	
	(books includesKey: aClientId) ifFalse: [
		books add: aClientId->(OrderedCollection new).
	].
	^ books at: aClientId.! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total cartId items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'accessing' stamp: 'fa 11/9/2023 18:46:55'!
items
	
	^ items copy.! !

!Sale methodsFor: 'accessing' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'fa 11/9/2023 19:54:12'!
initializeTotal: aTotal withItems: anItemBag

	total := aTotal.
	items := anItemBag.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'assertions' stamp: 'fa 11/9/2023 23:20:54'!
assertTotalIsNotNegative: aTotal

	(aTotal < 0) ifTrue: [self error: self totalCannotBeNegativeError ].! !


!Sale class methodsFor: 'error messages' stamp: 'fa 11/9/2023 23:21:19'!
totalCannotBeNegativeError

	^ 'a sale cannot record a negative total'.! !


!Sale class methodsFor: 'instance creation' stamp: 'fa 11/9/2023 23:21:29'!
of: aTotal for: anItemsList

	self assertTotalIsNotNegative: aTotal.
	
	^self new initializeTotal: aTotal withItems: anItemsList.
! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fa 11/9/2023 22:30:12'!
itemNotSoldByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fa 11/9/2023 22:26:29'!
itemSoldByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'fa 11/9/2023 22:51:52'!
itemSoldByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'fa 11/9/2023 22:51:52'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSoldByTheStore put: self itemSoldByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !
